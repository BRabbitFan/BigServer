-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 21:51:32
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 14:35:23
-- FilePath     : /BigServer/Service/ConfigLoader/Main.lua
-- Description  : 配置服务--服务入口
-- -----------------------------

local skynet = require "skynet"

local util = require "Util.SvrUtil"

local Cmd = require "ConfigLoaderCmd"

skynet.start(function()
  skynet.dispatch("lua", function(session, source, cmd, ...)
    local f = Cmd[cmd]
    if f then
      skynet.retpack(f(...))
    end
  end)
end)