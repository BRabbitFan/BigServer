-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2020-12-31 18:28:01
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-05 17:01:02
-- FilePath     : /BigServer/luacode/service/watchdog.lua
-- Description  : 网关服务---watchdog
-- -----------------------------

---require------------------------------------------------------------------------------------------

local skynet = require "skynet"
require "skynet.manager"
require "util.service_name"

---global-------------------------------------------------------------------------------------------

---local--------------------------------------------------------------------------------------------

local CMD = {}
local SOCKET = {}
local gate
local agent = {}

---global-function----------------------------------------------------------------------------------

---local-function-----------------------------------------------------------------------------------

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
