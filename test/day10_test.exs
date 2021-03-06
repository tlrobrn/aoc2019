defmodule AOC.Day10.Test do
  use ExUnit.Case, async: true
  alias AOC.Day10

  test "part 1" do
    assert 269 == Day10.part1()
  end

  test "part 2" do
    assert 612 == Day10.part2()
  end
end
