require "api"


local dice = {}

dice.last_results = {}
dice.last_results_die = nil

dice.sides = {
  -- current side, other sides
  {1, {2, 3, 4, 5}},
  {2, {1, 3, 4, 6}},
  {3, {1, 2, 5, 6}},
  {4, {1, 2, 5, 6}},
  {5, {1, 3, 4, 6}},
  {6, {2, 3, 4, 5}}
}

dice.probabilities = {
  -- previous side, next side
  {1, 6},
  {2, 5},
  {3, 4},
  {4, 3},
  {5, 2},
  {6, 1}
}

function dice.zero_last_results()
  dice.last_results = {}
  dice.last_results_die = nil
end

function dice.add_to_last_results(side, die)
  table.insert(dice.last_results, side)
  dice.last_results_die = die
end

function dice.generate_rolls(roll_length)
  if not roll_length then roll_length = math.random(3, 6) end
  local rolls_sequence = {}
  while (roll_length > 0) do
    table.insert(rolls_sequence, dice.generate_roll())
    roll_length = roll_length - 1
  end
  print(table.concat(rolls_sequence, ", "))
  return rolls_sequence
end

function dice.generate_roll()
  local current_side = math.random(1, 6)
  local previous_side = dice.probabilities[current_side][2]
  local next_side = dice.sides[current_side][2][math.random(4)]
  if next_side ~= dice.probabilities[previous_side][2] then
    next_side = dice.sides[current_side][2][math.random(4)]
  end
  return next_side
end

dice.green = {
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
  }
}

function dice.draw(x, y, die, side)
  Spr(x, y, die[side][1][1])
  Spr(x+8, y, die[side][1][2])
  Spr(x, y+8, die[side][2][1])
  Spr(x+8, y+8, die[side][2][2])
end

return dice