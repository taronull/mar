# Mar

Simple Web in Elixir

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

    options = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, options)
  end
  # ...
end
```

Add Mar to your page module:

```elixir
defmodule MyApp.Page do
  use Mar

  def get(%{}) do
    "Hello, world!"
  end
end
```

## Use

Using `Mar` makes the module a route.
It injects `Mar.Route` protocol and a struct.
Set a `path` or the default is "/".
Add parameters in the path or in the `params` list.

```elixir
defmodule MyApp do
  use Mar, path: "/post/:id", params: [:likes, :comment]
end
```

Name your function after the HTTP method.
Take HTTP parameters from a map.
Return a response body with text.

```elixir
def get(%{id: id}) do
  "You are reading #{id}"
end
```

Returning a map will send a response in JSON.

```elixir
def post(%{id: id, comment: comment}) do
  %{
    id: id,
    comment: comment
  }
end
```

Return a tuple to set HTTP status and headers.

```elixir
def delete(%{id: _id}) do
  # {status, header, body}
  {301, [location: "/"], nil}
end
```

`Mar.Route` protocol lets you access `Plug.Conn`.

```elixir
defimpl Mar.Route do
  # Mar.Route.MyApp

  def before_action(route) do
    # Access `route.conn` before the actions you have defined.
    route
  end

  def after_action(route) do
    # Access `route.conn` after the actions you have defined.
    route
  end
end
```

## Reference

- [Mar on HexDocs](https://hexdocs.pm/mar)
- [Proposal on Elixir Forum](https://elixirforum.com/t/62885)
