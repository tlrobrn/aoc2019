defmodule AOC.Day2.Part1 do
  alias AOC.Intcode

  def run(input) do
    {:ok, pid} = Intcode.start_link(input)
    Intcode.set(pid, [{1, 12}, {2, 2}])
    Intcode.run(pid)
    Intcode.read(pid, 0)
  end
end
