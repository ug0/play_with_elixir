defmodule Todo.Database do
  use GenServer

  alias Todo.DatabaseWorker

  @db_folder "./persist"

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
    key
    |> choose_worker()
    |> DatabaseWorker.store(key, data)
  end

  def get(key) do
    key
    |> choose_worker()
    |> DatabaseWorker.get(key)
  end

  defp choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key})
  end

  def init(_) do
    File.mkdir_p!(@db_folder)

    workers = Enum.into(0..2, %{}, fn i ->
      {:ok, worker} = DatabaseWorker.start(@db_folder)
      {i, worker}
    end)

    {:ok, workers}
  end

  def handle_call({:choose_worker, key}, _caller, workers) do
    worker = Map.fetch!(workers, :erlang.phash2(key, 3))

    {:reply, worker, workers}
  end
end
