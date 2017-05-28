defmodule Ragnaros.Web.TavernChannel do
  use Phoenix.Channel
  require Logger

  @doc """
  Authorize socket to subscribe and broadcast events on this channel & topic
  Possible Return Values
  `{:ok, socket}` to authorize subscription for channel for requested topic
  `:ignore` to deny subscription/broadcast on this channel
  for the requested topic
  """
  def join("tavern", %{token: id}, socket) do
    Ragnaros.Tavern.join({id, self()})
    {:ok, socket}
  end

  def handle_in("accept", %{token: id}, socket) do
    Ragnaros.Tavern.accept(id)
    {:noreply, Phoenix.Socket.t}
  end

  def handle_in("reject", %{token: id}, socket) do
    Ragnaros.Tavern.reject(id)
  end

  def handle_info(:game_found, socket) do
    push socket, "game_found", %{}
    {:noreply, socket}
  end

  def handle_info(:game_canceled, socket) do
    push socket, "game_canceled", %{}
    {:noreply, socket}
  end

  def handle_info({:game_started, game_id}, socket) do
    push socket, "game_start", %{gameRoom: "game:#{game_id}"}
    {:noreply, socket}
  end
end
