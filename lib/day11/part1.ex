defmodule AOC.Day11.Part1 do
  alias AOC.Intcode

  @black 0

  defmodule Robot do
    @up {0, 1}
    @down {0, -1}
    @left {-1, 0}
    @right {1, 0}
    @turn_left 0
    @turn_right 1

    defstruct position: {0, 0}, direction: @up

    def turn(%__MODULE__{direction: @up} = robot, @turn_left), do: %__MODULE__{robot | direction: @left}
    def turn(%__MODULE__{direction: @left} = robot, @turn_left), do: %__MODULE__{robot | direction: @down}
    def turn(%__MODULE__{direction: @down} = robot, @turn_left), do: %__MODULE__{robot | direction: @right}
    def turn(%__MODULE__{direction: @right} = robot, @turn_left), do: %__MODULE__{robot | direction: @up}

    def turn(%__MODULE__{direction: @up} = robot, @turn_right), do: %__MODULE__{robot | direction: @right}
    def turn(%__MODULE__{direction: @right} = robot, @turn_right), do: %__MODULE__{robot | direction: @down}
    def turn(%__MODULE__{direction: @down} = robot, @turn_right), do: %__MODULE__{robot | direction: @left}
    def turn(%__MODULE__{direction: @left} = robot, @turn_right), do: %__MODULE__{robot | direction: @up}

    def move_forward(%__MODULE__{position: {x, y}, direction: {dx, dy}} = robot) do
      %__MODULE__{robot | position: {x + dx, y + dy}}
    end
  end

  def run(input) do
    {:ok, pid} = Intcode.start_link(input)
    Intcode.run(pid)
    paint(pid, %Robot{})
    |> Enum.count()
  end

  defp paint(com, %Robot{position: pos} = robot, panels \\ %{}) do
    case Intcode.status(com) do
      :halted ->
        panels
      _ ->
        Intcode.input(com, Map.get(panels, pos, @black))
        [color, turn] = Intcode.output(com)
        new_panels = Map.put(panels, pos, color)
        new_robot =
          robot
          |> Robot.turn(turn)
          |> Robot.move_forward()
        paint(com, new_robot, new_panels)
    end
  end
end
