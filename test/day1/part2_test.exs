defmodule AOC.Day1.Part2.Test do
  use ExUnit.Case, async: true
  alias AOC.Day1.Part2

  test "example 1" do
    input = [14]
    assert 2 == Part2.run(input)
  end

  test "example 2" do
    input = [1969]
    assert 966 == Part2.run(input)
  end

  test "example 3" do
    input = [100756]
    assert 50346 == Part2.run(input)
  end

  test "examples" do
    input = [14, 1969, 100756]
    assert 2 + 966 + 50346 == Part2.run(input)
  end
end
