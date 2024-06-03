defmodule MedHubWeb.WorkplaceLive.Show do
  use MedHubWeb, :live_view

  alias MedHub.Practices
  alias MedHub.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign_current_view(socket, __MODULE__)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    workplace =
      id
      |> Practices.get_workplace!()
      |> Repo.preload([:medics])

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:workplace, workplace)}
  end

  defp page_title(:show), do: "Show Workplace"
  defp page_title(:edit), do: "Edit Workplace"
end
