-- WezTerm Configuration Starter
-- A comprehensive configuration covering fonts, colors, keybindings, and more
-- Reload config: Press Ctrl+Shift+R in WezTerm

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- =============================================================================
-- PLUGINS (LAZY LOADED)
-- =============================================================================
-- Plugins are loaded lazily (on-demand) to avoid startup delays
-- They will be loaded when first used, not at startup
local resurrect = nil
local ai_helper = nil
local plugins_loading = false

local function load_plugins_async()
	if plugins_loading or (resurrect and ai_helper) then
		return
	end
	plugins_loading = true
	
	wezterm.log_info('Loading plugins in background...')
	
	-- Try to load each plugin independently
	if not resurrect then
		local success, plugin = pcall(function()
			return wezterm.plugin.require('https://github.com/MLFlexer/resurrect.wezterm')
		end)
		if success then
			resurrect = plugin
			wezterm.log_info('resurrect.wezterm loaded successfully')
		else
			wezterm.log_warn('Failed to load resurrect.wezterm: ' .. tostring(plugin))
		end
	end
	
	if not ai_helper then
		local success, plugin = pcall(function()
			return wezterm.plugin.require('https://github.com/Michal1993r/ai-helper.wezterm')
		end)
		if success then
			ai_helper = plugin
			wezterm.log_info('ai-helper.wezterm loaded successfully')
		else
			wezterm.log_warn('Failed to load ai-helper.wezterm: ' .. tostring(plugin))
		end
	end
end

-- Load plugins after startup (gives time for GUI to render first)
wezterm.on('gui-startup', function(cmd)
	load_plugins_async()
end)

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

-- Window sizing
config.initial_rows = nil -- Let OS handle window size
config.initial_cols = nil -- Let OS handle window size

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

	-- ---- RESURRECT : SAVE SESSIONS ----
	{
		key = 's',
		mods = 'ALT',
		action = wezterm.action_callback(function(win, pane)
			if resurrect then
				resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
				resurrect.window_state.save_window_action()
			end
		end),
	},
	{
		key = 'S',
		mods = 'ALT',
		action = wezterm.action_callback(function(win, pane)
			if resurrect then
				resurrect.tab_state.save_tab_action()
			end
		end),
	},

	-- ---- RESURRECT : RESTORE SESSIONS ----
	{
		key = 'r',
		mods = 'ALT',
		action = wezterm.action_callback(function(win, pane)
			if resurrect then
				resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
					local type = string.match(id, '^([^/]+)')
					id = string.match(id, '([^/]+)$')
					id = string.match(id, '(.+)%..+$')
					local state = resurrect.state_manager.load_state(id, type)
					if type == 'workspace' then
						resurrect.workspace_state.restore_workspace(state, {
							relative = true,
							restore_text = true,
							on_pane_restore = resurrect.tab_state.default_on_pane_restore,
						})
					elseif type == 'window' then
						resurrect.window_state.restore_window(pane:window(), state, {
							relative = true,
							restore_text = true,
							on_pane_restore = resurrect.tab_state.default_on_pane_restore,
						})
					elseif type == 'tab' then
						resurrect.tab_state.restore_tab(pane:tab(), state, {
							relative = true,
							restore_text = true,
							on_pane_restore = resurrect.tab_state.default_on_pane_restore,
						})
					end
				end)
			end
		end),
	},

	-- ---- RESURRECT : DELETE SESSIONS ----
	{
		key = 'd',
		mods = 'ALT',
		action = wezterm.action_callback(function(win, pane)
			if resurrect then
				resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
					resurrect.state_manager.delete_state(id)
				end, { title = 'Delete State', description = 'Select state to delete', fuzzy_description = 'Delete: ' })
			end
		end),
	},
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
-- local wsl_domains = wezterm.default_wsl_domains()
-- config.wsl_domains = wsl_domains

-- Set default domain to Ubuntu WSL
-- The domain name follows the format 'WSL:DistroName'
-- config.default_domain = 'WSL:Ubuntu'

--- Set Pwsh as the default on Windows
config.default_prog = { 'pwsh.exe', '-NoLogo' }

-- Launch menu for quick selection
config.launch_menu = {
	{
		label = 'PowerShell (Default)',
		args = { 'powershell.exe', '-NoLogo' },
	},
	{
		label = 'Pwsh (Modern PowerShell)',
		args = { 'pwsh.exe', '-NoLogo' },
	},
}

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
-- LOCAL CONFIGURATION OVERRIDE
-- =============================================================================
-- Load local configuration if it exists (wezterm.local.lua)
-- This allows machine-specific overrides without versioning
local ok, local_config = pcall(function()
	return require 'wezterm.local'
end)

if ok and local_config then
	-- Merge local config into main config
	for key, value in pairs(local_config) do
		config[key] = value
	end
end

-- =============================================================================
-- WINDOW STARTUP BEHAVIOR
-- =============================================================================
-- Maximize window on startup
wezterm.on('gui-attached', function(domain)
	local mux = wezterm.mux
	local workspace = mux.get_active_workspace()
	for _, window in ipairs(mux.all_windows()) do
		window:gui_window():maximize()
	end
end)

-- =============================================================================
-- RESURRECT : SESSION MANAGER
-- =============================================================================
-- Save sessions periodically (every 5 minutes)
if resurrect then
	resurrect.state_manager.periodic_save({
		interval_seconds = 300,
		save_workspaces = true,
		save_windows = true,
		save_tabs = true,
	})
else
	wezterm.log_warn('resurrect.wezterm plugin not loaded - session save/restore unavailable')
end

-- =============================================================================
-- AI HELPER : GITHUB COPILOT INTEGRATION
-- =============================================================================
-- Requires a GitHub Personal Access Token with 'copilot' scope
-- Generate one at: https://github.com/settings/tokens
-- Store your token in wezterm.local.lua as: os.setenv('GITHUB_COPILOT_TOKEN', 'ghp_...')
local github_token = os.getenv('GITHUB_COPILOT_TOKEN') or ''

if ai_helper then
	ai_helper.apply_to_config(config, {
		type = 'http',
		api_url = 'https://api.githubcopilot.com/chat/completions',
		api_key = github_token,
		model = 'gpt-4o',
		headers = {
			['Editor-Version'] = 'vscode/1.85.0',
			['Copilot-Integration-Id'] = 'vscode-chat',
		},
		keybinding = { key = 'i', mods = 'CTRL|SHIFT' },
		keybinding_with_pane = { key = 'I', mods = 'CTRL|SHIFT|ALT' },
		system_prompt = 'You are an assistant that specializes in CLI and Windows/PowerShell/WSL commands. Be brief and to the point. Print commands in a way that is easy to copy. Concatenate commands with && or || for ease of use.',
		timeout = 30,
		show_loading = true,
		share_n_lines = 150,
	})
else
	wezterm.log_warn('ai-helper.wezterm plugin not loaded - Copilot integration unavailable')
end

return config
