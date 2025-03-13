defmodule Server.Repo.Migrations.CreatePlanets do
  use Ecto.Migration

  def change do
    create table(:planets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :dimension, :decimal

      timestamps(type: :utc_datetime)
    end
  end
end
