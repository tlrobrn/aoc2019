defmodule AOC.Day10.Part1 do
  alias AOC.Day10.Vector

  def run(input) do
    input
    |> Stream.map(&lines_for_point(&1, input))
    |> Enum.max()
  end

  defp lines_for_point(p, points) do
    points
    |> Stream.reject(&(&1 == p))
    |> Stream.map(&Vector.angle(p, &1))
    |> MapSet.new()
    |> MapSet.size()
  end
end
