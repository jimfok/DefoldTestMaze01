# Codex Change Log

## 2025-07-13
- Added maze generation module and initialized maze in main script.
- Ensured script files end with a newline.

### Later
- Implemented `debug_print` in `maze.lua` to visualize the maze in the console.
- Updated `main.script` to call the new debug method after generation.

## 2025-07-14
- Created `demo_pattern.lua` module to parse CSV pattern files.
- Loaded `demopattern01.csv` in `main.script` during initialization.
- Added `debug_print` in `demo_pattern.lua` and invoked it from `main.script`.

## 2025-07-15
- Added boundary assertions in `Maze.new` to ensure the maze dimensions are smaller than the base grid.
- Implemented wall checking helpers `check_block_up`, `check_block_down`, `check_block_left`, `check_block_right` and `check_block` in `maze.lua`.

