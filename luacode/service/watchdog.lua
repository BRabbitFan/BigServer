-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2020-12-31 18:28:01
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-19 21:58:38
-- FilePath     : /BigServer/luacode/service/watchdog.lua
-- Description  : 网关服务---watchdog
-- -----------------------------

local skynet = require "skynet"
require "skynet.manager"
require "util.service_name"

local CMD = {}
local SOCKET = {}
local gate
local agent = {}

skynet.start(function()
  skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
    if cmd == "socket" then
      local f = SOCKET[subcmd]
      local suc, ret = pcall(f, ...)
    end
    skynet.retpack(true)
  end)
  util.setSvr("watchdog")
  gate = skynet.newservice("gate")
end)
