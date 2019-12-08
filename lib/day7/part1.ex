defmodule AOC.Day7.Part1 do
  alias AOC.Intcode

  @phases [0, 1, 2, 3, 4]

  def run(input) do
    permute(@phases)
    |> Stream.map(&run_amplifiers(input, &1))
    |> Enum.max()
  end

  defp permute([]), do: [[]]
  defp permute(list) do
    for x <- list, y <- permute(list -- [x]), do: [x|y]
  end

  defp run_amplifiers(memory, phases) do
    Enum.reduce(phases, 0, &run_amplifier(memory, [&1, &2]))
  end

  defp run_amplifier(memory, inputs) do
    {:ok, pid} = Intcode.start_link(memory)
    Intcode.run(pid)
    Enum.each(inputs, &Intcode.input(pid, &1))
    [output] = Intcode.output(pid)
    output
  end
end
