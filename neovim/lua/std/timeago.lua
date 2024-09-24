--- credit goes to https://github.com/f-person/lua-timeago
local _ = {}

local words = {
  justnow = 'now',
  minute = { singular = '1 mi', plural = 'mis', },
  hour = { singular = '1 hr', plural = 'hrs', },
  day = { singular = '1 dy', plural = 'dys', },
  week = { singular = '1 wk', plural = 'wks', },
  month = { singular = '1 mo', plural = 'mos', },
  year = { singular = '1 yr', plural = 'yrs', },
}

---@param num number
---@return number
local function round( num ) return math.floor( num + 0.5 ) end

---@param time osdate
---@return string
function _.format( time )
  local now = os.time()
  local diff_seconds = os.difftime( now, time )
  if diff_seconds < 45 then return words.justnow end

  local diff_minutes = diff_seconds / 60
  if diff_minutes < 1.5 then return words.minute.singular end
  if diff_minutes < 59.5 then
    return round( diff_minutes ) .. ' ' .. words.minute.plural
  end

  local diff_hours = diff_minutes / 60
  if diff_hours < 1.5 then return words.hour.singular end
  if diff_hours < 23.5 then
    return round( diff_hours ) .. ' ' .. words.hour.plural
  end

  local diff_days = diff_hours / 24
  if diff_days < 1.5 then return words.day.singular end
  if diff_days < 7.5 then
    return round( diff_days ) .. ' ' .. words.day.plural
  end

  local diff_weeks = diff_days / 7
  if diff_weeks < 1.5 then return words.week.singular end
  if diff_weeks < 4.5 then
    return round( diff_weeks ) .. ' ' .. words.week.plural
  end

  local diff_months = diff_days / 30
  if diff_months < 1.5 then return words.month.singular end
  if diff_months < 11.5 then
    return round( diff_months ) .. ' ' .. words.month.plural
  end

  local diff_years = diff_days / 365.25
  if diff_years < 1.5 then return words.year.singular end
  return round( diff_years ) .. ' ' .. words.year.plural
end

return _
