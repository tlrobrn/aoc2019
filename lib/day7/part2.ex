defmodule AOC.Day7.Part2 do
  alias AOC.Intcode

  @phases [5, 6, 7, 8, 9]

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
    amplifiers = Enum.map(phases, fn phase ->
      {:ok, pid} = Intcode.start_link(memory)
      Intcode.input(pid, phase)
      pid
    end)
    until_halt(amplifiers, 0)
  end

  defp until_halt(amplifiers, first_input) do
    if Enum.all?(amplifiers, &(Intcode.status(&1) == :halted)) do
      first_input
    else
      last_output = 
        amplifiers
        |> Enum.reduce(first_input, fn pid, input ->
          Intcode.input(pid, input)
          hd(Intcode.output(pid))
        end)
      until_halt(amplifiers, last_output)
    end
  end
end
