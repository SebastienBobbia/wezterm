-- wezterm.local.template.lua
-- ============================================================
-- LOCAL CONFIGURATION TEMPLATE
-- ============================================================
-- This file is a template for local machine-specific settings.
-- Instructions:
-- 1. Copy this file to wezterm.local.lua (in the same directory)
-- 2. Uncomment the shell configuration you prefer
-- 3. Do NOT commit wezterm.local.lua (it's in .gitignore)
-- ============================================================

-- Uncomment ONE of the following shell configurations:

-- ============ PowerShell (Windows native) ============
-- Use this for PowerShell as the default shell
config.default_prog = { "pwsh.exe", "-NoLogo" }

-- ============ WSL (Ubuntu via Windows Subsystem for Linux) ============
-- Uncomment BOTH lines below to use WSL, and comment out PowerShell above
-- config.default_domain = 'WSL:Ubuntu'
-- config.default_prog = { 'bash', '-l' }

-- ============ Additional Local Settings ============
-- Add any other machine-specific settings here (colors, fonts, etc.)
-- Examples:
-- config.font_size = 11
-- config.color_scheme = 'Dracula'
