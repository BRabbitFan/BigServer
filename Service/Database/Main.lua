-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-12 21:21:38
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-13 19:45:55
-- FilePath     : /BigServer/Service/Database/Main.lua
-- Description  : 数据库服务--服务入口
-- -----------------------------

local skynet = require "skynet"
local sharedata = require "skynet.sharedata"

local util = require "Util.SvrUtil"
local pbmap = require "Util.PbMap"

local Cmd = require "DatabaseCmd"
local Data = require "DatabaseData"
local Mysql = require "DatabaseMysql"
local Redis = require "DatabaseRedis"

skynet.start(function()
  skynet.dispatch("lua", function(session, source, cmd, ...)
    local func = Cmd[cmd]
    if func then
      skynet.retpack(func(...))
    end
  end)
end)