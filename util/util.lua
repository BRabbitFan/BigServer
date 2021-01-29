-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 20:51:39
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-29 21:04:12
-- FilePath     : /BigServer/util/util.lua
-- Description  : 工具模块
-- -----------------------------

local _M = {}

local serpent = require "serpent"

---table -> string 转换
---@param tab table 待转换的table
---@alias typeString
---|> '"line"'   # 转为一行字符串(储存)
---|  '"block"'  # 保留table结构(打印)
---@param toType? typeString
---@return string str 转换后的字符串
function _M.tabToStr(tab, toType)
  if not tab or type(tab) ~= "table" then
    return nil
  end
  if type(toType) ~= "string" or toType == "line" then
    return serpent.line(tab, {comment = false})
  else
    return serpent.block(tab, {comment = false})
  end
end

---string -> table 转换
---@param str string 待转换的string
---@return table tab 转换后的table
function _M.strToTab(str)
  if not str or type(str) ~= "string" then
    return nil
  end
  local _, tab = serpent.load(str)
  return tab
end

return _M