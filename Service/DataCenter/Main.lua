-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-25 20:22:58
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 14:15:20
-- FilePath     : /BigServer/Service/DataCenter/Main.lua
-- Description  : 数据中心--服务入口
-- -----------------------------

local skynet = require "skynet"

local Cmd = require "DataCenterCmd"
local Data = require "DataCenterData"

skynet.start(function()
  skynet.dispatch("lua", function(session, source, cmd, ...)
    local func = Cmd[cmd]
    if func then
      skynet.retpack(func(...))
    end
  end)
end)