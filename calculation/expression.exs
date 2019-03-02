defmodule Expression.Guards do
  defguard higher_priority(op1, op2) when op1 in ["*", "/"] and op2 in ["+", "-"]
end

defmodule Expression do
  import Expression.Guards

  def calculate(expression) do
    expression
    |> to_string()
    |> String.split(~r/[^\d]+/, include_captures: true)
    |> parse_exp()
    |> eval()
  end


  defp eval({op, left, right}), do: operation(op).(eval(left), eval(right))
  defp eval(num) when is_binary(num), do: String.to_integer(num)

  defp operation("+"), do: fn a, b -> a + b end
  defp operation("-"), do: fn a, b -> a - b end
  defp operation("*"), do: fn a, b -> a * b end
  defp operation("/"), do: fn a, b -> a / b end

  defp parse_exp([left_num, op, right_num | rest]) do
    parse_exp(rest, {op, left_num, right_num})
  end

  defp parse_exp([], tree) do
    tree
  end

  defp parse_exp([next_op, next_num | rest], {op, left, right}) when higher_priority(next_op, op) do
    {sub_exp, rest} = extract_sub_exp(rest, op, [next_num, next_op])
    parse_exp(rest, {op, left, parse_exp(sub_exp, right)})
  end

  defp parse_exp([next_op, next_num | rest], tree) do
    parse_exp(rest, {next_op, tree, next_num})
  end

  defp extract_sub_exp([next_op, num | rest], op, sub_exp) when higher_priority(next_op, op) do
    extract_sub_exp(rest, op, [num, next_op | sub_exp])
  end

  defp extract_sub_exp(rest, _op, sub_exp) do
    {Enum.reverse(sub_exp), rest}
  end
end
