defmodule LorcanBetAsync.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LorcanBetAsyncWeb.Telemetry,
      LorcanBetAsync.Repo,
      {DNSCluster, query: Application.get_env(:lorcan_bet_async, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LorcanBetAsync.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LorcanBetAsync.Finch},
      # Start a worker by calling: LorcanBetAsync.Worker.start_link(arg)
      # {LorcanBetAsync.Worker, arg},
      # Start to serve requests, typically the last entry
      LorcanBetAsyncWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LorcanBetAsync.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LorcanBetAsyncWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
