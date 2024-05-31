defmodule MedHubWeb.MedicLiveTest do
  use MedHubWeb.ConnCase

  import Phoenix.LiveViewTest
  import MedHub.PracticesFixtures

  @invalid_attrs %{name: nil, title: nil, gender: :other}

  defp create_medic(_) do
    medic = medic_fixture()
    %{medic: medic}
  end

  describe "Index" do
    setup [:create_medic]

    test "lists all medics", %{conn: conn, medic: medic} do
      {:ok, _index_live, html} = live(conn, ~p"/medics")

      assert html =~ "Listing Medics"
      assert html =~ medic.name
    end

    test "saves new medic", %{conn: conn} do
      attrs = medic_attrs()
      {:ok, index_live, _html} = live(conn, ~p"/medics")

      assert index_live |> element("a", "New Medic") |> render_click() =~
               "New Medic"

      assert_patch(index_live, ~p"/medics/new")

      assert index_live
             |> form("#medic-form", medic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#medic-form", medic: attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/medics")

      html = render(index_live)
      assert html =~ "Medic created successfully"
      assert html =~ attrs.name
    end

    test "updates medic in listing", %{conn: conn, medic: medic} do
      attrs = medic_attrs()
      {:ok, index_live, _html} = live(conn, ~p"/medics")

      assert index_live |> element("#medics-#{medic.id} a", "Edit") |> render_click() =~
               "Edit Medic"

      assert_patch(index_live, ~p"/medics/#{medic}/edit")

      assert index_live
             |> form("#medic-form", medic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#medic-form", medic: attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/medics")

      html = render(index_live)
      assert html =~ "Medic updated successfully"
      assert html =~ attrs.name
    end

    test "deletes medic in listing", %{conn: conn, medic: medic} do
      {:ok, index_live, _html} = live(conn, ~p"/medics")

      assert index_live |> element("#medics-#{medic.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#medics-#{medic.id}")
    end
  end

  describe "Show" do
    setup [:create_medic]

    test "displays medic", %{conn: conn, medic: medic} do
      {:ok, _show_live, html} = live(conn, ~p"/medics/#{medic}")

      assert html =~ "Show Medic"
      assert html =~ medic.name
    end

    test "updates medic within modal", %{conn: conn, medic: medic} do
      attrs = medic_attrs()
      {:ok, show_live, _html} = live(conn, ~p"/medics/#{medic}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Medic"

      assert_patch(show_live, ~p"/medics/#{medic}/show/edit")

      assert show_live
             |> form("#medic-form", medic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#medic-form", medic: attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/medics/#{medic}")

      html = render(show_live)
      assert html =~ "Medic updated successfully"
      assert html =~ attrs.name
    end
  end
end
