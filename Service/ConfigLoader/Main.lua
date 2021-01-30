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

--[[
  配置服务(ConfigLoader)只用于加载配置文件至sharedata, 服务在加载配置结束后则退出.
  通过start指令传入参数, loadAll<boolean>指定是否加载所有文件, loadList<table>指定加载的文件.
  当需要热更重新加载配置文件时, 再起一个ConfigLoader即可.
--]]

local skynet = require "skynet"

local CMD = require "ConfigLoaderCmd"

skynet.start(function()
  skynet.dispatch("lua", function(session, source, cmd, ...)
    local f = CMD[cmd]
    if f then
      skynet.retpack(f(...))
    end
  end)
end)