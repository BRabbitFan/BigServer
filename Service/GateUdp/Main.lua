-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-22 13:06:10
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-22 13:06:10
-- FilePath     : /BigServer/Service/GateUdp/Main.lua
-- Description  : UDP网关--入口
-- -----------------------------

local skynet = require "skynet"
local socket = require "skynet.socket"

local util = require "Util.SvrUtil"

local Cmd = require "GateCmd"

skynet.start(function()
  skynet.dispatch("lua", function(session, source, cmd, ...)
    local func = Cmd[cmd]
    if func then
      skynet.retpack(func(...))
    end
  end)
end)