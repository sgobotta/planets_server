defmodule ServerWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation

  object :planet do
    field :id, :id
    field :name, :string
    field :description, :string
    field :dimension, :float
  end
end
