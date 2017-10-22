defmodule MastermindGenTest do
  use ExUnit.Case, async: true

  test "a game can start" do
    {:ok, game} = MastermindGen.start()

    assert is_pid(game)
  end

  test "sets a code at game start" do
    {:ok, game} = MastermindGen.start()

    code = MastermindGen.code(game)
    refute Enum.empty?(code)
  end

  test "allows a specific code to be set at game start" do
    {:ok, game} = MastermindGen.start([:x, :x, :x, :x])

    code = MastermindGen.code(game)

    assert code == [:x, :x, :x, :x]
  end

  test "creates a random code if the code passed in is not a list" do
    {:ok, game} = MastermindGen.start({:x, :x, :x, :x})

    code = MastermindGen.code(game)

    refute code == [:x, :x, :x, :x]
  end

  test "returns a solved status when the guess is correct" do
    {:ok, game} = MastermindGen.start()

    guess  = MastermindGen.code(game)
    status = MastermindGen.guess(game, guess)

    assert status == "Solved"
  end

  test "returns 'unsolved' status when the guess is not correct" do
    {:ok, game} = MastermindGen.start()

    status = MastermindGen.guess(game, [:x, :x, :x, :x])

    assert status == "Unsolved"
  end

  test "Turn history starts empty" do
    {:ok, game} = MastermindGen.start()

    hints = MastermindGen.turns(game)

    assert hints == []
  end

  test "History accumulates each turn" do
    {:ok, game} = MastermindGen.start()

    MastermindGen.guess(game, [:x, :x, :x, :x])
    turns = MastermindGen.turns(game)

    assert turns == [%{guess: [:x, :x, :x, :x], hint: []}]

    MastermindGen.guess(game, [:y, :x, :z, :x])

    turns = MastermindGen.turns(game)

    assert turns == [%{guess: [:y, :x, :z, :x], hint: []},
                     %{guess: [:x, :x, :x, :x], hint: []}
                    ]
  end

  test "hints have only white pegs when colors are correct, position is not" do
    {:ok, game} = MastermindGen.start([:blue,   :green, :red,  :blue])
    MastermindGen.guess(game,         [:orange, :blue,  :blue, :pink])

    turns = MastermindGen.turns(game)

    assert List.first(turns).hint == [:white, :white]
  end

  test "hints have only black pegs when positions are correct" do
    {:ok, game} = MastermindGen.start([:blue, :green,  :red, :blue])
    MastermindGen.guess(game,         [:blue, :orange, :red, :pink])

    turns = MastermindGen.turns(game)

    assert List.first(turns).hint == [:black, :black]
  end

  test "hints can have both black and white pegs" do
    {:ok, game} = MastermindGen.start([:blue, :green,  :red, :blue])
    MastermindGen.guess(game,         [:blue, :orange, :red, :green])

    turns = MastermindGen.turns(game)

    assert List.first(turns).hint == [:black, :black, :white]
  end

  test "guessing a color twice when it only appears once in the code should
        only return one hint" do
    {:ok, game} = MastermindGen.start([:blue, :orange, :red,    :pink])
    MastermindGen.guess(game,         [:blue, :blue,  :orange, :orange])

    turns = MastermindGen.turns(game)

    assert List.first(turns).hint == [:black, :white]
  end
end
