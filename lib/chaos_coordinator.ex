defmodule ChaosCoordinator do
  @moduledoc """
  Documentation for `ChaosCoordinator`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ChaosCoordinator.hello()
      :world

  """
  def hello do
    :world
  end

  def example_events do
    [
      %Calendar.Entry{
        title: "before",
        # deadline: ~U[2025-07-09 14:00:00Z],
        fixed_start_time: ~U[2025-07-09 11:00:00Z],
        dependencies: [],
        duration: %Duration{minute: 15},
        note: "",
        fixed: true,
        priority: 3
      },
      %Calendar.Entry{
        title: "later",
        deadline: ~U[2025-07-09 12:00:00Z],
        fixed_start_time: nil,
        dependencies: ["before"],
        duration: %Duration{minute: 45},
        note: "",
        fixed: false,
        priority: 1
      }
    ]
  end
end
