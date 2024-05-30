defmodule MedHub.Practices.Workplace do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workplaces" do
    field :name, :string
    field :zip, :string
    field :street_name, :string
    field :house_number, :string
    field :city, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workplace, attrs) do
    workplace
    |> cast(attrs, [:name, :street_name, :house_number, :zip, :city])
    |> validate_required([:name, :street_name, :house_number, :zip, :city])
  end
end
