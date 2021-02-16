-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 21:42:53
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-02-16 18:49:15
-- FilePath     : /BigServer/Util/PbMap.lua
-- Description  : lua-protobuf的再封装, 方便使用
-- -----------------------------

--[[
  统一消息格式:
  1-2字节 : 消息长度; 3字节开始为消息包.
  消息包第一个字段为消息Id(MessageId.proto中定义)

--]]

local pb = require "pb"

local _M = {}

local PB_SRC = "Proto/"   -- pb文件路径
local PACKET = "Packet."  -- 统一的Packet

local pbList = {
  PB_SRC.."MessageId.pb",  -- 消息Id
  PB_SRC.."Base.pb",       -- 基础消息
  PB_SRC.."test.pb",       -- 测试消息
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


function _M.pack(msgName, msgTab)
  local msgStr = pb.encode(PACKET..msgName, msgTab)
  return msgStr
end

function _M.unpack(msgName, msgStr)
  local msgTab = pb.decode(PACKET..msgName, msgStr)
  return msgTab
end

return _M.load()