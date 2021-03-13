-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-12 21:19:02
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-13 19:34:24
-- FilePath     : /BigServer/Service/Hall/Main.lua
-- Description  : 游戏大厅--服务入口
-- -----------------------------

local skynet = require "skynet"
local sharedata = require "skynet.sharedata"

local pbmap = require "Util.PbMap"
local util = require "Util.SvrUtil"

local ERROR_CODE = require "GlobalDefine.ErrorCode"

local Cmd = require "HallCmd"
local Data = require "HallData"

skynet.start(function()

  Data.GLOBAL_CONFIG = sharedata.query("CONF")

  skynet.dispatch("lua", function(session, source, cmd, ...)
    local func = Cmd[cmd]
    if func then
      skynet.retpack(func(...))
    end
  end)

end)