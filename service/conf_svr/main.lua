-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 21:51:32
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-29 22:50:48
-- FilePath     : /BigServer/service/conf_svr/main.lua
-- Description  : 配置服务--服务入口
-- -----------------------------

--[[
  配置服务(conf_svr)只用于加载配置文件至sharedata, 服务在加载配置结束后则退出.
  这里的配置指供全局使用的只读对象, 包括游戏规则相关的配置(conf)以及网络协议相关的配置(proto).
  通过start指令传入参数, conf_svr将使用loadConf()与loadProto()载入配置到sharedata.
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