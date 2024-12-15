defmodule Appelixir.Application do
  use Application

  @impl true
  def start(_type, _args) do
    {port, _} =
      System.get_env("PORT", "4000")
      |> Integer.parse()

    bandit_options = [
      port: port
    ]

    topologies = [
      appelixir: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:"node1@MacBook-Air-de-Iramar", :"node2@MacBook-Air-de-Iramar"]]
      ]
    ]

    children = [
      {Cache, []},
      {Bandit, plug: Appelixir.Router, scheme: :http, options: bandit_options},
      {Cluster.Supervisor, [topologies, [name: Appelixir.ClusterSupervisor]]}
    ]

    opts = [strategy: :one_for_one, name: Appelixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
