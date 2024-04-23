# Mar

Simple Web in Elixir

## Installation

If you don't have a project, create one:

```sh
$ mix new my_app --sup
$ cd my_app
```

Add Mar to your dependencies in:

```elixir
# mix.exs
defp deps do
  [
    {:mar, "~> 0.2.0"}
  ]
end
```

Add Mar as a child:

```elixir
# lib/my_app/application.ex
def start(_type, _args) do
  children = [
    Mar
  ]
  # ...
end
```

Add Mar to your module to make it a route:

```elixir
# lib/my_app/route.ex
defmodule MyApp.Page do
  use Mar

  def get() do
    "Hello, world!"
  end
end
```

Spin up a server:

```sh
$ mix run --no-halt
```

```sh
$ curl localhost:4000
# Hello, world!
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
