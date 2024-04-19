defmodule Mar do
  @moduledoc """
  Documentation for `Mar`.
  """

  @callback get() :: any()
  @callback post() :: any()

  defmacro __using__(options) do
    quote do
      @behaviour unquote(__MODULE__)

      defimpl Mar.Route do
        # __MODULE__ => Mar.Route.MyApp.MyModule
        def path(struct) do
          # TODO: One is compile-time, the other is runtime. Fix it.
          unquote(options[:path])
        end
      end
    end
  end

  def child_spec(options) do
    options = Keyword.put(options, :plug, Mar.Plug)

    %{
      id: __MODULE__,
      start: {Bandit, :start_link, [options]}
    }
  end
end
