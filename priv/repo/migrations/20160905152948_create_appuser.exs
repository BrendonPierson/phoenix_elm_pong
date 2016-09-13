defmodule Pong.Repo.Migrations.CreateAppuser do
  use Ecto.Migration

  def change do
    create table(:appusers) do
      add :email, :string
      add :given_name, :string
      add :family_name, :string
      add :gender, :string
      add :google_id, :string
      add :picture, :string
      add :verified_email, :boolean
      add :locale, :string
      add :username, :string
      add :rating, :integer, default: 1300

      timestamps()
    end

    create unique_index(:appusers, [:google_id])
  end
end
