-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-12 21:21:38
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-16 15:11:38
-- FilePath     : /BigServer/Service/Database/Main.lua
-- Description  : 数据库服务--服务入口
-- -----------------------------

local skynet = require "skynet"
local queue = require("skynet.queue")()

local util = require "Util.SvrUtil"

local Cmd = require "DatabaseCmd"
local Mysql = require "DatabaseMysql"
local Redis = require "DatabaseRedis"

skynet.start(function()
  skynet.dispatch("lua", function(session, source, cmd, ...)
    local func = Cmd[cmd]
    if func then
      skynet.retpack(queue(func, ...))
    end
  end)
end)