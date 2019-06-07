defmodule Shapes do
  @moduledoc """
  Solutions to the Elixir exercises at Zidcn.
  https://github.com/zidcn/interns-training/blob/master/backend/elixir/exercises/shapes.md
  """

  ## First attempt
  # def square(n) do
  #   "*"
  #   |> List.duplicate(5)
  #   |> Enum.join(" ")
  #   |> List.duplicate(5)
  #   |> Enum.join("\n")
  # end

  def square(n) do
    shape(:square, {n - 1, n - 1})
  end

  def rectangle(n, m) do
    shape(:rectangle, {n - 1, m - 1})
  end

  def pyramid(n) do
    shape(:pyramid, {n - 1, n - 1})
  end

  defp shape(shape, {max_row, max_col}) do
    Enum.reduce(0..max_row, [], fn row_num, rows ->
      [row(shape, {max_row, max_col}, row_num) | rows]
    end)
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  defp row(shape, {max_row, max_col}, row_num) do
    Enum.reduce(0..max_col, [], fn col_num, cols ->
      [element(shape, {max_row, max_col}, {row_num, col_num}) | cols]
    end)
    |> Enum.reverse()
    |> Enum.join(" ")
  end

  defp element(:square, _size, _pos), do: "*"

  defp element(:rectangle, _size, {0, _}), do: "*"
  defp element(:rectangle, _size, {_, 0}), do: "*"
  defp element(:rectangle, {max_row, _}, {max_row, _}), do: "*"
  defp element(:rectangle, {_, max_col}, {_, max_col}), do: "*"
  defp element(:rectangle, _size, _pos), do: " "

  defp element(:pyramid, {max_row, _}, {row, col}) when row >= (max_row - col), do: "*"
  defp element(:pyramid, _size, _pos), do: ""
end
