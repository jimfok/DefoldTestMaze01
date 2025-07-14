-- draw_maze.lua
-- Utility to draw a Maze using debug lines

local DrawMaze = {}
local DebugDraw = require "main.debug_draw"

--- Draw the maze using debug lines
-- @param maze table Maze object
-- @param cell_size number Size of each cell in pixels
-- @param color vector4 Line color
function DrawMaze.draw(maze, cell_size, color)
    cell_size = cell_size or 32
    color = color or vmath.vector4(1, 1, 1, 1)

    local w, h = maze.width, maze.height
    for y = 1, h do
        for x = 1, w do
            local ox = (x - 1) * cell_size
            local oy = (y - 1) * cell_size

            if maze:check_block_left(x, y) then
                DebugDraw.line(ox, oy, ox, oy + cell_size, color)
            end

            if maze:check_block_up(x, y) then
                DebugDraw.line(ox, oy + cell_size, ox + cell_size, oy + cell_size, color)
            end

            if x == w and maze:check_block_right(x, y) then
                DebugDraw.line(ox + cell_size, oy, ox + cell_size, oy + cell_size, color)
            end

            if y == h and maze:check_block_down(x, y) then
                DebugDraw.line(ox, oy, ox + cell_size, oy, color)
            end
        end
    end
end

return DrawMaze

