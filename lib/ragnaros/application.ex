defmodule Ragnaros.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Ragnaros.Repo, []),
      # Start the Games Supervisor
      supervisor(Ragnaros.GamesSupervisor, []),
      # Start the endpoint when the application starts
      supervisor(Ragnaros.Web.Endpoint, []),
      # Start your own worker by calling: Ragnaros.Worker.start_link(arg1, arg2, arg3)
      # worker(Ragnaros.Worker, [arg1, arg2, arg3]),
      worker(Ragnaros.Draft.Bot, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ragnaros.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
