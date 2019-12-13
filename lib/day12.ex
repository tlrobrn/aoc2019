defmodule AOC.Day12 do
  alias AOC.Day12.Vector

  def parse(stream) do
    stream |> Stream.map(&Vector.parse/1)
  end

  use AOC.Day
end
