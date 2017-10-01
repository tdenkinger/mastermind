defmodule MastermindGenTest do
  use ExUnit.Case

  setup do
    {:ok, game} = MastermindGen.start()
    {:ok, game: game}
  end

  test "a game can start", %{game: game} do
    assert is_pid(game)
  end

  test "sets a code at game start", %{game: game} do
    code = MastermindGen.code(game)
    refute Enum.empty?(code)
  end
end
