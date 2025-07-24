-- ***********************************************
-- ** pyflowenv/utils/time_utils.lua            **
-- ** ----------------------------------------- **
-- ** FR : Fonctions utilitaires de gestion du  **
-- **      temps (formatage relatif, etc.)      **
-- ** EN : Time utility functions (relative,    **
-- **      ISO, absolute formatting)            **
-- ***********************************************

local M = {}

-- **************************************************************
-- * Relative time formatter (à l’instant, il y a X minutes...) *
-- **************************************************************
---@param timestamp_string string -- format: "YYYY-MM-DD HH:MM:SS"
---@return string
function M.format_relative_time(timestamp_string)
  local lang = require("pyflowenv.lang").get()

  if type(timestamp_string) ~= "string" then
    return "?"
  end

  local y, m, d, h, min, s = timestamp_string:match "^(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)$"
  if not (y and m and d and h and min and s) then
    return "?"
  end

  local time = os.time {
    year = assert(tonumber(y)),
    month = assert(tonumber(m)),
    day = assert(tonumber(d)),
    hour = assert(tonumber(h)),
    min = assert(tonumber(min)),
    sec = assert(tonumber(s)),
  }

  local now = os.time()
  local diff = os.difftime(now, time)

  local seconds = math.floor(diff)
  local minutes = math.floor(seconds / 60)
  local hours = math.floor(minutes / 60)
  local days = math.floor(hours / 24)
  local months = math.floor(days / 30)
  local years = math.floor(days / 365)

  if seconds < 60 then
    return lang.time.now
  elseif minutes < 60 then
    return string.format(lang.time.minutes, minutes)
  elseif hours < 24 then
    return string.format(lang.time.hours, hours)
  elseif days < 30 then
    return string.format(lang.time.days, days)
  elseif months < 12 then
    return string.format(lang.time.months, months)
  else
    return string.format(lang.time.years, years)
  end
end

return M
