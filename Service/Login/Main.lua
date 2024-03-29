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

local skynet = require "skynet"

local Cmd = require "LoginCmd"

skynet.start(function()
  skynet.dispatch("lua", function(session, source, cmd, ...)
    local func = Cmd[cmd]
    if func then
      skynet.retpack(func(source, ...))
    end
  end)
end)