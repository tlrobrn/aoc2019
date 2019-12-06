defmodule AOC.Day3.Part2 do
  alias AOC.Day3

  def run(input) do
    [a, b] = Enum.map(input, &with_steps/1)
    find_min_steps(a, b)
  end

  defp with_steps(path) do
    Enum.map(path, &calculate_steps/1)
  end

  defp calculate_steps([{x0, y0}, {x1, y1}] = segment) do
    {segment, abs(x1 - x0) + abs(y1 - y0)}
  end

  defp find_min_steps(a, b), do: find_min_steps(a, b, b, 0, 0, :infinity)
  defp find_min_steps([], _, _, _, _, min_steps), do: min_steps
  defp find_min_steps([{_, steps} | a], [], b, a_steps, _, min_steps), do: find_min_steps(a, b, b, a_steps + steps, 0, min_steps)
  defp find_min_steps([{[p0, p1], _} | _] = a, [{[q0, q1], r} | b], initial_b, a_steps, b_steps, min_steps) do
    case Day3.intersect_at([p0, p1], [q0, q1]) do
      {0, 0} ->
        find_min_steps(a, b, initial_b, a_steps, b_steps + r, min_steps)
      {x, y} ->
        {_, da} = calculate_steps([p0, {x, y}])
        {_, db} = calculate_steps([q0, {x, y}])
        steps = a_steps + da + b_steps + db
        find_min_steps(a, b, initial_b, a_steps, b_steps + r, min(steps, min_steps))
      _ ->
        find_min_steps(a, b, initial_b, a_steps, b_steps + r, min_steps)
    end
  end
end
