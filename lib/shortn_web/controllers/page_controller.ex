defmodule ShortnWeb.PageController do
  use ShortnWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/links/new")
  end
end
