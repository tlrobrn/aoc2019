defmodule AOC.Day11.Part1 do
  alias AOC.Day11.Robot
  alias AOC.Intcode

  def run(input) do
    {:ok, pid} = Intcode.start_link(input)
    %Robot{}
    |> Robot.run(pid)
    |> Enum.count()
  end
end
