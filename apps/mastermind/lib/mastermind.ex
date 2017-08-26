defmodule Mastermind do
  alias Mastermind.GuessEvaluator

  def start(game_length \\ 10) do
    code = Mastermind.CreateCode.new
    run(%{code: code, turns: []}, game_length)
  end

  def run(%{code: code, turns: turns}, game_length) do

    display_prior_turns(turns)
    check_game_over(turns, code, game_length)

    guess = get_player_guess()

    case GuessEvaluator.guess(%{guess: guess, code: code}) do
      {:ok, "solved"} -> "Winner"
      {:ok,     hint} -> run(%{code: code, turns: [%{hint: hint, guess: guess} | turns]}, game_length)
      {:error,   msg} -> "Error: #{msg}"
    end
  end

  def check_game_over(turns, code, game_length) do
    if Enum.count(turns) == game_length do
      IO.puts "========================"
      IO.puts "Game Over. The code was:"
      Enum.join(code, " ") |> IO.puts

      Process.exit(self(), :normal)
    end
  end

  def display_prior_turns(turns) do
    turns
    |> Enum.reverse
    |> Enum.each(fn(turn) -> print_prior_turn(turn) end)
  end

  def print_prior_turn(turn) do
    Enum.join(turn.guess, " ") <> " | " <> Enum.join(turn.hint, "/")
    |> IO.puts
  end

  def get_player_guess do
    IO.gets("Your guess: ")
    |> String.split
    |> Enum.map(fn(x) -> String.to_atom(x) end)
  end
end

