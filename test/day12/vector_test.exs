defmodule AOC.Day12.VectorTest do
  use ExUnit.Case, async: true
  alias AOC.Day12.Vector

  test "parse" do
    assert %Vector{x: 1, y: -2, z: 3} == Vector.parse("<x=1, y=-2, z=3>")
  end

  test "add" do
    assert %Vector{x: 2, y: 0, z: 1} == Vector.add(%Vector{x: 1, y: 2, z: 1}, %Vector{x: 1, y: -2, z: 0})
  end
end
