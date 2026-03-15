-- WezTerm Configuration Starter
-- A comprehensive configuration covering fonts, colors, keybindings, and more
-- Reload config: Press Ctrl+Shift+R in WezTerm

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- =============================================================================
-- FONTS CONFIGURATION
-- =============================================================================
-- Configure primary font with fallback support for symbols and emojis
config.font = wezterm.font('JetBrains Mono')
config.font_size = 12.0

-- Font fallback chain: JetBrains Mono → Nerd Font Symbols → Noto Color Emoji
config.font_rules = {
	{
		intensity = 'Normal',
		italic = false,
		font = wezterm.font('JetBrains Mono'),
	},
	{
		intensity = 'Bold',
		italic = false,
		font = wezterm.font('JetBrains Mono', { weight = 'Bold' }),
	},
	{
		intensity = 'Normal',
		italic = true,
		font = wezterm.font('JetBrains Mono', { italic = true }),
	},
	{
		intensity = 'Bold',
		italic = true,
		font = wezterm.font('JetBrains Mono', { weight = 'Bold', italic = true }),
	},
}

-- Fallback fonts for symbols and emojis (bundled with WezTerm)
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

-- =============================================================================
-- COLORS & APPEARANCE CONFIGURATION
-- =============================================================================
-- Use a built-in color scheme (1001+ available from iTerm2, base16, Gogh, etc.)
-- Scheme names are case-sensitive. See: https://wezterm.org/colorschemes/
config.color_scheme = 'nord'

-- Window appearance
config.window_decorations = 'RESIZE' -- TITLE | RESIZE | NONE
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

-- Cursor styling
config.default_cursor_style = 'BlinkingBar'
config.cursor_thickness = 2
-- underline_position: number (pixels) or strings like '-2px', '0.1cell', '2pt', '200%'
config.underline_position = -2
config.underline_thickness = '1px'

-- Tab bar styling: 'fancy' uses native tabs, 'retro' uses old-style
config.tab_bar_at_bottom = true  -- Moved tabs to bottom
config.use_fancy_tab_bar = false -- Using retro style (simpler)
config.tab_max_width = 32

-- Tab bar colors
config.colors = {
	tab_bar = {
		background = '#0b0022',
		active_tab = {
			bg_color = '#2e8b57',
			fg_color = '#ffffff',
			intensity = 'Bold',
			underline = 'None',
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = '#1e1e1e',
			fg_color = '#808080',
		},
		inactive_tab_hover = {
			bg_color = '#3e3e3e',
			fg_color = '#909090',
		},
		new_tab = {
			bg_color = '#1e1e1e',
			fg_color = '#808080',
		},
	},
}

-- Visual bell instead of audio
config.visual_bell = {
	fade_in_duration_ms = 75,
	fade_out_duration_ms = 75,
	target = 'CursorColor',
}

-- =============================================================================
-- KEYBINDINGS CONFIGURATION
-- =============================================================================
-- Keybinding syntax:
--   phys:LETTER = physical key position (position-independent)
--   mapped:LETTER = mapped key (layout-dependent, e.g., QWERTY)
--   Modifiers: CTRL, ALT, SHIFT, SUPER
-- Available actions: SpawnTab, SpawnWindow, CloseCurrentPane, etc.

config.keys = {
	-- ---- TAB MANAGEMENT ----
	{ key = 't',          mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
	{ key = 'w',          mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = false } },
	{ key = 'Tab',        mods = 'CTRL',       action = wezterm.action.ActivateTabRelative(1) },
	{ key = 'Tab',        mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },

	-- ---- PANE CREATION (Ctrl+Shift+Arrow to create pane in direction) ----
	{ key = 'LeftArrow',  mods = 'CTRL|ALT',   action = wezterm.action.SplitPane { direction = 'Left', size = { Percent = 30 } } },
	{ key = 'RightArrow', mods = 'CTRL|ALT',   action = wezterm.action.SplitPane { direction = 'Right', size = { Percent = 30 } } },
	{ key = 'UpArrow',    mods = 'CTRL|ALT',   action = wezterm.action.SplitPane { direction = 'Up', size = { Percent = 30 } } },
	{ key = 'DownArrow',  mods = 'CTRL|ALT',   action = wezterm.action.SplitPane { direction = 'Down', size = { Percent = 30 } } },

	-- ---- PANE MANAGEMENT (Alt+key) ----
	{ key = 'w',          mods = 'ALT',        action = wezterm.action.CloseCurrentPane { confirm = false } },
	{ key = 'n',          mods = 'ALT',        action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
	{ key = 'm',          mods = 'ALT',        action = wezterm.action.TogglePaneZoomState },

	-- ---- PANE NAVIGATION (Quick: Ctrl+Alt+Arrow) ----
	{ key = 'LeftArrow',  mods = 'ALT',        action = wezterm.action.ActivatePaneDirection 'Left' },
	{ key = 'RightArrow', mods = 'ALT',        action = wezterm.action.ActivatePaneDirection 'Right' },
	{ key = 'UpArrow',    mods = 'ALT',        action = wezterm.action.ActivatePaneDirection 'Up' },
	{ key = 'DownArrow',  mods = 'ALT',        action = wezterm.action.ActivatePaneDirection 'Down' },

	-- ---- PANE RESIZING ----
	{ key = 'LeftArrow',  mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
	{ key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
	{ key = 'UpArrow',    mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
	{ key = 'DownArrow',  mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },

	-- ---- WINDOW MANAGEMENT ----
	{ key = 'n',          mods = 'CTRL|SHIFT', action = wezterm.action.SpawnWindow },
	{ key = 'F11',        mods = '',           action = wezterm.action.ToggleFullScreen },

	-- ---- COPY/PASTE & SELECTION ----
	{ key = 'c',          mods = 'CTRL',       action = wezterm.action.CopyTo 'Clipboard' },
	{ key = 'v',          mods = 'CTRL',       action = wezterm.action.PasteFrom 'Clipboard' },

	-- ---- SEARCH & SCROLLBACK ----
	{ key = 'f',          mods = 'CTRL|SHIFT', action = wezterm.action.Search { CaseInSensitiveString = '' } },
	{ key = 'r',          mods = 'CTRL|SHIFT', action = wezterm.action.ReloadConfiguration },

	-- ---- QUICK SELECT (Select text in pane) ----
	{ key = 's',          mods = 'CTRL|SHIFT', action = wezterm.action.QuickSelect },
}

-- =============================================================================
-- PANE & WINDOW MANAGEMENT
-- =============================================================================
-- Automatically renumber panes when one is closed
config.automatically_reload_config = true

-- Initial size of new windows
config.initial_cols = 140
config.initial_rows = 50

-- =============================================================================
-- SCROLLBACK CONFIGURATION
-- =============================================================================
-- Maximum lines of scrollback history per pane (default is 3500)
config.scrollback_lines = 5000

-- Scroll wheel behavior
config.mouse_wheel_scrolls_tabs = false

-- =============================================================================
-- TERMINAL BEHAVIOR
-- =============================================================================
-- Exit behavior when closing panes/windows
-- NeverPrompt: Close without confirmation
-- AlwaysPrompt: Always ask for confirmation before closing
config.window_close_confirmation = 'NeverPrompt'

-- Audible bell: 'Disabled' = no system beep, 'SystemBeep' = system sound
config.audible_bell = 'Disabled'

-- Adjust scrollback on output (follow along as new text appears)
config.adjust_window_size_when_changing_font_size = true

-- Enable hyperlink detection (clickable URLs in terminal)
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- =============================================================================
-- WSL INTEGRATION
-- =============================================================================
-- Use WezTerm's default WSL domain detection
-- This automatically creates domains for all WSL distributions found on the system
local wsl_domains = wezterm.default_wsl_domains()
config.wsl_domains = wsl_domains

-- Set default domain to Ubuntu WSL
-- The domain name follows the format 'WSL:DistroName'
config.default_domain = 'WSL:Ubuntu'

-- =============================================================================
-- RENDERING & FRONTEND
-- =============================================================================
-- Frontend rendering engine: 'OpenGL' (modern, default), 'WebGpu', or 'Software'
config.front_end = 'OpenGL'

-- GPU-accelerated rendering options
config.freetype_load_flags = 'DEFAULT'
config.freetype_render_target = 'HorizontalLcd'

-- Anti-aliasing
config.anti_alias_custom_block_glyphs = true

-- Performance options
config.animation_fps = 1 -- Higher values = smoother animation, lower values = less CPU
config.cursor_blink_ease_in = 'Linear'
config.cursor_blink_ease_out = 'Linear'
config.cursor_blink_rate = 800

-- =============================================================================
-- WINDOWS AESTHETICS
-- =============================================================================
-- Apply the Mica backdrop effect (Windows 11 frosted glass appearance)
-- Mica creates a semi-transparent background with a modern Windows 11 aesthetic
-- Available options: 'None', 'Mica', 'Tabbed', 'TabbedDark'
config.win32_system_backdrop = 'Mica'

-- Set window opacity to fully transparent for Mica effect
-- This allows the Mica backdrop to be fully visible
-- Range: 0.0 (fully transparent) to 1.0 (fully opaque)
config.window_background_opacity = 0

-- =============================================================================
-- FINAL CONFIGURATION RETURN
-- =============================================================================
return config
