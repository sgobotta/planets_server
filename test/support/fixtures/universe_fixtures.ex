defmodule Server.UniverseFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Server.Universe` context.
  """

  @doc """
  Generate a planet.
  """
  def planet_fixture(attrs \\ %{}) do
    {:ok, planet} =
      attrs
      |> Enum.into(%{
        description: "some description",
        dimension: "120.5",
        name: "some name"
      })
      |> Server.Universe.create_planet()

    planet
  end
end
