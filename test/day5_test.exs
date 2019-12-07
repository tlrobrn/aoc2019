defmodule AOC.Day5.Test do
  use ExUnit.Case, async: true
  alias AOC.Day5

  test "part 1" do
    assert 13294380 == Day5.part1()
  end

  test "part 2" do
    assert 11460760 == Day5.part2()
  end
end
