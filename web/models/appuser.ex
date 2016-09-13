defmodule Pong.Appuser do
  use Pong.Web, :model

  schema "appusers" do
    field :email, :string
    field :given_name, :string
    field :family_name, :string
    field :gender, :string
    field :google_id, :string
    field :picture, :string
    field :verified_email, :boolean
    field :locale, :string
    field :username, :string
    field :rating, :integer, default: 1300

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :given_name, :family_name, :gender, :google_id, :picture, :verified_email, :username, :rating])
    |> validate_required([:email, :given_name, :family_name, :google_id, :verified_email, :rating])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:google_id)
  end
end


