defmodule Ragnaros.Web.DeckView do
  use Ragnaros.Web, :view
  alias Ragnaros.Web.DeckView

  def render("index.json", %{decks: decks}) do
    %{data: render_many(decks, DeckView, "deck.json")}
  end

  def render("show.json", %{deck: deck}) do
    %{data: render_one(deck, DeckView, "deck.json")}
  end

  def render("deck.json", %{deck: deck}) do
    %{id: deck.id,
      game_id: deck.game_id,
      user_id: deck.user_id,
      cards: deck.cards}
  end
end
