defmodule MedHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MedHubWeb.Telemetry,
      MedHub.Repo,
      {DNSCluster, query: Application.get_env(:med_hub, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MedHub.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MedHub.Finch},
      # Start a worker by calling: MedHub.Worker.start_link(arg)
      # {MedHub.Worker, arg},
      # Start to serve requests, typically the last entry
      MedHubWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MedHub.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MedHubWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
