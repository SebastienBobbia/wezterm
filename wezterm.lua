-- WezTerm Configuration
-- Reload config: Press Ctrl+Shift+R in WezTerm

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- =============================================================================
-- PLUGINS
-- =============================================================================
-- Plugins are loaded at top-level (required for periodic_save and apply_to_config
-- to work correctly at config evaluation time).

local resurrect_ok, resurrect = pcall(function()
	return wezterm.plugin.require('https://github.com/MLFlexer/resurrect.wezterm')
end)
if not resurrect_ok then
	resurrect = nil
	wezterm.log_warn('Failed to load resurrect.wezterm: ' .. tostring(resurrect))
end

local ai_helper_ok, ai_helper = pcall(function()
	return wezterm.plugin.require('https://github.com/Michal1993r/ai-helper.wezterm')
end)
if not ai_helper_ok then
	ai_helper = nil
	wezterm.log_warn('Failed to load ai-helper.wezterm: ' .. tostring(ai_helper))
end

local tabline_ok, tabline = pcall(function()
	return wezterm.plugin.require('https://github.com/michaelbrusegard/tabline.wez')
end)
if not tabline_ok then
	tabline = nil
	wezterm.log_warn('Failed to load tabline.wez: ' .. tostring(tabline))
end

local smart_splits_ok, smart_splits = pcall(function()
	return wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')
end)
if not smart_splits_ok then
	smart_splits = nil
	wezterm.log_warn('Failed to load smart-splits.nvim: ' .. tostring(smart_splits))
end

-- =============================================================================
-- FONTS CONFIGURATION
-- =============================================================================
-- Font with fallback chain for symbols and emojis
config.font = wezterm.font_with_fallback({
	'JetBrains Mono',
	'Symbols Nerd Font Mono',
	'Noto Color Emoji',
})
config.font_size = 12.0
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

-- =============================================================================
-- COLORS & APPEARANCE CONFIGURATION
-- =============================================================================
-- Scheme names are case-sensitive. See: https://wezterm.org/colorschemes/
-- Using a LIGHT theme temporarily to verify theme application visually.
-- Switch back to 'Nord' once confirmed: config.color_scheme = 'Nord'
config.color_scheme = 'Catppuccin Latte'

-- Window appearance
config.window_decorations = 'RESIZE' -- TITLE | RESIZE | NONE

-- Window sizing — window is maximized on startup (gui-attached below),
-- so these only affect the brief moment before maximization.
config.initial_cols = 140
config.initial_rows = 50

config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

-- Cursor styling
config.default_cursor_style = 'BlinkingBar'
config.cursor_thickness = 2
config.underline_position = -2
config.underline_thickness = '1px'

-- Tab bar: tabline.wez will configure these if loaded; set sensible defaults
-- in case tabline fails to load. tabline requires use_fancy_tab_bar = false.
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_max_width = 32

-- Tab bar colors (fallback when tabline.wez is not loaded).
-- These match the active color_scheme; update if you change color_scheme.
config.colors = {
	tab_bar = {
		background = '#EFF1F5',    -- Catppuccin Latte base
		active_tab = {
			bg_color = '#1E66F5',  -- Catppuccin Latte blue
			fg_color = '#EFF1F5',  -- Catppuccin Latte base
			intensity = 'Bold',
			underline = 'None',
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = '#DCE0E8',  -- Catppuccin Latte crust
			fg_color = '#4C4F69',  -- Catppuccin Latte text
		},
		inactive_tab_hover = {
			bg_color = '#CCD0DA',  -- Catppuccin Latte surface0
			fg_color = '#4C4F69',  -- Catppuccin Latte text
		},
		new_tab = {
			bg_color = '#DCE0E8',  -- Catppuccin Latte crust
			fg_color = '#4C4F69',  -- Catppuccin Latte text
		},
	},
}

-- Visual bell instead of audio
config.visual_bell = {
	fade_in_duration_ms = 75,
	fade_out_duration_ms = 75,
	target = 'CursorColor',
}

-- Pane visibility: dim inactive panes so the active pane stands out.
-- Note: WezTerm only supports `inactive_pane_hsb` (there is no `active_pane_hsb`).
-- The active pane always renders at full brightness; inactive panes are adjusted.
config.inactive_pane_hsb = {
	hue = 1.0,         -- no hue shift
	saturation = 0.7,  -- slightly desaturated
	brightness = 0.6,  -- noticeably dimmed
}

-- =============================================================================
-- KEYBINDINGS CONFIGURATION
-- =============================================================================
-- Note on smart-splits navigation keybindings:
--   If smart-splits loads successfully, apply_to_config() below adds:
--     CTRL+h/j/k/l  → move between panes (passes through to Neovim when focused)
--     META+Left/Down/Up/Right → resize panes (passes through to Neovim)
--   The ALT+Arrow pane navigation keys below are kept for non-Neovim use.
--   The ALT+Arrow pane creation keys (CTRL+ALT+Arrow) are kept as-is.

config.keys = {
	-- ---- TAB MANAGEMENT ----
	{ key = 't',          mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
	{ key = 'w',          mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = false } },
	{ key = 'Tab',        mods = 'CTRL',       action = wezterm.action.ActivateTabRelative(1) },
	{ key = 'Tab',        mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },

	-- ---- PANE CREATION (Ctrl+Alt+Arrow to create pane in direction) ----
	{ key = 'LeftArrow',  mods = 'CTRL|ALT',   action = wezterm.action.SplitPane { direction = 'Left', size = { Percent = 30 } } },
	{ key = 'RightArrow', mods = 'CTRL|ALT',   action = wezterm.action.SplitPane { direction = 'Right', size = { Percent = 30 } } },
	{ key = 'UpArrow',    mods = 'CTRL|ALT',   action = wezterm.action.SplitPane { direction = 'Up', size = { Percent = 30 } } },
	{ key = 'DownArrow',  mods = 'CTRL|ALT',   action = wezterm.action.SplitPane { direction = 'Down', size = { Percent = 30 } } },

	-- ---- PANE MANAGEMENT ----
	{ key = 'w',          mods = 'ALT',        action = wezterm.action.CloseCurrentPane { confirm = false } },
	{ key = 'n',          mods = 'ALT',        action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
	{ key = 'm',          mods = 'ALT',        action = wezterm.action.TogglePaneZoomState },

	-- ---- PANE NAVIGATION (fallback when smart-splits not loaded) ----
	-- ALT+Arrow alone is intercepted by Windows Snap before WezTerm sees it.
	-- ALT+SHIFT+Arrow avoids that conflict.
	{ key = 'LeftArrow',  mods = 'ALT|SHIFT',  action = wezterm.action.ActivatePaneDirection 'Left' },
	{ key = 'RightArrow', mods = 'ALT|SHIFT',  action = wezterm.action.ActivatePaneDirection 'Right' },
	{ key = 'UpArrow',    mods = 'ALT|SHIFT',  action = wezterm.action.ActivatePaneDirection 'Up' },
	{ key = 'DownArrow',  mods = 'ALT|SHIFT',  action = wezterm.action.ActivatePaneDirection 'Down' },

	-- ---- PANE RESIZING ----
	{ key = 'LeftArrow',  mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
	{ key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
	{ key = 'UpArrow',    mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
	{ key = 'DownArrow',  mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },

	-- ---- WINDOW MANAGEMENT ----
	{ key = 'n',          mods = 'CTRL|SHIFT', action = wezterm.action.SpawnWindow },
	{ key = 'F11',        mods = '',           action = wezterm.action.ToggleFullScreen },

	-- ---- COPY/PASTE & SELECTION ----
	-- Ctrl+C: copy if text is selected, otherwise send SIGINT normally
	{
		key = 'c',
		mods = 'CTRL',
		action = wezterm.action_callback(function(window, pane)
			local sel = window:get_selection_text_for_pane(pane)
			if sel and sel ~= '' then
				window:perform_action(wezterm.action.CopyTo('Clipboard'), pane)
			else
				window:perform_action(wezterm.action.SendKey { key = 'c', mods = 'CTRL' }, pane)
			end
		end),
	},
	{ key = 'v',          mods = 'CTRL',       action = wezterm.action.PasteFrom 'Clipboard' },

	-- ---- SEARCH & SCROLLBACK ----
	{ key = 'f',          mods = 'CTRL|SHIFT', action = wezterm.action.Search { CaseInSensitiveString = '' } },
	{ key = 'r',          mods = 'CTRL|SHIFT', action = wezterm.action.ReloadConfiguration },

	-- ---- QUICK SELECT (Select text patterns in pane) ----
	{ key = 's',          mods = 'CTRL|SHIFT', action = wezterm.action.QuickSelect },

	-- ---- LAUNCHER (open launch_menu to select shell) ----
	{ key = 'l',          mods = 'ALT',        action = wezterm.action.ShowLauncher },

	-- ---- RESURRECT : SAVE SESSIONS ----
	{
		key = 's',
		mods = 'ALT',
		action = wezterm.action_callback(function(win, pane)
			if resurrect then
				resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
				resurrect.window_state.save_window_action()
			else
				wezterm.log_warn('resurrect not loaded')
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

	-- ---- AI HELPER ----
	-- Keybindings for ai-helper are registered below via apply_to_config
	-- if the plugin loaded successfully. These placeholders are unused if
	-- apply_to_config is called, but kept here as documentation.
	-- CTRL+SHIFT+i  → open AI prompt
	-- CTRL+SHIFT+ALT+I → open AI prompt with pane context
}

-- =============================================================================
-- MOUSE BINDINGS
-- =============================================================================
config.mouse_bindings = {
	-- Right-click to paste from clipboard
	{
		event = { Down = { streak = 1, button = 'Right' } },
		mods = 'NONE',
		action = wezterm.action.PasteFrom 'Clipboard',
	},
	-- Ctrl+Click to open hyperlinks
	{
		event = { Up = { streak = 1, button = 'Left' } },
		mods = 'CTRL',
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

-- =============================================================================
-- QUICK SELECT PATTERNS
-- =============================================================================
config.quick_select_patterns = {
	'[0-9a-f]{7,40}',                                    -- git hashes
	'[\\w./-]+\\.\\w+:\\d+',                             -- file:line patterns
	'\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}',        -- IPv4 addresses
	'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}',  -- email addresses
}

-- =============================================================================
-- PANE & WINDOW MANAGEMENT
-- =============================================================================
config.automatically_reload_config = true

-- =============================================================================
-- SCROLLBACK CONFIGURATION
-- =============================================================================
config.scrollback_lines = 5000
config.mouse_wheel_scrolls_tabs = false

-- =============================================================================
-- TERMINAL BEHAVIOR
-- =============================================================================
config.window_close_confirmation = 'NeverPrompt'
config.audible_bell = 'Disabled'
config.adjust_window_size_when_changing_font_size = true
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Close pane on clean exit (exit code 0); keep open on error for inspection
config.exit_behavior = 'CloseOnCleanExit'

-- =============================================================================
-- WSL INTEGRATION
-- =============================================================================
-- Use WezTerm's built-in WSL domain for proper cwd tracking and shell integration.
config.default_domain = 'WSL:Ubuntu'

-- Launch menu for quick shell selection (ALT+L to open)
config.launch_menu = {
	{
		label = 'WSL Ubuntu',
		args = { 'wsl.exe', '--distribution', 'Ubuntu' },
	},
	{
		label = 'PowerShell (Modern)',
		args = { 'pwsh.exe', '-NoLogo' },
	},
	{
		label = 'PowerShell (Legacy)',
		args = { 'powershell.exe', '-NoLogo' },
	},
	{
		label = 'Command Prompt',
		args = { 'cmd.exe' },
	},
}

-- =============================================================================
-- RENDERING & FRONTEND
-- =============================================================================
config.front_end = 'OpenGL'
config.freetype_load_flags = 'DEFAULT'
config.freetype_render_target = 'HorizontalLcd'
config.anti_alias_custom_block_glyphs = true
config.animation_fps = 1
config.cursor_blink_ease_in = 'Linear'
config.cursor_blink_ease_out = 'Linear'
config.cursor_blink_rate = 800

-- =============================================================================
-- WINDOWS AESTHETICS
-- =============================================================================
-- Mica backdrop effect (Windows 11 frosted glass)
config.win32_system_backdrop = 'Mica'

-- 0.85 allows Mica to show through while keeping text readable
config.window_background_opacity = 0.85

-- =============================================================================
-- TABLINE PLUGIN (tab bar + status bar)
-- =============================================================================
-- tabline.wez replaces format-tab-title and update-status with a rich bar
-- inspired by lualine.nvim.
--
-- tabline resolves theme names by calling wezterm.color.get_builtin_schemes()
-- internally. Some built-in schemes may lack fields that tabline expects
-- (e.g. .ansi), which causes a runtime error. Passing the scheme object
-- directly bypasses that lookup and avoids the crash.
local _scheme = wezterm.color.get_builtin_schemes()['Catppuccin Latte']

if tabline then
	tabline.setup({
		options = {
			icons_enabled = true,
			theme = _scheme,
			tabs_enabled = true,
			section_separators = {
				left = wezterm.nerdfonts.pl_left_hard_divider,
				right = wezterm.nerdfonts.pl_right_hard_divider,
			},
			component_separators = {
				left = wezterm.nerdfonts.pl_left_soft_divider,
				right = wezterm.nerdfonts.pl_right_soft_divider,
			},
			tab_separators = {
				left = wezterm.nerdfonts.pl_left_hard_divider,
				right = wezterm.nerdfonts.pl_right_hard_divider,
			},
		},
		sections = {
			tabline_a = { 'mode' },
			tabline_b = { 'workspace' },
			tabline_c = { ' ' },
			tab_active = {
				'index',
				{ 'parent', padding = 0 },
				'/',
				{ 'cwd', padding = { left = 0, right = 1 } },
				{ 'zoomed', padding = 0 },
			},
			tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
			tabline_x = { 'ram', 'cpu' },
			tabline_y = { 'datetime', 'battery' },
			tabline_z = { 'domain' },
		},
		extensions = resurrect and { 'resurrect' } or {},
	})
	-- Applies tab_bar_at_bottom=true, use_fancy_tab_bar=false, etc.
	tabline.apply_to_config(config)
else
	wezterm.log_warn('tabline.wez not loaded - using default tab bar')
end

-- =============================================================================
-- SMART-SPLITS PLUGIN (seamless Neovim/WezTerm pane navigation)
-- =============================================================================
-- Keybindings added by smart_splits.apply_to_config:
--   CTRL+h/j/k/l        → move between panes (transparent with Neovim)
--   META+Left/Down/Up/Right → resize panes (transparent with Neovim)
-- Neovim side: install mrjones2014/smart-splits.nvim and bind the same keys.
if smart_splits then
	smart_splits.apply_to_config(config, {
		direction_keys = {
			move   = { 'h', 'j', 'k', 'l' },
			resize = { 'LeftArrow', 'DownArrow', 'UpArrow', 'RightArrow' },
		},
		modifiers = {
			move   = 'CTRL',
			resize = 'META',
		},
	})
else
	wezterm.log_warn('smart-splits.nvim not loaded - using standard pane navigation')
end

-- =============================================================================
-- RESURRECT : SESSION MANAGER (periodic auto-save)
-- =============================================================================
if resurrect then
	-- Save state dir on Windows: ensure WezTerm has write access
	-- resurrect.state_manager.change_state_save_dir('C:\\Users\\NexusLoop\\AppData\\Local\\wezterm\\resurrect')

	resurrect.state_manager.periodic_save({
		interval_seconds = 300,  -- every 5 minutes
		save_workspaces = true,
		save_windows = true,
		save_tabs = true,
	})
else
	wezterm.log_warn('resurrect.wezterm not loaded - session save/restore unavailable')
end

-- =============================================================================
-- AI HELPER : GITHUB COPILOT INTEGRATION
-- =============================================================================
-- Requires a GitHub Personal Access Token with 'copilot' scope.
-- Set GITHUB_COPILOT_TOKEN env variable before launching WezTerm.
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
	wezterm.log_warn('ai-helper.wezterm not loaded - Copilot integration unavailable')
end

-- =============================================================================
-- LOCAL CONFIGURATION OVERRIDE
-- =============================================================================
-- Load local configuration if it exists (wezterm.local.lua).
-- Returns a table; each key overrides the corresponding config value.
-- Deep-merge is not supported: table values replace entirely.
local ok, local_config = pcall(function()
	return require 'wezterm.local'
end)

if ok and local_config then
	for key, value in pairs(local_config) do
		config[key] = value
	end
end

-- =============================================================================
-- WINDOW STARTUP BEHAVIOR
-- =============================================================================
-- Maximize windows in the active workspace on startup.
-- Filter by workspace to avoid touching unrelated windows or spawning extras.
wezterm.on('gui-attached', function(domain)
	local mux = wezterm.mux
	local workspace = mux.get_active_workspace()
	for _, window in ipairs(mux.all_windows()) do
		if window:get_workspace() == workspace then
			window:gui_window():maximize()
		end
	end
end)

return config
