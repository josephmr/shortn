defmodule ShortnWeb.PageControllerTest do
  use ShortnWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert redirected_to(conn) == ~p"/links/new"
  end
end
