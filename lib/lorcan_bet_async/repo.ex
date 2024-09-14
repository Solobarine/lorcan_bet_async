defmodule LorcanBetAsync.Repo do
  use Ecto.Repo,
    otp_app: :lorcan_bet_async,
    adapter: Ecto.Adapters.Postgres
end
