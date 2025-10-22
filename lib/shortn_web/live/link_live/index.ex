defmodule ShortnWeb.LinkLive.Index do
  use ShortnWeb, :live_view

  alias Shortn.Links

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Links
        <:actions>
          <.button variant="primary" navigate={~p"/links/new"}>
            <.icon name="hero-plus" /> New Link
          </.button>
        </:actions>
      </.header>

      <.table
        id="links"
        rows={@streams.links}
      >
        <:col :let={{_id, link}} label="Url">{link.url}</:col>
        <:col :let={{_id, link}} label="Link">
          <.link class="underline" href={~p"/#{link.short}"}>{link.short}</.link>
        </:col>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Links")
     |> stream(:links, list_links())}
  end

  defp list_links() do
    Links.list_links()
  end
end
