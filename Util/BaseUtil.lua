-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-30 14:06:40
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-06 15:01:28
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

---获得table的长度(value的个数)
---用于当索引不为连续整数时
---@param table table 取长度的table
---@return integer len 长度
function _M.tabLen(table)
  local len = 0
  for _, _ in pairs(table) do
    len = len + 1
  end
  return len
end

---根据index获取table的值
---用于当索引不为连续整数时, 按照lua虚拟机中的存储顺序获得值
---@param table table 取长度的table
---@param index number 索引
---@return value any 对应index的value
function _M.getValByIdx(table, index)
  for key, value in pairs(table) do
    if index == 1 then
      return value
    else
      index = index - 1
    end
  end
  return false
end

return _M