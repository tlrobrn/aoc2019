defmodule AOC.Day2.Part2 do
  alias AOC.Intcode

  def run(input) do
    winning_pid =
      Stream.flat_map(0..99, fn noun ->
        Enum.map(0..99, fn verb ->
          Task.async(fn ->
            {:ok, pid} = Intcode.start_link(input)
            Intcode.set(pid, [{1, noun}, {2, verb}])
            Intcode.run(pid)
            pid
          end)
        end)
      end)
      |> Stream.map(&Task.await/1)
      |> Enum.find(fn pid -> Intcode.read(pid, 0) == 19_690_720 end)

    noun = Intcode.read(winning_pid, 1)
    verb = Intcode.read(winning_pid, 2)
    100 * noun + verb
  end
end
