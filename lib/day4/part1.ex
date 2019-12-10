defmodule AOC.Day4.Part1 do
  def run([min, max]) do
    min..max |> Enum.count(&valid?/1)
  end

  def valid?(password) when password > 99999 and password <= 999_999 do
    paired_digits =
      password
      |> Integer.digits()
      |> Enum.chunk_every(2, 1, :discard)

    has_double = Enum.any?(paired_digits, fn [a, b] -> a == b end)
    always_increasing = Enum.all?(paired_digits, fn [a, b] -> a <= b end)

    has_double and always_increasing
  end

  def valid?(_), do: false
end
