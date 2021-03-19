-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-13 19:08:00
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-13 19:08:10
-- FilePath     : /BigServer/Service/Room/Main.lua
-- Description  : 房间服务--服务入口
-- -----------------------------

local skynet = require "skynet"
local sharedata = require "skynet.sharedata"

local util = require "Util.SvrUtil"

local Data = require "RoomData"
local Cmd = require "RoomCmd"

skynet.start(function()

  Data.GLOBAL_CONFIG = sharedata.query("CONF")

  skynet.dispatch("lua", function(session, source, cmd, ...)
    local func = Cmd[cmd]
    if func then
      skynet.retpack(func(...))
    end
  end)
end)