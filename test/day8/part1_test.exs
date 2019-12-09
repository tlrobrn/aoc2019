defmodule AOC.Day8.Part1.Test do
  use ExUnit.Case, async: true
  alias AOC.Day8.Part1

  test "example" do
    input = [1,2,3,4,5,6,7,8,9,0,1,2]
    assert [
      [1, 2, 3, 4, 5, 6],
      [7, 8, 9, 0, 1, 2],
    ] == Part1.parse_layers(input, {3, 2})
  end
end
