defmodule AOC.Day4.Part2 do
  alias AOC.Day4.Part1

  def run([min, max]) do
    min..max
    |> Stream.filter(&Part1.valid?/1)
    |> Stream.map(&Integer.to_string/1)
    |> Enum.count(&valid?/1)
  end

  def valid?(password) do
    duplicates =
      Regex.scan(~r/(.)\1/, password, capture: :all_but_first)
      |> List.flatten()
      |> Enum.dedup()

    Enum.any?(duplicates, fn digit ->
      !String.contains?(password, digit <> digit <> digit)
    end)
  end
end
