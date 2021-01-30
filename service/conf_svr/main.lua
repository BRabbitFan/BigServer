-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 21:51:32
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 11:35:43
-- FilePath     : /BigServer/service/conf_svr/main.lua
-- Description  : 配置服务--服务入口
-- -----------------------------

--[[
  配置服务(conf_svr)只用于加载配置文件至sharedata, 服务在加载配置结束后则退出.
  通过start指令传入参数, loadAll<boolean>指定是否加载所有文件, loadList<table>指定加载的文件.
  当需要热更重新加载配置文件时, 再起一个conf_svr即可.
--]]

local skynet = require "skynet"

local CMD = require "conf_cmd"

skynet.start(function()
  skynet.dispatch("lua", function(session, source, cmd, ...)
    local f = CMD[cmd]
    if f then
      skynet.retpack(f(...))
    end
  end)
end)