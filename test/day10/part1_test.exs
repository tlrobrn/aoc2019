defmodule AOC.Day10.Part1.Test do
  use ExUnit.Case, async: true
  alias AOC.Day10.Part1

  test "example 1" do
    input =
      [
        ".#..#\n",
        ".....\n",
        "#####\n",
        "....#\n",
        "...##\n"
      ]
      |> AOC.Day10.parse()

    assert 8 == Part1.run(input)
  end

  test "example 2" do
    input =
      [
        "......#.#.\n",
        "#..#.#....\n",
        "..#######.\n",
        ".#.#.###..\n",
        ".#..#.....\n",
        "..#....#.#\n",
        "#..#....#.\n",
        ".##.#..###\n",
        "##...#..#.\n",
        ".#....####\n"
      ]
      |> AOC.Day10.parse()

    assert 33 == Part1.run(input)
  end

  test "example 3" do
    input =
      [
        "#.#...#.#.\n",
        ".###....#.\n",
        ".#....#...\n",
        "##.#.#.#.#\n",
        "....#.#.#.\n",
        ".##..###.#\n",
        "..#...##..\n",
        "..##....##\n",
        "......#...\n",
        ".####.###.\n"
      ]
      |> AOC.Day10.parse()

    assert 35 == Part1.run(input)
  end
end
