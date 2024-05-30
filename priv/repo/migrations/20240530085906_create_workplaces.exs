defmodule MedHub.Repo.Migrations.CreateWorkplaces do
  use Ecto.Migration

  def change do
    create table(:workplaces) do
      add :name, :string
      add :street_name, :string
      add :house_number, :string
      add :zip, :string
      add :city, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:workplaces, [:name])
    create index(:workplaces, [:street_name, :house_number, :zip, :city])
  end
end
