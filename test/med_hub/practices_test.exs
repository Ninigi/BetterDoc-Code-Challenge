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
      valid_attrs = %{name: "some name", zip: "some zip", street_name: "some street_name", house_number: "some house_number", city: "some city"}

      assert {:ok, %Workplace{} = workplace} = Practices.create_workplace(valid_attrs)
      assert workplace.name == "some name"
      assert workplace.zip == "some zip"
      assert workplace.street_name == "some street_name"
      assert workplace.house_number == "some house_number"
      assert workplace.city == "some city"
    end

    test "create_workplace/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Practices.create_workplace(@invalid_attrs)
    end

    test "update_workplace/2 with valid data updates the workplace" do
      workplace = workplace_fixture()
      update_attrs = %{name: "some updated name", zip: "some updated zip", street_name: "some updated street_name", house_number: "some updated house_number", city: "some updated city"}

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
    @valid_genders Ecto.Enum.values(Medic, :gender)

    defp valid_attrs do
      workplace = workplace_fixture()
      gender = Enum.random(@valid_genders)
      %{name: "some name", title: "some title", gender: gender, specialty: "some specialty", workplace_id: workplace.id}
    end

    defp different_gender(current_gender) do
      case Enum.random(@valid_genders) do
        ^current_gender -> different_gender(current_gender)
        new_gender -> new_gender
      end
    end

    test "list_medics/0 returns all medics" do
      medic = medic_fixture()
      assert Practices.list_medics() == [medic]
    end

    test "get_medic!/1 returns the medic with given id" do
      medic = medic_fixture()
      assert Practices.get_medic!(medic.id) == medic
    end

    test "create_medic/1 with valid data creates a medic" do
      attrs = valid_attrs()
      assert {:ok, %Medic{} = medic} = Practices.create_medic(attrs)
      assert medic.name == "some name"
      assert medic.title == "some title"
      assert medic.gender == attrs.gender
      assert medic.specialty == "some specialty"
    end

    test "create_medic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Practices.create_medic(@invalid_attrs)
    end

    test "create_medic/1 with invalid gender returns error changeset" do
      attrs = %{name: "some name", title: "some title", gender: "invalid gender", specialty: "some specialty"}
      assert {:error, %Ecto.Changeset{}} = Practices.create_medic(attrs)
    end

    test "update_medic/2 with valid data updates the medic" do
      medic = medic_fixture()
      gender = different_gender(medic.gender)
      workplace = workplace_fixture()
      update_attrs = %{name: "some updated name", title: "some updated title", gender: gender, specialty: "some updated specialty", workplace_id: workplace.id}

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
      assert {:error, %Ecto.Changeset{} = error_changeset} = Practices.update_medic(medic, %{gender: "invalid gender"})
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
end
