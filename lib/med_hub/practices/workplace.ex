defmodule MedHub.Practices.Workplace do
  use Ecto.Schema
  import Ecto.Changeset

  alias MedHub.Repo
  alias MedHub.Practices.Medic

  schema "workplaces" do
    field :name, :string
    field :zip, :string
    field :street_name, :string
    field :house_number, :string
    field :city, :string

    # Never update this manually, let the database handle it!
    # see priv/repo/migrations/20240530103500_add_medics_number_to_workplaces.exs
    field :medics_count, :integer, default: 0

    has_many :medics, Medic

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workplace, attrs) do
    workplace
    |> cast(attrs, [:name, :street_name, :house_number, :zip, :city])
    |> validate_required([:name, :street_name, :house_number, :zip, :city])
    |> unsafe_validate_unique(:name, Repo)
    |> unique_constraint(:name)
  end
end
