defmodule FigletTest do
  use ExUnit.Case
  doctest Figlet

  test "greets the world" do
    assert Figlet.hello() == :world
  end
end
