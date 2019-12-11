defmodule AOC.Day11.Test do
  use ExUnit.Case, async: true
  alias AOC.Day11

  test "part 1" do
    assert 2172 == Day11.part1()
  end

  test "part 2" do
    expected =
      [
        "",
        "   XX XXXX X    XXXX XXXX  XX  X  X XXX    ",
        "    X X    X    X    X    X  X X  X X  X   ",
        "    X XXX  X    XXX  XXX  X    XXXX X  X   ",
        "    X X    X    X    X    X XX X  X XXX    ",
        " X  X X    X    X    X    X  X X  X X      ",
        "  XX  XXXX XXXX XXXX X     XXX X  X X      ",
        ""
      ]
      |> Enum.join("\n")

    assert expected == Day11.part2()
  end
end
