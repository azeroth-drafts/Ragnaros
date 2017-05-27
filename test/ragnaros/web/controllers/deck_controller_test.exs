defmodule Ragnaros.Web.DeckControllerTest do
  use Ragnaros.Web.ConnCase

  alias Ragnaros.Game
  alias Ragnaros.Game.Deck

  @create_attrs %{cards: [], game_id: 42, user_id: 42}
  @update_attrs %{cards: [], game_id: 43, user_id: 43}
  @invalid_attrs %{cards: nil, game_id: nil, user_id: nil}

  def fixture(:deck) do
    {:ok, deck} = Game.create_deck(@create_attrs)
    deck
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, deck_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates deck and renders deck when data is valid", %{conn: conn} do
    conn = post conn, deck_path(conn, :create), deck: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, deck_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "cards" => [],
      "game_id" => 42,
      "user_id" => 42}
  end

  test "does not create deck and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, deck_path(conn, :create), deck: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen deck and renders deck when data is valid", %{conn: conn} do
    %Deck{id: id} = deck = fixture(:deck)
    conn = put conn, deck_path(conn, :update, deck), deck: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, deck_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "cards" => [],
      "game_id" => 43,
      "user_id" => 43}
  end

  test "does not update chosen deck and renders errors when data is invalid", %{conn: conn} do
    deck = fixture(:deck)
    conn = put conn, deck_path(conn, :update, deck), deck: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen deck", %{conn: conn} do
    deck = fixture(:deck)
    conn = delete conn, deck_path(conn, :delete, deck)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, deck_path(conn, :show, deck)
    end
  end
end
