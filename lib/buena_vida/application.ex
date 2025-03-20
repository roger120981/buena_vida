defmodule BuenaVida.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BuenaVidaWeb.Telemetry,
      BuenaVida.Repo,
      {DNSCluster, query: Application.get_env(:buena_vida, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BuenaVida.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BuenaVida.Finch},
      # Start a worker by calling: BuenaVida.Worker.start_link(arg)
      # {BuenaVida.Worker, arg},
      # Start to serve requests, typically the last entry
      BuenaVidaWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BuenaVida.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BuenaVidaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
