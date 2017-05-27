defmodule Ragnaros.Web.AuthController do
  use Ragnaros.Web, :controller

  @socket "ws://localhost:4000/ws"

  def auth(conn, %{"user" => user_name}) do
    user = Ragnaros.Repo.get_by(Ragnaros.Accounts.User, name: user_name)
    json conn, (
      cond do
        not user_exists?(user) ->
          user =
            Ragnaros.Repo.insert! %Ragnaros.Accounts.User{name: user_name}
          success(user.id)

        connected?(user) ->
          fail ("User `" <> user.name <> "` already logged in!")

        true ->
          success(user.id)
      end
    )
  end

  def refresh(conn, %{"token" => token}) do
    user = Ragnaros.Repo.get(Ragnaros.Accounts.User, token)
    json conn,
    (cond do
      user_exists?(user) ->
        success(token)
      true ->
          fail("Fail to authenticate!")
      end
    )
  end

  def refresh(conn, _) do
    json conn, fail("watever")
  end

  defp user_exists?(user) do
    user != nil
  end

  defp connected?(user) do
    false
  end

  defp success(token) do
    %{success: true,
      token: token,
      socket: @socket,
      message: ""}
  end

  defp fail(reason) do
    %{success: false,
      token: "",
      socket: "",
      message: reason}
  end
end
