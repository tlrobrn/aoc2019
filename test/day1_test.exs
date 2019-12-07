defmodule AOC.Day1.Test do
  use ExUnit.Case, async: true
  alias AOC.Day1

  test "part 1" do
    assert 3297626 == Day1.part1()
  end

  test "part 2" do
    assert 4943578 == Day1.part2()
  end
end
