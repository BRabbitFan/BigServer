local skynet = require "skynet"
require "skynet.manager"
require "util"
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
  -- skynet.register(skynet.getenv("watchdog"))
  SetSvr("watchdog")
  gate = skynet.newservice("gate")
end)