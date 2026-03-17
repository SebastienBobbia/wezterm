-- =============================================================================
-- LOCAL WEZTERM CONFIGURATION
-- =============================================================================
-- This file is NOT versioned in Git (.gitignore)
-- It allows you to override the default configuration for your specific machine
--
-- Any key returned here will override the corresponding key in wezterm.lua

-- =============================================================================
-- GITHUB COPILOT TOKEN
-- =============================================================================
-- Set the GITHUB_COPILOT_TOKEN environment variable before launching WezTerm:
--
-- Windows (PowerShell):
--   $env:GITHUB_COPILOT_TOKEN='your_token_here'
--   wezterm
--
-- Generate a PAT with 'copilot' scope at:
-- https://github.com/settings/tokens

-- =============================================================================
-- MACHINE-SPECIFIC OVERRIDES
-- =============================================================================
-- Override default_domain, launch_menu, or any other setting here.
-- Example: to switch back to PowerShell, uncomment the following:
-- return {
-- 	default_domain = 'local',
-- 	default_prog = { 'pwsh.exe', '-NoLogo' },
-- }

return {}
