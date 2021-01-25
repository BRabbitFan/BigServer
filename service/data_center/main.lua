-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-25 20:22:58
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-25 22:27:51
-- FilePath     : /BigServer/service/data_center/main.lua
-- Description  : 数据中心--服务入口
-- -----------------------------

local skynet = require "skynet"

local util = require "util.service_name"
local CMD = require "data_center.cmd"

---全局Agent列表
---@type table<uid, agent>
agentList = {}

---全局Fd列表
---@type table<agent, fd>
fdList = {}

skynet.start(function()
  skynet.dispatch("lua", function(session, source, cmd, ...)
    local f = CMD[cmd]
    if f then
      skynet.retpack(f(...))
    end
  end)
end)