defmodule ServerWeb.PlanetLive.Show do
  use ServerWeb, :live_view

  alias Server.Universe

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:planet, Universe.get_planet!(id))}
  end

  defp page_title(:show), do: "Show Planet"
  defp page_title(:edit), do: "Edit Planet"
end
