defmodule AOC.Day11.Robot do
  alias AOC.Intcode

  @up {0, 1}
  @down {0, -1}
  @left {-1, 0}
  @right {1, 0}
  @turn_left 0
  @turn_right 1
  @black 0

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

  def run(%__MODULE__{position: pos} = robot, computer, panels \\ %{}) do
    case Intcode.status(computer) do
      :halted ->
        panels
      _ ->
        Intcode.input(computer, Map.get(panels, pos, @black))
        [color, turn] = Intcode.output(computer)
        new_panels = Map.put(panels, pos, color)
        new_robot =
          robot
          |> turn(turn)
          |> move_forward()
        run(new_robot, computer, new_panels)
    end
  end
end
