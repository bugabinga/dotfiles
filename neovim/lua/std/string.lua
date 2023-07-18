local function is_blank(string)
  return string == nil or string == '' or vim.trim(string) == ''
end

return {
  is_blank = is_blank,
}
