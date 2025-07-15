local DebugDraw = require "modules.debug-draw"

local MazeDraw = {}

 --- Draw a maze using DebugDraw lines
-- @param maze Maze object
-- @param ox origin x coordinate
-- @param oy origin y coordinate
-- @param size cell size in pixels
-- @param color line color
function MazeDraw.draw(maze, ox, oy, size, color)
    ox = ox or 0
    oy = oy or 0
    size = size or 16
    color = color or DebugDraw.COLORS.yellow

    local h = maze.height
    local w = maze.width
    local grid = maze.grid

    for y = 1, h do
        for x = 1, w do
            local cell = grid[y][x]
            local x1 = ox + (x - 1) * size
            local y1 = oy + (h - y) * size
            local x2 = x1 + size
            local y2 = y1 + size

            if cell.block_top then
                DebugDraw.line(x1, y2, x2, y2, color)
            end
            if cell.block_left then
                DebugDraw.line(x1, y1, x1, y2, color)
            end

            if y == h then
                local bottom = true
                if grid[y + 1] and grid[y + 1][x] then
                    bottom = grid[y + 1][x].block_top
                end
                if bottom then
                    DebugDraw.line(x1, y1, x2, y1, color)
                end
            end

            if x == w then
                local right = true
                if grid[y] and grid[y][x + 1] then
                    right = grid[y][x + 1].block_left
                end
                if right then
                    DebugDraw.line(x2, y1, x2, y2, color)
                end
            end
        end
    end
end

return MazeDraw

