defmodule Shortn.Repo do
  use Ecto.Repo,
    otp_app: :shortn,
    adapter: Ecto.Adapters.Postgres
end
