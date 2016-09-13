# Todo Make authenticated.html view to render app inside of
defmodule Pong.AuthController do
  use Pong.Web, :controller
  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__ 
  alias Pong.Appuser

  def unauthenticated(conn, _params) do
    redirect(conn, to: "/")
  end

  def index(conn, _params) do
    conn
    |> render("authenticated.html")
  end

  def login(conn, %{"id" => google_id} = params) do
    # 1. try to find user in db, if found create token else create new useer then token
    find_user = Repo.get_by(Appuser, google_id: google_id)

    user = case find_user do
      %Appuser{} = user -> user 
      _ -> 
       %Appuser{} = Appuser.changeset(%Appuser{}, Map.put(params, "google_id", params["id"]))
       |> Repo.insert!
    end

    conn
    |> fetch_session
    |> Guardian.Plug.sign_in(%Appuser{id: user.id})
    |> render("authenticated.html")
  end

end
