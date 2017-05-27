defmodule Ragnaros.Web.InstanceControllerTest do
  use Ragnaros.Web.ConnCase

  alias Ragnaros.Game
  alias Ragnaros.Game.Instance

  @create_attrs %{players: []}
  @update_attrs %{players: []}
  @invalid_attrs %{players: nil}

  def fixture(:instance) do
    {:ok, instance} = Game.create_instance(@create_attrs)
    instance
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, instance_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates instance and renders instance when data is valid", %{conn: conn} do
    conn = post conn, instance_path(conn, :create), instance: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, instance_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "players" => []}
  end

  test "does not create instance and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, instance_path(conn, :create), instance: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen instance and renders instance when data is valid", %{conn: conn} do
    %Instance{id: id} = instance = fixture(:instance)
    conn = put conn, instance_path(conn, :update, instance), instance: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, instance_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "players" => []}
  end

  test "does not update chosen instance and renders errors when data is invalid", %{conn: conn} do
    instance = fixture(:instance)
    conn = put conn, instance_path(conn, :update, instance), instance: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen instance", %{conn: conn} do
    instance = fixture(:instance)
    conn = delete conn, instance_path(conn, :delete, instance)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, instance_path(conn, :show, instance)
    end
  end
end
