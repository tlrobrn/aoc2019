defmodule AOC.Day8 do
  defp parse(lines) do
    lines
    |> Stream.flat_map(&String.split(&1, "", trim: true))
    |> Stream.map(&String.to_integer/1)
  end

  use AOC.Day
end
