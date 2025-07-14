-- draw_maze.lua
-- Utility to draw a Maze using debug lines

local DrawMaze = {}

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
                msg.post("@render:", "draw_line", {
                    start_point = vmath.vector3(ox, oy, 0),
                    end_point = vmath.vector3(ox, oy + cell_size, 0),
                    color = color
                })
            end

            if maze:check_block_up(x, y) then
                msg.post("@render:", "draw_line", {
                    start_point = vmath.vector3(ox, oy + cell_size, 0),
                    end_point = vmath.vector3(ox + cell_size, oy + cell_size, 0),
                    color = color
                })
            end

            if x == w and maze:check_block_right(x, y) then
                msg.post("@render:", "draw_line", {
                    start_point = vmath.vector3(ox + cell_size, oy, 0),
                    end_point = vmath.vector3(ox + cell_size, oy + cell_size, 0),
                    color = color
                })
            end

            if y == h and maze:check_block_down(x, y) then
                msg.post("@render:", "draw_line", {
                    start_point = vmath.vector3(ox, oy, 0),
                    end_point = vmath.vector3(ox + cell_size, oy, 0),
                    color = color
                })
            end
        end
    end
end

return DrawMaze

