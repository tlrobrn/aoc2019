defmodule AOC.Day6.Part1 do
  def run(input) do
    input
    |> build_tree()
    |> count_orbits()
  end

  defp build_tree(input) do
    input
    |> Enum.reduce(%{}, &add_line/2)
  end

  defp add_line(line, tree) do
    [center, orbiter] = String.split(line, ")", parts: 2, trim: true)
    Map.put_new(tree, orbiter, center)
  end

  defp count_orbits(tree) do
    tree
    |> Map.keys()
    |> Stream.map(&count(tree, &1))
    |> Enum.sum()
  end

  defp count(tree, pair, total \\ 0)
  defp count(_, "COM", total), do: total

  defp count(tree, body, total) do
    count(tree, Map.get(tree, body), total + 1)
  end
end
