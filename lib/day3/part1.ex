defmodule AOC.Day3.Part1 do
  def run(input) do
    [a, b] = input |> Enum.map(&parse/1)
    a
    |> Stream.flat_map(fn va -> Enum.map(b, &intersect_at(va, &1)) end)
    |> Stream.reject(&is_nil/1)
    |> Stream.map(fn {x, y} -> abs(x) + abs(y) end)
    |> Stream.reject(&(&1 == 0))
    |> Enum.min()
  end

  defp parse(path) do
    path
    |> String.split(",", trim: true)
    |> Enum.reduce([{0, 0}], fn token, [{x, y} | _] = points ->
      {dx, dy} = decode(token)
      [{x + dx, y + dy} | points]
    end)
    |> Enum.chunk_every(2, 1)
  end

  defp decode("R" <> n), do: {String.to_integer(n), 0}
  defp decode("L" <> n), do: {-String.to_integer(n), 0}
  defp decode("U" <> n), do: {0, String.to_integer(n)}
  defp decode("D" <> n), do: {0, -String.to_integer(n)}

  defp intersect_at([{x0, y}, {x1, y}], [{x, y0}, {x, y1}])
  when ((y - y0) * (y - y1) <= 0) and ((x - x0) * (x - x1) <= 0),
    do: {x, y}

  defp intersect_at([{x, y0}, {x, y1}], [{x0, y}, {x1, y}])
  when ((y - y0) * (y - y1) <= 0) and ((x - x0) * (x - x1) <= 0),
    do: {x, y}

  defp intersect_at(_, _), do: nil
end
