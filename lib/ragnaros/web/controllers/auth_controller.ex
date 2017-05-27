defmodule Ragnaros.Web.AuthController do
  use Ragnaros.Web, :controller

  def auth(conn, %{"user" => user_name}) do
    #user = Ragnaros.Repo.get_by(Ragnaros.Accounts.User, name: user_name)
    json conn, (
      cond do
        not user_exists?(user) ->
          %{success: true,
            token: "token",
            socket: "socket",
            message: ""}

        connected?(user) ->
          %{success: false,
            token: "",
            socket: "",
            message: "Already loged in"}

        true ->
          %{success: true,
            token: "",
            socket: "socket",
            message: "Already loged in"}
      end
    )
  end

  def refresh(conn, %{"token" => token}) do
    json conn, %{token: token}
  end

  def user_exists?(user) do
    # FIXME
    true
  end

  def connected?(user) do
    # FIXME
    false
  end
end
