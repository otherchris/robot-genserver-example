defmodule Robot.ServerTest do

  use ExUnit.Case, async: true

  setup do
    robot = start_supervised!(Robot.Server)
    %{robot: robot}
  end

  describe "robot motion" do

    test "walk forward", %{robot: robot} do
      GenServer.call(robot, :forward)
      new_state = GenServer.call(robot, :report)

      assert new_state.location == {0,1}
    end

    test "turn left", %{robot: robot} do
      GenServer.call(robot, :turn_left)
      new_state = GenServer.call(robot, :report)

      assert new_state.direction == :left

      GenServer.call(robot, :turn_left)
      new_state = GenServer.call(robot, :report)

      assert new_state.direction == :down

      GenServer.call(robot, :forward)
      new_state = GenServer.call(robot, :report)

      assert new_state.location == {0, -1}
    end
  end

end
