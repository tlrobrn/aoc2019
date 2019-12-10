defmodule AOC.Day10.Part2.Test do
  use ExUnit.Case, async: true
  alias AOC.Day10.Part2

  test "example 1" do
    input = [
      ".#..##.###...#######\n",
      "##.############..##.\n",
      ".#.######.########.#\n",
      ".###.#######.####.#.\n",
      "#####.##.#.##.###.##\n",
      "..#####..#.#########\n",
      "####################\n",
      "#.####....###.#.#.##\n",
      "##.#################\n",
      "#####.##.###..####..\n",
      "..######..##.#######\n",
      "####.##.####...##..#\n",
      ".#####..#.######.###\n",
      "##...#.##########...\n",
      "#.##########.#######\n",
      ".####.#.###.###.#.##\n",
      "....##.##.###..#####\n",
      ".#.#.###########.###\n",
      "#.#.#.#####.####.###\n",
      "###.##.####.##.#..##\n",
    ] |> AOC.Day10.parse()

    assert 802 == Part2.run(input)
  end
end