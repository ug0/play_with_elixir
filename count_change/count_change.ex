defmodule Change do
  def count(0, _coins), do: 1
  def count(amount, _coins) when amount < 0, do: 0
  def count(_amount, []), do: 0

  def count(amount, [first | rest] = coins) do
    count(amount, rest) + count(amount - first, coins)
  end
end
