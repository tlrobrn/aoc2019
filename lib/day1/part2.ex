defmodule AOC.Day1.Part2 do
  def run(input) do
    input
    |> Stream.map(&AOC.Day1.fuel_calculation/1)
    |> Stream.map(&calculate_fuel([&1]))
    |> Enum.sum()
  end

  defp calculate_fuel([last | rest]) when last <= 0 do
    Enum.sum(rest)
  end

  defp calculate_fuel([last | rest]) do
    calculate_fuel([
      AOC.Day1.fuel_calculation(last),
      last | rest
    ])
  end
end
