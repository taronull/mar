defmodule Mar.Plug do
  use Plug.Builder

  def init(options) do
    {:consolidated, routes} = Mar.Route.__protocol__(:impls)
    [{:routes, routes} | options]
  end

  def call(conn, options) do
    routes = Keyword.get(options, :routes)
    # TODO: Without a defstruct on the user, it's broken. Fix it.
    route =
      Enum.find(routes, fn module -> Mar.Route.route(module.__struct__) == conn.request_path end)

    action = String.downcase(conn.method) |> String.to_atom()
    body = apply(route, action, [])

    conn
    |> super(options)
    |> put_resp_content_type("text/plain")
    |> send_resp(200, body)
  end
end
