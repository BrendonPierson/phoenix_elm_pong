defmodule Pong.AppuserTest do
  use Pong.ModelCase

  alias Pong.Appuser

  @valid_attrs %{auth_id: "some content", first_name: "some content", last_name: "some content", rating: 42, username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Appuser.changeset(%Appuser{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Appuser.changeset(%Appuser{}, @invalid_attrs)
    refute changeset.valid?
  end
end
