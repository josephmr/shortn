defmodule Shortn.Links do
  @moduledoc """
  The Links context.
  """

  import Ecto.Query, warn: false
  alias Shortn.Repo
  alias Shortn.Links.Link
  alias Phoenix.PubSub

  def subscribe() do
    PubSub.subscribe(Shortn.PubSub, "links")
  end

  def notify({:ok, %Link{} = link} = result, event) do
    PubSub.broadcast(Shortn.PubSub, "links", {event, link})
    result
  end

  def notify(error, _event) do
    error
  end

  @doc """
  Returns the list of links.

  ## Examples

      iex> list_links()
      [%Link{}, ...]

  """
  def list_links do
    Repo.all(Link)
  end

  def get_link_by_short(short) do
    Repo.get_by(Link, short: short)
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_link!(id), do: Repo.get!(Link, id)

  @doc """
  Creates a link or returns existing link for url.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs) do
    insert =
      %Link{}
      |> Link.changeset(attrs)
      |> Repo.insert()

    url = attrs["url"] || attrs[:url]

    cond do
      # If no URL provided, just insert and return error changeset
      is_nil(url) ->
        insert

      link = Repo.get_by(Link, url: url) ->
        {:ok, link}

      true ->
        insert
        |> notify(:link_created)
    end
  end

  @doc """
  Deletes a link.

  ## Examples

      iex> delete_link(link)
      {:ok, %Link{}}

      iex> delete_link(link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
    |> notify(:link_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{data: %Link{}}

  """
  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.url_changeset(link, attrs)
  end
end
