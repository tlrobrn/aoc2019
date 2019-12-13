defmodule AOC.Day13.Part2 do
  alias AOC.Intcode

  @paddle 3
  @ball 4

  def run(input) do
    {:ok, pid} = Intcode.start_link(input)
    Intcode.set(pid, [{0, 2}])
    Intcode.run(pid)

    play(pid)
  end

  defp play(game, paddle \\ nil, ball \\ nil) do
    output =
      game
      |> Intcode.output()
      |> Enum.chunk_every(3)

    case Intcode.status(game) do
      :halted ->
        find_score(output)

      _ ->
        paddle = find_paddle(output) || paddle
        ball = find_ball(output) || ball

        cond do
          ball < paddle -> Intcode.input(game, -1)
          ball > paddle -> Intcode.input(game, 1)
          ball == paddle -> Intcode.input(game, 0)
        end

        play(game, paddle, ball)
    end
  end

  defp find_ball(output) do
    output
    |> Enum.find(fn [_, _, id] -> id == @ball end)
    |> case do
      nil -> nil
      [x, _, _] -> x
    end
  end

  defp find_paddle(output) do
    output
    |> Enum.find(fn [_, _, id] -> id == @paddle end)
    |> case do
      nil -> nil
      [x, _, _] -> x
    end
  end

  defp find_score(output) do
    output
    |> Enum.find(fn [x, y, _] -> x == -1 && y == 0 end)
    |> case do
      nil -> nil
      [_, _, score] -> score
    end
  end
end
