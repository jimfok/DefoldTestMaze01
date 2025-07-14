-- demo_pattern.lua
-- Utility to load and parse demo pattern CSV files
-- 
-- csv file contain two set of data, place horizontally
--
-- left set data is block pattern, where number is wall flag of up/right/down/left
-- for block pattern, not number means empty grid
--
-- right set data is unit pattern, four special character P,E,C,X -> Player, Enemy, Cross, eXit
-- for unit pattern, not P,E,C,X means empty grid
--
-- left/right set data should be of the same size, somehow you can use Q character to control the CSV area (make use of unit pattern area rules)

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
        pattern_width = half,
        pattern_height = height,
        block_pattern = block_pattern,
        unit_pattern = unit_pattern,
    }
end

--- Print pattern data to the console for debugging
-- @param data table Pattern table returned from `DemoPattern.load`
function DemoPattern.debug_print(data)
    assert(type(data) == 'table', 'Expected pattern table')

    print('width:' .. data.pattern_width)
    print('height:' .. data.pattern_height)
        
    print('Block pattern:')
    for y = 1, data.pattern_height do
        local line = ''
        for x = 1, data.pattern_width do
            line = line .. tostring(data.block_pattern[y][x]) .. ' '
        end
        print(line)
    end

    print('Unit pattern:')
    for y = 1, data.pattern_height do
        local line = ''
        for x = 1, data.pattern_width do
            line = line .. tostring(data.unit_pattern[y][x]) .. ' '
        end
        print(line)
    end
end

return DemoPattern
