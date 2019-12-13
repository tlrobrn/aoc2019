defmodule AOC.Day12.Moon do
  alias AOC.Day12.Vector

  defstruct position: %Vector{}, velocity: %Vector{}

  def gravitate(%__MODULE__{velocity: %Vector{x: x, y: y, z: z}} = this, %__MODULE__{} = other) do
    dx = adjust_x_velocity(this, other)
    dy = adjust_y_velocity(this, other)
    dz = adjust_z_velocitz(this, other)

    %__MODULE__{this | velocity: %Vector{x: x + dx, y: y + dy, z: z + dz}}
  end

  def move(%__MODULE__{position: p, velocity: v} = this) do
    %__MODULE__{this | position: Vector.add(p, v)}
  end

  def potential_energy(%__MODULE__{position: p, velocity: v}) do
    energy(p) * energy(v)
  end

  defp energy(%Vector{x: x, y: y, z: z}) do
    abs(x) + abs(y) + abs(z)
  end

  defp adjust_x_velocity(%__MODULE__{position: %Vector{x: x0}}, %__MODULE__{
         position: %Vector{x: x1}
       })
       when x0 > x1 do
    -1
  end

  defp adjust_x_velocity(%__MODULE__{position: %Vector{x: x0}}, %__MODULE__{
         position: %Vector{x: x1}
       })
       when x0 < x1 do
    1
  end

  defp adjust_x_velocity(_, _) do
    0
  end

  defp adjust_y_velocity(%__MODULE__{position: %Vector{y: y0}}, %__MODULE__{
         position: %Vector{y: y1}
       })
       when y0 > y1 do
    -1
  end

  defp adjust_y_velocity(%__MODULE__{position: %Vector{y: y0}}, %__MODULE__{
         position: %Vector{y: y1}
       })
       when y0 < y1 do
    1
  end

  defp adjust_y_velocity(_, _) do
    0
  end

  defp adjust_z_velocitz(%__MODULE__{position: %Vector{z: z0}}, %__MODULE__{
         position: %Vector{z: z1}
       })
       when z0 > z1 do
    -1
  end

  defp adjust_z_velocitz(%__MODULE__{position: %Vector{z: z0}}, %__MODULE__{
         position: %Vector{z: z1}
       })
       when z0 < z1 do
    1
  end

  defp adjust_z_velocitz(_, _) do
    0
  end
end
