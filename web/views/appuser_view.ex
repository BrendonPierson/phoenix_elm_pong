defmodule Pong.AppuserView do
  use Pong.Web, :view

  def render("index.json", %{appusers: appusers}) do
    %{data: render_many(appusers, Pong.AppuserView, "appuser.json")}
  end

  def render("show.json", %{appuser: appuser}) do
    %{data: render_one(appuser, Pong.AppuserView, "appuser.json")}
  end

  def render("appuser.json", %{appuser: appuser}) do
    %{id: appuser.id,
      first_name: appuser.first_name,
      last_name: appuser.last_name,
      username: appuser.username,
      rating: appuser.rating,
      auth_id: appuser.auth_id}
  end
end
