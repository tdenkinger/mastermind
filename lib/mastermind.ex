defmodule Mastermind do
  def start do
    code = Mastermind.CreateCode.new
    IO.inspect code
    run(%{code: code, turns: []})
  end

  def run(%{code: code, turns: turns}) do
    display_prior_turns(turns)
    guess = get_player_guess()

    case Mastermind.GuessEvaluator.guess(%{guess: guess, code: code}) do
      {:ok, "solved"} -> "Winner"
      {:ok,     hint} -> run(%{code: code, turns: [%{hint: hint, guess: guess} | turns]})
      {:error,   msg} -> "Error: #{msg}"
    end
  end

  def display_prior_turns(turns) do
    turns
    |> Enum.reverse
    |> Enum.each(fn(turn) -> print_prior_guess(turn) end)
  end

  def print_prior_guess(turn) do
    Enum.join(turn.guess, " ") <> " | " <> Enum.join(turn.hint, "/")
    |> IO.puts
  end

  def get_player_guess do
    IO.gets("Your guess: ")
    |> String.split
    |> Enum.map(fn(x) -> String.to_atom(x) end)
  end
end

