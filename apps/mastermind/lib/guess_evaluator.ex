defmodule Mastermind.GuessEvaluator do
  @moduledoc """
  Create a "code" using 4 colored pegs
  Player guesses the colors and positions

  Each white peg means that one of the guessed pegs is correct but is in the wrong hole.
  Each black peg means that one of the guessed pegs is correct and is in the right hole.
  The order of the white and black pegs does not matter.

  pegs colors: green, red, blue, yellow, purple, orange
  """

  @doc """
  Accepts a guess and a code of color atoms.

  Returns `[:solved]` if the guess and the code are the same
  Otherwise returns the hint pegs, shuffled, as a list of atoms
  """
  def guess(%{guess: guess, code: code}) when guess == code do
    {:ok, "solved"}
  end

  def guess(%{guess: guess, code: code}) do
    hints =
    set_hints(guess, code)
    |> Enum.shuffle

    {:ok, hints}
  end

  defp set_hints(guess, code) do
    set_hints(:black, guess, code) ++ set_hints(:white, guess, code)
  end

  defp set_hints(:black, guess, code) do
    Enum.zip(guess, code)
    |> Enum.filter(fn(pegs) -> elem(pegs, 0) == elem(pegs, 1) end)
    |> Enum.reduce([], fn(_, hints) -> [:black | hints] end)
  end

  defp set_hints(:white, guess, code) do
    Enum.zip(guess, code)
    |> Enum.filter(fn(pegs) -> elem(pegs, 0) != elem(pegs, 1) end)
    |> Enum.unzip
    |> set_white_hints
  end

  defp set_white_hints({guess, code}) do
    compile_white_hints({guess, code, 0})
  end

  defp compile_white_hints({[], _, match_count}) do
    List.duplicate(:white, match_count)
  end

  defp compile_white_hints({ [guess|guesses], code, match_count }) do
    case Enum.member?(code, guess) do
      :true -> increment_match_count(code, guess, guesses, match_count)
               |> compile_white_hints
          _ -> compile_white_hints({guesses, code, match_count})
    end
  end

  defp increment_match_count(code, guess, guesses, match_count) do
    {guesses, List.delete(code, guess), match_count + 1}
  end
end
