-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 21:51:32
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-29 22:18:44
-- FilePath     : /BigServer/service/conf_svr/main.lua
-- Description  : 配置服务--服务入口
-- -----------------------------

--[[
  配置服务(conf_svr)只用于加载配置文件至sharedata, 服务在加载配置结束后立即销毁.
  这里的配置指供全局使用的只读对象, 包括游戏规则相关的配置(conf)以及网络协议相关的配置(proto).
  conf_svr通过loadConf()与loadProto()将其载入sharedata.
  当需要对配置进行更新时, 可使用reloadConf()与reloadProto()进行热更, 
--]]

local skynet = require "skynet"

skynet.start(function(
  
))