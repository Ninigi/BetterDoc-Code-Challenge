defmodule MedHubWeb.MedicLive.FormComponent do
  use MedHubWeb, :live_component

  alias MedHub.Practices

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage medic records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="medic-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:gender]} type="select" label="Gender" options={@gender_options} />
        <.input field={@form[:specialty]} type="text" label="Specialty" />
        <.input
          field={@form[:workplace_id]}
          type="select"
          label="Workplace"
          options={@workplace_options}
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Medic</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{medic: medic} = assigns, socket) do
    changeset = Practices.change_medic(medic)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> assign_workplace_options()
     |> assign_gender_options()}
  end

  @impl true
  def handle_event("validate", %{"medic" => medic_params}, socket) do
    changeset =
      socket.assigns.medic
      |> Practices.change_medic(medic_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"medic" => medic_params}, socket) do
    save_medic(socket, socket.assigns.action, medic_params)
  end

  defp save_medic(socket, :edit, medic_params) do
    case Practices.update_medic(socket.assigns.medic, medic_params) do
      {:ok, medic} ->
        notify_parent({:saved, medic})

        {:noreply,
         socket
         |> put_flash(:info, "Medic updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_medic(socket, :new, medic_params) do
    case Practices.create_medic(medic_params) do
      {:ok, medic} ->
        notify_parent({:saved, medic})

        {:noreply,
         socket
         |> put_flash(:info, "Medic created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp assign_gender_options(socket) do
    gender_options =
      Practices.Medic.genders()
      |> Map.new(fn gender ->
        key =
          gender
          |> Atom.to_string()
          |> Phoenix.Naming.humanize()

        {key, gender}
      end)

    assign(socket, :gender_options, gender_options)
  end

  defp assign_workplace_options(socket) do
    workplace_options =
      Practices.list_workplaces()
      |> Map.new(&{&1.name, &1.id})

    assign(socket, :workplace_options, workplace_options)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
