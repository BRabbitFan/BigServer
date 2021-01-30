-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-30 14:06:40
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 14:08:23
-- FilePath     : /BigServer/Util/BaseUtil.lua
-- Description  : 基础工具模块--不需要在skynet服务中即可调用
-- -----------------------------

local serpent = require "serpent"

local _M = {}

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