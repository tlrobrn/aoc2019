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

  # Server

  defstruct memory: %{}, pointer: 0

  @impl true
  def init(instructions) do
    memory = initialize_memory(instructions)
    {:ok, %__MODULE__{memory: memory}}
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
  def handle_cast(:run, %__MODULE__{memory: memory, pointer: pointer} = state) do
    {new_memory, new_pointer} = run(memory, pointer)
    {:noreply, %__MODULE__{state | memory: new_memory, pointer: new_pointer}}
  end

  @impl true
  def handle_call({:read, address}, _from, %__MODULE__{memory: memory} = state) when is_list(memory) do
    {:reply, Enum.at(memory, address), state}
  end

  defp initialize_memory(instructions), do: instructions

  defp run(memory, pointer) do
    case step(memory, pointer) do
      {:ok, {new_memory, new_pointer}} -> run(new_memory, new_pointer)
      {:halt, new_state} -> new_state
    end
  end

  defp step(memory, pointer) when is_list(memory) do
    opcode = Enum.at(memory, pointer)
    case opcode do
      nil -> {:halt, {memory, pointer}}
      99 -> {:halt, {memory, pointer}}
      1 ->
        left = Enum.at(memory, pointer + 1)
        right = Enum.at(memory, pointer + 2)
        store = Enum.at(memory, pointer + 3)
        {:ok, {do_command(memory, left, right, store, &+/2), pointer + 4}}
      2 ->
        left = Enum.at(memory, pointer + 1)
        right = Enum.at(memory, pointer + 2)
        store = Enum.at(memory, pointer + 3)
        {:ok, {do_command(memory, left, right, store, &*/2), pointer + 4}}
      _ -> {:ok, {memory, pointer + 1}}
    end
  end

  defp do_command(memory, left, right, store, op) when is_list(memory) do
    result = op.(Enum.at(memory, left), Enum.at(memory, right))
    List.replace_at(memory, store, result)
  end
end
