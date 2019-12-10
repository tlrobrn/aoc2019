defmodule AOC.Day5.Test do
  use ExUnit.Case, async: true
  alias AOC.Day5

  test "part 1" do
    assert 13_294_380 == Day5.part1()
  end

  test "part 2" do
    assert 11_460_760 == Day5.part2()
  end
end
