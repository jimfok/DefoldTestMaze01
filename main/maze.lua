-- maze.lua
-- Provides functions to create a base grid and generate a maze

local Maze = {}

-- Create a new maze object
-- width, height: dimensions of the maze to generate
-- base_width, base_height: dimensions of the underlying grid
function Maze.new(width, height, base_width, base_height)
    base_width = base_width or width
    base_height = base_height or height
    assert(width < base_width, "width must be less than base width")
    assert(height < base_height, "height must be less than base height")
    local grid = {}
    for y = 1, base_height do
        grid[y] = {}
        for x = 1, base_width do
            grid[y][x] = {
                block_top = true,
                block_left = true,
                disable_clear_wall = false
            }
        end
    end
    local self = {
        width = width,
        height = height,
        base_width = base_width,
        base_height = base_height,
        grid = grid
    }
    return setmetatable(self, { __index = Maze })
end

-- Helper to check bounds
local function in_bounds(x, y, w, h)
    return x >= 1 and x <= w and y >= 1 and y <= h
end

-- Carve the maze using a depth-first search (recursive backtracker)
function Maze:generate()
    local visited = {}
    for y = 1, self.height do
        visited[y] = {}
        for x = 1, self.width do
            if self:CheckDisableClearWall(x, y) then
                visited[y][x] = true
            end
        end
    end

    local stack = {}
    table.insert(stack, { x = 1, y = 1 })
    visited[1][1] = true

    local function neighbors(x, y)
        local list = {}
        if self:CheckDisableClearWall(x, y) then
            return list
        end
        if in_bounds(x, y - 1, self.width, self.height)
            and not visited[y - 1][x]
            and not self:CheckDisableClearWall(x, y - 1) then
            table.insert(list, { x = x, y = y - 1, dir = "up" })
        end
        if in_bounds(x - 1, y, self.width, self.height)
            and not visited[y][x - 1]
            and not self:CheckDisableClearWall(x - 1, y) then
            table.insert(list, { x = x - 1, y = y, dir = "left" })
        end
        if in_bounds(x + 1, y, self.width, self.height)
            and not visited[y][x + 1]
            and not self:CheckDisableClearWall(x + 1, y) then
            table.insert(list, { x = x + 1, y = y, dir = "right" })
        end
        if in_bounds(x, y + 1, self.width, self.height)
            and not visited[y + 1][x]
            and not self:CheckDisableClearWall(x, y + 1) then
            table.insert(list, { x = x, y = y + 1, dir = "down" })
        end
        return list
    end

    math.randomseed(os.time())
    while #stack > 0 do
        local current = stack[#stack]
        local nbs = neighbors(current.x, current.y)
        if #nbs > 0 then
            local next = nbs[math.random(#nbs)]
            if not self:CheckDisableClearWall(current.x, current.y)
                and not self:CheckDisableClearWall(next.x, next.y) then
                -- remove wall between current and next
                if next.dir == "up" then
                    self.grid[current.y][current.x].block_top = false
                elseif next.dir == "left" then
                    self.grid[current.y][current.x].block_left = false
                elseif next.dir == "right" then
                    self.grid[current.y][current.x + 1].block_left = false
                elseif next.dir == "down" then
                    self.grid[current.y + 1][current.x].block_top = false
                end
            end
            visited[next.y][next.x] = true
            table.insert(stack, { x = next.x, y = next.y })
        else
            table.remove(stack)
        end
    end
end

--- Check if the wall above the given cell is blocked
-- @param x number
-- @param y number
-- @return boolean
function Maze:check_block_up(x, y)
    return self.grid[y] and self.grid[y][x] and self.grid[y][x].block_top
end

--- Check if the wall below the given cell is blocked
-- @param x number
-- @param y number
-- @return boolean
function Maze:check_block_down(x, y)
    return self.grid[y + 1] and self.grid[y + 1][x] and self.grid[y + 1][x].block_top
end

--- Check if the wall to the left of the given cell is blocked
-- @param x number
-- @param y number
-- @return boolean
function Maze:check_block_left(x, y)
    return self.grid[y] and self.grid[y][x] and self.grid[y][x].block_left
end

--- Check if the wall to the right of the given cell is blocked
-- @param x number
-- @param y number
-- @return boolean
function Maze:check_block_right(x, y)
    return self.grid[y] and self.grid[y][x + 1] and self.grid[y][x + 1].block_left
end

--- Check if clearing walls is disabled for the given cell
-- @param x number
-- @param y number
-- @return boolean
function Maze:CheckDisableClearWall(x, y)
    return self.grid[y] and self.grid[y][x] and self.grid[y][x].disable_clear_wall
end

--- Generic block check depending on direction
-- @param x number
-- @param y number
-- @param dir string Direction: "up", "down", "left", "right"
-- @return boolean
function Maze:check_block(x, y, dir)
    if dir == "up" then
        return self:check_block_up(x, y)
    elseif dir == "down" then
        return self:check_block_down(x, y)
    elseif dir == "left" then
        return self:check_block_left(x, y)
    elseif dir == "right" then
        return self:check_block_right(x, y)
    end
    return nil
end

--- Print a textual representation of the maze for debugging
function Maze:debug_print()
    local w, h = self.width, self.height
    -- draw initial top border
    local line = ""
    for x = 1, w do
        line = line .. "+" .. (self.grid[1][x].block_top and "--" or "  ")
    end
    print(line .. "+")

    for y = 1, h do
        local middle = ""
        local next_top = ""
        for x = 1, w do
            -- left wall of cell
            middle = middle .. (self.grid[y][x].block_left and "|  " or "   ")
            -- bottom wall uses next row's top flag when available
            local bottom = true
            if self.grid[y + 1] and self.grid[y + 1][x] then
                bottom = self.grid[y + 1][x].block_top
            end
            next_top = next_top .. "+" .. (bottom and "--" or "  ")
        end
        print(middle .. "|")
        print(next_top .. "+")
    end
end

return Maze

