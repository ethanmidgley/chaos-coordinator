defmodule Calendar.ProblemBuilder do
  def create(entries) do
    %Csp{
      variables: entries |> Enum.map(& &1.title),
      domains:
        entries
        |> List.foldl(%{}, fn entry, acc ->
          Map.merge(
            acc,
            %{
              entry.title =>
                Calendar.ProblemBuilder.Domain.create(entry, [
                  {DateTime.utc_now() |> DateTime.to_date()}
                ])
            }
          )
        end),
      # domains:
      #   entries
      #   |> Enum.map(
      #     &%{
      #       &1.title =>
      #         Calendar.ProblemBuilder.Domain.create(&1, [
      #           {DateTime.utc_now() |> DateTime.to_date()}
      #         ])
      #     }
      #   ),
      constraints: Calendar.ProblemBuilder.Constraint.create(entries)
    }
  end
end
