defmodule MastermindGenTest do
  use ExUnit.Case
  doctest MastermindGen

  test "greets the world" do
    assert MastermindGen.hello() == :world
  end
end
