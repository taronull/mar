# Mar

The Web in Elixir

## Installation

Add Mar to your Mix file:

```elixir
defmodule MyApp.Mix do
  use Mix.Project
  # ...
  defp deps do
    [
      {:mar, "~> 0.1.0"}
    ]
  end
  # ...
end
```

Add Mar as a child:

```elixir
defmodule MyApp.Application do
  use Application
  # ...
  def start(_type, _args) do
    children = [
      Mar
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
  # ...
end
```

Add Mar to your page module:

```elixir
defmodule MyApp.Page do
  use Mar

  # TODO: Add callback example
end
```
