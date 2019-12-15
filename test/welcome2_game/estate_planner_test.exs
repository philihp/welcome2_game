defmodule Welcome2Game.EstatePlannerTest do
  alias Welcome2Game.{EstatePlanner, State, Plan, Tableau}
  use ExUnit.Case

  describe "#satisfy_plan?" do
    test "satisfies positive" do
      state = %State{
        plan1: %Plan{
          needs: %{
            "3" => 3,
            "4" => 1
          }
        },
        player: %Tableau{
          built_estates1: 0,
          built_estates2: 0,
          built_estates3: 3,
          built_estates4: 1,
          built_estates5: 0,
          built_estates6: 0
        }
      }

      assert true == EstatePlanner.satisfy_plan?(state, state.plan1)
    end

    test "oversatifies" do
      state = %State{
        plan1: %Plan{
          needs: %{
            "1" => 2
          }
        },
        player: %Tableau{
          built_estates1: 4,
          built_estates2: 2,
          built_estates3: 3,
          built_estates4: 1,
          built_estates5: 0,
          built_estates6: 0
        }
      }

      assert true == EstatePlanner.satisfy_plan?(state, state.plan1)
    end

    test "unsatisfied" do
      state = %State{
        plan1: %Plan{
          needs: %{
            "3" => 3,
            "4" => 1
          }
        },
        player: %Tableau{
          built_estates1: 0,
          built_estates2: 0,
          built_estates3: 2,
          built_estates4: 1,
          built_estates5: 0,
          built_estates6: 0
        }
      }

      assert false == EstatePlanner.satisfy_plan?(state, state.plan1)
    end
  end
end
