-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-30 17:02:24
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 17:17:11
-- FilePath     : /BigServer/RobotClient/Client/Main.lua
-- Description  : 机器人客户端--客户端服务(模拟客户端)
-- -----------------------------

local skynet = require "skynet"

local DEF = require "ClientDef"

local CMD = require "ClientCmd"

local MSG = require "ClientMsg"

local DATA = require "ClientData"

local STATE = require "ClientState"

skynet.start(function()
  skynet.dispatch("lua", function(session, source, cmd, ...)
    local f = CMD[cmd]
    if f then
      skynet.retpack(f(...))
    end
  end)
  skynet.error("client start!!!!")
end)