defmodule Ragnaros.Web.AuthController do
  use Ragnaros.Web, :controller

  def auth(conn, params) do
    %{errors: %{detail: "Page not found"}}
    auth conn, params
  end

  def refresh(conn, params) do
    refresh conn, params
  end
end
