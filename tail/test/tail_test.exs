defmodule TailTest do
  use ExUnit.Case
  doctest Tail

  test "greets the world" do
    assert Tail.hello() == :world
  end
end
