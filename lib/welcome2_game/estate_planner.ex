defmodule Welcome2Game.EstatePlanner do
  alias Welcome2Game.{State, Plan}

  def update(
        state = %State{
          plan1: plan1,
          plan1_used: plan1_used,
          plan2: plan2,
          plan2_used: plan2_used,
          plan3: plan3,
          plan3_used: plan3_used
        }
      ) do
    state
    |> apply_plan(plan1, plan1_used)
    |> apply_plan(plan2, plan2_used)
    |> apply_plan(plan3, plan3_used)
  end

  def apply_plan(state = %State{}, plan, used) do
    (!used && satisfy_plan?(state, plan) && with_plan(state, plan)) || state
  end

  def satisfy_plan?(%State{player: player}, %Plan{needs: needs}) do
    Enum.all?(
      for {size, needs_of_size} <- needs do
        needs_of_size <= Map.get(player, :"built_estates#{size}")
      end
    )
  end

  def with_plan(state, _plan) do
    state
  end
end
