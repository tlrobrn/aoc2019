defmodule AOC.Intcode do
  use GenServer

  # Client

  def start_link(instructions) do
    GenServer.start_link(__MODULE__, instructions)
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

  def input(pid, input) do
    GenServer.call(pid, {:input, input})
  end

  def status(pid) do
    GenServer.call(pid, :status)
  end

  # Server

  defstruct memory: %{}, pointer: 0, inputs: [], outputs: [], status: :ready

  @impl true
  def init(instructions) do
    memory = initialize_memory(instructions)
    {:ok, %__MODULE__{memory: memory}}
  end

  @impl true
  def handle_cast({:set, key_value_pairs}, %__MODULE__{memory: memory} = state) do
    new_memory =
      key_value_pairs
      |> Enum.reduce(memory, fn {k, v}, acc ->
        acc |> Map.put(k, v)
      end)
    {:noreply, %__MODULE__{state | memory: new_memory}}
  end

  @impl true
  def handle_cast(:run, %__MODULE__{memory: memory, pointer: pointer, inputs: inputs, outputs: outputs}) do
    {new_memory, new_pointer, new_inputs, new_outputs, new_status} = run(memory, pointer, inputs, outputs)
    {:noreply, %__MODULE__{memory: new_memory, pointer: new_pointer, inputs: new_inputs, outputs: new_outputs, status: new_status}}
  end

  @impl true
  def handle_call({:read, address}, _from, %__MODULE__{memory: memory} = state) do
    {:reply, Map.get(memory, address), state}
  end

  @impl true
  def handle_call(:output, _from, %__MODULE__{outputs: outputs} = state) do
    {:reply, Enum.reverse(outputs), %__MODULE__{state | outputs: []}}
  end

  @impl true
  def handle_call({:input, input}, _from, %__MODULE__{inputs: inputs} = state) do
    GenServer.cast(self(), :run)
    new_inputs = inputs ++ [input]
    {:reply, new_inputs, %__MODULE__{state | inputs: new_inputs}}
  end

  @impl true
  def handle_call(:status, _from, %__MODULE__{status: status} = state) do
    {:reply, status, state}
  end

  defp initialize_memory(instructions) do
    instructions
    |> Stream.with_index()
    |> Map.new(fn {v, k} -> {k, v} end)
  end

  defp run(memory, pointer, inputs, outputs) do
    case step(memory, pointer, inputs, outputs) do
      {:ok, {new_memory, new_pointer, new_inputs, new_outputs}} -> run(new_memory, new_pointer, new_inputs, new_outputs)
      {:halt, new_state} -> new_state
    end
  end

  defp step(memory, pointer, inputs, outputs) do
    [_store_mode, right_mode, left_mode, code] = opcode(memory, pointer)
    case code do
      nil -> {:halt, {memory, pointer, inputs, outputs, :halted}}
      99 -> {:halt, {memory, pointer, inputs, outputs, :halted}}
      1 ->
        {left, right, store} = {
          Map.get(memory, pointer + 1, 0),
          Map.get(memory, pointer + 2, 0),
          Map.get(memory, pointer + 3, 0),
        }
        left_value = if left_mode == 0, do: Map.get(memory, left, 0), else: left
        right_value = if right_mode == 0, do: Map.get(memory, right, 0), else: right
        {:ok, {Map.put(memory, store, left_value + right_value), pointer + 4, inputs, outputs}}
      2 ->
        {left, right, store} = {
          Map.get(memory, pointer + 1, 0),
          Map.get(memory, pointer + 2, 0),
          Map.get(memory, pointer + 3, 0),
        }
        left_value = if left_mode == 0, do: Map.get(memory, left, 0), else: left
        right_value = if right_mode == 0, do: Map.get(memory, right, 0), else: right
        {:ok, {Map.put(memory, store, left_value * right_value), pointer + 4, inputs, outputs}}
      3 ->
        if Enum.empty?(inputs) do
          {:halt, {memory, pointer, inputs, outputs, :ready}}
        else
          store = Map.get(memory, pointer + 1, 0)
          [input | new_inputs] = inputs
          {:ok, {Map.put(memory, store, input), pointer + 2, new_inputs, outputs}}
        end
      4 ->
        param = Map.get(memory, pointer + 1, 0)
        {:ok, {memory, pointer + 2, inputs, [Map.get(memory, param, 0) | outputs]}}
      5 ->
        {left, right} = {
          Map.get(memory, pointer + 1, 0),
          Map.get(memory, pointer + 2, 0),
        }
        left_value = if left_mode == 0, do: Map.get(memory, left, 0), else: left
        right_value = if right_mode == 0, do: Map.get(memory, right, 0), else: right
        new_pointer = if left_value == 0, do: pointer + 3, else: right_value
        {:ok, {memory, new_pointer, inputs, outputs}}
      6 ->
        {left, right} = {
          Map.get(memory, pointer + 1, 0),
          Map.get(memory, pointer + 2, 0),
        }
        left_value = if left_mode == 0, do: Map.get(memory, left, 0), else: left
        right_value = if right_mode == 0, do: Map.get(memory, right, 0), else: right
        new_pointer = if left_value == 0, do: right_value, else: pointer + 3
        {:ok, {memory, new_pointer, inputs, outputs}}
      7 ->
        {left, right, store} = {
          Map.get(memory, pointer + 1, 0),
          Map.get(memory, pointer + 2, 0),
          Map.get(memory, pointer + 3, 0),
        }
        left_value = if left_mode == 0, do: Map.get(memory, left, 0), else: left
        right_value = if right_mode == 0, do: Map.get(memory, right, 0), else: right
        result = if left_value < right_value, do: 1, else: 0
        {:ok, {Map.put(memory, store, result), pointer + 4, inputs, outputs}}
      8 ->
        {left, right, store} = {
          Map.get(memory, pointer + 1, 0),
          Map.get(memory, pointer + 2, 0),
          Map.get(memory, pointer + 3, 0),
        }
        left_value = if left_mode == 0, do: Map.get(memory, left, 0), else: left
        right_value = if right_mode == 0, do: Map.get(memory, right, 0), else: right
        result = if left_value == right_value, do: 1, else: 0
        {:ok, {Map.put(memory, store, result), pointer + 4, inputs, outputs}}
      _ ->
        raise "Bad opcode: #{Map.get(memory, pointer)}, at location: #{pointer}"
    end
  end

  defp opcode(memory, pointer) do
    Map.get(memory, pointer, 0)
    |> Integer.to_string()
    |> String.pad_leading(5, "0")
    |> String.split("", parts: 4, trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
