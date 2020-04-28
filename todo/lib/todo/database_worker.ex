defmodule Todo.DatabaseWorker do
  use GenServer

  def start_link({dir, worker_id}) do
    IO.puts("Starting database worker #{worker_id}.")

    GenServer.start_link(__MODULE__, dir, name: via_tuple(worker_id))
  end

  def store(worker_id, key, data) do
    GenServer.cast(via_tuple(worker_id), {:store, key, data})
  end

  def get(worker_id, key) do
    GenServer.call(via_tuple(worker_id), {:get, key})
  end

  defp via_tuple(worker_id) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, worker_id})
  end

  def init(dir) do
    File.mkdir_p!(dir)
    {:ok, dir}
  end

  def handle_cast({:store, key, data}, dir) do
    dir
    |> file_name(key)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, dir}
  end

  def handle_call({:get, key}, _, dir) do
    data = case File.read(file_name(dir, key)) do
      {:ok, contents} -> :erlang.binary_to_term(contents)
      _ -> nil
    end

    {:reply, data, dir}
  end

  defp file_name(dir, key) do
    Path.join(dir, to_string(key))
  end
end
