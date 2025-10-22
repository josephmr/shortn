defmodule ShortnWeb.LinkLiveTest do
  use ShortnWeb.ConnCase

  import Phoenix.LiveViewTest
  import Shortn.LinksFixtures

  @create_attrs %{url: "some url"}
  @invalid_attrs %{url: nil}

  defp create_link(_) do
    link = link_fixture()

    %{link: link}
  end

  describe "Index" do
    setup [:create_link]

    test "lists all links", %{conn: conn, link: link} do
      {:ok, _index_live, html} = live(conn, ~p"/links")

      assert html =~ link.url
    end

    test "saves new link", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/links")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Link")
               |> render_click()
               |> follow_redirect(conn, ~p"/links/new")

      assert render(form_live) =~ "Shorten"

      assert form_live
             |> form("#link-form", link: @invalid_attrs)
             |> render_submit() =~ "can&#39;t be blank"

      assert html =
               form_live
               |> form("#link-form", link: @create_attrs)
               |> render_submit()

      assert html =~ "Link created successfully"
      assert html =~ "Shortened Link"
    end
  end
end
