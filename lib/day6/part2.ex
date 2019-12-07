defmodule AOC.Day6.Part2 do
  def run(input) do
    input
    |> build_graph()
    |> bfs()
  end

  defp build_graph(input) do
    input
    |> Enum.reduce(%{}, &add_line/2)
  end

  defp add_line(line, graph) do
    [center, orbiter] = String.split(line, ")", parts: 2, trim: true)
    graph
    |> Map.update(center, [orbiter], &[orbiter | &1])
    |> Map.update(orbiter, [center], &[center | &1])
  end

  defp bfs(graph, seen \\ MapSet.new(), queue \\ [{"YOU", -1}])
  defp bfs(graph, seen, [{current, count} | queue]) do
    neighbors = Map.get(graph, current)
    if Enum.find(neighbors, &(&1 == "SAN")) do
      count
    else
      tail =
        neighbors
        |> Stream.reject(&MapSet.member?(seen, &1))
        |> Enum.map(&{&1, count + 1})
      bfs(graph, MapSet.put(seen, current), queue ++ tail)
    end
  end
end
