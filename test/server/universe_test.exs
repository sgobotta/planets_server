defmodule Server.UniverseTest do
  use Server.DataCase

  alias Server.Universe

  describe "planets" do
    alias Server.Universe.Planet

    import Server.UniverseFixtures

    @invalid_attrs %{name: nil, description: nil, dimension: nil}

    test "list_planets/0 returns all planets" do
      planet = planet_fixture()
      assert Universe.list_planets() == [planet]
    end

    test "get_planet!/1 returns the planet with given id" do
      planet = planet_fixture()
      assert Universe.get_planet!(planet.id) == planet
    end

    test "create_planet/1 with valid data creates a planet" do
      valid_attrs = %{name: "some name", description: "some description", dimension: "120.5"}

      assert {:ok, %Planet{} = planet} = Universe.create_planet(valid_attrs)
      assert planet.name == "some name"
      assert planet.description == "some description"
      assert planet.dimension == Decimal.new("120.5")
    end

    test "create_planet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Universe.create_planet(@invalid_attrs)
    end

    test "update_planet/2 with valid data updates the planet" do
      planet = planet_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", dimension: "456.7"}

      assert {:ok, %Planet{} = planet} = Universe.update_planet(planet, update_attrs)
      assert planet.name == "some updated name"
      assert planet.description == "some updated description"
      assert planet.dimension == Decimal.new("456.7")
    end

    test "update_planet/2 with invalid data returns error changeset" do
      planet = planet_fixture()
      assert {:error, %Ecto.Changeset{}} = Universe.update_planet(planet, @invalid_attrs)
      assert planet == Universe.get_planet!(planet.id)
    end

    test "delete_planet/1 deletes the planet" do
      planet = planet_fixture()
      assert {:ok, %Planet{}} = Universe.delete_planet(planet)
      assert_raise Ecto.NoResultsError, fn -> Universe.get_planet!(planet.id) end
    end

    test "change_planet/1 returns a planet changeset" do
      planet = planet_fixture()
      assert %Ecto.Changeset{} = Universe.change_planet(planet)
    end
  end
end
