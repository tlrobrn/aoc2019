defmodule AOC.Day2.Part1.Test do
  use ExUnit.Case
  alias AOC.Day2.Part1

  test "example 1" do
    input = [1, 0, 0, 0, 99]
    assert 2 == Part1.run(input)
  end

  test "example 2" do
    input = [2, 3, 0, 3, 99]
    assert 2 == Part1.run(input)
  end

  test "example 3" do
    input = [2, 4, 4, 5, 99, 0]
    assert 2 == Part1.run(input)
  end

  test "example 4" do
    input = [1, 1, 1, 4, 99, 5, 6, 0, 99]
    assert 30 == Part1.run(input)
  end
end
