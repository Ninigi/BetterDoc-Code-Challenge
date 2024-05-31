defmodule MedHubWeb.WorkplaceLiveTest do
  use MedHubWeb.ConnCase

  import Phoenix.LiveViewTest
  import MedHub.PracticesFixtures

  @invalid_attrs %{name: nil, zip: nil, street_name: nil, house_number: nil, city: nil}

  defp create_workplace(_) do
    workplace = workplace_fixture()
    %{workplace: workplace}
  end

  describe "Index" do
    setup [:create_workplace]

    test "lists all workplaces", %{conn: conn, workplace: workplace} do
      {:ok, _index_live, html} = live(conn, ~p"/workplaces")

      assert html =~ "Listing Workplaces"
      assert html =~ workplace.name
    end

    test "saves new workplace", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/workplaces")

      assert index_live |> element("a", "New Workplace") |> render_click() =~
               "New Workplace"

      assert_patch(index_live, ~p"/workplaces/new")

      assert index_live
             |> form("#workplace-form", workplace: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      attrs = workplace_attrs()

      assert index_live
             |> form("#workplace-form", workplace: attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/workplaces")

      html = render(index_live)
      assert html =~ "Workplace created successfully"
      assert html =~ attrs.name
    end

    test "updates workplace in listing", %{conn: conn, workplace: workplace} do
      {:ok, index_live, _html} = live(conn, ~p"/workplaces")

      assert index_live |> element("#workplaces-#{workplace.id} a", "Edit") |> render_click() =~
               "Edit Workplace"

      assert_patch(index_live, ~p"/workplaces/#{workplace}/edit")

      assert index_live
             |> form("#workplace-form", workplace: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      attrs = workplace_attrs()

      assert index_live
             |> form("#workplace-form", workplace: attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/workplaces")

      html = render(index_live)
      assert html =~ "Workplace updated successfully"
      assert html =~ attrs.name
    end

    test "deletes workplace in listing", %{conn: conn, workplace: workplace} do
      {:ok, index_live, _html} = live(conn, ~p"/workplaces")

      assert index_live |> element("#workplaces-#{workplace.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#workplaces-#{workplace.id}")
    end
  end

  describe "Show" do
    setup [:create_workplace]

    test "displays workplace", %{conn: conn, workplace: workplace} do
      {:ok, _show_live, html} = live(conn, ~p"/workplaces/#{workplace}")

      assert html =~ "Show Workplace"
      assert html =~ workplace.name
    end

    test "updates workplace within modal", %{conn: conn, workplace: workplace} do
      {:ok, show_live, _html} = live(conn, ~p"/workplaces/#{workplace}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Workplace"

      assert_patch(show_live, ~p"/workplaces/#{workplace}/show/edit")

      assert show_live
             |> form("#workplace-form", workplace: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      attrs = workplace_attrs()

      assert show_live
             |> form("#workplace-form", workplace: attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/workplaces/#{workplace}")

      html = render(show_live)
      assert html =~ "Workplace updated successfully"
      assert html =~ attrs.name
    end
  end
end
