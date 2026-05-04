local wezterm = require("wezterm")

------------------------------------------------------------------------------------------------------
-- Platform detection
-- プラットフォーム判定
------------------------------------------------------------------------------------------------------
local target_triple = wezterm.target_triple or ""
local is_windows = target_triple:find("windows") ~= nil
local is_linux = target_triple:find("linux") ~= nil

------------------------------------------------------------------------------------------------------
-- Base configuration
-- 共通設定
------------------------------------------------------------------------------------------------------
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.adjust_window_size_when_changing_font_size = false
config.use_ime = true

------------------------------------------------------------------------------------------------------
-- Window appearance
-- ウィンドウ外観
------------------------------------------------------------------------------------------------------
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.show_close_tab_button_in_tabs = true
config.window_background_opacity = 0.8

-- Linux-specific visual effect
-- Linux 固有の見た目設定
-- Windows では未設定のままにしておく
if is_linux then
  config.kde_window_background_blur = true
end

-- Windows は仮で Acrylic を有効化しておく
-- 必要に応じて Mica などに変更する
if is_windows then
  config.win32_system_backdrop = "Acrylic"
end

-- Color scheme
config.color_scheme = "Kanagawa (Gogh)"

------------------------------------------------------------------------------------------------------
-- Font
------------------------------------------------------------------------------------------------------
if is_linux then
  config.font = wezterm.font("DepartureMono Nerd Font Mono", {
    weight = "Medium",
    stretch = "Normal",
    style = "Normal",
  }) -- /usr/local/share/fonts/g/GohuFont11NerdFontMono_Regular.ttf, FontConfig pixel_sizes=[18]
end
config.font_size = 16

------------------------------------------------------------------------------------------------------
-- Padding
------------------------------------------------------------------------------------------------------
config.window_padding = {
  left = 0,
  right = 2,
  top = 0,
  bottom = "0.5cell",
}

------------------------------------------------------------------------------------------------------
-- Tab title separators
-- タブタイトルの装飾
------------------------------------------------------------------------------------------------------
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_ice_waveform_mirrored
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_ice_waveform

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"

  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end

  local edge_foreground = background
  local title_max_width = math.max(max_width - 6, 0)
  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, title_max_width) .. "   "

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

return config
