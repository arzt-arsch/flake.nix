-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'GruvboxDarkHard'

config.font = wezterm.font "Source Code Pro"

local function map(key, mods, action)
  local _map = {
    key = key,
    mods = mods,
    action = action,
  }
  return _map
end

wezterm.on('dec-opacity', function(window, _)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 0.8
  end
  overrides.window_background_opacity = overrides.window_background_opacity - 0.05
  window:set_config_overrides(overrides)
end)

wezterm.on('inc-opacity', function(window, _)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 0.8
  end
  overrides.window_background_opacity = overrides.window_background_opacity + 0.05
  window:set_config_overrides(overrides)
end)

config.keys = {
  map('x', 'META', act.ShowLauncher),
  map('s', 'META', act.SplitHorizontal),
  map('v', 'META', act.SplitVertical),
  map('q', 'META', act.CloseCurrentPane { confirm = false } ),

  map('h', 'META', act.ActivatePaneDirection 'Left'),
  map('j', 'META', act.ActivatePaneDirection 'Down'),
  map('k', 'META', act.ActivatePaneDirection 'Up'),
  map('l', 'META', act.ActivatePaneDirection 'Right'),

  map('h', 'META|CTRL', act.AdjustPaneSize { 'Left', 2 }),
  map('j', 'META|CTRL', act.AdjustPaneSize { 'Down', 2 }),
  map('k', 'META|CTRL', act.AdjustPaneSize { 'Up', 2 }),
  map('l', 'META|CTRL', act.AdjustPaneSize { 'Right', 2 }),

  map('z', 'META', act.TogglePaneZoomState),

  map('d', 'META|CTRL', act.EmitEvent 'inc-opacity'),
  map('u', 'META|CTRL', act.EmitEvent 'dec-opacity'),

  map('g', 'META', act.ActivateCopyMode ),

  map('u', 'META', act.RotatePanes 'CounterClockwise' ),
  map('d', 'META', act.RotatePanes 'Clockwise' ),

  map('n', 'META', act.ActivateTabRelative(1)),
  map('p', 'META', act.ActivateTabRelative(-1)),

  map('n', 'META|CTRL', act.SpawnTab 'CurrentPaneDomain' ),
}

config.disable_default_key_bindings = false
config.window_background_opacity = 0.8
config.force_reverse_video_cursor = true

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
window_decorations = "TITLE | RESIZE"

-- and finally, return the configuration to wezterm
return config
