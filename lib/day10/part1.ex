defmodule AOC.Day10.Part1 do
  def run(input) do
    input
    |> Stream.map(&lines_for_point(&1, input))
    |> Stream.map(&length/1)
    |> Enum.max()
  end

  defp lines_for_point({x0, y0} = p, points) do
    points
    |> Stream.reject(&(&1 == p))
    |> Enum.reduce(%{}, fn {x1, y1} = q, visible ->
      d1 = :math.sqrt((x1 - x0) * (x1 - x0) + (y1 - y0) * (y1 - y0))
      visible
      |> Enum.find(fn {{x2, y2}, _} ->
        ((y1 - y0) * (x2 - x1) == (y2 - y1) * (x1 - x0)) and
          ((x2 - x0) * (x1 - x0) >= 0) and
          ((y2 - y0) * (y1 - y0) >= 0)
      end)
      |> case do
        nil ->
          Map.put_new(visible, q, d1)
        {_, d2} when d2 < d1 ->
          visible
        {w, _} ->
          visible
          |> Map.delete(w)
          |> Map.put_new(q, d1)
      end
    end)
    |> Map.keys()
  end
end
