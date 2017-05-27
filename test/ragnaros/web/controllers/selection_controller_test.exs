defmodule Ragnaros.Web.SelectionControllerTest do
  use Ragnaros.Web.ConnCase

  alias Ragnaros.Game
  alias Ragnaros.Game.Selection

  @create_attrs %{card_id: 42, game_id: 42, user_id: 42}
  @update_attrs %{card_id: 43, game_id: 43, user_id: 43}
  @invalid_attrs %{card_id: nil, game_id: nil, user_id: nil}

  def fixture(:selection) do
    {:ok, selection} = Game.create_selection(@create_attrs)
    selection
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, selection_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates selection and renders selection when data is valid", %{conn: conn} do
    conn = post conn, selection_path(conn, :create), selection: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, selection_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "card_id" => 42,
      "game_id" => 42,
      "user_id" => 42}
  end

  test "does not create selection and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, selection_path(conn, :create), selection: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen selection and renders selection when data is valid", %{conn: conn} do
    %Selection{id: id} = selection = fixture(:selection)
    conn = put conn, selection_path(conn, :update, selection), selection: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, selection_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "card_id" => 43,
      "game_id" => 43,
      "user_id" => 43}
  end

  test "does not update chosen selection and renders errors when data is invalid", %{conn: conn} do
    selection = fixture(:selection)
    conn = put conn, selection_path(conn, :update, selection), selection: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen selection", %{conn: conn} do
    selection = fixture(:selection)
    conn = delete conn, selection_path(conn, :delete, selection)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, selection_path(conn, :show, selection)
    end
  end
end
