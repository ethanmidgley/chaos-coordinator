defmodule Csp do
  alias Csp.{Constraint, Backtracking}

  @type variable :: String.t()
  @type value :: any
  @type domain :: [value]
  @type constraint :: (value -> boolean) | (value, value -> boolean)
  @type assignment :: %{variable => value}

  @type solve_result :: {:solved, assignment(), [assignment()]} | :no_solution

  @type t :: %Csp{
          variables: [atom],
          domains: %{variable => domain},
          constraints: [Constraint.t()]
        }

  defstruct [:variables, :domains, :constraints]

  @spec solve(Csp.t(), Keyword.t()) :: solve_result()
  def solve(%Csp{} = problem, opts \\ []) do
    method = Keyword.get(opts, :method, :backtracking)

    case method do
      :backtracking -> Backtracking.solve(problem, opts)
    end
  end

  @spec consistent?(Csp.t(), assignment()) :: boolean()
  def consistent?(%Csp{} = problem, assignments) do
    assigned_variables = assignments |> Map.keys() |> MapSet.new()

    Enum.all?(problem.constraints, fn constraint ->
      arguments = Constraint.arguments(constraint)

      if Enum.all?(arguments, fn argument -> argument in assigned_variables end) do
        Constraint.satisfies?(constraint, assignments)
      else
        true
      end
    end)
  end
end
