defmodule Pong.AppuserController do
  use Pong.Web, :controller

  alias Pong.OAuth.Google
  alias Pong.Appuser

  def index(conn, %{"code" => code}) do
    auth_resp = Google.get_token!(code: code)
      |> Google.get_user!

    IO.inspect auth_resp
    
    case auth_resp do
      %{body: user, status_code: 200} -> 
        login(conn, user)
      %{body: %{"error" => %{"errors" => errors}}} -> 
        conn
        |> put_flash(:error, List.first(errors)["message"])
        |> redirect(to: "/")
    end

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
    |> redirect(to: "/auth")
  end

  def create(conn, %{"appuser" => appuser_params}) do
    changeset = Appuser.changeset(%Appuser{}, appuser_params)

    case Repo.insert(changeset) do
      {:ok, appuser} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", appuser_path(conn, :show, appuser))
        |> render("show.json", appuser: appuser)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Pong.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    appuser = Repo.get!(Appuser, id)
    render(conn, "show.json", appuser: appuser)
  end

  def update(conn, %{"id" => id, "appuser" => appuser_params}) do
    appuser = Repo.get!(Appuser, id)
    changeset = Appuser.changeset(appuser, appuser_params)

    case Repo.update(changeset) do
      {:ok, appuser} ->
        render(conn, "show.json", appuser: appuser)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Pong.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    appuser = Repo.get!(Appuser, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(appuser)

    send_resp(conn, :no_content, "")
  end
end
