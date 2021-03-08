-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-06 16:12:35
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-08 13:30:31
-- FilePath     : /BigServer/Service/Gate/GateCmd.lua
-- Description  : 网关命令--处理其他服务的消息
-- -----------------------------

local gateserver = require "snax.gateserver"

local util = require "Util.SvrUtil"

local DATA = require "GateData"

local _M = {}

---Agent准备好后开启链接
---@param agent number 消息源地址(服务)
---@param fd string 对应的socket句柄
function _M.forward(agent, fd)
	util.log(" [Gate] [CMD] [forward] agent->"..agent.." fd->"..fd)
  if next(DATA.connection[fd]) then
		gateserver.openclient(fd)
	end
end

---Agent主动关闭连接
---@param agent number 消息源地址(服务)
---@param fd string 对应的socket句柄
function _M.unforward(agent, fd)
	util.log(" [Gate] [CMD] [unforward] agent->"..agent.." fd->"..fd)
	if next(DATA.connection[fd]) then
		gateserver.closeclient(fd)
	end
end

return _M