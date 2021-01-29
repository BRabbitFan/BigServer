-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-25 22:01:50
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-25 22:08:42
-- FilePath     : /BigServer/service/data_center/data_center_cmd.lua
-- Description  : 数据中心--服务命令
-- -----------------------------

local skynet = require "skynet"

local util = require "util.service_name"

local _M = {}

function _M.start(conf)
  util.setSvr(conf.svrName)
end

return _M