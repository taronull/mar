defprotocol Mar.Route do
  @moduledoc """
  `Mar.Route` protocol lets you access `Plug.Conn`.

  ```elixir
  defmodule MyApp do
    # ...

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
  end

  ```
  """
  @spec before_action(t()) :: t()
  def before_action(route)

  @spec after_action(t()) :: t()
  def after_action(route)
end

defimpl Mar.Route, for: Any do
  def before_action(route), do: route
  def after_action(route), do: route
end
