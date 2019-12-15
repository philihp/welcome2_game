defmodule Welcome2Game.EstatePlanner do
  alias Welcome2Game.{State, Plan, Tableau}

  @houses_per_row %{
    a: 10,
    b: 11,
    c: 12
  }

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
    |> maybe_apply_plan(plan1, plan1_used)
    |> maybe_apply_plan(plan2, plan2_used)
    |> maybe_apply_plan(plan3, plan3_used)
  end

  def maybe_apply_plan(state = %State{}, plan, used) do
    (!used && satisfy_plan?(state, plan) && with_plan(state, plan)) || state
  end

  def satisfy_plan?(%State{player: player}, %Plan{needs: needs}) do
    Enum.all?(
      for {size, needs_of_size} <- needs do
        needs_of_size <= Map.get(player, :"built_estates#{size}")
      end
    )
  end

  def with_plan(state, plan) do
    Enum.reduce(plan_needs(plan), state, fn blocksize, state ->
      {row, index} = first_estate_at(state, blocksize)
      block_off(state, blocksize, row, index)
    end)
  end

  def plan_needs(%Plan{needs: needs}) do
    for {size, amount} <- needs do
      for _ <- 1..amount do
        size
      end
    end
    |> List.flatten()
    |> Enum.reverse()
  end

  def first_estate_at(state, blocksize) do
    first_estate_in(state, blocksize, :a) ||
      first_estate_in(state, blocksize, :b) ||
      first_estate_in(state, blocksize, :c)
  end

  def first_estate_in(state, blocksize, row) do
    found =
      Enum.find(1..@houses_per_row[row], nil, fn index ->
        estate_exists_at({row, index}, state, blocksize)
      end)

    found && {row, found}
  end

  def estate_exists_at({row, index}, %State{player: player}, 1) do
    Enum.all?([
      Map.get(player, :"fence#{row}#{index - 1}", true),
      Map.get(player, :"row#{row}#{index}number", nil) !== nil,
      Map.get(player, :"row#{row}#{index}plan", true) === false,
      Map.get(player, :"fence#{row}#{index}", true)
    ])
  end

  def estate_exists_at({row, index}, %State{player: player}, blocksize) do
    Enum.all?(
      [
        # left fence built
        Map.get(player, :"fence#{row}#{index - 1}", true),
        # right fence built
        Map.get(player, :"fence#{row}#{index - 1 + blocksize}", true)
      ] ++
        for offset <- 0..(blocksize - 1) do
          Map.get(player, :"row#{row}#{index + offset}number", nil) !== nil &&
            Map.get(player, :"row#{row}#{index + offset}plan", true) !== true
        end ++
        for offset <- 0..(blocksize - 2) do
          Map.get(player, :"fence#{row}#{index + offset}", true) === false
        end
    )
  end

  def block_off(state, blocksize, row, index) do
    Enum.reduce(0..(blocksize - 1), state, fn offset, state ->
      %State{state | player: struct(state.player, %{:"row#{row}#{index + offset}plan" => true})}
    end)
  end
end