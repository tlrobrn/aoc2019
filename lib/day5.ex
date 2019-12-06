defmodule AOC.Day5 do
  defp parse(lines) do
    lines
    |> Stream.flat_map(&String.split(&1, ",", trim: true))
    |> Enum.map(&String.to_integer/1)
  end

  use AOC.Day
end
