defmodule AOC.Day9.Test do
  use ExUnit.Case, async: true
  alias AOC.Day9

  test "part 1" do
    assert 2204990589 == Day9.part1()
  end

  test "part 2" do
    assert 50008 == Day9.part2()
  end
end
