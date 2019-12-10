defmodule AOC.Day4.Part1.Test do
  use ExUnit.Case, async: true
  alias AOC.Day4.Part1

  test "6 digits" do
    assert Part1.valid?(122_456)
    refute Part1.valid?(122)
    refute Part1.valid?(1_224_567)
  end

  test "at least 2 adjacent digits are the same" do
    assert Part1.valid?(122_456)
    refute Part1.valid?(123_456)
  end

  test "always increasing" do
    assert Part1.valid?(122_456)
    refute Part1.valid?(122_450)
  end
end
