defmodule AppelixirTest do
  use ExUnit.Case
  doctest Appelixir

  test "greets the world" do
    assert Appelixir.hello() == :world
  end
end
