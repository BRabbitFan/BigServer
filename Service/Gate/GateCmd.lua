-- -----------------------------
-- symbol_custom_string_obkoro1: https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-06 16:12:35
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-06 17:00:51
-- FilePath     : /BigServer/Service/Gate/GateCmd.lua
-- Description  : 网关命令--处理其他服务的消息
-- -----------------------------

local skynet = require "skynet.manager"
local gateserver = require "snax.gateserver"

local util = require "Util.SvrUtil"

local DATA = require "GateData"

local _M = {}

---Agent启动后回调注册 (Agent已准备好)
---@param agent string 消息源地址(服务)
---@param fd string 对应的socket句柄
function _M.forward(agent, fd)
	util.log(" [Gate] [CMD] [forward] "..agent.." "..fd)
  DATA.agentToFd[agent] = fd
	gateserver.openclient(fd)
end

return _M