defmodule MedHubWeb.WorkplaceLive.FormComponent do
  use MedHubWeb, :live_component

  alias MedHub.Practices

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage workplace records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="workplace-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:street_name]} type="text" label="Street name" />
        <.input field={@form[:house_number]} type="text" label="House number" />
        <.input field={@form[:zip]} type="text" label="Zip" />
        <.input field={@form[:city]} type="text" label="City" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Workplace</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{workplace: workplace} = assigns, socket) do
    changeset = Practices.change_workplace(workplace)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"workplace" => workplace_params}, socket) do
    changeset =
      socket.assigns.workplace
      |> Practices.change_workplace(workplace_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"workplace" => workplace_params}, socket) do
    save_workplace(socket, socket.assigns.action, workplace_params)
  end

  defp save_workplace(socket, :edit, workplace_params) do
    case Practices.update_workplace(socket.assigns.workplace, workplace_params) do
      {:ok, workplace} ->
        notify_parent({:saved, workplace})

        {:noreply,
         socket
         |> put_flash(:info, "Workplace updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_workplace(socket, :new, workplace_params) do
    case Practices.create_workplace(workplace_params) do
      {:ok, workplace} ->
        notify_parent({:saved, workplace})

        {:noreply,
         socket
         |> put_flash(:info, "Workplace created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
