defmodule MedHubWeb.WorkplaceLive.Index do
  use MedHubWeb, :live_view

  alias MedHub.Practices
  alias MedHub.Practices.Workplace

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :workplaces, Practices.list_workplaces())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Workplace")
    |> assign(:workplace, Practices.get_workplace!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Workplace")
    |> assign(:workplace, %Workplace{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Workplaces")
    |> assign(:workplace, nil)
  end

  @impl true
  def handle_info({MedHubWeb.WorkplaceLive.FormComponent, {:saved, workplace}}, socket) do
    {:noreply, stream_insert(socket, :workplaces, workplace)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    workplace = Practices.get_workplace!(id)
    {:ok, _} = Practices.delete_workplace(workplace)

    {:noreply, stream_delete(socket, :workplaces, workplace)}
  end
end
