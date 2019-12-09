defmodule AOC.Day9.Part2 do
  alias AOC.Intcode

  def run(input) do
    {:ok, pid} = Intcode.start_link(input)
    Intcode.run(pid)
    Intcode.input(pid, 2)
    outputs = Intcode.output(pid)
    if Enum.count(outputs, &(&1 != 0)) == 1 do
      outputs
      |> Enum.reverse()
      |> hd()
    else
      raise "diagnostics failed, outputs: [#{Enum.join(outputs, ", ")}]"
    end
  end
end
