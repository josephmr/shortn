defmodule Shortn.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Shortn.Links` context.
  """

  @doc """
  Generate a unique link short.
  """
  def unique_link_short, do: "some short#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique link url.
  """
  def unique_link_url, do: "some url#{System.unique_integer([:positive])}"

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        short: unique_link_short(),
        url: unique_link_url()
      })
      |> Shortn.Links.create_link()

    link
  end
end
