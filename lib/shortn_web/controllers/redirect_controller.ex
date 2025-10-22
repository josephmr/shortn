defmodule ShortnWeb.RedirectController do
  use ShortnWeb, :controller

  alias Shortn.Links

  def show(conn, %{"short" => short}) do
    case Links.get_link_by_short(short) do
      nil ->
        conn
        |> put_flash(:error, "Link not found")
        |> redirect(to: ~p"/links/new")

      link ->
        conn
        |> put_status(:moved_permanently)
        |> redirect(external: link.url)
    end
  end
end
