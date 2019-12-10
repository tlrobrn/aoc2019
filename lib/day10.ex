defmodule AOC.Day10 do
  def parse(stream) do
    stream
    |> Stream.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Stream.with_index()
      |> Stream.filter(fn {c, _} -> c == "#" end)
      |> Enum.map(fn {_, x} -> {x, y} end)
    end)
  end

  use AOC.Day
end
