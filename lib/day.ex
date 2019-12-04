defmodule AOC.Day do
  defmacro __using__(_opts) do
    quote do
      def part1 do
        input()
        |> parse()
        |> __MODULE__.Part1.run()
      end

      def part2 do
        input()
        |> parse()
        |> __MODULE__.Part2.run()
      end

      defp input do
        [_, day] = String.split(Atom.to_string(__MODULE__), "Day")
        day |> AOC.input_lines()
      end

      if !Module.defines?(__MODULE__, {:parse, 1}) do
        defp parse(stream), do: stream
      end
    end
  end
end
