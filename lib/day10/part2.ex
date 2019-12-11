defmodule AOC.Day10.Part2 do
  alias AOC.Day10.Vector

  def run(input) do
    {x, y} =
      input
      |> Stream.map(&lines_for_point(&1, input))
      |> Enum.max_by(&length/1)
      |> destroy_asteroids()
      |> Enum.at(199)

    100 * x + y
  end

  defp destroy_asteroids(lines_of_sight) do
    Stream.resource(
      fn -> {Enum.map(lines_of_sight, fn {_, asteroids} -> asteroids end), 0} end,
      fn
        {[], _i} ->
          {:halt, nil}

        {lines, i} when i >= length(lines) ->
          {[], {lines, 0}}

        {lines, i} ->
          case Enum.at(lines, i) do
            [asteroid | []] ->
              {[asteroid], {List.delete_at(lines, i), i}}

            [asteroid | rest] ->
              {[asteroid], {List.replace_at(lines, i, rest), i + 1}}
          end
      end,
      fn _ -> nil end
    )
  end

  defp lines_for_point(p, points) do
    points
    |> Stream.reject(&(&1 == p))
    |> Enum.reduce(%{}, fn q, visible ->
      Map.update(visible, Vector.angle(p, q), [q], &[q | &1])
    end)
    |> Enum.map(fn {r, points} ->
      {r, Enum.sort_by(points, &Vector.dist(p, &1))}
    end)
    |> Enum.sort_by(fn {r, _} -> r end)
  end
end
