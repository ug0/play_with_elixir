defmodule Todo.Server do
  use GenServer

  def start(name) do
    GenServer.start(__MODULE__, name)
  end

  def add_entry(todo_server, new_entry) do
    GenServer.cast(todo_server, {:add_entry, new_entry})
  end

  def entries(todo_server, date) do
    GenServer.call(todo_server, {:entries, date})
  end

  def init(name) do
    list = Todo.Database.get(name) || Todo.List.new()

    {:ok, {name, list}}
  end

  def handle_cast({:add_entry, new_entry}, {name, list}) do
    new_list = Todo.List.add_entry(list, new_entry)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  def handle_call({:entries, date}, _, state = {_name, list}) do
    {:reply, Todo.List.entries(list, date), state}
  end
end
