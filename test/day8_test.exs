defmodule AOC.Day8.Test do
  use ExUnit.Case, async: true
  alias AOC.Day8

  test "part 1" do
    assert 2159 == Day8.part1()
  end

  test "part 2" do
    expected =
      [
        "",
        " XX    XX XXXX X  X XXX  ",
        "X  X    X    X X  X X  X ",
        "X       X   X  XXXX X  X ",
        "X       X  X   X  X XXX  ",
        "X  X X  X X    X  X X X  ",
        " XX   XX  XXXX X  X X  X ",
        ""
      ]
      |> Enum.join("\n")

    assert expected == Day8.part2()
  end
end
