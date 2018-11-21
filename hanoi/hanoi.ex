defmodule Hanoi do
  defstruct from: [], to: [], spare: []

  def new(n) do
    %Hanoi{from: Enum.into(1..n, []), to: [], spare: []}
  end

  def move(state, 0, _from, _to, _spare), do: {:done, state}
  def move(state, num_of_plates, from, to, spare) do
    {:done, state} = move(state, num_of_plates - 1, from, spare, to)

    state = make_one_move(state, from, to)

    move(state, num_of_plates - 1, spare, to, from)
  end

  def move_iter(state, 0, _from, _to, _spare), do: {:done, state}
  def move_iter(state, num_of_plates, from, to, spare) do

  end

  def make_one_move(state, from, to) do
    display state

    [plate | new_from] = Map.fetch!(state, from)
    new_to = [plate | Map.fetch!(state, to)]

    state
    |> Map.put(from, new_from)
    |> Map.put(to, new_to)
  end

  def display(state) do
    IO.puts "==================================================="

    Enum.each([:from, :to, :spare], fn tower ->
      display_tower(state, tower)
    end)

    IO.puts "==================================================="
  end

  def display_tower(state, tower) do
    plates = Map.fetch!(state, tower)

    tower
    |> to_string
    |> String.rjust(10)
    |> IO.write()

    IO.write(": ")

    plates
    |> Stream.each(&to_string/1)
    |> Enum.join(", ")
    |> IO.puts()
  end
end
