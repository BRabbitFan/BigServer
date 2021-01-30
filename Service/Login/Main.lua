-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-30 15:42:12
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 15:46:00
-- FilePath     : /BigServer/Service/Login/Main.lua
-- Description  : 登录服务
-- -----------------------------

--[[
  登录服务是一个无状态的服务, 其只用于验证用户登录, 且只与watchdog通讯
--]]

local skynet = require "skynet"

local CMD = require "LoginCmd"

skynet.start(function()
  skynet.dispatch("lua", function(session, source, cmd, ...)
    local f = CMD[cmd]
    if f then
      skynet.retpack(f(...))
    end
  end)
end)