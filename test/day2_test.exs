defmodule AOC.Day2.Test do
  use ExUnit.Case, async: true
  alias AOC.Day2

  test "part 1" do
    assert 4930687 == Day2.part1()
  end

  test "part 2" do
    assert 5335 == Day2.part2()
  end
end
