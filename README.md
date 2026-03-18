# WezTerm Configuration

This directory contains the shared WezTerm configuration for the team.

## Quick Start for Developers

### 1. Set up your local configuration

Copy the template to create your local config:

```bash
cp wezterm.local.template.lua wezterm.local.lua
```

### 2. Choose your shell

Edit `wezterm.local.lua` and uncomment ONE of:

**Option A: PowerShell (Windows native)**
```lua
config.default_prog = { "pwsh.exe", "-NoLogo" }
```

**Option B: WSL (Ubuntu)**
```lua
config.default_domain = 'WSL:Ubuntu'
config.default_prog = { 'bash', '-l' }
```

### 3. Reload WezTerm

- Press `Ctrl+Shift+R` to reload the config without restarting
- Or close and reopen WezTerm

## File Structure

- **`wezterm.lua`** — Main shared configuration (committed to Git)
- **`wezterm.local.template.lua`** — Template for local machine config (committed)
- **`wezterm.local.lua`** — Your personal config (ignored by Git, created from template)
- **`.gitignore`** — Prevents local config from being committed

## Important Notes

- ⚠️ **Never commit `wezterm.local.lua`** — it's for personal machine settings only
- To add new features/configs that all devs should have, edit `wezterm.lua`
- For personal GitHub tokens or other sensitive data, use environment variables instead of adding them to config files
- Changes to `wezterm.lua` take effect on `Ctrl+Shift+R` reload

## Customization

Any setting in the WezTerm config can be overridden in your `wezterm.local.lua`. See the main config comments for available options.
