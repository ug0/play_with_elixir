defmodule Todo.Database do
  use GenServer

  alias Todo.DatabaseWorker

  @db_folder "./persist"

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
    GenServer.cast(__MODULE__, {:store, key, data})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def init(_) do
    File.mkdir_p!(@db_folder)

    state = 0..2
    |> Enum.reduce(%{}, fn i, workers ->
      {:ok, worker} = DatabaseWorker.start(@db_folder)
      Map.put(workers, i, worker)
    end)

    {:ok, state}
  end

  def handle_cast({:store, key, data}, state) do
    choose_worker(state, key)
    |> DatabaseWorker.store(key, data)

    {:noreply, state}
  end

  def handle_call({:get, key}, _caller, state) do
    data =
      choose_worker(state, key)
      |> DatabaseWorker.get(key)

    {:reply, data, state}
  end

  def choose_worker(state, key) do
    Map.fetch!(state, :erlang.phash2(key, 3))
  end
end
