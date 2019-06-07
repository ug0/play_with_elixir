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
             |> String.strip()
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
             |> String.strip()

    assert Shapes.rectangle(4, 8) ==
             """
             * * * * * * * *
             *             *
             *             *
             * * * * * * * *
             """
             |> String.strip()
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
end
