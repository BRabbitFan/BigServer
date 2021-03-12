-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 21:42:53
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-12 16:39:15
-- FilePath     : /BigServer/Util/PbMap.lua
-- Description  : lua-protobuf的再封装, 方便使用
-- -----------------------------

local pb = require "pb"

local _M = {}

local PB_SRC = "Proto/"         -- pb文件路径
local PACKET = "Packet."        -- 统一的Packet
local BASE_MSG = "BaseMessage"  -- 统一外层消息名

local pbList = {
  PB_SRC.."Base.pb",       -- 基础消息
}

---加载pb文件
---模块require时调用, 也可用于热更协议
---@param loadList table 消息文件列表
---@return module PbMap 返回模块
function _M.load(loadList)
  loadList = loadList or pbList

  for _, pbFile in pairs(loadList) do
    pb.loadfile(pbFile)
  end

  return _M
end

---打包消息
---@param msgName string 消息名(对应proto消息名)
---@param msgTable table 内层消息(table格式)
---@return string baseBytes 外层消息(bytes格式)
function _M.pack(msgName, msgTable)
  local msgBytes = pb.encode(PACKET..msgName, msgTable)

  local BaseTable = {
    name = msgName,
    bytes = msgBytes,
  }
  local baseBytes = pb.encode(PACKET..BASE_MSG, BaseTable)

  return baseBytes
end

---解包消息
---@param baseBytes string 外层消息(bytes格式)
---@return string msgName 内层消息名
---@return table msgTable 内层消息(table格式)
function _M.unpack(baseBytes)
  local baseTable = pb.decode(PACKET..BASE_MSG, baseBytes)
  local msgName = baseTable.name
  local msgBytes = baseTable.bytes
  local msgTable = pb.decode(PACKET..tostring(msgName), msgBytes)
  return msgName, msgTable
end

return _M.load()