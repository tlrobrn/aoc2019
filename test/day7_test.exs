defmodule AOC.Day7.Test do
  use ExUnit.Case, async: true
  alias AOC.Day7

  test "part1" do
    assert 38834 = Day7.part1()
  end

  test "part2" do
    assert 69113332 = Day7.part2()
  end
end
