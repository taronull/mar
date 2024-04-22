defmodule Mar.Router do
  @moduledoc false
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _options) do
    route = route(conn.request_path)
    path_params = fetch_path_params(route.path, conn.request_path)
    params = Map.merge(conn.params, path_params)
    conn = %{conn | path_params: path_params, params: params}
    route = %{route | params: load_params(route.params, params), action: load_action(conn.method)}

    route = %{route | conn: conn}
    route = Mar.Route.before_action(route)
    response = apply(route.__struct__, route.action, if_params(route.params))
    route = %{route | conn: respond(conn, response)}
    route = Mar.Route.after_action(route)

    send_resp(route.conn)
  end

  defp route(path) do
    {_hard_matches, routes} =
      list_routes()
      |> Stream.map(fn route -> {route, match_path(route.path, path)} end)
      |> Stream.filter(fn {_route, match} -> match && Enum.all?(match) end)
      |> Enum.group_by(fn {_route, match} -> Enum.count(match, &(&1 == :hard)) end)
      |> Enum.max()

    {route, _match} =
      Enum.max_by(routes, fn
        {_route, match} -> length(Enum.take_while(match, &(&1 == :hard)))
      end)

    route
  end

  defp list_routes do
    case Mar.Route.__protocol__(:impls) do
      {:consolidated, modules} -> Enum.map(modules, &struct(&1))
      :not_consolidated -> []
    end
  end

  defp match_path(route_path, path) do
    route_nodes = Path.split(route_path)
    nodes = Path.split(path)

    if length(route_nodes) == length(nodes) do
      Enum.zip_with(route_nodes, nodes, &match_node/2)
    end
  end

  defp match_node(route_node, node) do
    cond do
      route_node == node -> :hard
      String.starts_with?(route_node, ":") -> :soft
      true -> nil
    end
  end

  defp fetch_path_params(route_path, path) do
    route_path
    |> String.replace(~r/:(\w+)/, "(?<\\1>\\w+)")
    |> Regex.compile!()
    |> Regex.named_captures(path)
  end

  defp load_params(route_params, params) do
    route_params
    |> Enum.map(fn route_param ->
      value = params[Atom.to_string(route_param)]
      if value, do: {route_param, value}, else: nil
    end)
    |> Enum.filter(& &1)
    |> Enum.into(%{})
  end

  defp load_action(http_method) do
    String.downcase(http_method) |> String.to_atom()
  end

  defp respond(conn, body) when not is_tuple(body) and not is_nil(body) do
    conn
    |> put_resp_content_type(make_type(body))
    |> resp(200, make_body(body))
  end

  defp respond(conn, {status, headers, body}) when is_number(status) and is_list(headers) do
    conn = if body, do: put_resp_content_type(conn, make_type(body)), else: conn
    conn = resp(conn, status, make_body(body))

    Enum.reduce(headers, conn, &adapt_header/2)
  end

  defp make_type(body) when is_binary(body), do: "text/plain"
  defp make_type(body) when is_map(body), do: "application/json"

  defp make_body(body) when is_map(body), do: Jason.encode!(body)
  defp make_body(body) when is_nil(body), do: ""
  defp make_body(body), do: body

  defp adapt_header({key, value}, conn) do
    key = Atom.to_string(key) |> String.replace("_", "-")
    Plug.Conn.put_resp_header(conn, key, value)
  end

  defp if_params(params) when map_size(params) == 0, do: []
  defp if_params(params), do: [params]
end
