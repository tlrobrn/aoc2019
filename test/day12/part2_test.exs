defmodule AOC.Day12.Part2.Test do
  use ExUnit.Case, async: true
  alias AOC.Day12.{Part2, Vector}

  test "example" do
    input = [
      %Vector{x: -1, y: 0, z: 2},
      %Vector{x: 2, y: -10, z: -7},
      %Vector{x: 4, y: -8, z: 8},
      %Vector{x: 3, y: 5, z: -1}
    ]

    assert 2772 == Part2.run(input)
  end
end
