require "api"


local dice = {}

dice.last_results = {}

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

dice.red = {}
dice.red.sides = {
  -- current side, other sides
  {6, {2, 3, 4, 5}},
  {2, {6, 3, 4, 6}},
  {3, {6, 2, 5, 6}},
  {4, {6, 2, 5, 6}},
  {5, {6, 3, 4, 6}},
  {6, {2, 3, 4, 5}}
}
dice.red.probabilities = {
  -- previous side, next side
  {6, 6},
  {2, 5},
  {3, 4},
  {4, 3},
  {5, 2},
  {6, 6}
}
dice.red.sprites = {
  { --1=6
    {61, 62},
    {91, 92}
  },
  { --2
    {69, 70},
    {99, 100}
  },
  { --3
    {67, 68},
    {97, 98}
  },
  { --4
    {65, 66},
    {95, 96}
  },
  { --5
    {63, 64},
    {93, 94},
  },
  { --6
    {61, 62},
    {91, 92}
  },
  { --6 success marked
    {71, 72},
    {101, 102}
  }
}

dice.gold = {}
dice.gold.sides = {
  -- current side, other sides
  {1, {6, 6, 4, 5}},
  {6, {1, 6, 4, 6}},
  {6, {1, 6, 5, 6}},
  {4, {1, 6, 5, 6}},
  {5, {1, 6, 4, 6}},
  {6, {6, 6, 4, 5}}
}
dice.gold.probabilities = {
  -- previous side, next side
  {1, 6},
  {6, 5},
  {6, 4},
  {4, 6},
  {5, 6},
  {6, 1}
}
dice.gold.sprites = {
  { --1
    {127, 128},
    {157, 158}
  },
  { --2=6
    {121, 122},
    {151, 152}
  },
  { --3=6
    {121, 122},
    {151, 152}
  },
  { --4
    {125, 126},
    {155, 156}
  },
  { --5
    {123, 124},
    {153, 154},
  },
  { --6
    {121, 122},
    {151, 152}
  },
  { --6 success marked
    {129, 130},
    {159, 160}
  }
}

function dice.update_last_results(rolls, current_side)
  dice.zero_last_results()
  for _, roll in ipairs(rolls) do
    table.insert(dice.last_results, {roll[1], roll[2][current_side]})
  end
end

function dice.zero_last_results()
  dice.last_results = {}
end

function dice.add_to_last_results(side, die)
  table.insert(dice.last_results, {die, side})
end

function dice.generate_rolls(dices, roll_length)
  assert(dices ~= nil, "dices can't be nil")
  assert(#dices > 0, "dices array must be longer than 0")
  if not roll_length then roll_length = math.random(3, 6) end
  local rolls = {}
  for _, die in ipairs(dices) do
    local rolls_sequence = {}
    local j = 0
    while (roll_length > j) do
      table.insert(rolls_sequence, dice.generate_roll(die))
      j = j + 1
    end
    table.insert(rolls, {die, rolls_sequence})
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

function dice.check_for_success()
  for i, roll in ipairs(Rolls) do
    if roll[#roll][1] == 6 then
      return true
    end
  end
  return false
end

function dice.draw(x, y, die, side)
  Spr(x, y, die.sprites[side][1][1])
  Spr(x+8, y, die.sprites[side][1][2])
  Spr(x, y+8, die.sprites[side][2][1])
  Spr(x+8, y+8, die.sprites[side][2][2])
end

return dice
