defmodule MedHub.PracticesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MedHub.Practices` context.
  """

  @doc """
  Generate a workplace.
  """
  def workplace_fixture(attrs \\ %{}) do
    name = "#{Faker.Color.name()} #{Faker.Cat.name}"

    {:ok, workplace} =
      attrs
      |> Enum.into(%{
        city: Faker.Address.city(),
        house_number: Faker.Address.building_number(),
        name: name,
        street_name: Faker.Address.street_name(),
        zip: Faker.Address.zip_code()
      })
      |> MedHub.Practices.create_workplace()

    workplace
  end

  @doc """
  Generate a medic.
  """
  def medic_fixture(attrs \\ %{}) do
    gender = MedHub.Practices.Medic 
    |> Ecto.Enum.values(:gender)
    |> Enum.random()

    workplace = workplace_fixture()

    {:ok, medic} =
      attrs
      |> Enum.into(%{
        gender: gender,
        name: "some name",
        specialty: "some specialty",
        title: "some title",
        workplace_id: workplace.id
      })
      |> MedHub.Practices.create_medic()

    medic
  end
end
