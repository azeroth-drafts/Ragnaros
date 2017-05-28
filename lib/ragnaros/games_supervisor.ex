defmodule Ragnaros.GamesSupervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(Ragnaros.Tavern, [])
    ]

    opts = [strategy: :one_for_one]
    supervise(children, opts)
  end
end
