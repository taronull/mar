defmodule Mar do
  @moduledoc """
  Documentation for `Mar`.
  """

  @callback get() :: any()
  @callback post() :: any()

  defmacro __using__(options) do
    quote do
      @behaviour unquote(__MODULE__)

      defimpl Mar.Router do
        # __MODULE__ => Mar.Router.MyApp.MyModule
        def route(struct) do
          # TODO: One is compile-time, the other is runtime. Fix it.
          unquote(options[:path]) || Mar.infer_path(struct.__struct__)
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

  def infer_path(module) do
    # MyApp => /myapp
    # This a temporary spec for demonstration purposes.
    module
    |> Module.split()
    |> List.last()
    |> String.downcase()
    |> Path.absname("/")
  end
end
