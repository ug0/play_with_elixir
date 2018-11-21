defmodule Tail.CLI do
  def main(args) do
    {opts, file, _} =
      OptionParser.parse(args,
        strict: [lines: :integer],
        aliases: [n: :lines]
      )
    Tail.start(file, opts)
  end
end
