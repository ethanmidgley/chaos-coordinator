defmodule Csp.Backtracking do
  @type variable_selector :: :take_head | ([Csp.variable()] -> {Csp.variable(), [Csp.variable()]})

  @spec solve(Csp.t(), Keyword.t()) :: Csp.solve_result()
  def solve(%Csp{} = problem, opts \\ []) do
    selector = Keyword.get(opts, :variable_selector, :take_head)
    all = Keyword.get(opts, :all, false)

    case backtrack(%{}, problem.variables, problem, selector, all) do
      [] -> :no_solution
      [solution] -> {:solved, solution}
      solutions when is_list(solutions) -> {:solved, solutions}
    end
  end

  @spec backtrack(Csp.assignment(), [Csp.variable()], Csp.t(), variable_selector(), boolean()) ::
          [Csp.assignment()]
  defp backtrack(assignment, [], %Csp{} = problem, _variable_selector, _all) do
    if Csp.consistent?(problem, assignment), do: [assignment], else: []
  end

  defp backtrack(assignment, [variable | rest], %Csp{} = problem, :take_head, all) do
    domain = Map.fetch!(problem.domains, variable)

    Enum.reduce_while(domain, [], fn x, acc ->
      assignment = Map.put(assignment, variable, x)

      if Csp.consistent?(problem, assignment) do
        # If the value chosen is consistent lets go to the next variable pick 
        case backtrack(assignment, rest, problem, :take_head, all) do
          [] ->
            {:cont, acc}

          solutions when is_list(solutions) ->
            if all, do: {:cont, acc ++ solutions}, else: {:halt, solutions}
        end
      else
        # It is not consistent so we need to pick the next value at the current variable
        {:cont, acc}
      end
    end)
  end
end
