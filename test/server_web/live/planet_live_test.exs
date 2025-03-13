defmodule ServerWeb.PlanetLiveTest do
  use ServerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Server.UniverseFixtures

  @create_attrs %{name: "some name", description: "some description", dimension: "120.5"}
  @update_attrs %{name: "some updated name", description: "some updated description", dimension: "456.7"}
  @invalid_attrs %{name: nil, description: nil, dimension: nil}

  defp create_planet(_) do
    planet = planet_fixture()
    %{planet: planet}
  end

  describe "Index" do
    setup [:create_planet]

    test "lists all planets", %{conn: conn, planet: planet} do
      {:ok, _index_live, html} = live(conn, ~p"/planets")

      assert html =~ "Listing Planets"
      assert html =~ planet.name
    end

    test "saves new planet", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/planets")

      assert index_live |> element("a", "New Planet") |> render_click() =~
               "New Planet"

      assert_patch(index_live, ~p"/planets/new")

      assert index_live
             |> form("#planet-form", planet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#planet-form", planet: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/planets")

      html = render(index_live)
      assert html =~ "Planet created successfully"
      assert html =~ "some name"
    end

    test "updates planet in listing", %{conn: conn, planet: planet} do
      {:ok, index_live, _html} = live(conn, ~p"/planets")

      assert index_live |> element("#planets-#{planet.id} a", "Edit") |> render_click() =~
               "Edit Planet"

      assert_patch(index_live, ~p"/planets/#{planet}/edit")

      assert index_live
             |> form("#planet-form", planet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#planet-form", planet: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/planets")

      html = render(index_live)
      assert html =~ "Planet updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes planet in listing", %{conn: conn, planet: planet} do
      {:ok, index_live, _html} = live(conn, ~p"/planets")

      assert index_live |> element("#planets-#{planet.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#planets-#{planet.id}")
    end
  end

  describe "Show" do
    setup [:create_planet]

    test "displays planet", %{conn: conn, planet: planet} do
      {:ok, _show_live, html} = live(conn, ~p"/planets/#{planet}")

      assert html =~ "Show Planet"
      assert html =~ planet.name
    end

    test "updates planet within modal", %{conn: conn, planet: planet} do
      {:ok, show_live, _html} = live(conn, ~p"/planets/#{planet}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Planet"

      assert_patch(show_live, ~p"/planets/#{planet}/show/edit")

      assert show_live
             |> form("#planet-form", planet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#planet-form", planet: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/planets/#{planet}")

      html = render(show_live)
      assert html =~ "Planet updated successfully"
      assert html =~ "some updated name"
    end
  end
end
