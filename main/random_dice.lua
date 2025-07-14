-- random_dice.lua
-- Simple LCG-based integer random number generator with dice helpers
--
-- RandomDice.randomseed(s)
--   Set Seed
--
-- RandomDice.random(...)
--   tbl : random element from the table `tbl`
--   a   : random from 1 to a
--   b, c: random from b to c


local RandomDice = {}

-- LCG constants from Numerical Recipes
local a = 1664525
local c = 1013904223
local m = 2^32

-- default seed
local seed = 1

--- Set the internal seed for the generator
-- @param s number New seed value
function RandomDice.randomseed(s)
    seed = (tonumber(s) or 0) % m
end

local function next_value()
    seed = (a * seed + c) % m
    return seed
end

--- Generate a random integer
-- Behaves similarly to `math.random` but uses an LCG.
-- * `random()`        -> integer in the range [0, m-1]
-- * `random(upper)`   -> integer in the range [1, upper]
-- * `random(lower, upper)` -> integer in [lower, upper]
-- * `random(tbl)`    -> random element from array-like table `tbl`
function RandomDice.random(...)
    local n = select('#', ...)
    if n == 0 then
        return next_value()
    elseif n == 1 then
        local arg1 = ...
        if type(arg1) == 'table' then
            assert(#arg1 > 0, 'table must not be empty')
            return arg1[RandomDice.random(#arg1)]
        else
            local value = next_value()
            local upper = arg1
            assert(type(upper) == 'number' and upper >= 1, 'upper must be >= 1')
            return value % upper + 1
        end
    elseif n == 2 then
        local lower, upper = ...
        assert(type(lower) == 'number' and type(upper) == 'number' and lower <= upper,
            'lower must be <= upper')
        local value = next_value()
        return value % (upper - lower + 1) + lower
    else
        error('invalid arguments to random')
    end
end

--- Roll a dice with the specified number of sides
-- @param sides number Number of sides
-- @return number Random integer between 1 and `sides`
function RandomDice.dice(sides)
    return RandomDice.random(sides)
end

--- Get a random integer between `min` and `max` inclusive
-- @param min number Lower bound
-- @param max number Upper bound
-- @return number Random integer between `min` and `max`
function RandomDice.random_between(min, max)
    return RandomDice.random(min, max)
end

return RandomDice

