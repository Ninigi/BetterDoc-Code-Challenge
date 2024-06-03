defmodule MedHub.PracticesTest do
  use MedHub.DataCase

  alias MedHub.Practices

  describe "workplaces" do
    alias MedHub.Practices.Workplace

    import MedHub.PracticesFixtures

    @invalid_attrs %{name: nil, zip: nil, street_name: nil, house_number: nil, city: nil}

    test "list_workplaces/0 returns all workplaces" do
      workplace = workplace_fixture()
      assert Practices.list_workplaces() == [workplace]
    end

    test "get_workplace!/1 returns the workplace with given id" do
      workplace = workplace_fixture()
      assert Practices.get_workplace!(workplace.id) == workplace
    end

    test "create_workplace/1 with valid data creates a workplace" do
      valid_attrs = workplace_attrs()

      assert {:ok, %Workplace{} = workplace} = Practices.create_workplace(valid_attrs)
      assert valid_attrs == Map.take(workplace, [:name, :zip, :street_name, :house_number, :city])
    end

    test "create_workplace/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Practices.create_workplace(@invalid_attrs)
    end

    test "create_workplace/1 with duplicate name returns error" do
      valid_attrs = workplace_attrs()

      invalid_attrs = workplace_attrs(%{name: valid_attrs.name})

      assert {:ok, %Workplace{}} = Practices.create_workplace(valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Practices.create_workplace(invalid_attrs)
    end

    test "update_workplace/2 with valid data updates the workplace" do
      workplace = workplace_fixture()

      update_attrs = %{
        name: "some updated name",
        zip: "some updated zip",
        street_name: "some updated street_name",
        house_number: "some updated house_number",
        city: "some updated city"
      }

      assert {:ok, %Workplace{} = workplace} = Practices.update_workplace(workplace, update_attrs)
      assert workplace.name == "some updated name"
      assert workplace.zip == "some updated zip"
      assert workplace.street_name == "some updated street_name"
      assert workplace.house_number == "some updated house_number"
      assert workplace.city == "some updated city"
    end

    test "update_workplace/2 with invalid data returns error changeset" do
      workplace = workplace_fixture()
      assert {:error, %Ecto.Changeset{}} = Practices.update_workplace(workplace, @invalid_attrs)
      assert workplace == Practices.get_workplace!(workplace.id)
    end

    test "delete_workplace/1 deletes the workplace" do
      workplace = workplace_fixture()
      assert {:ok, %Workplace{}} = Practices.delete_workplace(workplace)
      assert_raise Ecto.NoResultsError, fn -> Practices.get_workplace!(workplace.id) end
    end

    test "change_workplace/1 returns a workplace changeset" do
      workplace = workplace_fixture()
      assert %Ecto.Changeset{} = Practices.change_workplace(workplace)
    end
  end

  describe "medics" do
    alias MedHub.Practices.Medic

    import MedHub.PracticesFixtures

    @invalid_attrs %{name: nil, title: nil, gender: nil, specialty: nil}

    defp different_gender(current_gender) do
      case medic_attrs() do
        %{gender: ^current_gender} -> different_gender(current_gender)
        %{gender: new_gender} -> new_gender
      end
    end

    test "list_medics/0 returns all medics" do
      medic = medic_fixture()
      assert Practices.list_medics() == [medic]
    end

    test "list_medics/1 can be filtered by gender and specialty" do
      medic1 = medic_fixture(%{specialty: "Specialty 1"})
      medic2 = medic_fixture(%{gender: different_gender(medic1.gender), specialty: "Specialty 2"})

      assert [medic] = Practices.list_medics(filter: [gender: medic1.gender])
      assert medic.gender == medic1.gender

      assert [medic] = Practices.list_medics(filter: [specialty: medic2.specialty])
      assert medic.specialty == medic2.specialty
    end

    test "get_medic!/1 returns the medic with given id" do
      medic = medic_fixture()
      assert Practices.get_medic!(medic.id) == medic
    end

    test "create_medic/1 with valid data creates a medic" do
      attrs = medic_attrs()
      assert {:ok, %Medic{} = medic} = Practices.create_medic(attrs)

      keys = Map.keys(attrs)
      assert attrs == Map.take(medic, keys)
    end

    test "create_medic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Practices.create_medic(@invalid_attrs)
    end

    test "create_medic/1 with invalid gender returns error changeset" do
      attrs = %{
        name: "some name",
        title: "some title",
        gender: "invalid gender",
        specialty: "some specialty"
      }

      assert {:error, %Ecto.Changeset{}} = Practices.create_medic(attrs)
    end

    test "update_medic/2 with valid data updates the medic" do
      medic = medic_fixture()
      gender = different_gender(medic.gender)
      workplace = workplace_fixture()

      update_attrs = %{
        name: "some updated name",
        title: "some updated title",
        gender: gender,
        specialty: "some updated specialty",
        workplace_id: workplace.id
      }

      assert {:ok, %Medic{} = medic} = Practices.update_medic(medic, update_attrs)
      assert medic.name == "some updated name"
      assert medic.title == "some updated title"
      assert medic.gender == gender
      assert medic.specialty == "some updated specialty"
    end

    test "update_medic/2 with invalid data returns error changeset" do
      medic = medic_fixture()
      assert {:error, %Ecto.Changeset{}} = Practices.update_medic(medic, @invalid_attrs)
      assert medic == Practices.get_medic!(medic.id)
    end

    test "update_medic/2 with invalid gender returns error changeset" do
      medic = medic_fixture()

      assert {:error, %Ecto.Changeset{} = error_changeset} =
               Practices.update_medic(medic, %{gender: "invalid gender"})

      assert medic == Practices.get_medic!(medic.id)
      assert {"is invalid", _} = error_changeset.errors[:gender]
    end

    test "delete_medic/1 deletes the medic" do
      medic = medic_fixture()
      assert {:ok, %Medic{}} = Practices.delete_medic(medic)
      assert_raise Ecto.NoResultsError, fn -> Practices.get_medic!(medic.id) end
    end

    test "change_medic/1 returns a medic changeset" do
      medic = medic_fixture()
      assert %Ecto.Changeset{} = Practices.change_medic(medic)
    end
  end

  describe "medics per workplace" do
    import MedHub.PracticesFixtures
    alias MedHub.Practices
    alias MedHub.Repo

    setup do
      %{workplace: workplace_fixture()}
    end

    test "does not allow more than 50 medics", %{workplace: workplace} do
      Enum.each(1..50, fn _num ->
        medic_fixture(%{workplace_id: workplace.id})
      end)

      assert Repo.aggregate(Practices.Medic, :count) == 50

      attrs = medic_attrs(%{workplace_id: workplace.id})

      assert {:error, %Ecto.Changeset{}} = Practices.create_medic(attrs)
    end

    test "works for to up to 50 medics", %{workplace: workplace} do
      Enum.each(1..49, fn _num ->
        medic_fixture(%{workplace_id: workplace.id})
      end)

      attrs = medic_attrs(%{workplace_id: workplace.id})

      assert Repo.aggregate(Practices.Medic, :count) == 49
      assert {:ok, _medic} = Practices.create_medic(attrs)
    end

    test "automatically increments workplace.medics_count when creating a medic", %{
      workplace: workplace
    } do
      assert workplace.medics_count == 0
      attrs = medic_attrs(%{workplace_id: workplace.id})

      assert {:ok, _} = Practices.create_medic(attrs)

      workplace = Practices.get_workplace!(workplace.id)

      assert workplace.medics_count == 1
    end

    test "automatically decrements workplace.medics_count when creating a medic", %{
      workplace: workplace
    } do
      attrs = medic_attrs(%{workplace_id: workplace.id})

      assert {:ok, medic} = Practices.create_medic(attrs)

      workplace = Practices.get_workplace!(workplace.id)

      assert workplace.medics_count == 1

      Practices.delete_medic(medic)

      workplace = Practices.get_workplace!(workplace.id)

      assert workplace.medics_count == 0
    end

    test "automatically updates workplace.medics_count when updating a medic", %{
      workplace: workplace
    } do
      attrs = medic_attrs(%{workplace_id: workplace.id})

      assert {:ok, medic} = Practices.create_medic(attrs)

      workplace = Practices.get_workplace!(workplace.id)

      assert workplace.medics_count == 1

      new_workplace = workplace_fixture()

      Practices.update_medic(medic, %{workplace_id: new_workplace.id})

      workplace = Practices.get_workplace!(workplace.id)
      new_workplace = Practices.get_workplace!(new_workplace.id)

      assert workplace.medics_count == 0
      assert new_workplace.medics_count == 1
    end

    test "prevents updating a medic if workplace.medics_count == 50", %{workplace: workplace} do
      Enum.each(1..50, fn num ->
        medic_fixture(%{workplace_id: workplace.id, name: "some name #{num}"})
      end)

      medic = medic_fixture()

      assert {:error, error_changeset} =
               Practices.update_medic(medic, %{workplace_id: workplace.id})

      assert error_changeset.errors[:medics_count] != nil
    end
  end
end
