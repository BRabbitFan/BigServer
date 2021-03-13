-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-13 19:41:30
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-13 20:11:10
-- FilePath     : /BigServer/Service/Database/DatabaseMysql.lua
-- Description  : 数据库服务--mysql相关
-- -----------------------------

local mysql = require "skynet.db.mysql"

local db

local _M = {}

function _M.getConnect(host, port, database, user, password, maxPacketSize, onConnect)
  db = mysql.connect({
    host = host or "127.0.0.1",
    port = port or 3306,
    database = database or "skynet",
    user = user or "root",
    password = password or "123456",
    max_packet_size = maxPacketSize or (1024 * 1024),  --数据包最大字节数
    on_connect = onConnect or on_connect
  })
end

function _M.disConnect()
  db:disconnect()
end

return _M