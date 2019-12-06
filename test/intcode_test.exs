defmodule AOC.Intcode.Test do
  use ExUnit.Case
  alias AOC.Intcode

  test "example 1" do
    instructions = [1, 0, 0, 0, 99]
    {:ok, pid} = Intcode.start_link(instructions)
    Intcode.run(pid)

    assert 2 == Intcode.read(pid, 0)
  end

  test "example 2" do
    instructions = [2, 3, 0, 3, 99]
    {:ok, pid} = Intcode.start_link(instructions)
    Intcode.run(pid)

    assert 2 == Intcode.read(pid, 0)
  end

  test "example 3" do
    instructions = [2, 4, 4, 5, 99, 0]
    {:ok, pid} = Intcode.start_link(instructions)
    Intcode.run(pid)

    assert 2 == Intcode.read(pid, 0)
  end

  test "example 4" do
    instructions = [1, 1, 1, 4, 99, 5, 6, 0, 99]
    {:ok, pid} = Intcode.start_link(instructions)
    Intcode.run(pid)

    assert 30 == Intcode.read(pid, 0)
  end
end
