defmodule ServerWeb.Schemas do
  use Absinthe.Schema

  query do
    field :id, :id do
      resolve(fn _, _, _ -> {:ok, Ecto.UUID.generate()} end)
    end
    field :name, :string do
      resolve(fn _, _, _ -> {:ok, "Pluto"} end)
    end
    field :description, :string do
      resolve(fn _, _, _ -> {:ok, "Pluto is a complex and mysterious world with mountains, valleys, plains, craters, and glaciers. It is located in the distant Kuiper Belt. Discovered in 1930, Pluto was long considered our solar system's ninth planet."} end)
    end
    field :dimension, :string do
      resolve(fn _, _, _ -> {:ok, "2,376.6±1.6 km"} end)
    end
  end
end
