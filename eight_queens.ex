defmodule EightQueens do
  def solutions(board_size) do
    scale_to_col(board_size).(board_size)
  end

  defp scale_to_col(board_size) do
    fn
      0 ->
        [[]]

      col when col <= board_size ->
        Enum.flat_map(scale_to_col(board_size).(col - 1), fn positions ->
          Enum.map(1..board_size, fn row ->
            [{row, col} | positions]
          end)
          |> Enum.filter(&safe?/1)
        end)
    end
  end

  def safe?([h | t]) do
    Enum.all?(t, &safe?(h, &1))
  end

  def safe?({x, _}, {x, _}), do: false
  def safe?({_, y}, {_, y}), do: false
  def safe?({x1, y1}, {x2, y2}) when abs(x1 - x2) == abs(y1 - y2), do: false
  def safe?(_, _), do: true
end
