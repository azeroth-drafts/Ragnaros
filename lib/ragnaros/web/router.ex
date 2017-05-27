defmodule Ragnaros.Web.Router do
  use Ragnaros.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Ragnaros.Web do
    pipe_through :api
  end
end
