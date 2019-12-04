defmodule AOC.Day2.Part1 do
  def run(input) do
    result = process(input, 0)
    hd(result)
  end

  defp process(state, index) do
    command = Enum.at(state, index)
    if command == 99 do
      state
    else
      left = Enum.at(state, index + 1)
      right = Enum.at(state, index + 2)
      store = Enum.at(state, index + 3)

      new_state = process_command(command, left, right, store, state)
      process(new_state, index + 4)
    end
  end

  defp process_command(1, left, right, store, state) do
    result = Enum.at(state, left) + Enum.at(state, right)
    List.replace_at(state, store, result)
  end

  defp process_command(2, left, right, store, state) do
    result = Enum.at(state, left) * Enum.at(state, right)
    List.replace_at(state, store, result)
  end
end
