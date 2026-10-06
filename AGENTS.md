# AGENTS.md — Advanced Target Priorities

This document serves as the guide for AI agents working on the **Advanced Target Priorities** mod for Factorio.

---

## 1. Project Overview

- **Mod Name:** `advanced_target_priorities`
- **Display Title:** Advanced Target Priorities
- **Author:** heyqule
- **Target Factorio Version:** 2.1+ (Engine 2.1 API)
- **Dependencies:** `base >= 2.1.0`, `?space-age >= 2.1.0` (optional)
- **Primary Function:** Provides an intuitive graphical interface attached to player turrets allowing batch selection, sorting, and preset management for turret target priorities.

---

## 2. Directory Structure & Key Files

```
advanced_target_priorities/
├── info.json                       # Mod metadata, versioning, and dependencies
├── control.lua                     # Runtime entry point: event handler registration & remote API
├── data.lua                        # Prototype stage entry point: loads custom styles
├── remote_api.lua                  # Remote API implementation (debugging & inspection)
├── changelog.txt                   # Version history and release notes
├── LICENSE                         # GPL-3.0 License
├── thumbnail.png                   # Mod portal thumbnail image
├── gui/
│   ├── enemy_data.lua              # Built-in definitions of targetable categories & enemies
│   ├── gui_events.lua              # Event listener registration and routing (event_handler)
│   ├── preset_window.lua           # Preset management window (save, load, delete presets)
│   └── target_priority_attachment.lua # Main relative GUI attached to turret interface & priority logic
├── locale/
│   └── en/
│       └── strings.cfg             # English localization keys
└── prototypes/
    └── styles.lua                  # GUI custom button styles and clickable label definitions
```

---

## 3. Core Architecture & Runtime Mechanics

### 3.1 Factorio 2.1 Runtime Storage (`storage`)
Factorio 2.0+ deprecated `global` in favor of `storage`. ATP strictly stores persistent state inside `storage`:
- `storage.target_priority_data`: Registered dataset definitions for each enemy category/section (populated from `enemy_data.lua` + remote API calls).
- `storage.prototype_data`: Cached table of verified entity prototypes mapped to `{ entity = ..., health = ..., order = ... }`, sorted descending by health.
- `storage.target_priority_presets[player_index]`: Mapping of preset names to `{ name = "...", checkbox_data = { ... } }`.
- `storage.target_priority_player_data[player_index]`: Per-player state:
  - `turret`: Current `LuaEntity` reference of the opened turret.
  - `current_section`: Active section name (e.g., `"biters"`, `"asteroids"`).
  - `selected_index`: Selected tab/section list-box index.
  - `preset`: Active preset name (defaults to `"Default"`).
  - `apply_to_same_turret_name`: Boolean flag for batch applying to same turret name.
  - `apply_to_radius`: Number (32–640) or nil for radius application.
  - `checkbox_data`: Multi-dimensional table tracking selections: `checkbox_data[section][option_type][option_name] = boolean`.
  - Temporary GUI element references: `section_selector_obj`, `preset_label_field`, `preset_name_table`, `preset_name_textfield`, `apply_to_same_turret_name_checkbox`, `apply_to_radius_textfield`.

### 3.2 Event Handling (`gui/gui_events.lua`)
- Uses Factorio's standard `event_handler` library: `handler.add_lib(require(...))`.
- Valid turret types supported:
  - `"ammo-turret"`
  - `"fluid-turret"`
  - `"electric-turret"`
  - `"turret"` (e.g., Terran Bunkers)
- Handled events:
  - `defines.events.on_gui_opened`: Attaches relative GUI (`TargetPriorityAttachment.show`) when opening a valid turret.
  - `defines.events.on_gui_closed`: Closes preset modal if open (`PresetWindow.hide`).
  - `defines.events.on_gui_click`: Routes action buttons (Apply, Clear, open Preset modal, confirm Preset, load Preset, delete Preset).
  - `defines.events.on_gui_selection_state_changed`: Triggers `TargetPriorityAttachment.refresh_list` when selecting a different section.
  - `defines.events.on_gui_checked_state_changed`: Updates `storage.target_priority_player_data[player.index].checkbox_data` and Apply Options checkbox.
  - `defines.events.on_gui_text_changed`: Validates and tracks numeric radius text in Apply Options.
  - `defines.events.on_gui_confirmed`: Clamps radius text to range [32, 640] on Enter.
  - `defines.events.on_player_created`: Initializes player state via `TargetPriorityAttachment.init_player_values`.
  - `GuiEvent.on_init` and `GuiEvent.on_configuration_changed`: Re-initializes dataset cache via `TargetPriorityAttachment.init()`.

### 3.3 Target Combination & Priority Assignment (`gui/target_priority_attachment.lua`)
1. **Combination Generation:**
   - Combinations are generated recursively via `generate_combinations()` across all selected options (`size`, `unit_type`, `tier`, `variant`).
   - Delimiters (default `-` or section overrides) and optional prefixes/suffixes are appended to build candidate prototype names (e.g. `small-biter`).
2. **Prototype Validation & Health Sorting:**
   - Candidate entity prototypes are resolved via `prototypes.get_entity_filtered({{ filter = "name", name = final_name }})`.
   - Valid prototypes are ordered by max health (`entity.get_max_health()`) descending so tougher targets are prioritized first.
3. **Turret Application:**
   - Identifies candidate turrets based on "Apply Options":
     - Single opened turret (default when neither option is set).
     - Same turret prototype across the current surface (`apply_to_same_turret_name = true`, no radius).
     - Any valid turrets within radius (`apply_to_radius = <number>`, `apply_to_same_turret_name = false`).
     - Same turret prototype within radius (`apply_to_same_turret_name = true`, `apply_to_radius = <number>`).
   - Clears existing target priority slots on all matched turrets using `turret.set_priority_target(tindex, nil)`.
   - Iterates the sorted candidate list and assigns targets sequentially via `turret.set_priority_target(index, entity_name)`.

---

## 4. Preset Management (`gui/preset_window.lua`)

- Rendered under `player.gui.screen` (draggable modal frame centered on screen).
- `"Default"` preset is reserved and cannot be deleted.
- Deleting an active preset reverts the player back to `"Default"`.
- Creating a preset immediately saves the current selection and updates the active preset label.

---

## 5. Extensibility & Third-Party Mod Integration

### 5.1 Native Compatibility (`gui/enemy_data.lua`)
ATP conditionally activates sections or options based on `script.active_mods`:
- `space-age`: Asteroids (`small`, `medium`, `big`, `huge` × `oxide`, `carbonic`, `metallic`, `promethium`), Demolishers (`segmented-unit`), and Pentapods.
- `Toxic_biters`, `Cold_biters`, `ArmouredBiters`, `Explosive_biters`: Variant biters and spitters.
- `Electric_flying_enemies`: Fulgoran walking and flying electric units with tiers (1–5).
- `planet-arrakis`: Sandworms added to `segmented-unit`.
- `tenebris` / `tenebris-prime`: Centipede head sizes.
- `behemoth-enemies`: Adds `behemoth` tier to pentapods and demolishers.

### 5.2 Remote Interface Hooks
External mods can register custom targets dynamically during initialization:
- **Interface Name:** Any external mod registering remote functions:
  1. `advanced_target_priorities_register_section_data`: Returns an array of section definitions:
     ```lua
     {
         delimiter = "-",                 -- Required
         name = "my-enemy-section",       -- Required
         prefix = "enemy",                -- Optional
         suffix = nil,                    -- Optional
         options = { ... },               -- Required: arrays of options
         option_titles = { ... },         -- Required: order of option titles ('size', 'unit_type', etc.)
         option_delimiters = { ... },     -- Optional: delimiter overrides per option position
         unit_type_columns = 2,           -- Optional: column count for unit_type checkboxes
     }
     ```
  2. `advanced_target_priorities_insert_section_data`: Injects an option into an existing section:
     ```lua
     {
         section = "asteroids",
         option_title = "unit_type",
         option = "new_type",
     }
     ```

### 5.3 Debug Remote Interface (`remote_api.lua`)
- `remote.call("advanced_target_priorities", "print_global")`:
  Dumps the contents of `storage` into `script-output/advanced_target_priorities/storage.json`.

---

## 6. Coding & Contribution Guidelines

### 6.1 Coding Standards
- **Indentation:** 4 spaces.
- **Factorio 2.1 Compatibility:**
  - Always use `storage`, never `global`.
  - Always verify `entity and entity.valid` before accessing properties or applying priorities.
  - Safely guard GUI lookups with `player.gui.relative[...]` and `player.gui.screen[...]`.
- **Global Variables:**
  - Keep pollution of the Lua global table minimal.
  - Debug flag: `ATP_DEBUG_MODE` in `control.lua`.
- **GUI Destruction & Recreation:**
  - Ensure any opened frame is destroyed (`.destroy()`) before creating a new instance to prevent duplicate UI elements.
  - Avoid persisting GUI element references across save/load cycles; rebuild references when GUI is opened.

### 6.2 Localization Rules
- Store all user-facing strings (window titles, button captions, tooltips) in `locale/en/strings.cfg`.
- **Exception:** Checkbox options for units, sizes, tiers, and variants are **not** localized. They correspond directly to prototype name fragments used during combination generation.

### 6.3 Release & Versioning Checklist
When updating or cutting a new release:
1. Increment the version in `info.json` (`version` field) and update `date` (format: `YYYY-MM-DD`).
2. Add corresponding version block with `Date`, `Features`, `Changes`, and/or `Bugfixes` in `changelog.txt`.
3. Verify backward compatibility with existing savegames and ensure `storage` migrations/initializations run cleanly in `on_configuration_changed`.
