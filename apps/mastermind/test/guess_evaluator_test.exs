defmodule GuessEvaluatorTest do
  use ExUnit.Case
  doctest Mastermind.GuessEvaluator

  alias Mastermind.GuessEvaluator

  test "declares a winner when guess and code match" do
    {:ok, result} = GuessEvaluator.guess(%{guess: [:red, :red, :red, :red],
                                    code:  [:red, :red, :red, :red]})

    assert result == "solved"
  end

  test "hints are empty when there are no correct guesses" do
    {:ok, result} = GuessEvaluator.guess(%{guess: [:red, :red,  :blue,  :blue],
                                           code:  [:green, :green, :orange, :orange]})

    assert result == []
  end

  test "hints have only white pegs when colors are correct, position is not" do
    {:ok, result} = GuessEvaluator.guess(%{guess: [:red, :red,  :blue,  :blue],
                                           code:  [:green, :green, :red, :red]})

    assert result == [:white, :white]
  end

  test "hints have only black pegs when positions are correct" do
    {:ok, result} = GuessEvaluator.guess(%{guess: [:red, :red, :blue, :blue],
                                           code:  [:red, :red, :red, :blue]})

    assert result == [:black, :black, :black]
  end

  test "hints can have both black and white pegs" do
    {:ok, result} = GuessEvaluator.guess(%{guess: [:red, :red,  :blue,  :purple],
                                           code:  [:red, :blue, :green, :purple]})

    assert Enum.sort(result) == [:black, :black, :white]
  end

  test "guessing a color twice when it only appears once in the code should
        only return one hint" do
    {:ok, result} = GuessEvaluator.guess(%{guess: [:red, :blue, :green, :green],
                                           code:  [:green, :blue, :blue, :red]})

    assert Enum.sort(result) == [:black, :white, :white]
  end

end
