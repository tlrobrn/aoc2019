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

  test "day 5 part 2 example input is < 8" do
    instructions = [
      3,
      21,
      1008,
      21,
      8,
      20,
      1005,
      20,
      22,
      107,
      8,
      21,
      20,
      1006,
      20,
      31,
      1106,
      0,
      36,
      98,
      0,
      0,
      1002,
      21,
      125,
      20,
      4,
      20,
      1105,
      1,
      46,
      104,
      999,
      1105,
      1,
      46,
      1101,
      1000,
      1,
      20,
      4,
      20,
      1105,
      1,
      46,
      98,
      99
    ]

    {:ok, pid} = Intcode.start_link(instructions)
    Intcode.run(pid)
    Intcode.input(pid, 0)
    output = Intcode.output(pid)

    assert [999] == output
  end

  test "day 5 part 2 example input is 8" do
    instructions = [
      3,
      21,
      1008,
      21,
      8,
      20,
      1005,
      20,
      22,
      107,
      8,
      21,
      20,
      1006,
      20,
      31,
      1106,
      0,
      36,
      98,
      0,
      0,
      1002,
      21,
      125,
      20,
      4,
      20,
      1105,
      1,
      46,
      104,
      999,
      1105,
      1,
      46,
      1101,
      1000,
      1,
      20,
      4,
      20,
      1105,
      1,
      46,
      98,
      99
    ]

    {:ok, pid} = Intcode.start_link(instructions)
    Intcode.run(pid)
    Intcode.input(pid, 8)
    output = Intcode.output(pid)

    assert [1000] == output
  end

  test "day 5 part 2 example input is > 8" do
    instructions = [
      3,
      21,
      1008,
      21,
      8,
      20,
      1005,
      20,
      22,
      107,
      8,
      21,
      20,
      1006,
      20,
      31,
      1106,
      0,
      36,
      98,
      0,
      0,
      1002,
      21,
      125,
      20,
      4,
      20,
      1105,
      1,
      46,
      104,
      999,
      1105,
      1,
      46,
      1101,
      1000,
      1,
      20,
      4,
      20,
      1105,
      1,
      46,
      98,
      99
    ]

    {:ok, pid} = Intcode.start_link(instructions)
    Intcode.run(pid)
    Intcode.input(pid, 12)
    output = Intcode.output(pid)

    assert [1001] == output
  end

  test "day 8 part 1" do
    instructions = [
      109,
      1,
      204,
      -1,
      1001,
      100,
      1,
      100,
      1008,
      100,
      16,
      101,
      1006,
      101,
      0,
      99
    ]

    {:ok, pid} = Intcode.start_link(instructions)
    Intcode.run(pid)
    output = Intcode.output(pid)

    assert instructions == output
  end

  test "day 8 part 2" do
    instructions = [
      1102,
      34_915_192,
      34_915_192,
      7,
      4,
      7,
      99,
      0
    ]

    {:ok, pid} = Intcode.start_link(instructions)
    Intcode.run(pid)
    [output] = Intcode.output(pid)

    assert 16 == length(Integer.digits(output))
  end

  test "day 8 part 3" do
    instructions = [
      104,
      1_125_899_906_842_624,
      99
    ]

    {:ok, pid} = Intcode.start_link(instructions)
    Intcode.run(pid)
    [output] = Intcode.output(pid)

    assert 1_125_899_906_842_624 == output
  end
end
