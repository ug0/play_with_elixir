defmodule Todo.DatabaseWorker do
  use GenServer

  def start(folder) do
    GenServer.start(__MODULE__, folder)
  end

  def store(worker, key, data) do
    GenServer.cast(worker, {:store, key, data})
  end

  def get(worker, key) do
    GenServer.call(worker, {:get, key})
  end

  def init(folder) do
    {:ok, folder}
  end

  def handle_cast({:store, key, data}, state) do
    file_name(state, key)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, state}
  end

  def handle_call({:get, key}, _caller, state) do
    data =
      case File.read(file_name(state, key)) do
        {:ok, contents} -> :erlang.binary_to_term(contents)
        _ -> nil
      end

    {:reply, data, state}
  end

  def file_name(folder, key) do
    Path.join(folder, to_string(key))
  end
end
