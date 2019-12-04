defmodule AOC.Day1.Part1 do
  def run(input) do
    input
    |> Stream.map(&AOC.Day1.fuel_calculation/1)
    |> Enum.sum()
  end
end
