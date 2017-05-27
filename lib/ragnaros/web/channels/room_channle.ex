defmodule Ragnaros.Web.RoomChannel do
  use Phoenix.Channel
  require Logger

  @doc """
  Authorize socket to subscribe and broadcast events on this channel & topic
  Possible Return Values
  `{:ok, socket}` to authorize subscription for channel for requested topic
  `:ignore` to deny subscription/broadcast on this channel
  for the requested topic
  """
  def join("room:lobby", message, socket) do
    IO.puts "asd"
    Process.flag(:trap_exit, true)
    :timer.send_interval(10000, :ping)
    send(self, {:after_join, message})

    {:ok, socket}
  end

  def handle_info({:after_join, msg}, socket) do
    broadcast! socket, "user_entered", %{user: msg["user"]}
    push socket, "join", %{status: "connected"}
    {:noreply, socket}
  end

  def handle_info(:ping, socket) do
    push socket, "new_msg", %{user: "SYSTEM", body: "ping"}
    {:noreply, socket}
  end
end
