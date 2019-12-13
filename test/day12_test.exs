defmodule AOC.Day12.Test do
  use ExUnit.Case, async: true
  alias AOC.Day12

  test "part 1" do
    assert 7988 == Day12.part1()
  end

  test "part 2" do
    assert 337_721_412_394_184 == Day12.part2()
  end
end
