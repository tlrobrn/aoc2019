defmodule AOC.Day9.Part1 do
  alias AOC.Intcode

  def run(input) do
    {:ok, pid} = Intcode.start_link(input)
    Intcode.run(pid)
    Intcode.input(pid, 1)
    outputs = Intcode.output(pid)

    if Enum.count(outputs, &(&1 != 0)) == 1 do
      List.last(outputs)
    else
      raise "diagnostics failed, outputs: [#{Enum.join(outputs, ", ")}]"
    end
  end
end
