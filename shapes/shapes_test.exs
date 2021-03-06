Code.load_file("shapes.ex", __DIR__)

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule ShapesTest do
  use ExUnit.Case

  test "square" do
    assert Shapes.square(5) ==
             """
             * * * * *
             * * * * *
             * * * * *
             * * * * *
             * * * * *
             """
             |> String.trim()
  end

  test "rectangle" do
    assert Shapes.rectangle(5, 3) ==
             """
             * * *
             *   *
             *   *
             *   *
             * * *
             """
             |> String.trim()

    assert Shapes.rectangle(4, 8) ==
             """
             * * * * * * * *
             *             *
             *             *
             * * * * * * * *
             """
             |> String.trim()
  end

  test "pyramid" do
    assert Shapes.pyramid(5) == """
               *
              * *
             * * *
            * * * *
           * * * * *
           """ |> String.trim_trailing()
  end

  test "diamond" do
    assert Shapes.diamond(5) == """
               *
              * *
             * * *
            * * * *
           * * * * *
            * * * *
             * * *
              * *
               *
           """ |> String.trim_trailing()
  end

  test "pascal triangle" do
    assert Shapes.pascal_triangle(5) == """
               1
              1 1
             1 2 1
            1 3 3 1
           1 4 6 4 1
           """ |> String.trim_trailing()
  end
end
