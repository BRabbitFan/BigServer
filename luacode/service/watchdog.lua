local skynet = require "skynet"

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
  end)

  gate = skynet.newservice("gate")
end)