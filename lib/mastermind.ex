defmodule Mastermind do
  def start do
    code = Mastermind.CreateCode.new
    run(%{code: code, turns: []})
  end

  def run(%{code: code, turns: turns}) do
    turns
    |> Enum.reverse
    |> IO.inspect

    guess = get_player_guess()

    case Mastermind.GuessEvaluator.guess(%{guess: guess, code: code}) do
      [:solved] -> "Winner"
      hint      -> run(%{code: code,
                         turns: [%{hint: hint, guess: guess} | turns]})
    end
  end

  def get_player_guess do
    IO.gets("Your guess: ")
    |> String.split
    |> Enum.map(fn(x) -> String.to_atom(x) end)
  end
end

