defmodule AOC.Day13.Part1 do
  alias AOC.Intcode

  @block 2

  def run(input) do
    {:ok, pid} = Intcode.start_link(input)
    Intcode.run(pid)

    Intcode.output(pid)
    |> Stream.chunk_every(3)
    |> Stream.map(fn [x, y, id] -> {{x, y}, id} end)
    |> Map.new()
    |> Enum.count(fn {_, tile_id} -> tile_id == @block end)
  end
end
