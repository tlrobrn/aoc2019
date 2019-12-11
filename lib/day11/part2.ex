defmodule AOC.Day11.Part2 do
  alias AOC.Day11.Robot
  alias AOC.Intcode

  @black 0
  @white 1

  def run(input) do
    {:ok, pid} = Intcode.start_link(input)
    %Robot{}
    |> Robot.run(pid, %{{0, 0} => @white})
    |> display()
  end

  defp display(panels) do
    panels_string =
      y_range(panels)
        |> Enum.map(fn y ->
          x_range(panels)
          |> Enum.map(fn x ->
            case Map.get(panels, {x, y}, @black) do
              @black -> " "
              @white -> "X"
            end
          end)
          |> Enum.join("")
        end)
        |> Enum.join("\n")

    "\n" <> panels_string <> "\n"
  end

  defp y_range(panels) do
    {{_, min_y}, {_, max_y}} =
      panels
      |> Map.keys()
      |> Enum.min_max_by(fn {_, y} -> y end)

    max_y..min_y
  end

  defp x_range(panels) do
    {{min_x, _}, {max_x, _}} =
      panels
      |> Map.keys()
      |> Enum.min_max_by(fn {x, _} -> x end)

    min_x..max_x
  end
end
