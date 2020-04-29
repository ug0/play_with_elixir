defmodule SimpleRegistry do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def register(name) do
    if :ets.insert_new(__MODULE__, {name, self()}) do
      GenServer.cast(__MODULE__, {:link, self()})
      :ok
    else
      :error
    end
  end

  def whereis(name) do
    case :ets.lookup(__MODULE__, name) do
      [{^name, pid}] -> pid
      [] -> nil
    end
  end

  @impl GenServer
  def init(_) do
    Process.flag(:trap_exit, true)
    :ets.new(__MODULE__, [:named_table, :public])
    {:ok, nil}
  end

  @impl GenServer
  def handle_cast({:link, pid}, state) do
    Process.link(pid)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:EXIT, pid, _reason}, state) do
    :ets.match_delete(__MODULE__, {:_, pid})
    {:noreply, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end
