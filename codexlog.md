# Codex Change Log

## 2025-07-13
- Added maze generation module and initialized maze in main script.
- Ensured script files end with a newline.
- Implemented `debug_print` in `maze.lua` to visualize the maze in the console.
- Updated `main.script` to call the new debug method after generation.
- Created `demo_pattern.lua` module to parse CSV pattern files.
- Loaded `demopattern01.csv` in `main.script` during initialization.
- Added `debug_print` in `demo_pattern.lua` and invoked it from `main.script`.
- Added boundary assertions in `Maze.new` to ensure the maze dimensions are smaller than the base grid.
- Implemented wall checking helpers `check_block_up`, `check_block_down`, `check_block_left`, `check_block_right` and `check_block` in `maze.lua`.

## 2025-07-14
- Added `CheckDisableClearWall` helper and integrated it into maze generation.
- Maze generation now respects `disable_clear_wall` flags on grid cells.
- Implemented wall clearing helpers and `load_demo_pattern` in `maze.lua`.
- `main.script` now loads the demo pattern by default.
- Added assertion in `load_demo_pattern` to require at least a 4-cell margin around the pattern.
- Reversed wall clearing logic in `load_demo_pattern` to clear walls when the corresponding bit is NOT set.
- Converted debug error print to an assertion in `Maze.generate`.
- Implemented `set_disable_clear_wall` helper and updated call site in `load_demo_pattern`.
- Added `calculate_center_distances` in `maze.lua` to compute minimum path
  distances from the maze center.
- Updated `main.script` to invoke the new function and print the resulting
  distance grid for debugging.
- Added `verify_demo_pattern` in `maze.lua` to validate walls against a demo pattern.
- Invoked `verify_demo_pattern` from `main.script` and printed the result.
- Added `print_distance_grid` and `validate_distance_grid` helpers in `main.script`.
- Distance grid printing and validation are now performed during initialization.
- Added `random_dice.lua` implementing an integer random generator with dice helpers.
- Replaced `math.random` usage in `maze.lua` with the new `RandomDice` module.
- Seeded the random generator using `RandomDice.randomseed`.
- Implemented `test_randomdice` in `main.script` to verify all `RandomDice` functions.
- Added optional `seed` parameter to `Maze:generate` for deterministic runs.
- Updated `main.script` to pass a seed via `os.time()`.
- Added `Maze:draw` to render the maze using debug lines.
- `main.script` now draws the maze each frame in `update()`.
- Created `draw_maze.lua` module for maze rendering.
- Removed `Maze:draw` and updated `main.script` to use the new module.
- Extended `RandomDice.random` to accept a table argument and return a random element.
- Updated `test_randomdice` to exercise the new table support.
