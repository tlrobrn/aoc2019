defmodule AOC.Intcode do
  use GenServer

  # Client

  def start_link(instructions, inputs \\ Stream.cycle([nil])) do
    GenServer.start_link(__MODULE__, {instructions, inputs})
  end

  def set(pid, key_value_pairs) do
    GenServer.cast(pid, {:set, key_value_pairs})
  end

  def read(pid, address) do
    GenServer.call(pid, {:read, address})
  end

  def run(pid) do
    GenServer.cast(pid, :run)
  end

  def output(pid) do
    GenServer.call(pid, :output)
  end

  # Server

  defstruct memory: %{}, pointer: 0, inputs: [], outputs: []

  @impl true
  def init({instructions, inputs}) do
    memory = initialize_memory(instructions)
    {:ok, %__MODULE__{memory: memory, inputs: inputs}}
  end

  @impl true
  def handle_cast({:set, key_value_pairs}, %__MODULE__{memory: memory} = state) when is_list(memory) do
    new_memory =
      key_value_pairs
      |> Enum.reduce(memory, fn {k, v}, acc ->
        acc |> List.replace_at(k, v)
      end)
    {:noreply, %__MODULE__{state | memory: new_memory}}
  end

  @impl true
  def handle_cast(:run, %__MODULE__{memory: memory, pointer: pointer, inputs: inputs, outputs: outputs}) do
    {new_memory, new_pointer, new_inputs, new_outputs} = run(memory, pointer, inputs, outputs)
    {:noreply, %__MODULE__{memory: new_memory, pointer: new_pointer, inputs: new_inputs, outputs: new_outputs}}
  end

  @impl true
  def handle_call({:read, address}, _from, %__MODULE__{memory: memory} = state) when is_list(memory) do
    {:reply, Enum.at(memory, address), state}
  end

  @impl true
  def handle_call(:output, _from, %__MODULE__{outputs: outputs} = state) do
    {:reply, Enum.reverse(outputs), state}
  end

  defp initialize_memory(instructions), do: instructions

  defp run(memory, pointer, inputs, outputs) do
    case step(memory, pointer, inputs, outputs) do
      {:ok, {new_memory, new_pointer, new_inputs, new_outputs}} -> run(new_memory, new_pointer, new_inputs, new_outputs)
      {:halt, new_state} -> new_state
    end
  end

  defp step(memory, pointer, inputs, outputs) when is_list(memory) do
    [_store_mode, right_mode, left_mode, code] = opcode(memory, pointer)
    case code do
      nil -> {:halt, {memory, pointer, inputs, outputs}}
      99 -> {:halt, {memory, pointer, inputs, outputs}}
      1 ->
        [left, right, store] = Enum.slice(memory, pointer+1..pointer+3)
        left_value = if left_mode == 0, do: Enum.at(memory, left), else: left
        right_value = if right_mode == 0, do: Enum.at(memory, right), else: right
        {:ok, {List.replace_at(memory, store, left_value + right_value), pointer + 4, inputs, outputs}}
      2 ->
        [left, right, store] = Enum.slice(memory, pointer+1..pointer+3)
        left_value = if left_mode == 0, do: Enum.at(memory, left), else: left
        right_value = if right_mode == 0, do: Enum.at(memory, right), else: right
        {:ok, {List.replace_at(memory, store, left_value * right_value), pointer + 4, inputs, outputs}}
      3 ->
        store = Enum.at(memory, pointer + 1)
        input = hd(Enum.take(inputs, 1))
        {:ok, {List.replace_at(memory, store, input), pointer + 2, Stream.drop(inputs, 1), outputs}}
      4 ->
        param = Enum.at(memory, pointer + 1)
        {:ok, {memory, pointer + 2, inputs, [Enum.at(memory, param) | outputs]}}
      _ ->
        raise "Bad opcode: #{Enum.at(memory, pointer)}, at location: #{pointer}"
    end
  end

  defp opcode(memory, pointer) when is_list(memory) do
    Enum.at(memory, pointer)
    |> Integer.to_string()
    |> String.pad_leading(5, "0")
    |> String.split("", parts: 4, trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
