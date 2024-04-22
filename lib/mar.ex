defmodule Mar do
  @moduledoc ~S"""
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
  """
  @moduledoc since: "0.1.0"

  @doc false
  def child_spec(options) do
    options = Keyword.put(options, :plug, Mar.Plug)

    %{
      id: __MODULE__,
      start: {Bandit, :start_link, [options]}
    }
  end

  @doc false
  defmacro __using__(options) do
    path = Keyword.get(options, :path, "/")
    params = Keyword.get(options, :params, []) ++ parse_path_params(path)

    quote do
      @derive [Mar.Route]
      defstruct path: unquote(path),
                params: unquote(params),
                action: nil,
                conn: nil
    end
  end

  defp parse_path_params(path) do
    Regex.scan(~r/:(\w+)/, path, capture: :all_but_first)
    |> Enum.map(fn matches -> List.first(matches) |> String.to_atom() end)
  end
end
