defmodule Ragnaros.Web.GameChannel do
  use Phoenix.Channel
  require Logger

  @doc """
  Authorize socket to subscribe and broadcast events on this channel & topic
  Possible Return Values
  `{:ok, socket}` to authorize subscription for channel for requested topic
  `:ignore` to deny subscription/broadcast on this channel
  for the requested topic
  """
  def join("game:" <> game_id, %{"token" => id}, socket) do
    IO.inspect game_id
    Ragnaros.Registry.register(id, self())
    Ragnaros.Tavern.registered(id)
    {:ok, socket}
  end

  def handle_in("selected", %{"token" => id, "cardId" => card_id}, socket) do
    Ragnaros.Tavern.selected(id, card_id)
    {:ok, socket}
  end

  def handle_in("deck", %{"token" => id, "cards" => cards}, socket) do
    Ragnaros.Tavern.save_deck(id, cards)
    {:ok, socket}
  end

  def handle_info({:draft, cards}, socket) do
    push socket, "draft", cards
    {:noreply, socket}
  end

  def handle_info({:draft_finish, cards}, socket) do
    push socket, "draft_finish", cards
    {:noreply, socket}
  end
end
