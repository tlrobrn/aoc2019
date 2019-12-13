defmodule AOC.Day12.Part1 do
  alias AOC.Day12.Moon

  def run(input, steps \\ 1_000) do
    input
    |> Enum.map(&moon/1)
    |> run_simulation(steps)
    |> calculate_total_energy()
  end

  defp moon(position), do: %Moon{position: position}

  defp run_simulation(moons, 0), do: moons

  defp run_simulation(moons, steps) do
    moons
    |> adjust_velocity()
    |> adjust_position()
    |> run_simulation(steps - 1)
  end

  defp adjust_velocity(moons) do
    moons
    |> Enum.map(fn moon ->
      moons
      |> Enum.reduce(moon, fn other, new_moon ->
        Moon.gravitate(new_moon, other)
      end)
    end)
  end

  defp adjust_position(moons) do
    moons |> Enum.map(&Moon.move/1)
  end

  defp calculate_total_energy(moons) do
    moons
    |> Stream.map(&Moon.potential_energy/1)
    |> Enum.sum()
  end
end
