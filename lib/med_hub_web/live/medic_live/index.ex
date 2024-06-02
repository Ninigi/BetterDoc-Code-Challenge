defmodule MedHubWeb.MedicLive.Index do
  use MedHubWeb, :live_view

  alias MedHub.Practices
  alias MedHub.Practices.Medic
  alias MedHub.Repo

  import MedHubWeb.MedicLive.FormUtils

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> assign_medics_stream(params)
      |> assign_filter(params)
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

  def handle_event("filter", %{"filter" => filter}, socket) do
    filter = Map.reject(filter, fn {_key, val} -> val == "" end)

    {:noreply, push_patch(socket, to: ~p"/medics?#{%{filter: filter}}")}
  end

  defp preloads(medic_list_or_struct),
    do: Repo.preload(medic_list_or_struct, [:workplace])

  defp assign_medics_stream(socket, params) do
    filter = filter_keywords(params)

    medics =
      Practices.list_medics(filter: filter)
      |> preloads()

    stream(socket, :medics, medics, reset: true)
  end

  defp filter_keywords(%{"filter" => filter}) do
    for {key, val} <- Map.take(filter, ["gender", "specialty"]), String.trim(val) != "" do
      {String.to_existing_atom(key), String.trim(val)}
    end
  end

  defp filter_keywords(_params), do: []

  defp assign_filter(socket, params) do
    filter = Map.get(params, "filter", %{})

    assign(
      socket,
      :filter,
      to_form(%{
        "gender" => filter["gender"],
        "specialty" => filter["specialty"]
      })
    )
  end

  defp filter_gender_options(filter) do
    options =
      gender_options()
      |> Enum.into([])

    [{"Any Gender", nil} | options]
    |> Phoenix.HTML.Form.options_for_select(filter[:gender].value)
  end
end
