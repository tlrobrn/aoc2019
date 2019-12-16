defmodule AOC.Day14 do
  alias AOC.Day14.Reaction

  def parse(stream) do
    stream
    |> Enum.map(&Reaction.from_string/1)
    |> Map.new(fn %Reaction{product: product} = rx ->
      {product, rx}
    end)
  end

  use AOC.Day
end
