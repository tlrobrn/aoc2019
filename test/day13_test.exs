defmodule AOC.Day13.Test do
  use ExUnit.Case, async: true
  alias AOC.Day13

  test "part 1" do
    assert 239 == Day13.part1()
  end

  test "part 2" do
    assert 12099 == Day13.part2()
  end
end
