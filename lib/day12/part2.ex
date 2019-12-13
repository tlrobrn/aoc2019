defmodule AOC.Day12.Part2 do
  alias AOC.Day12.Moon

  def run(input) do
    input
    |> Enum.map(&moon/1)
    |> run_until_reset()
  end

  defp moon(position), do: %Moon{position: position}

  defp run_until_reset(moons) do
    [x, y, z] = calculate_periods(moons, moons, 0, [nil, nil, nil])
    lcm(lcm(x, y), z)
  end

  defp calculate_periods(initial_moons, moons, steps, periods) do
    new_moons = step(moons)
    new_steps = steps + 1
    new_periods = check(initial_moons, new_moons, new_steps, periods)

    if Enum.all?(new_periods) do
      new_periods
    else
      calculate_periods(initial_moons, new_moons, new_steps, new_periods)
    end
  end

  defp check(initial_moons, moons, steps, [x, y, z]) do
    {all_x, all_y, all_z} =
      Stream.zip(initial_moons, moons)
      |> Enum.reduce({is_nil(x), is_nil(y), is_nil(z)}, fn {initial, current},
                                                           {new_x, new_y, new_z} ->
        {
          new_x && check_axis(:x, initial, current),
          new_y && check_axis(:y, initial, current),
          new_z && check_axis(:z, initial, current)
        }
      end)

    [x || (all_x && steps) || nil, y || (all_y && steps) || nil, z || (all_z && steps) || nil]
  end

  defp check_axis(:x, initial, current) do
    initial.position.x == current.position.x && initial.velocity.x == current.velocity.x
  end

  defp check_axis(:y, initial, current) do
    initial.position.y == current.position.y && initial.velocity.y == current.velocity.y
  end

  defp check_axis(:z, initial, current) do
    initial.position.z == current.position.z && initial.velocity.z == current.velocity.z
  end

  defp step(moons) do
    moons
    |> adjust_velocity()
    |> adjust_position()
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

  defp gcd(a, 0), do: a
  defp gcd(0, b), do: b
  defp gcd(a, b), do: gcd(b, rem(a, b))

  defp lcm(0, 0), do: 0
  defp lcm(a, b), do: div(a * b, gcd(a, b))
end
