defmodule Pong.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Pong.{Repo, Appuser}

  def for_token(user = %Appuser{}), do: { :ok, "User:#{user.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("User:" <> id), do: { :ok, Repo.get(Appuser, id) }
  def from_token(_), do: { :error, "Unknown resource type" }
end
