-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:53:10
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-16 15:45:51
-- FilePath     : /BigServer/Service/Agent/AgentCmd.lua
-- Description  : agent的命令
-- -----------------------------

local skynet = require "skynet"
local socket = require "skynet.socket"

local SVR = require "GlobalDefine.ServiceName"
local util = require "Util.SvrUtil"

local Data = require "AgentData"

local _M = {}

function _M.sendToClient(msgBytes)
  local sendBytes = string.pack(">s2", msgBytes)
  socket.write(Data.base.fd, sendBytes)
end

function _M.start(conf)
  util.log(" [Agent] [CMD.start] " .. util.tabToStr(conf))
  local base = Data.base
  base.fd = conf.fd
  base.gate = conf.gate
  skynet.send(SVR.gate, "lua", "forward", base.fd)
end

function _M.close(...)
  util.log(" [Agent] [CMD.close] ")
  skynet.send(SVR.login, "lua", "logout", Data.account.uid)
  local fd = Data.base.fd
  skynet.send(SVR.gate, "lua", "unforward", fd)
  skynet.exit()
end

return _M