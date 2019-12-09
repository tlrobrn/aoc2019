defmodule AOC.Day8.Part1 do
  def run(input) do
    input
    |> parse_layers({25, 6})
    |> Enum.min_by(&count_n(&1, 0))
    |> checksum()
  end

  def parse_layers(pixel_stream, {width, height}) do
    pixel_stream |> Enum.chunk_every(width * height)
  end

  defp count_n(layer, n) do
    Enum.count(layer, &(&1 == n))
  end

  defp checksum(layer) do
    ones = count_n(layer, 1)
    twos = count_n(layer, 2)
    ones * twos
  end
end
