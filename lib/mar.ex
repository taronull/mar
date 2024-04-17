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

  defmacro __using__(_options) do
    quote do
      def hello do
        :world
      end
    end
  end
end
