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
        -- up and left first bcos exist of demo pattern
        if in_bounds(x, y - 1, self.width, self.height)
            and not visited[y - 1][x]
            -- already mark visited
            -- and not self:CheckDisableClearWall(x, y - 1)
               then
            table.insert(list, { x = x, y = y - 1, dir = "up" })
        end
        if in_bounds(x - 1, y, self.width, self.height)
            and not visited[y][x - 1]
            -- and not self:CheckDisableClearWall(x - 1, y) 
                then
            table.insert(list, { x = x - 1, y = y, dir = "left" })
        end
        if in_bounds(x + 1, y, self.width, self.height)
            and not visited[y][x + 1]
            -- and not self:CheckDisableClearWall(x + 1, y) 
                then
            table.insert(list, { x = x + 1, y = y, dir = "right" })
        end
        if in_bounds(x, y + 1, self.width, self.height)
            and not visited[y + 1][x]
            -- and not self:CheckDisableClearWall(x, y + 1) 
                then
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
            assert(not self:CheckDisableClearWall(next.x, next.y),
                string.format("Attempting to carve into disabled cell %d,%d",
                    next.x, next.y))
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
            -- debug print path
            print("pp: " .. next.x .. "," .. next.y)
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

--- Clear the wall above the given cell
-- @param x number
-- @param y number
function Maze:clear_block_up(x, y)
    if self.grid[y] and self.grid[y][x] then
        self.grid[y][x].block_top = false
    end
end

--- Check if the wall below the given cell is blocked
-- @param x number
-- @param y number
-- @return boolean
function Maze:check_block_down(x, y)
    return self.grid[y + 1] and self.grid[y + 1][x] and self.grid[y + 1][x].block_top
end

--- Clear the wall below the given cell
-- @param x number
-- @param y number
function Maze:clear_block_down(x, y)
    if self.grid[y + 1] and self.grid[y + 1][x] then
        self.grid[y + 1][x].block_top = false
    end
end

--- Check if the wall to the left of the given cell is blocked
-- @param x number
-- @param y number
-- @return boolean
function Maze:check_block_left(x, y)
    return self.grid[y] and self.grid[y][x] and self.grid[y][x].block_left
end

--- Clear the wall to the left of the given cell
-- @param x number
-- @param y number
function Maze:clear_block_left(x, y)
    if self.grid[y] and self.grid[y][x] then
        self.grid[y][x].block_left = false
    end
end

--- Check if the wall to the right of the given cell is blocked
-- @param x number
-- @param y number
-- @return boolean
function Maze:check_block_right(x, y)
    return self.grid[y] and self.grid[y][x + 1] and self.grid[y][x + 1].block_left
end

--- Clear the wall to the right of the given cell
-- @param x number
-- @param y number
function Maze:clear_block_right(x, y)
    if self.grid[y] and self.grid[y][x + 1] then
        self.grid[y][x + 1].block_left = false
    end
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

--- Set whether clearing walls is disabled for the given cell
-- @param x number
-- @param y number
-- @param flag boolean True to disable clearing, false to enable
function Maze:set_disable_clear_wall(x, y, flag)
    if self.grid[y] and self.grid[y][x] then
        self.grid[y][x].disable_clear_wall = flag and true or false
    end
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

--- Load a demo pattern into the maze and clear walls accordingly
-- @param pattern table Pattern table returned from DemoPattern.load
function Maze:load_demo_pattern(pattern)
    assert(type(pattern) == 'table', 'Expected pattern table')
    assert(self.width - pattern.pattern_width >= 4 and
           self.height - pattern.pattern_height >= 4,
           'Maze size must be at least 4 cells larger than pattern')

    -- -1 for better alignment
    local start_x = math.floor((self.width - pattern.pattern_width) / 2) + 1
    local start_y = math.floor((self.height - pattern.pattern_height) / 2) + 1

    local function bit_enabled(value, bit)
        return math.floor(value / bit) % 2 == 1
    end

    for py = 1, pattern.pattern_height do
        for px = 1, pattern.pattern_width do
            local v = tonumber(pattern.block_pattern[py][px])
            if v then
                local x = start_x + px - 1
                local y = start_y + py - 1
                self:set_disable_clear_wall(x, y, true)
                -- debug print demo pattern
                print("dp: " .. x .."," ..y)
                if not bit_enabled(v, 1) then self:clear_block_up(x, y) end
                if not bit_enabled(v, 2) then self:clear_block_right(x, y) end
                if not bit_enabled(v, 4) then self:clear_block_down(x, y) end
                if not bit_enabled(v, 8) then self:clear_block_left(x, y) end
            end
        end
    end
end

--- Verify that the maze walls match a demo pattern
-- @param pattern table Pattern table returned from DemoPattern.load
-- @return boolean True if all walls correspond to the pattern
function Maze:verify_demo_pattern(pattern)
    assert(type(pattern) == 'table', 'Expected pattern table')
    assert(self.width - pattern.pattern_width >= 4 and
           self.height - pattern.pattern_height >= 4,
           'Maze size must be at least 4 cells larger than pattern')

    local start_x = math.floor((self.width - pattern.pattern_width) / 2) + 1
    local start_y = math.floor((self.height - pattern.pattern_height) / 2) + 1

    local function bit_enabled(value, bit)
        return math.floor(value / bit) % 2 == 1
    end

    for py = 1, pattern.pattern_height do
        for px = 1, pattern.pattern_width do
            local v = tonumber(pattern.block_pattern[py][px])
            if v then
                local x = start_x + px - 1
                local y = start_y + py - 1

                if self:check_block(x, y, 'up')    ~= bit_enabled(v, 1) or
                   self:check_block(x, y, 'right') ~= bit_enabled(v, 2) or
                   self:check_block(x, y, 'down')  ~= bit_enabled(v, 4) or
                   self:check_block(x, y, 'left')  ~= bit_enabled(v, 8) then
                    return false
                end
            end
        end
    end

    return true
end

--- Calculate minimum path distances from maze center to all cells
-- @return table Distance grid with math.huge for unreachable cells
function Maze:calculate_center_distances()
    local cx = math.floor((self.width + 1) / 2)
    local cy = math.floor((self.height + 1) / 2)
    local dist = {}
    for y = 1, self.height do
        dist[y] = {}
        for x = 1, self.width do
            dist[y][x] = math.huge
        end
    end

    local queue = { { x = cx, y = cy } }
    dist[cy][cx] = 0
    local head = 1
    while head <= #queue do
        local node = queue[head]
        head = head + 1
        local d = dist[node.y][node.x]

        -- explore neighbors that are not separated by walls
        if node.y > 1 and not self:check_block_up(node.x, node.y) and
           dist[node.y - 1][node.x] == math.huge then
            dist[node.y - 1][node.x] = d + 1
            queue[#queue + 1] = { x = node.x, y = node.y - 1 }
        end
        if node.y < self.height and not self:check_block_down(node.x, node.y) and
           dist[node.y + 1][node.x] == math.huge then
            dist[node.y + 1][node.x] = d + 1
            queue[#queue + 1] = { x = node.x, y = node.y + 1 }
        end
        if node.x > 1 and not self:check_block_left(node.x, node.y) and
           dist[node.y][node.x - 1] == math.huge then
            dist[node.y][node.x - 1] = d + 1
            queue[#queue + 1] = { x = node.x - 1, y = node.y }
        end
        if node.x < self.width and not self:check_block_right(node.x, node.y) and
           dist[node.y][node.x + 1] == math.huge then
            dist[node.y][node.x + 1] = d + 1
            queue[#queue + 1] = { x = node.x + 1, y = node.y }
        end
    end

    return dist
end

return Maze

