defmodule AOC.Day8.Part2 do
  @transparent 2
  @dimensions {25, 6}

  def run(input) do
    input
    |> parse_pixels(@dimensions)
    |> flatten_layers()
    |> render_image()
  end

  def parse_pixels(pixel_stream, {width, height}) do
    pixel_stream
    |> Enum.chunk_every(width)
    |> Enum.chunk_every(height)
  end

  def flatten_layers(layers) do
    layers
    |> Enum.reverse()
    |> Enum.reduce(nil, &flatten/2)
    |> map_to_layer()
  end

  def render_image(image) do
    image_string =
      image
      |> Stream.map(
        &Enum.map(&1, fn
          0 -> " "
          1 -> "X"
        end)
      )
      |> Stream.map(&Enum.join(&1, ""))
      |> Enum.join("\n")

    "\n" <> image_string <> "\n"
  end

  defp flatten(layer, nil) do
    layer_to_map(layer)
  end

  defp flatten(layer, image) do
    layer
    |> layer_to_map()
    |> Stream.reject(fn {_key, pixel} -> pixel == @transparent end)
    |> Enum.reduce(image, fn {key, pixel}, new_image ->
      Map.put(new_image, key, pixel)
    end)
  end

  defp layer_to_map(layer) do
    layer
    |> Stream.with_index()
    |> Stream.flat_map(fn {row, y} ->
      row
      |> Stream.with_index()
      |> Enum.map(fn {pixel, x} ->
        {{x, y}, pixel}
      end)
    end)
    |> Map.new()
  end

  defp map_to_layer(layer_map) do
    {width, height} = dimensions_from_map(layer_map)

    layer =
      @transparent
      |> List.duplicate(width)
      |> List.duplicate(height)

    Enum.reduce(layer_map, layer, fn {{column, row}, pixel}, new_layer ->
      List.replace_at(
        new_layer,
        row,
        List.replace_at(
          Enum.at(new_layer, row),
          column,
          pixel
        )
      )
    end)
  end

  defp dimensions_from_map(layer_map) do
    width =
      layer_map
      |> Map.keys()
      |> Stream.map(fn {x, _} -> x end)
      |> Enum.max()

    height =
      layer_map
      |> Map.keys()
      |> Stream.map(fn {_, y} -> y end)
      |> Enum.max()

    {width + 1, height + 1}
  end
end
