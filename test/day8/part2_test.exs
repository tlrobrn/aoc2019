defmodule AOC.Day8.Part2.Test do
  use ExUnit.Case, async: true
  alias AOC.Day8.Part2

  test "example parse" do
    input = [0, 2, 2, 2, 1, 1, 2, 2, 2, 2, 1, 2, 0, 0, 0, 0]

    assert [
             [
               [0, 2],
               [2, 2]
             ],
             [
               [1, 1],
               [2, 2]
             ],
             [
               [2, 2],
               [1, 2]
             ],
             [
               [0, 0],
               [0, 0]
             ]
           ] == Part2.parse_pixels(input, {2, 2})
  end

  test "example flatten" do
    input = [0, 2, 2, 2, 1, 1, 2, 2, 2, 2, 1, 2, 0, 0, 0, 0]
    image = Part2.parse_pixels(input, {2, 2})

    assert [
             [0, 1],
             [1, 0]
           ] == Part2.flatten_layers(image)
  end

  test "render" do
    layer = [
      [0, 1],
      [1, 0]
    ]

    assert "\n X\nX \n" == Part2.render_image(layer)
  end
end
