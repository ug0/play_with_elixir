defmodule Tail do
  @default_lines 10

  def start(file, opts) do
    lines = Keyword.get(opts, :lines, @default_lines)
    tail_file(file, lines: lines)
  end

  defp tail_file(files, opts) when is_list(files) do
    files
    |> Enum.each(fn f ->
      IO.puts "==> #{f} <=="
      tail_file(f, opts)
    end)
  end

  defp tail_file(file, lines: lines) do
    file
    |> File.stream!
    |> Enum.slice(-(lines)..-1)
    |> Enum.join
    |> IO.puts
  end
end
