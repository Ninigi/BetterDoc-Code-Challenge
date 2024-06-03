defmodule MedHubWeb.MedicLive.MedicComponents do
  @moduledoc """
  heex components used in the medic context.
  """

  use Phoenix.Component

  import MedHubWeb.MedicLive.FormUtils
  import MedHubWeb.CoreComponents

  @doc """
  A filter component used to search for specific medics.

  On change or submit, the `action` will be called and send a map with a "filter" key, including the following keys:

  * "gender"
  * "specialty"

  The `filter` attribute has to be a `Phoenix.HTML.Form` struct, including the currently set `gender` and `specialty` filter fields.

  To use the component, you have to implement a `handle_event` callback to filter the displayed medics.

  ## Example

  in your LV

      def handle_params(params, _url, socket) do
        # ...
        # in this example, we will keep the current filter as query parameters
        filter = filter_from_params(socket, params)

        medics = Practices.list_medics(filter: filter)

        socket = assign(socket, %{filter: to_form(filter), medics: medics})

        {:noreply, socket}
      end

      # ...
      def handle_event("filter", %{"filter" => filter}, socket) do
        # only keep non-empty filter fields
        filter = Map.reject(filter, fn {_key, val} -> val == "" end)

        {:noreply, push_patch(socket, to: ~p"/medics?\#{%{filter: filter}}")}
      end

  in your heex

      <.index_filter action="filter" filter={@form} />
  """
  attr :filter, Phoenix.HTML.Form, required: true
  attr :action, :string, required: true

  def index_filter(assigns) do
    ~H"""
    <div>
      <.subheading>
        Filter
      </.subheading>

      <.form
        class="w-full mt-8"
        for={@filter}
        id="medic-filter"
        phx-change={@action}
        phx-submit={@action}
      >
        <div class="flex flex-wrap -mx-3 mb-6">
          <div class="w-full md:w-1/4 px-3">
            <select
              id="filter-gender"
              name="filter[gender]"
              class="mt-2 block w-full rounded-md border border-gray-300 bg-white shadow-sm focus:border-zinc-400 focus:ring-0 text-sm"
            >
              <%= filter_gender_options(@filter) %>
            </select>
          </div>

          <div class="w-full md:w-3/4 px-3">
            <input
              placeholder="Specialty"
              class="mt-2 block w-full rounded-md border border-gray-300 bg-white shadow-sm focus:border-zinc-400 focus:ring-0 text-sm"
              name="filter[specialty]"
              value={@filter[:specialty].value}
              type="text"
              phx-debounce="700"
            />
          </div>
        </div>
      </.form>
    </div>
    """
  end

  defp filter_gender_options(filter) do
    options =
      gender_options()
      |> Enum.into([])

    [{"Any Gender", nil} | options]
    |> Phoenix.HTML.Form.options_for_select(filter[:gender].value)
  end
end
