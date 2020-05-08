defmodule Todo.System do
  def start_link do
    Supervisor.start_link(
      [
        # Todo.ProcessRegistry, # not used in a distributed system
        Todo.Database,
        Todo.Cache,
        Todo.Web
        # Todo.Metrics
      ],
      strategy: :one_for_one
    )
  end
end
