defmodule MedHub.Repo.Migrations.CreateMedics do
  use Ecto.Migration

  def change do
    execute("CREATE TYPE gender AS ENUM ('male', 'female', 'non_binary', 'other');")

    create table(:medics) do
      add :name, :string
      add :title, :string
      add :gender, :gender
      add :specialty, :string
      add :workplace_id, references(:workplaces, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:medics, [:workplace_id])

    create index(:medics, [:name, :specialty])
  end
end
