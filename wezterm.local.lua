-- =============================================================================
-- LOCAL WEZTERM CONFIGURATION
-- =============================================================================
-- This file is NOT versioned in Git (.gitignore)
-- It allows you to override the default configuration for your specific machine
--
-- Choose ONE of the configurations below based on your preferred shell:
-- - PowerShell: Modern cross-platform PowerShell (pwsh.exe)
-- - WSL: Windows Subsystem for Linux (bash via WSL)

-- =============================================================================
-- GITHUB COPILOT TOKEN
-- =============================================================================
-- IMPORTANT: Do NOT put your token in this file!
-- Instead, set the GITHUB_COPILOT_TOKEN environment variable before launching WezTerm:
--
-- Windows (PowerShell):
--   $env:GITHUB_COPILOT_TOKEN='your_token_here'
--   wezterm
--
-- Windows (CMD):
--   set GITHUB_COPILOT_TOKEN=your_token_here
--   wezterm
--
-- Linux/macOS:
--   export GITHUB_COPILOT_TOKEN='your_token_here'
--   wezterm
--
-- Generate a PAT (Personal Access Token) with 'copilot' scope at:
-- https://github.com/settings/tokens
--
-- If you want to set it here, uncomment the line below and add your token:
-- os.setenv("GITHUB_COPILOT_TOKEN", "github_pat_XXXXX...XXXXX")

-- =============================================================================
-- CONFIGURATION 1: POWERSHELL (DEFAULT)
-- =============================================================================
-- Uncomment this section to use PowerShell as your default shell
return {
	default_prog = { "pwsh.exe", "-NoLogo" },
	launch_menu = {
		{
			label = "PowerShell (Default)",
			args = { "powershell.exe", "-NoLogo" },
		},
		{
			label = "Pwsh (Modern PowerShell)",
			args = { "pwsh.exe", "-NoLogo" },
		},
	},
}

-- =============================================================================
-- CONFIGURATION 2: WSL (UBUNTU)
-- =============================================================================
-- Uncomment this section to use WSL as your default shell
-- (and comment out the CONFIGURATION 1 section above)
-- return {
-- 	default_prog = { "wsl.exe", "--distribution", "Ubuntu" },
-- 	launch_menu = {
-- 		{
-- 			label = "WSL Ubuntu",
-- 			args = { "wsl.exe", "--distribution", "Ubuntu" },
-- 		},
-- 		{
-- 			label = "PowerShell (Modern)",
-- 			args = { "pwsh.exe", "-NoLogo" },
-- 		},
-- 	},
-- }
