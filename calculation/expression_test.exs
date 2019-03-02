if !System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("expression.exs", __DIR__)
end

ExUnit.start
ExUnit.configure exclude: :pending, trace: true

defmodule ExpressionTest do
  use ExUnit.Case

  test "Calculate expression" do
    assert Expression.calculate('123+27') == 150
    assert Expression.calculate('1+2+3+4+5') == 15
  end

  test "Calculate more complex expression" do
    assert Expression.calculate('12+3*5+3') == 30
    assert Expression.calculate('12+6*5/2+3*2-1') == 32
    assert Expression.calculate('12+2^3*5-2+3*2-1') == 55
    assert Expression.calculate('12+5*3^2-2+3*2-1') == 60
  end
end

