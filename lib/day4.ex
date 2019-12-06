defmodule AOC.Day4 do
  def parse(input) do
    input
    |> Enum.to_list()
    |> hd()
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
  end

  use AOC.Day
end
