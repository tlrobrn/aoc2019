defmodule AOC.Day4.Part1.Test do
  use ExUnit.Case, async: true
  alias AOC.Day4.Part1

  test "6 digits" do
    assert Part1.valid?(122456)
    refute Part1.valid?(122)
    refute Part1.valid?(1224567)
  end

  test "at least 2 adjacent digits are the same" do
    assert Part1.valid?(122456)
    refute Part1.valid?(123456)
  end

  test "always increasing" do
    assert Part1.valid?(122456)
    refute Part1.valid?(122450)
  end
end
