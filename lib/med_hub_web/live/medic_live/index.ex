defmodule MedHubWeb.MedicLive.Index do
  use MedHubWeb, :live_view

  alias MedHub.Practices
  alias MedHub.Practices.Medic
  alias MedHub.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> assign_medics_stream()
      |> apply_action(socket.assigns.live_action, params)

    {:noreply, socket}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Medic")
    |> assign(:medic, Practices.get_medic!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Medic")
    |> assign(:medic, %Medic{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Medics")
    |> assign(:medic, nil)
  end

  @impl true
  def handle_info({MedHubWeb.MedicLive.FormComponent, {:saved, medic}}, socket) do
    {:noreply, stream_insert(socket, :medics, preloads(medic))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    medic = Practices.get_medic!(id)

    {:ok, _} = Practices.delete_medic(medic)

    {:noreply, stream_delete(socket, :medics, medic)}
  end

  defp preloads(medic_list_or_struct),
    do: Repo.preload(medic_list_or_struct, [:workplace])

  defp assign_medics_stream(socket) do
    medics =
      Practices.list_medics()
      |> preloads()

    stream(socket, :medics, medics)
  end
end
