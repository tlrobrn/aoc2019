defmodule AOC.Day6.Part1.Test do
  use ExUnit.Case
  alias AOC.Day6.Part1

  test "example" do
    input = ~w[
      COM)B
      B)C
      C)D
      D)E
      E)F
      B)G
      G)H
      D)I
      E)J
      J)K
      K)L
    ]

    assert 42 == Part1.run(input)
  end
end
