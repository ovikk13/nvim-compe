local Context = {}

function Context:new(changedtick, manual)
  local this = setmetatable({}, { __index = self })
  this.changedtick = changedtick
  this.manual = manual
  this.lnum = vim.fn.line('.')
  this.col = vim.fn.col('.')
  this.bufnr = vim.fn.bufnr('%')
  this.filetype = vim.fn.getbufvar('%', '&filetype', '')
  this.before_line = string.sub(vim.fn.getline('.'), 1, this.col - 1)
  this.before_char = this:get_before_char(this.lnum, this.before_line)
  this.after_line = string.sub(vim.fn.getline('.'), this.col, -1)
  return this
end

--- get_input
function Context:get_input(start)
  return string.sub(self.before_line, start)
end

--- get_before_char
function Context:get_before_char(lnum, before_line)
  local current_lnum = lnum
  while current_lnum > 0 do
    local line = current_lnum == lnum and before_line or vim.fn.getline(current_lnum)
    local _, _, c = string.find(line, '([^%s])%s*$')
    if c ~= nil then
      break
    end
    current_lnum = current_lnum - 1
  end
  return string.sub(before_line, #before_line, #before_line)
end

return Context

