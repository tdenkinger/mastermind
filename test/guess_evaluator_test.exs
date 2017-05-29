defmodule GuessEvaluatorTest do
  use ExUnit.Case
  doctest Mastermind.GuessEvaluator

  alias Mastermind.GuessEvaluator

  test "declares a winner when guess and code match" do
    result = GuessEvaluator.guess(%{guess: [:red, :red, :red, :red],
                                    code:  [:red, :red, :red, :red]})

    assert result == [:solved]
  end

  test "hints are empty when there are no correct guesses" do
    result = GuessEvaluator.guess(%{guess: [:red, :red,  :blue,  :blue],
                                    code:  [:green, :green, :orange, :orange]})

    assert result == []
  end

  test "hints have only white pegs when colors are correct, position is not" do
    result = GuessEvaluator.guess(%{guess: [:red, :red,  :blue,  :blue],
                                code:  [:green, :green, :red, :red]})

    assert result == [:white, :white]
  end

  test "hints have only black pegs when positions are correct" do
    result = GuessEvaluator.guess(%{guess: [:red, :red, :blue, :blue],
                                code:  [:red, :red, :red, :blue]})

    assert result == [:black, :black, :black]
  end

  test "hints can have both black and white pegs" do
    result = GuessEvaluator.guess(%{guess: [:red, :red,  :blue,  :purple],
                                code:  [:red, :blue, :green, :purple]})

    assert Enum.sort(result) == [:black, :black, :white]
  end
end
