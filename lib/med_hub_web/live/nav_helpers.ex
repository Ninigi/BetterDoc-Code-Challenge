defmodule MedHubWeb.NavHelpers do
  @moduledoc """
  Navbar helpers
  """

  import Phoenix.Component, only: [assign: 3]

  @doc """
  Used in `mount/3` callbacks to assign the current view module.

  ## Example

      use MedHubWeb, :live_view

      @impl true
      def mount(_params, _session, socket) do
        {:ok, assign_current_view(socket, MedHubWeb.MedicLive)}
      end
  """
  def assign_current_view(socket, view) do
    assign(socket, :current_view, view)
  end

  @doc """
  Can be used to highlight the current page in navbar.

  This function relies on the context namespace of your live views, so you should follow the convention: `MedHubWeb.[ContextNamespace].MyLiveView`.

  ## Example

  Assuming you used `assign_current_view/2` in `mount`:

      <.link class={if is_current_nav?(@current_view, MedHubWeb.MedicLive), do: "highlight-class"}>
        Medics
      </.link>

      <.link class={if is_current_nav?(@current_view, MedHubWeb.WorkplaceLive), do: "highlight-class"}>
        Workplaces
      </.link>
  """
  def is_current_nav?(current_view, view_namespace) do
    ["MedHubWeb", current_namespace | _] = Module.split(current_view)
    ["MedHubWeb", namespace | _] = Module.split(view_namespace)

    namespace == current_namespace
  end
end
