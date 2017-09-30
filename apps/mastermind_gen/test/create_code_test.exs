defmodule CreateCodeGen do
  use ExUnit.Case
  doctest MastermindGen.CreateCode

  alias MastermindGen.CreateCode

  test "creates a code" do
    code = CreateCode.new(4)
    assert Enum.count(code) == 4
  end
end
