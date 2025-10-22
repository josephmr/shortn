defmodule Shortn.Links do
  @moduledoc """
  The Links context.
  """

  import Ecto.Query, warn: false
  alias Shortn.Repo

  alias Shortn.Links.Link

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
  def create_link(%{"url" => nil} = attrs), do: create_new_link(attrs)

  def create_link(%{"url" => url} = attrs) do
    case Repo.get_by(Link, url: url) do
      nil ->
        create_new_link(attrs)

      link ->
        {:ok, link}
    end
  end

  def create_new_link(attrs) do
    attrs = Map.put(attrs, "short", Shortn.Shortener.generate_short_code())

    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
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
