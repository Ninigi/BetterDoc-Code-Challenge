defmodule MedHub.PracticesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MedHub.Practices` context.
  """

  @valid_genders Ecto.Enum.values(MedHub.Practices.Medic, :gender)

  @doc """
  Valid workplace attributes
  """
  def workplace_attrs(attrs \\ %{}) do
    name = "#{Faker.Color.name()} #{Faker.Team.creature()} #{Faker.UUID.v4()}"

    Enum.into(attrs, %{
      city: Faker.Address.city(),
      house_number: Faker.Address.building_number(),
      name: name,
      street_name: Faker.Address.street_name(),
      zip: Faker.Address.zip_code()
    })
  end

  @doc """
  Generate a workplace.
  """
  def workplace_fixture(attrs \\ %{}) do
    {:ok, workplace} =
      attrs
      |> workplace_attrs()
      |> MedHub.Practices.create_workplace()

    workplace
  end

  @doc """
  Valid medic attributes
  """
  def medic_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      name: Faker.Person.name(),
      title: "Dr.",
      gender: Enum.random(@valid_genders),
      specialty: "some specialty",
      workplace_id: Map.get(attrs, :workplace_id, workplace_fixture().id)
    })
  end

  @doc """
  Generate a medic.
  """
  def medic_fixture(attrs \\ %{}) do
    {:ok, medic} =
      attrs
      |> medic_attrs()
      |> MedHub.Practices.create_medic()

    medic
  end
end
