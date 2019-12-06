defmodule AOC.Day3.Part1 do
  alias AOC.Day3

  def run([a, b]) do
    a
    |> Stream.flat_map(fn va ->
      Enum.map(b, &Day3.intersect_at(va, &1))
    end)
    |> Stream.reject(&is_nil/1)
    |> Stream.map(fn {x, y} -> abs(x) + abs(y) end)
    |> Stream.reject(&(&1 == 0))
    |> Enum.min()
  end
end
