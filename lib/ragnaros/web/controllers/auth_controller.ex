defmodule Ragnaros.Web.AuthController do
  use Ragnaros.Web, :controller

  def auth(conn, %{"user" => user}) do
    json conn, %{user: user}
  end

  def refresh(conn, %{"token" => token}) do
    json conn, %{token: token}
  end
end
