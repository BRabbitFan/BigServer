-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-25 22:01:50
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 14:14:57
-- FilePath     : /BigServer/Service/DataCenter/DataCenterCmd.lua
-- Description  : 数据中心--服务命令
-- -----------------------------

local skynet = require "skynet"

local util = require "Util.SvrUtil"

local _M = {}

function _M.start(conf)
  util.setSvr(conf.svrName)
end

return _M