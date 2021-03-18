-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-18 18:04:28
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-18 18:04:28
-- FilePath     : /BigServer/Service/GateNew/Main.lua
-- Description  : 网关--入口
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