defmodule MarTest do
  use ExUnit.Case
  doctest Mar

  test "greets the world" do
    assert Mar.hello() == :world
  end
end
