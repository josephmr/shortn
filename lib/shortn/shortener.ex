defmodule Shortn.Shortener do
  @moduledoc """
  Module responsible for generating short codes for URLs.
  """

  @doc """
  Generates a unique short code.

  ## Examples

      iex> Shortn.Shortener.generate_short_code()
      "a1b2c3"

  """
  def generate_short_code do
    :crypto.strong_rand_bytes(4)
    |> Base.url_encode64(padding: false)
    |> binary_part(0, 6)
  end
end
