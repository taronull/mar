defmodule Mar do
  @moduledoc """
  Documentation for `Mar`.
  """
  def child_spec(options) do
    options = Keyword.put(options, :plug, Mar.Plug)

    %{
      id: __MODULE__,
      start: {Bandit, :start_link, [options]}
    }
  end

  defmacro __using__(options) do
    path = Keyword.get(options, :path, "/")
    params = parse_path_params(path) ++ Keyword.get(options, :params, [])

    quote do
      @derive [Mar.Route]
      defstruct path: unquote(path),
                params: unquote(params),
                conn: %Plug.Conn{}
    end
  end

  defp parse_path_params(path) do
    Regex.scan(~r/:(\w+)/, path, capture: :all_but_first)
    |> Enum.map(fn matches -> List.first(matches) |> String.to_atom() end)
  end
end
