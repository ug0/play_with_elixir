defmodule Todo.DatabaseWorker do
  use GenServer

  def start_link(dir) do
    GenServer.start_link(__MODULE__, dir)
  end

  def store(worker_id, key, data) do
    GenServer.call(worker_id, {:store, key, data})
  end

  def get(worker_id, key) do
    GenServer.call(worker_id, {:get, key})
  end

  def init(dir) do
    dir = Path.join(dir, to_string(node()))
    File.mkdir_p!(dir)
    {:ok, dir}
  end

  def handle_call({:store, key, data}, _, dir) do
    dir
    |> file_name(key)
    |> File.write!(:erlang.term_to_binary(data))

    {:reply, :ok, dir}
  end

  def handle_call({:get, key}, _, dir) do
    data = case File.read(file_name(dir, key)) do
      {:ok, contents} -> :erlang.binary_to_term(contents)
      _ -> nil end

    {:reply, data, dir}
  end

  defp file_name(dir, key) do
    Path.join(dir, to_string(key))
  end
end
