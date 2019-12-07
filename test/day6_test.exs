defmodule AOC.Day6.Test do
  use ExUnit.Case, async: true
  alias AOC.Day6

  test "part1" do
    assert 145250 == Day6.part1()
  end

  test "part2" do
    assert 274 == Day6.part2()
  end
end
