defmodule ShortnWeb.PageController do
  use ShortnWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
