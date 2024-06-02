defmodule MedHubWeb.MedicLive.FormUtils do
  alias MedHub.Practices

  def gender_options do
    Practices.Medic.genders()
    |> Map.new(fn gender ->
      key =
        gender
        |> Atom.to_string()
        |> Phoenix.Naming.humanize()

      {key, gender}
    end)
  end
end
