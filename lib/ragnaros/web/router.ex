defmodule Ragnaros.Web.Router do
  use Ragnaros.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", Ragnaros.Web do
    pipe_through :api

    post "/", AuthController, :auth

    post "/refresh", AuthController, :refresh
  end
end
