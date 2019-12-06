defmodule AOC.Day4.Part2.Test do
  use ExUnit.Case
  alias AOC.Day4.Part2

  test "examples" do
    assert Part2.valid?("112233")
    refute Part2.valid?("123444")
    assert Part2.valid?("111122")
  end
end
