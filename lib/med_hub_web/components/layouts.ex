defmodule MedHubWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use MedHubWeb, :controller` and
  `use MedHubWeb, :live_view`.
  """
  use MedHubWeb, :html

  import MedHubWeb.NavHelpers, only: [is_current_nav?: 2]

  embed_templates "layouts/*"
end
