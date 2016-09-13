defmodule Pong.PageController do
  use Pong.Web, :controller

  def index(conn, _params) do
    conn
    |> assign(:auth_endpoint, Pong.OAuth.Google.authorize_url!)
    |> render("index.html")
  end
end
