defmodule AOC.Day12.Vector do
  defstruct x: 0, y: 0, z: 0

  @pattern ~r/^\<x=(-?\d+), y=(-?\d+), z=(-?\d+)\>$/

  def parse(line) do
    [x, y, z] =
      Regex.run(@pattern, line, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    %__MODULE__{x: x, y: y, z: z}
  end

  def add(%__MODULE__{x: x, y: y, z: z}, %__MODULE__{x: dx, y: dy, z: dz}) do
    %__MODULE__{x: x + dx, y: y + dy, z: z + dz}
  end
end
