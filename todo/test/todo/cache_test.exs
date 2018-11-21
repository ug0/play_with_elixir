defmodule Todo.CacheTest do
  use ExUnit.Case
  doctest Todo.Cache

  test "server_process" do
    {:ok, cache} = Todo.Cache.start()
    bob_pid = Todo.Cache.server_process(cache, "bob")

    assert bob_pid != Todo.Cache.server_process(cache, "alice")
    assert bob_pid == Todo.Cache.server_process(cache, "bob")
  end

  test "to-do operations" do
    {:ok, cache} = Todo.Cache.start()
    alice = Todo.Cache.server_process(cache, "alice")
    Todo.Server.add_entry(alice, %{date: ~D[2018-11-11], title: "Dentist"})
    entries = Todo.Server.entries(alice, ~D[2018-11-11])

    assert [%{date: ~D[2018-11-11], title: "Dentist"}] = entries
  end
end
