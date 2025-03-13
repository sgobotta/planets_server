defmodule ServerWeb.PlanetLive.FormComponent do
  use ServerWeb, :live_component

  alias Server.Universe

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage planet records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="planet-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:dimension]} type="number" label="Dimension" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Planet</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{planet: planet} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Universe.change_planet(planet))
     end)}
  end

  @impl true
  def handle_event("validate", %{"planet" => planet_params}, socket) do
    changeset = Universe.change_planet(socket.assigns.planet, planet_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"planet" => planet_params}, socket) do
    save_planet(socket, socket.assigns.action, planet_params)
  end

  defp save_planet(socket, :edit, planet_params) do
    case Universe.update_planet(socket.assigns.planet, planet_params) do
      {:ok, planet} ->
        notify_parent({:saved, planet})

        {:noreply,
         socket
         |> put_flash(:info, "Planet updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_planet(socket, :new, planet_params) do
    case Universe.create_planet(planet_params) do
      {:ok, planet} ->
        notify_parent({:saved, planet})

        {:noreply,
         socket
         |> put_flash(:info, "Planet created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
