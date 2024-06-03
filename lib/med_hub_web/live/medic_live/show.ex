defmodule MedHubWeb.MedicLive.Show do
  use MedHubWeb, :live_view

  alias MedHub.Practices
  alias MedHub.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign_current_view(socket, __MODULE__)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    medic =
      id
      |> Practices.get_medic!()
      |> Repo.preload([:workplace])

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:medic, medic)}
  end

  defp page_title(:show), do: "Show Medic"
  defp page_title(:edit), do: "Edit Medic"
end
