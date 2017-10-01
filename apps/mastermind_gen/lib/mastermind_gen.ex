defmodule MastermindGen do
  use GenServer

  # Public API

  def start do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def code(pid) do
    GenServer.call(pid, :code)
  end

  # Private Callbacks

  def init(:ok) do
    {:ok, %{code: MastermindGen.CreateCode.new}}
  end

  def handle_call(:code, _from, %{code: code}) do
    {:reply, code, code}
  end


end
