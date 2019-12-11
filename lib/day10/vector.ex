defmodule AOC.Day10.Vector do
  def dist({x0, y0}, {x1, y1}), do: :math.sqrt((x1 - x0) * (x1 - x0) + (y1 - y0) * (y1 - y0))

  def angle({x0, y0}, {x1, y1}) do
    case angle_against_vertical({x1 - x0, y1 - y0}) do
      r when r < 0 -> 2 * :math.pi() - r
      r -> r
    end
  end

  defp angle_against_vertical(vector),
    do: :math.atan2(determinant(vector, {0, 1}), dot_product(vector, {0, 1}))

  defp dot_product({x0, y0}, {x1, y1}), do: x0 * x1 + y0 * y1
  defp determinant({x0, y0}, {x1, y1}), do: x0 * y1 - y0 * x1
end
