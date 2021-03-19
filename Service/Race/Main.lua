-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-12 21:22:29
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-12 21:22:38
-- FilePath     : /BigServer/Service/Race/Main.lua
-- Description  : 游戏服务--入口
-- -----------------------------

local skynet = require "skynet"
local sharedata = require "skynet.sharedata"

local util = require "Util.SvrUtil"

local Cmd = require "RaceCmd"
local Data = require "RaceData"

skynet.start(function()

  Data.GLOBAL_CONFIG = sharedata.query("CONF")

  skynet.dispatch("lua", function(session, source, cmd, ...)
    local func = Cmd[cmd]
    if func then
      skynet.retpack(func(...))
    end
  end)
end)