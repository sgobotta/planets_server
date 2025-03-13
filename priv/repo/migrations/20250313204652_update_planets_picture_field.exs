defmodule Server.Repo.Migrations.UpdatePlanetsPictureField do
  use Ecto.Migration

  def change do
    alter table(:planets) do
      add :picture, :string
    end
  end
end
