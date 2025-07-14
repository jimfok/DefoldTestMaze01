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

## 2025-07-19
- Reversed wall clearing logic in `load_demo_pattern` to clear walls when the corresponding bit is NOT set.

## 2025-07-20
- Converted debug error print to an assertion in `Maze.generate`.
- Implemented `set_disable_clear_wall` helper and updated call site in `load_demo_pattern`.

## 2025-07-21
- Added `calculate_center_distances` in `maze.lua` to compute minimum path
  distances from the maze center.
- Updated `main.script` to invoke the new function and print the resulting
  distance grid for debugging.

## 2025-07-22
- Added `verify_demo_pattern` in `maze.lua` to validate walls against a demo pattern.

## 2025-07-23
- Invoked `verify_demo_pattern` from `main.script` and printed the result.

## 2025-07-24
- Added `print_distance_grid` and `validate_distance_grid` helpers in `main.script`.
- Distance grid printing and validation are now performed during initialization.
- Added `random_dice.lua` implementing an integer random generator with dice helpers.

## 2025-07-25
- Replaced `math.random` usage in `maze.lua` with the new `RandomDice` module.
- Seeded the random generator using `RandomDice.randomseed`.

## 2025-07-26
- Added optional `seed` parameter to `Maze:generate` for deterministic runs.
- Updated `main.script` to pass a seed via `os.time()`.
