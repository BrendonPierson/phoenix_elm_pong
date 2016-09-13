defmodule Pong.OAuth.Google do
  @moduledoc"""
  An OAuth2 strategy for Google.
  """
  use OAuth2.Strategy
  alias OAuth2.Strategy.AuthCode

  # Public API
  def authorize_url! do
    OAuth2.Client.authorize_url!(client(), scope: "email profile")
  end

  def get_token!(params \\ [], headers \\ []) do
    env_vars = Application.get_env(:oauth2, Google)
    params = Keyword.merge(params, env_vars)
    OAuth2.Client.get_token!(client(), params, headers)
  end

  def get_user!(client) do
    client
    |> Map.put(:site, "https://www.googleapis.com")
    |> OAuth2.Client.get!("/userinfo/v2/me")
  end

  # Strategy Callbacks

  defp client do
    Application.get_env(:oauth2, Google)
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
  end

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end

  defp config do
    [strategy: __MODULE__,
     site: "https://accounts.google.com",
     authorize_url: "/o/oauth2/v2/auth",
     token_url: "https://www.googleapis.com/oauth2/v4/token"]
  end
end
