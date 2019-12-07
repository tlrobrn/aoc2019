defmodule AOC.Day6.Part2.Test do
  use ExUnit.Case, async: true
  alias AOC.Day6.Part2

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
      K)YOU
      I)SAN
    ]

    assert 4 == Part2.run(input)
  end
end
