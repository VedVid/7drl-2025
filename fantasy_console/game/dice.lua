require "api"


local dice = {}

dice.last_results = {}
dice.last_results_die = nil

dice.green = {}
dice.green.sides = {
  -- current side, other sides
  {1, {2, 3, 4, 5}},
  {2, {1, 3, 4, 6}},
  {3, {1, 2, 5, 6}},
  {4, {1, 2, 5, 6}},
  {5, {1, 3, 4, 6}},
  {6, {2, 3, 4, 5}}
}
dice.green.probabilities = {
  -- previous side, next side
  {1, 6},
  {2, 5},
  {3, 4},
  {4, 3},
  {5, 2},
  {6, 1}
}
dice.green.sprites = {
  { --1
    {11, 12},
    {41, 42}
  },
  { --2
    {9, 10},
    {39, 40}
  },
  { --3
    {7, 8},
    {37, 38}
  },
  { --4
    {5, 6},
    {35, 36}
  },
  { --5
    {3, 4},
    {33, 34},
  },
  { --6
    {1, 2},
    {31, 32}
  },
  { --6 success marked
    {13, 14},
    {43, 44}
  }
}

function dice.update_last_results(rolls, current_side, die)
  dice.zero_last_results()
  for _, roll in ipairs(rolls) do
    dice.add_to_last_results(roll[current_side], die)
  end
end

function dice.zero_last_results()
  dice.last_results = {}
  dice.last_results_die = nil
end

function dice.add_to_last_results(side, die)
  table.insert(dice.last_results, side)
  dice.last_results_die = die
end

function dice.generate_rolls(dice_amount, die, roll_length)
  assert(dice_amount ~= nil, "dice_amount can't be nil")
  assert(dice_amount > 0, "dice_amount must be larger than 0")
  if not die then die = dice.green end
  if not roll_length then roll_length = math.random(3, 6) end
  local rolls = {}
  for i = 1, dice_amount do
    local rolls_sequence = {}
    local j = 0
    while (roll_length > j) do
      table.insert(rolls_sequence, dice.generate_roll(die))
      j = j + 1
    end
    table.insert(rolls, rolls_sequence)
    --print(table.concat(rolls_sequence, ", "))
  end
  return rolls
end

function dice.generate_roll(die)
  local current_side = math.random(1, 6)
  local previous_side = die.probabilities[current_side][2]
  local next_side = die.sides[current_side][2][math.random(4)]
  if next_side ~= die.probabilities[previous_side][2] then
    next_side = die.sides[current_side][2][math.random(4)]
  end
  return next_side
end

function dice.draw(x, y, die, side)
  Spr(x, y, die.sprites[side][1][1])
  Spr(x+8, y, die.sprites[side][1][2])
  Spr(x, y+8, die.sprites[side][2][1])
  Spr(x+8, y+8, die.sprites[side][2][2])
end

return dice
