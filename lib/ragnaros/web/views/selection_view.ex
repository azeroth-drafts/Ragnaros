defmodule Ragnaros.Web.SelectionView do
  use Ragnaros.Web, :view
  alias Ragnaros.Web.SelectionView

  def render("index.json", %{selections: selections}) do
    %{data: render_many(selections, SelectionView, "selection.json")}
  end

  def render("show.json", %{selection: selection}) do
    %{data: render_one(selection, SelectionView, "selection.json")}
  end

  def render("selection.json", %{selection: selection}) do
    %{id: selection.id,
      user_id: selection.user_id,
      game_id: selection.game_id,
      card_id: selection.card_id}
  end
end
