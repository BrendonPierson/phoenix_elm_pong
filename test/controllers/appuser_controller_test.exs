defmodule Pong.AppuserControllerTest do
  use Pong.ConnCase

  alias Pong.Appuser
  @valid_attrs %{auth_id: "some content", first_name: "some content", last_name: "some content", rating: 42, username: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, appuser_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    appuser = Repo.insert! %Appuser{}
    conn = get conn, appuser_path(conn, :show, appuser)
    assert json_response(conn, 200)["data"] == %{"id" => appuser.id,
      "first_name" => appuser.first_name,
      "last_name" => appuser.last_name,
      "username" => appuser.username,
      "rating" => appuser.rating,
      "auth_id" => appuser.auth_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, appuser_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, appuser_path(conn, :create), appuser: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Appuser, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, appuser_path(conn, :create), appuser: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    appuser = Repo.insert! %Appuser{}
    conn = put conn, appuser_path(conn, :update, appuser), appuser: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Appuser, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    appuser = Repo.insert! %Appuser{}
    conn = put conn, appuser_path(conn, :update, appuser), appuser: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    appuser = Repo.insert! %Appuser{}
    conn = delete conn, appuser_path(conn, :delete, appuser)
    assert response(conn, 204)
    refute Repo.get(Appuser, appuser.id)
  end
end
