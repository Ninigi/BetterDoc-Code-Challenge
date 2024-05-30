defmodule MedHub.Practices.Medic do
  use Ecto.Schema
  import Ecto.Changeset

  @genders [:male, :female, :non_binary, :other]

  schema "medics" do
    field :name, :string
    field :title, :string
    field :gender, Ecto.Enum, values: @genders
    field :specialty, :string
    field :workplace_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(medic, attrs) do
    medic
    |> cast(attrs, [:name, :title, :gender, :specialty, :workplace_id])
    |> validate_required([:name, :title, :gender, :specialty, :workplace_id])
  end
end
