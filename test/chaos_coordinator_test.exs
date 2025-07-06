defmodule ChaosCoordinatorTest do
  use ExUnit.Case
  doctest ChaosCoordinator

  test "greets the world" do
    assert ChaosCoordinator.hello() == :world
  end
end
