defmodule Shortn.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :url, :string
    field :short, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :short])
    |> validate_required([:url, :short])
    |> unique_constraint(:short)
    |> unique_constraint(:url)
  end

  def url_changeset(link, attrs) do
    link
    |> cast(attrs, [:url])
    |> validate_required([:url])
    |> unique_constraint(:url)
  end
end
