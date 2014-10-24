defmodule Main do
  use Application

  def start(_type, _args) do
    # IO.puts "=== === got to here === ==="
    import Supervisor.Spec, warn: false

    children = [
      worker(DataServer, [])
    ]
    
    opts = [strategy: :one_for_one, name: DataServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
