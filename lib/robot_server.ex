defmodule Robot.Server do
  @moduledoc false

  use GenServer

  def init(initial) do
    state = %{
      location: {0,0},
      direction: :up
    }
    {:ok, state}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def handle_call(:report, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:forward, state) do
    new_state =
      state
      |> Map.put(:location, stepper(state.direction, state.location))
    {:noreply, new_state}
  end

  def handle_call(:turn_left, _from, state) do
    new_state =
      state
      |> Map.put(:direction, left_turn(state.direction))

    {:reply, new_state, new_state}
  end

  def handle_cast(:marathon, state) do
    1..10000000
    |> Enum.each(fn(_) -> GenServer.cast(self(), :forward) end)

    IO.inspect "DONE!"
    {:noreply, state}
  end

  defp left_turn(direction) do
    case direction do
      :up -> :left
      :left -> :down
      :down -> :right
      :right -> :up
    end
  end

  defp stepper(direction, location = {x, y}) do
    case direction do
      :up -> {x, y + 1}
      :left -> {x - 1, y}
      :down -> {x, y - 1}
      :right -> {x + 1, y}
    end
  end

end
