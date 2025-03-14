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
        <%!-- <section phx-drop-target={@uploads.picture.ref}>
          <article :for={entry <- @uploads.picture.entries} class="upload-entry">
            <figure>
              <.live_img_preview entry={entry} />
              <figcaption>{entry.client_name}</figcaption>
            </figure>

            <progress value={entry.progress} max="100"> {entry.progress}% </progress>

            <button type="button" phx-click="cancel-upload" phx-value-ref={entry.ref} aria-label="cancel">&times;</button>

            <p :for={err <- upload_errors(@uploads.picture, entry)} class="alert alert-danger">{error_to_string(err)}</p>
          </article>

          <p :for={err <- upload_errors(@uploads.picture)} class="alert alert-danger">
            {error_to_string(err)}
          </p>
        </section> --%>
        <%!-- <.live_file_input upload={@uploads.picture} />
         --%>
        <.input field={@form[:picture]} type="text" label="Picture URL" />
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
     end)
     |> assign(:picture, [])
     |> allow_upload(:picture, accept: ~w(.jpg .jpeg .gif), max_entries: 1)}
  end

  @impl true
  def handle_event("validate", %{"planet" => planet_params}, socket) do
    changeset = Universe.change_planet(socket.assigns.planet, planet_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"planet" => planet_params}, socket) do
    # uploaded_files =
    #   consume_uploaded_entries(socket, :picture, fn %{path: path}, entry ->
    #     IO.inspect(entry, label: "Entry")
    #     dest = Path.join(Application.app_dir(:server, "priv/static/uploads"), Path.basename(path))
    #     # You will need to create `priv/static/uploads` for `File.cp!/2` to work.
    #     File.cp!(path, dest)
    #     {:ok, ~p"/uploads/#{Path.basename(dest)}"}
    #   end)
    # socket = update(socket, :picture, &(&1 ++ uploaded_files))

    # planet_params = case uploaded_files do
    #   [] -> planet_params
    #   [uploaded_file] -> Map.merge(planet_params, %{"picture" => uploaded_file})
    # end

    save_planet(socket, socket.assigns.action, planet_params)
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :picture, ref)}
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

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
