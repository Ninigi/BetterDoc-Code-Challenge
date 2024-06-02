defmodule MedHub.Practices do
  @moduledoc """
  The Practices context.
  """

  import Ecto.Query, warn: false
  alias MedHub.Repo

  alias MedHub.Practices.Workplace

  @doc """
  Returns the list of workplaces.

  ## Examples

      iex> list_workplaces()
      [%Workplace{}, ...]

  """
  def list_workplaces do
    Repo.all(Workplace)
  end

  @doc """
  Gets a single workplace.

  Raises `Ecto.NoResultsError` if the Workplace does not exist.

  ## Examples

      iex> get_workplace!(123)
      %Workplace{}

      iex> get_workplace!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workplace!(id), do: Repo.get!(Workplace, id)

  @doc """
  Creates a workplace.

  ## Examples

      iex> create_workplace(%{field: value})
      {:ok, %Workplace{}}

      iex> create_workplace(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workplace(attrs \\ %{}) do
    %Workplace{}
    |> Workplace.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workplace.

  ## Examples

      iex> update_workplace(workplace, %{field: new_value})
      {:ok, %Workplace{}}

      iex> update_workplace(workplace, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workplace(%Workplace{} = workplace, attrs) do
    workplace
    |> Workplace.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a workplace.

  ## Examples

      iex> delete_workplace(workplace)
      {:ok, %Workplace{}}

      iex> delete_workplace(workplace)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workplace(%Workplace{} = workplace) do
    Repo.delete(workplace)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workplace changes.

  ## Examples

      iex> change_workplace(workplace)
      %Ecto.Changeset{data: %Workplace{}}

  """
  def change_workplace(%Workplace{} = workplace, attrs \\ %{}) do
    Workplace.changeset(workplace, attrs)
  end

  alias MedHub.Practices.Medic

  @doc """
  Returns the list of medics.

  Medics can be filtered by passing a `:filter` option. If filter includes `:specialty`, this function applies an `ilike` search.

  ## Examples

      iex> list_medics()
      [%Medic{}, ...]

      iex> list_medics(filter: %{})

  """
  def list_medics(opts \\ []) do
    {filter, _opts} = Keyword.pop(opts, :filter, [])
    {specialty, filter} = Keyword.pop(filter, :specialty)

    Medic
    |> maybe_filter_specialty(specialty)
    |> where(^filter)
    |> Repo.all()
  end

  defp maybe_filter_specialty(queryable, nil), do: queryable

  defp maybe_filter_specialty(queryable, specialty) do
    specialty_query = "%#{specialty}%"

    from(
      medics in queryable,
      where: ilike(medics.specialty, ^specialty_query)
    )
  end

  @doc """
  Gets a single medic.

  Raises `Ecto.NoResultsError` if the Medic does not exist.

  ## Examples

      iex> get_medic!(123)
      %Medic{}

      iex> get_medic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_medic!(id), do: Repo.get!(Medic, id)

  @doc """
  Creates a medic.

  ## Examples

      iex> create_medic(%{field: value})
      {:ok, %Medic{}}

      iex> create_medic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_medic(attrs \\ %{}) do
    %Medic{}
    |> Medic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a medic.

  ## Examples

      iex> update_medic(medic, %{field: new_value})
      {:ok, %Medic{}}

      iex> update_medic(medic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_medic(%Medic{} = medic, attrs) do
    medic
    |> Medic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a medic.

  ## Examples

      iex> delete_medic(medic)
      {:ok, %Medic{}}

      iex> delete_medic(medic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_medic(%Medic{} = medic) do
    Repo.delete(medic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking medic changes.

  ## Examples

      iex> change_medic(medic)
      %Ecto.Changeset{data: %Medic{}}

  """
  def change_medic(%Medic{} = medic, attrs \\ %{}) do
    Medic.changeset(medic, attrs)
  end
end
