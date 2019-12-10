defmodule AOC.Day1.Part1.Test do
  use ExUnit.Case, async: true
  alias AOC.Day1.Part1

  test "example 1" do
    input = [12]
    assert 2 == Part1.run(input)
  end

  test "example 2" do
    input = [14]
    assert 2 == Part1.run(input)
  end

  test "example 3" do
    input = [1969]
    assert 654 == Part1.run(input)
  end

  test "example 4" do
    input = [100_756]
    assert 33583 == Part1.run(input)
  end

  test "multiple examples" do
    input = [12, 14, 1969, 100_756]
    assert 2 + 2 + 654 + 33583 == Part1.run(input)
  end
end
