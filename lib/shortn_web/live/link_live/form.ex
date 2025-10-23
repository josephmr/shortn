defmodule ShortnWeb.LinkLive.Form do
  use ShortnWeb, :live_view

  alias Shortn.Links
  alias Shortn.Links.Link

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.form for={@form} id="link-form" phx-submit="save">
        <.input field={@form[:url]} type="text" label="Url" autofocus />
        <footer>
          <.button variant="primary">Shorten</.button>
        </footer>
      </.form>

      <div :if={assigns[:link]}>
        Shortened Link: <span id="shortened-url" phx-hook=".Copy">{url(~p"/#{@link.short}")}</span>
      </div>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".Copy">
        export default {
          copy() {
            navigator.clipboard.writeText(this.el.textContent)
              .then(() => this.pushEvent("copied", {}));
          },
          mounted() {
            this.copy();
          },
          updated() {
            this.copy();
          }
        }
      </script>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:form, to_form(Links.change_link(%Link{})))}
  end

  @impl true
  def handle_event("copied", _params, socket) do
    {:noreply,
     socket
     |> clear_flash()
     |> put_flash(:info, "Shortened URL copied to clipboard!")}
  end

  def handle_event("save", %{"link" => link_params}, socket) do
    case Links.create_link(link_params) do
      {:ok, link} ->
        {:noreply,
         socket
         |> put_flash(:info, "Link created successfully")
         |> assign(:link, link)
         |> assign(form: to_form(Links.change_link(%Link{})))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
