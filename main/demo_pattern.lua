-- demo_pattern.lua
-- Utility to load and parse demo pattern CSV files

local DemoPattern = {}

local function split_line(line)
    local t = {}
    line = line:gsub('\r', '')
    for value in (line .. ','):gmatch('([^,]*),') do
        table.insert(t, value)
    end
    return t
end

--- Load a CSV pattern file
-- @param path string Path to the CSV resource
-- @return table Parsed pattern data
function DemoPattern.load(path)
    local data = sys.load_resource(path)
    assert(data, 'Unable to load pattern file: ' .. path)

    local rows = {}
    for line in data:gmatch('[^\n]+') do
        table.insert(rows, split_line(line))
    end

    local height = #rows
    local width = #rows[1]
    local half = width / 2

    local block_pattern = {}
    local unit_pattern = {}

    for y = 1, height do
        block_pattern[y] = {}
        unit_pattern[y] = {}
        for x = 1, half do
            block_pattern[y][x] = rows[y][x]
        end
        for x = half + 1, width do
            unit_pattern[y][x - half] = rows[y][x]
        end
    end

    return {
        pattern_width = width,
        pattern_height = height,
        block_pattern = block_pattern,
        unit_pattern = unit_pattern,
    }
end

return DemoPattern
