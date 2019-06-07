Code.load_file("count_change.ex", __DIR__)

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule CountChangeTest do
  use ExUnit.Case

  test "count change" do
    assert Change.count(100, [1, 5, 10, 25, 50]) == 292
  end
end
