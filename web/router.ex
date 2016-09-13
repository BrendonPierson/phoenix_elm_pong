defmodule Pong.Router do
  use Pong.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Pong do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/auth", AuthController, :index
    get "/appusers", AppuserController, :index
  end

  # Other scopes may use custom stacks.
   scope "/api", Pong do
     pipe_through :api
     
     resources "/appusers", AppuserController
   end
end
