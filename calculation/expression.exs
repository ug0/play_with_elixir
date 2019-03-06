defmodule Expression.Guards do
  defguard higher_priority(op1, op2)
           when (op1 in ["^", "*", "/"] and op2 in ["+", "-"]) or
                  (op1 in ["^"] and op2 in ["*", "/", "+", "-"])
end

defmodule Expression do
  import Expression.Guards

  def calculate(expression) do
    expression
    |> to_string()
    |> String.split(~r/[^\d]/, include_captures: true, trim: true)
    |> parse_parentheses([])
    |> parse_exp()
    |> eval()
  end


  defp eval({op, left, right}), do: operation(op).(eval(left), eval(right))
  defp eval(num) when is_binary(num), do: String.to_integer(num)

  defp operation("+"), do: fn a, b -> a + b end
  defp operation("-"), do: fn a, b -> a - b end
  defp operation("*"), do: fn a, b -> a * b end
  defp operation("/"), do: fn a, b -> a / b end
  defp operation("^"), do: &:math.pow/2

  defp parse_parentheses([], parsed_exp) do
    Enum.reverse(parsed_exp)
  end

  defp parse_parentheses(["(" | rest], parsed_exp) do
    {inner_exp, rest} = parse_parentheses(rest, [], 1)
    parse_parentheses(rest, [inner_exp | parsed_exp])
  end

  defp parse_parentheses([next | rest], parsed_exp) do
    parse_parentheses(rest, [next | parsed_exp])
  end

  defp parse_parentheses(["(" | rest], inner_exp, occurs) do
    parse_parentheses(rest, ["(" | inner_exp], occurs + 1)
  end

  defp parse_parentheses([")" | rest], inner_exp, 1) do
    {parse_parentheses(Enum.reverse(inner_exp), []), rest}
  end

  defp parse_parentheses([")" | rest], inner_exp, occurs) do
    parse_parentheses(rest, [")" | inner_exp], occurs - 1)
  end

  defp parse_parentheses([next | rest], inner_exp, occurs) do
    parse_parentheses(rest, [next | inner_exp], occurs)
  end

  defp parse_exp(num) when is_binary(num) do
    num
  end

  defp parse_exp([left_num, op, right_num | rest]) do
    parse_exp(rest, {op, parse_exp(left_num), parse_exp(right_num)})
  end

  defp parse_exp([], tree) do
    tree
  end

  defp parse_exp([next_op, sub_exp | rest], tree) when is_list(sub_exp) do
    parse_exp([next_op, parse_exp(sub_exp) | rest], tree)
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
