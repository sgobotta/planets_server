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

  mutation do
    @desc "Create a planet"
    field :create_planet, type: :planet do
      arg :name, non_null(:string)
      arg :description, non_null(:string)
      arg :dimension, non_null(:float)
      arg :picture, non_null(:string)

      resolve &Resolvers.Content.create_planet/3
    end
  end
end
