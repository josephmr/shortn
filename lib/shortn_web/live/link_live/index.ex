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
    if connected?(socket), do: Links.subscribe()

    {:ok,
     socket
     |> stream(:links, list_links())}
  end

  @impl true
  def handle_info({:link_created, link}, socket) do
    {:noreply, stream_insert(socket, :links, link)}
  end

  def handle_info({:link_deleted, link}, socket) do
    {:noreply, stream_delete(socket, :links, link)}
  end

  defp list_links() do
    Links.list_links()
  end
end
