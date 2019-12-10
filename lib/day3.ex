defmodule AOC.Day3 do
  def parse(lines) do
    Enum.map(lines, &parse_line/1)
  end

  def intersect_at([{x0, y}, {x1, y}], [{x, y0}, {x, y1}])
      when (y - y0) * (y - y1) <= 0 and (x - x0) * (x - x1) <= 0,
      do: {x, y}

  def intersect_at([{x, y0}, {x, y1}], [{x0, y}, {x1, y}])
      when (y - y0) * (y - y1) <= 0 and (x - x0) * (x - x1) <= 0,
      do: {x, y}

  def intersect_at(_, _), do: nil

  defp parse_line(input_line) do
    input_line
    |> String.split(",", trim: true)
    |> Enum.reduce([{0, 0}], fn token, [{x, y} | _] = points ->
      {dx, dy} = decode(token)
      [{x + dx, y + dy} | points]
    end)
    |> Enum.reverse()
    |> Enum.chunk_every(2, 1, :discard)
  end

  defp decode("R" <> n), do: {String.to_integer(n), 0}
  defp decode("L" <> n), do: {-String.to_integer(n), 0}
  defp decode("U" <> n), do: {0, String.to_integer(n)}
  defp decode("D" <> n), do: {0, -String.to_integer(n)}

  use AOC.Day
end
