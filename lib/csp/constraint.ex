defprotocol Csp.Constraint do
  @type t :: any

  @spec arguments(t) :: [Csp.variable()]
  def arguments(constraint)

  @spec satisfies?(t, Csp.assignment()) :: boolean()
  def satisfies?(constraint, assignment)
end

defimpl Csp.Constraint, for: Tuple do
  @type t :: {arguments :: [Csp.variable()], fun :: ([any] -> boolean)}

  @spec arguments(t) :: [Csp.variable()]
  def arguments({arguments, _function}) when is_list(arguments), do: arguments

  @spec satisfies?(t, Csp.assignment()) :: boolean()
  def satisfies?({arguments, fun}, assignments) do
    values = Enum.map(arguments, fn variable -> Map.fetch!(assignments, variable) end)
    apply(fun, values)
  end
end
