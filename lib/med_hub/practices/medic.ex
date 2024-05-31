defmodule MedHub.Practices.Medic do
  use Ecto.Schema
  import Ecto.Changeset

  alias MedHub.Repo
  alias MedHub.Practices.Workplace

  @genders [:male, :female, :non_binary, :other]
  @medics_count_error "number of medics per workplace must be less or equal to 50"

  schema "medics" do
    field :name, :string
    field :title, :string
    field :gender, Ecto.Enum, values: @genders
    field :specialty, :string
    belongs_to :workplace, Workplace

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(medic, attrs) do
    medic
    |> cast(attrs, [:name, :title, :gender, :specialty, :workplace_id])
    |> validate_required([:name, :title, :gender, :specialty, :workplace_id])
    |> unsafe_validate_medics_count()
    |> check_constraint(:medics_count, name: "check_medics_count", message: @medics_count_error)
  end

  def genders, do: @genders

  defp unsafe_validate_medics_count(changeset) do
    # NOTE: medics count <= 50 is enforced by database triggers and a constraint!
    # this validation is just for convenience, to avoid unnecessary ERROR logs, and easier to read code
    # see priv/repo/migrations/20240530103500_add_medics_number_to_workplaces.exs

    with {:workplace_changed, %{workplace_id: workplace_id}} <-
           {:workplace_changed, changeset.changes},
         workplace <- Repo.get!(Workplace, workplace_id),
         {:count, 50} <- {:count, workplace.medics_count} do
      add_error(changeset, :medics_count, @medics_count_error)
    else
      {_key, _} ->
        # key can be used for debugging
        changeset
    end
  end
end
