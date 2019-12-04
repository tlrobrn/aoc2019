defmodule Mix.Tasks.Gen.Day do
  use Mix.Task
  alias Mix.Generator

  @shortdoc "Generate a day's files"

  def run([day]) do
    Generator.create_file("lib/day#{day}.ex", day_module(day))
    Generator.create_file("test/day#{day}_test.exs", day_test(day))
    Generator.create_directory("lib/day#{day}")
    Generator.create_directory("test/day#{day}")
    create_part_files(day)
  end

  defp day_module(day) do
    """
    defmodule AOC.Day#{day} do
      use AOC.Day
    end
    """
  end

  defp day_test(day) do
    """
    defmodule AOC.Day#{day}.Test do
      use ExUnit.Case
      alias AOC.Day#{day}
    end
    """
  end

  defp create_part_files(day) do
    1..2 |> Enum.map(&create_part_module(day, &1))
    1..2 |> Enum.map(&create_part_test(day, &1))
  end

  defp create_part_module(day, part) do
    Generator.create_file(
      "lib/day#{day}/part#{part}.ex",
      part_module(day, part)
    )
  end

  defp part_module(day, part) do
    """
    defmodule AOC.Day#{day}.Part#{part} do
      def run(input) do
      end
    end
    """
  end

  defp create_part_test(day, part) do
    Generator.create_file(
      "test/day#{day}/part#{part}_test.exs",
      part_test(day, part)
    )
  end

  defp part_test(day, part) do
    """
    defmodule AOC.Day#{day}.Part#{part}.Test do
      use ExUnit.Case
      alias AOC.Day#{day}.Part#{part}
    end
    """
  end
end
