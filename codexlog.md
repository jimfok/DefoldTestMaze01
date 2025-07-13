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

## 2025-07-16
- Added `CheckDisableClearWall` helper and integrated it into maze generation.
- Maze generation now respects `disable_clear_wall` flags on grid cells.

## 2025-07-17
- Implemented wall clearing helpers and `load_demo_pattern` in `maze.lua`.
- `main.script` now loads the demo pattern by default.

## 2025-07-18
- Added assertion in `load_demo_pattern` to require at least a 4-cell margin around the pattern.

