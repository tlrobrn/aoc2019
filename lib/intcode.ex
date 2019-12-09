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

  defstruct memory: %{}, pointer: 0, relative_offset: 0, inputs: [], outputs: [], status: :ready

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
  def handle_cast(:run, state) do
    {:noreply, step(%__MODULE__{state | status: :running})}
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

  defp step(%__MODULE__{memory: memory, pointer: pointer, inputs: inputs, outputs: outputs} = state) do
    [_third_mode, second_mode, first_mode, code] = opcode(memory, pointer)
    case code do
      nil -> %__MODULE__{state | status: :halted}
      99 -> %__MODULE__{state | status: :halted}
      1 ->
        [first, second, third] = parameters(memory, pointer, 3)
        first_value = if first_mode == 0, do: Map.get(memory, first, 0), else: first
        second_value = if second_mode == 0, do: Map.get(memory, second, 0), else: second
        step(%__MODULE__{state | memory: Map.put(memory, third, first_value + second_value), pointer: pointer + 4})
      2 ->
        [first, second, third] = parameters(memory, pointer, 3)
        first_value = if first_mode == 0, do: Map.get(memory, first, 0), else: first
        second_value = if second_mode == 0, do: Map.get(memory, second, 0), else: second
        step(%__MODULE__{state | memory: Map.put(memory, third, first_value * second_value), pointer: pointer + 4})
      3 ->
        if Enum.empty?(inputs) do
          %__MODULE__{state | status: :ready}
        else
          store = Map.get(memory, pointer + 1, 0)
          [input | new_inputs] = inputs
          step(%__MODULE__{state | memory: Map.put(memory, store, input), pointer: pointer + 2, inputs: new_inputs})
        end
      4 ->
        param = Map.get(memory, pointer + 1, 0)
        step(%__MODULE__{state | pointer: pointer + 2, outputs: [Map.get(memory, param, 0) | outputs]})
      5 ->
        [first, second] = parameters(memory, pointer, 2)
        first_value = if first_mode == 0, do: Map.get(memory, first, 0), else: first
        second_value = if second_mode == 0, do: Map.get(memory, second, 0), else: second
        new_pointer = if first_value == 0, do: pointer + 3, else: second_value
        step(%__MODULE__{state | pointer: new_pointer})
      6 ->
        [first, second] = parameters(memory, pointer, 2)
        first_value = if first_mode == 0, do: Map.get(memory, first, 0), else: first
        second_value = if second_mode == 0, do: Map.get(memory, second, 0), else: second
        new_pointer = if first_value == 0, do: second_value, else: pointer + 3
        step(%__MODULE__{state | pointer: new_pointer})
      7 ->
        [first, second, third] = parameters(memory, pointer, 3)
        first_value = if first_mode == 0, do: Map.get(memory, first, 0), else: first
        second_value = if second_mode == 0, do: Map.get(memory, second, 0), else: second
        result = if first_value < second_value, do: 1, else: 0
        step(%__MODULE__{state | memory: Map.put(memory, third, result), pointer: pointer + 4})
      8 ->
        [first, second, third] = parameters(memory, pointer, 3)
        first_value = if first_mode == 0, do: Map.get(memory, first, 0), else: first
        second_value = if second_mode == 0, do: Map.get(memory, second, 0), else: second
        result = if first_value == second_value, do: 1, else: 0
        step(%__MODULE__{state | memory: Map.put(memory, third, result), pointer: pointer + 4})
      _ ->
        raise "Bad opcode: #{Map.get(memory, pointer)}, at location: #{pointer}"
    end
  end

  defp parameters(memory, pointer, n) do
    1..n |> Enum.map(&Map.get(memory, pointer + &1, 0))
  end

  defp opcode(memory, pointer) do
    Map.get(memory, pointer, 0)
    |> Integer.to_string()
    |> String.pad_leading(5, "0")
    |> String.split("", parts: 4, trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
