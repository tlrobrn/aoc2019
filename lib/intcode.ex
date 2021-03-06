defmodule AOC.Intcode do
  # Puzzle input parsing
  defmacro __using__(_opts) do
    quote do
      defp parse(lines) do
        lines
        |> Stream.flat_map(&String.split(&1, ",", trim: true))
        |> Enum.map(&String.to_integer/1)
      end
    end
  end

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

  def clone(pid) do
    GenServer.call(pid, :clone)
  end

  # Server

  defstruct memory: %{}, pointer: 0, relative_offset: 0, inputs: [], outputs: [], status: :ready

  @impl true
  def init(%__MODULE__{} = state) do
    {:ok, state}
  end

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
    {:reply, Map.get(memory, address, 0), state}
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

  @impl true
  def handle_call(:clone, _from, state) do
    {:reply, GenServer.start_link(__MODULE__, state), state}
  end

  defp initialize_memory(instructions) do
    instructions
    |> Stream.with_index()
    |> Map.new(fn {v, k} -> {k, v} end)
  end

  defp step(
         %__MODULE__{
           memory: memory,
           pointer: pointer,
           relative_offset: relative_offset,
           inputs: inputs,
           outputs: outputs
         } = state
       ) do
    [third_mode, second_mode, first_mode, code] = opcode(memory, pointer)

    case code do
      99 ->
        %__MODULE__{state | status: :halted}

      1 ->
        [first, second, third] = parameters(memory, pointer, 3)
        first_value = fetch(state, first, first_mode)
        second_value = fetch(state, second, second_mode)

        step(%__MODULE__{
          state
          | memory: write(state, third, third_mode, first_value + second_value),
            pointer: pointer + 4
        })

      2 ->
        [first, second, third] = parameters(memory, pointer, 3)
        first_value = fetch(state, first, first_mode)
        second_value = fetch(state, second, second_mode)

        step(%__MODULE__{
          state
          | memory: write(state, third, third_mode, first_value * second_value),
            pointer: pointer + 4
        })

      3 ->
        if Enum.empty?(inputs) do
          %__MODULE__{state | status: :ready}
        else
          param = Map.get(memory, pointer + 1, 0)
          [input | new_inputs] = inputs

          step(%__MODULE__{
            state
            | memory: write(state, param, first_mode, input),
              pointer: pointer + 2,
              inputs: new_inputs
          })
        end

      4 ->
        param = Map.get(memory, pointer + 1, 0)

        step(%__MODULE__{
          state
          | pointer: pointer + 2,
            outputs: [fetch(state, param, first_mode) | outputs]
        })

      5 ->
        [first, second] = parameters(memory, pointer, 2)
        first_value = fetch(state, first, first_mode)
        second_value = fetch(state, second, second_mode)
        new_pointer = if first_value == 0, do: pointer + 3, else: second_value
        step(%__MODULE__{state | pointer: new_pointer})

      6 ->
        [first, second] = parameters(memory, pointer, 2)
        first_value = fetch(state, first, first_mode)
        second_value = fetch(state, second, second_mode)
        new_pointer = if first_value == 0, do: second_value, else: pointer + 3
        step(%__MODULE__{state | pointer: new_pointer})

      7 ->
        [first, second, third] = parameters(memory, pointer, 3)
        first_value = fetch(state, first, first_mode)
        second_value = fetch(state, second, second_mode)
        result = if first_value < second_value, do: 1, else: 0

        step(%__MODULE__{
          state
          | memory: write(state, third, third_mode, result),
            pointer: pointer + 4
        })

      8 ->
        [first, second, third] = parameters(memory, pointer, 3)
        first_value = fetch(state, first, first_mode)
        second_value = fetch(state, second, second_mode)
        result = if first_value == second_value, do: 1, else: 0

        step(%__MODULE__{
          state
          | memory: write(state, third, third_mode, result),
            pointer: pointer + 4
        })

      9 ->
        param = Map.get(memory, pointer + 1, 0)
        new_offset = relative_offset + fetch(state, param, first_mode)
        step(%__MODULE__{state | pointer: pointer + 2, relative_offset: new_offset})

      _ ->
        raise "Bad opcode: #{Map.get(memory, pointer)}, at location: #{pointer}"
    end
  end

  defp parameters(memory, pointer, n) do
    1..n |> Enum.map(&Map.get(memory, pointer + &1, 0))
  end

  defp fetch(%__MODULE__{memory: memory}, parameter, 0) do
    Map.get(memory, parameter, 0)
  end

  defp fetch(_, parameter, 1), do: parameter

  defp fetch(%__MODULE__{memory: memory, relative_offset: offset}, parameter, 2)
       when offset + parameter >= 0 do
    Map.get(memory, offset + parameter, 0)
  end

  defp write(%__MODULE__{memory: memory}, key, 0, value) do
    Map.put(memory, key, value)
  end

  defp write(%__MODULE__{memory: memory, relative_offset: offset}, key, 2, value)
       when offset + key >= 0 do
    Map.put(memory, offset + key, value)
  end

  defp opcode(memory, pointer) do
    Map.get(memory, pointer, 0)
    |> Integer.to_string()
    |> String.pad_leading(5, "0")
    |> String.split("", parts: 4, trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
