defmodule AOC.Day1 do
  def fuel_calculation(mass) do
    Integer.floor_div(mass, 3) - 2
  end

  defp parse(lines) do
    lines |> Stream.map(&String.to_integer/1)
  end

  use AOC.Day
end
