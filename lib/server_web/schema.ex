defmodule ServerWeb.Schema do
  use Absinthe.Schema

  import_types ServerWeb.Schema.ContentTypes

  alias ServerWeb.Resolvers

  query do
    @desc "Get all planets"
    field :planets, list_of(:planet) do
      resolve &Resolvers.Content.list_planets/3
    end

    @desc "Get single planet"
    field :planet, :planet do
      arg :id, non_null(:id)
      resolve &Resolvers.Content.get_planet/3
    end
  end
end
