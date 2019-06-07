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

  def square(n, offset \\ 0) do
    shape_str(:square, {n - 1, n - 1}, offset)
  end

  def rectangle(n, m, offset \\ 0) do
    shape_str(:rectangle, {n - 1, m - 1}, offset)
  end

  def pyramid(n, offset \\ 0) do
    shape_str(:pyramid, {n - 1, n - 1}, offset)
  end

  def inverted_pyramid(n, offset \\ 0) do
    shape_str(:inverted_pyramid, {n - 1, n - 1}, offset)
  end

  def diamond(n, offset \\ 0) do
    pyramid(n, offset) <> "\n" <> inverted_pyramid(n - 1, offset + 1)
  end

  def pascal_triangle(n, offset \\ 0) do
    shape_str(:pascal_triangle, {n - 1, n - 1}, offset)
  end

  defp shape_str(kind, size, offset \\ 0) do
    kind
    |> shape(size)
    |> Enum.map(fn row ->
      String.duplicate(" ", offset) <> Enum.join(row, " ")
    end)
    |> Enum.join("\n")
  end

  defp shape(kind, {max_row, max_col}) do
    Enum.reduce(0..max_row, [], fn row_num, rows ->
      [row(kind, {max_row, max_col}, row_num) | rows]
    end)
    |> Enum.reverse()
  end

  defp row(kind, {max_row, max_col}, row_num) do
    Enum.reduce(0..max_col, [], fn col_num, cols ->
      [element(kind, {max_row, max_col}, {row_num, col_num}) | cols]
    end)
    |> Enum.reverse()
  end

  defp element(:square, _size, _pos), do: "*"

  defp element(:rectangle, _size, {0, _}), do: "*"
  defp element(:rectangle, _size, {_, 0}), do: "*"
  defp element(:rectangle, {max_row, _}, {max_row, _}), do: "*"
  defp element(:rectangle, {_, max_col}, {_, max_col}), do: "*"
  defp element(:rectangle, _size, _pos), do: " "

  defp element(:pyramid, {max_row, _}, {row, col}) when row >= max_row - col, do: "*"
  defp element(:pyramid, _size, _pos), do: ""

  defp element(:inverted_pyramid, {max_row, _}, {row, col}) when col >= row, do: "*"
  defp element(:inverted_pyramid, _size, _pos), do: ""

  defp element(:pascal_triangle, {max_row, _}, {row, col}) when row >= max_row - col, do: pascal(row, col - (max_row - row))
  defp element(:pascal_triangle, _size, _pos), do: ""

  def pascal(0, 0), do: 1
  def pascal(row, col) when row < 0 or col < 0, do: 0
  def pascal(row, col), do: pascal(row - 1, col - 1) + pascal(row - 1, col)
end
