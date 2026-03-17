# WezTerm Configuration Audit Report

**Date**: 2026-03-17  
**Config directory**: `~/.config/wezterm/`  
**Files reviewed**: `wezterm.lua`, `wezterm.local.lua`

---

## 1. Fixes Applied

### 1.1 Startup Error (FIXED)

**Error**: `Process "pwsh.exe -NoLogo" in domain "local" didn't exit cleanly - Exited with code 1`

**Root cause**: `default_prog` was set to `{ 'pwsh.exe', '-NoLogo' }`, which launches PowerShell as a raw process in the `local` domain. If `pwsh.exe` is not installed or fails, WezTerm shows the error and no shell opens.

**Fix applied**: Replaced `default_prog` with `default_domain = 'WSL:Ubuntu'` (line 322). This uses WezTerm's built-in WSL domain support, which provides proper cwd tracking, shell integration, and reliable process management. A `launch_menu` was added (lines 325-342) with WSL Ubuntu, PowerShell Modern, PowerShell Legacy, and Command Prompt entries for quick shell switching.

### 1.2 Local Config Simplified (FIXED)

**Problem**: `wezterm.local.lua` contained a stale `default_prog` override pointing to WSL via `wsl.exe`, which conflicted with the main config and was unreliable with `config_builder()` objects.

**Fix applied**: Simplified to return an empty table `{}` with commented examples for machine-specific overrides.

---

## 2. Remaining Issues

### 2.1 CRITICAL: Plugin Lazy-Loading Never Works

**Location**: Lines 8-54, 408-417, 427-446

The plugin loading pattern is fundamentally broken:

1. Plugins are loaded inside the `gui-startup` event callback (line 52)
2. `resurrect` and `ai_helper` are module-level variables initialized to `nil` (lines 13-14)
3. The `gui-startup` event fires **after** the config file has already been evaluated and `return config` has executed
4. Therefore, the checks at lines 408 and 427 (`if resurrect then` / `if ai_helper then`) **always evaluate to `false`** at config evaluation time
5. `periodic_save()` never runs; `apply_to_config()` never runs
6. The plugins may load eventually (when `gui-startup` fires), but only the keybinding callbacks (lines 212-278) will work, since they check `if resurrect then` at invocation time

**Impact**: Session auto-save and AI helper integration are completely non-functional. Only manual save/restore/delete keybindings work (and only after `gui-startup` fires).

**Recommendation**: Load plugins at the top level (outside events) and call `periodic_save()` / `apply_to_config()` after loading:

```lua
local resurrect_ok, resurrect = pcall(function()
    return wezterm.plugin.require('https://github.com/MLFlexer/resurrect.wezterm')
end)
if not resurrect_ok then resurrect = nil end

-- Then use resurrect directly in periodic_save and keybindings
```

### 2.2 HIGH: `color_scheme = 'nord'` (Incorrect Case)

**Location**: Line 95

WezTerm color scheme names are case-sensitive. The correct name is `'Nord'`, not `'nord'`. This may cause WezTerm to fall back to the default color scheme silently.

**Fix**: Change to `config.color_scheme = 'Nord'`

### 2.3 HIGH: `Ctrl+C` Overrides Terminal SIGINT

**Location**: Line 201

```lua
{ key = 'c', mods = 'CTRL', action = wezterm.action.CopyTo 'Clipboard' },
```

Mapping `Ctrl+C` to copy will intercept the standard terminal interrupt signal (SIGINT). This breaks `Ctrl+C` for canceling running commands, exiting programs, etc. This is especially problematic in WSL/Linux where `Ctrl+C` is the primary way to interrupt processes.

**Recommendation**: Use `CTRL|SHIFT` modifier instead, or use `Ctrl+C` only when there is a selection:

```lua
{ key = 'c', mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo 'Clipboard' },
```

Or conditionally copy only when text is selected:

```lua
{
    key = 'c',
    mods = 'CTRL',
    action = wezterm.action_callback(function(window, pane)
        local sel = window:get_selection_text_for_pane(pane)
        if sel and sel ~= '' then
            window:perform_action(wezterm.action.CopyTo('Clipboard'), pane)
        else
            window:perform_action(wezterm.action.SendKey({ key = 'c', mods = 'CTRL' }), pane)
        end
    end),
},
```

### 2.4 MEDIUM: `window_background_opacity = 0` (Fully Transparent)

**Location**: Line 374

A value of `0` makes the window content area fully transparent. Combined with `win32_system_backdrop = 'Mica'`, this means the terminal text is rendered directly on top of the Mica blur effect with zero background. This can cause readability issues, especially with light desktop backgrounds.

**Recommendation**: Use a value between `0.7` and `0.95` for a good balance of Mica visibility and text readability. Example: `config.window_background_opacity = 0.85`

### 2.5 MEDIUM: `initial_rows`/`initial_cols` Set Twice (Contradictory)

**Location**: Lines 101-102 and 288-289

```lua
-- Line 101-102
config.initial_rows = nil
config.initial_cols = nil

-- Line 288-289
config.initial_cols = 140
config.initial_rows = 50
```

The first assignment sets them to `nil` (letting the OS decide), then they are overridden to `140`/`50`. The first assignment is dead code. Additionally, since `gui-attached` maximizes the window (line 400), these values only affect the brief moment before maximization.

**Recommendation**: Remove lines 101-102 entirely. If the window is always maximized on startup, consider removing lines 288-289 as well.

### 2.6 MEDIUM: `font_rules` Are Redundant

**Location**: Lines 64-85

The `font_rules` block restates the default font rendering for JetBrains Mono (Normal, Bold, Italic, Bold+Italic). Since `config.font` is already set to JetBrains Mono (line 60), WezTerm will use these exact variants by default. The comment says "Font fallback chain" but `font_rules` does not provide fallback fonts.

**Recommendation**: Remove the `font_rules` block entirely, or replace `config.font` with `wezterm.font_with_fallback()` to add actual fallback fonts:

```lua
config.font = wezterm.font_with_fallback({
    'JetBrains Mono',
    'Symbols Nerd Font Mono',
    'Noto Color Emoji',
})
```

### 2.7 LOW: Tab Bar Colors Don't Match Nord Palette

**Location**: Lines 124-148

The tab bar uses custom dark colors (`#0b0022`, `#1e1e1e`, `#2e8b57`) that don't belong to the Nord color palette. This creates a visual inconsistency between the terminal content (Nord) and the tab bar.

**Nord-aligned alternatives**:
- Background: `#2E3440` (nord0)
- Active tab bg: `#88C0D0` (nord8) or `#A3BE8C` (nord14)
- Active tab fg: `#2E3440` (nord0)
- Inactive tab bg: `#3B4252` (nord1)
- Inactive tab fg: `#D8DEE9` (nord4)

### 2.8 LOW: Unused Variable `workspace`

**Location**: Line 398

```lua
local workspace = mux.get_active_workspace()
```

This variable is assigned but never used. It should be removed to avoid confusion.

### 2.9 LOW: `ALT+n` Duplicates `CTRL+SHIFT+t`

**Location**: Lines 168, 181

Both keybindings perform `SpawnTab 'CurrentPaneDomain'`. This is not necessarily a bug (having multiple shortcuts for common actions is fine), but it should be intentional and documented.

### 2.10 LOW: Local Config Merge May Be Fragile

**Location**: Lines 381-390

The `require 'wezterm.local'` call uses Lua's module resolution, which interprets dots as directory separators. This means it looks for `wezterm/local.lua` in the Lua path, not `wezterm.local.lua` in the config directory. This works because WezTerm adds the config directory to the Lua path and the file is named `wezterm.local.lua`, but it's non-obvious.

Additionally, the `pairs()` loop to merge config works for simple values but does **not** deep-merge tables. If `wezterm.local.lua` returns `{ colors = { tab_bar = { background = '#000' } } }`, it will replace the entire `colors` table, not just the `tab_bar.background` field.

---

## 3. Missing Features / Recommendations

### 3.1 No `ShowLauncher` Keybinding

The `launch_menu` (lines 325-342) is configured but there's no keybinding to open it. Without a keybinding, the launch menu is only accessible via right-clicking the `+` tab button.

**Recommendation**: Add a keybinding:

```lua
{ key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncher },
```

### 3.2 No `format-tab-title` Event Handler

Tab titles default to the process name, which is often not useful (e.g., "bash" for every tab). A `format-tab-title` event handler can show the current working directory, tab number, or custom labels.

### 3.3 No `update-status` Event Handler (Status Bar)

WezTerm supports a status bar area (left and right of the tab bar) that can display dynamic information like the current workspace, git branch, hostname, battery status, or time.

### 3.4 No `exit_behavior` Configuration

When a process exits (especially with an error), WezTerm keeps the pane open showing the exit message. Consider setting:

```lua
config.exit_behavior = 'CloseOnCleanExit'  -- Close pane only on exit code 0
```

### 3.5 No Mouse Bindings Customization

The config has no custom mouse bindings. Consider adding conveniences like:
- Right-click to paste
- `Ctrl+Click` to open URLs

### 3.6 No `quick_select_patterns`

The `QuickSelect` feature (line 209) uses default patterns. Adding custom patterns for common items like git hashes, IP addresses, or file paths can improve productivity:

```lua
config.quick_select_patterns = {
    '[0-9a-f]{7,40}',           -- git hashes
    '[\\w./-]+\\.\\w+:\\d+',    -- file:line patterns
    '\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}', -- IPv4
}
```

---

## 4. Plugin Recommendations

| Plugin | Purpose | URL |
|--------|---------|-----|
| resurrect.wezterm | Session save/restore (already included, needs fix) | https://github.com/MLFlexer/resurrect.wezterm |
| tabline.wez | Status bar and tab formatting | https://github.com/michaelbrusegard/tabline.wez |
| smart-splits.wezterm | Seamless navigation between WezTerm panes and Neovim splits | https://github.com/mrjones2014/smart-splits.nvim |

---

## 5. Summary

| Category | Count |
|----------|-------|
| Fixes applied | 2 |
| Critical issues remaining | 1 (plugin loading) |
| High severity issues | 2 (color_scheme case, Ctrl+C override) |
| Medium severity issues | 3 (opacity, duplicate settings, redundant font_rules) |
| Low severity issues | 4 (tab colors, unused var, duplicate keybind, merge fragility) |
| Missing features | 6 |

**Priority fix order**: Plugin loading pattern > `Ctrl+C` override > `color_scheme` case > `window_background_opacity` > remove dead code > cosmetic improvements.
