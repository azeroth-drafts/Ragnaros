defmodule Ragnaros.Web.AuthView do
  use Ragnaros.Web, :view

  def show(conn, %{"user" => user}) do
    json conn, %{user: user}
  end

  def show("500.json", %{"token" => token}) do
    json conn, %{token: token}
  end
end
