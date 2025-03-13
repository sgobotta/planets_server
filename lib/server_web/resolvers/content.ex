defmodule ServerWeb.Resolvers.Content do
  alias Server.Universe



  def list_planets(_parent, _args, _resolution) do
    {:ok, Universe.list_planets() |> parse_planets}
  end

  def get_planet(_parent, %{id: planet_id} = _args, _resolution) do
    {:ok, Universe.get_planet!(planet_id) |> parse_planet}
  end

  defp parse_planets(planets), do: Enum.map(planets, &parse_planet/1)

  defp parse_planet(%Universe.Planet{} = planet) do
    %Universe.Planet{
      planet | dimension: Decimal.to_float(planet.dimension)
    }
  end
end
