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

local CMD = require "DataCenterCmd"

---全局Agent列表
---@type table<uid, agent>
AgentList = {}

---全局Fd列表
---@type table<agent, fd>
FdList = {}

skynet.start(function()
  skynet.dispatch("lua", function(session, source, cmd, ...)
    local f = CMD[cmd]
    if f then
      skynet.retpack(f(...))
    end
  end)
end)