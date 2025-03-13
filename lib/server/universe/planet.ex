defmodule Server.Universe.Planet do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "planets" do
    field :name, :string
    field :description, :string
    field :dimension, :decimal
    field :picture, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(planet, attrs) do
    planet
    |> cast(attrs, [:name, :description, :dimension, :picture])
    |> validate_required([:name, :description, :dimension])
  end
end
