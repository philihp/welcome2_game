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

  describe "#plan_needs" do
    test "returns empty array" do
      result = EstatePlanner.plan_needs(%Plan{needs: %{}})
      assert result == []
    end

    test "returns an array of estate sizes to find" do
      result = EstatePlanner.plan_needs(%Plan{needs: %{4 => 3, 3 => 2, 2 => 1}})
      assert result == [4, 4, 4, 3, 3, 2]
    end

    test "plan of just one type" do
      result = EstatePlanner.plan_needs(%Plan{needs: %{3 => 3}})
      assert result == [3, 3, 3]
    end
  end

  describe "#first_estate_at" do
    test "find the first available estate" do
      player = %Tableau{
        rowa1number: 1,
        rowa2number: 2,
        rowa3number: 3,
        rowa4number: 4,
        fencea4: true,
        rowa5number: 5,
        rowa6number: 6,
        rowa7number: 7,
        fencea7: true,
        rowa8number: 8,
        rowa9number: 9,
        rowa10number: 10
      }

      assert EstatePlanner.first_estate_at(%State{player: player}, 1) == nil
      assert EstatePlanner.first_estate_at(%State{player: player}, 2) == nil
      assert EstatePlanner.first_estate_at(%State{player: player}, 3) == {:a, 5}
      assert EstatePlanner.first_estate_at(%State{player: player}, 4) == {:a, 1}
      assert EstatePlanner.first_estate_at(%State{player: player}, 5) == nil
      assert EstatePlanner.first_estate_at(%State{player: player}, 6) == nil
    end
  end

  describe "#estate_exists_at" do
    test "a few found" do
      player = %Tableau{
        rowa1number: 1,
        rowa2number: 2,
        rowa3number: 3,
        rowa4number: 4,
        fencea4: true,
        rowa5number: 5,
        rowa6number: 6,
        rowa7number: 7,
        fencea7: true,
        rowa8number: 8,
        rowa9number: 9,
        rowa10number: 10
      }

      assert EstatePlanner.estate_exists_at({:a, 1}, %State{player: player}, 3) == false
      assert EstatePlanner.estate_exists_at({:a, 2}, %State{player: player}, 3) == false
      assert EstatePlanner.estate_exists_at({:a, 3}, %State{player: player}, 3) == false
      assert EstatePlanner.estate_exists_at({:a, 4}, %State{player: player}, 3) == false
      assert EstatePlanner.estate_exists_at({:a, 5}, %State{player: player}, 3) == true
      assert EstatePlanner.estate_exists_at({:a, 6}, %State{player: player}, 3) == false
      assert EstatePlanner.estate_exists_at({:a, 7}, %State{player: player}, 3) == false
      assert EstatePlanner.estate_exists_at({:a, 8}, %State{player: player}, 3) == true
      assert EstatePlanner.estate_exists_at({:a, 9}, %State{player: player}, 3) == false
      assert EstatePlanner.estate_exists_at({:a, 10}, %State{player: player}, 3) == false
    end

    test "none found of too big" do
      player = %Tableau{
        rowa1number: 1,
        rowa2number: 2,
        rowa3number: 3,
        rowa4number: 4,
        fencea4: true,
        rowa5number: 5,
        rowa6number: 6,
        rowa7number: 7,
        fencea7: true,
        rowa8number: 8,
        rowa9number: 9,
        rowa10number: 10
      }

      assert EstatePlanner.estate_exists_at({:a, 1}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 2}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 3}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 4}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 5}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 6}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 7}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 8}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 9}, %State{player: player}, 5) == false
      assert EstatePlanner.estate_exists_at({:a, 10}, %State{player: player}, 5) == false
    end
  end

  describe "#block_off" do
    test "blocks off a set of slots" do
      state = EstatePlanner.block_off(%State{player: %Tableau{}}, 3, :b, 5)

      assert state.player.rowb4plan == false
      assert state.player.rowb5plan == true
      assert state.player.rowb6plan == true
      assert state.player.rowb7plan == true
      assert state.player.rowb8plan == false
    end
  end
end
