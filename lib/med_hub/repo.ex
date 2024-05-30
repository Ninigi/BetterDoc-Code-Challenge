defmodule MedHub.Repo do
  use Ecto.Repo,
    otp_app: :med_hub,
    adapter: Ecto.Adapters.Postgres
end
