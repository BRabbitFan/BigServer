-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-30 15:45:17
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 16:00:41
-- FilePath     : /BigServer/Service/Login/LoginCmd.lua
-- Description  : 登录服务--服务器指令
-- -----------------------------

local skynet = require "skynet"
local socket = require "skynet.socket"

local pbmap = require "Util.PbMap"
local util = require "Util.SvrUtil"

local ERROR_CODE = require "GlobalDefine.ErrorCode"
local SVR = require "GlobalDefine.ServiceName"

local Data = require "LoginData"

local _M = {}

function _M.start(source, conf)
  util.log("[Login][Cmd][start]"..
           " source->"..tostring(source)..
           " conf->"..util.tabToStr(conf, "block"))
  util.setSvr(conf.svrName)
end

local function getNewToken()
  util.log("[login][Cmd][getNewToken]")
  Data.maxToken = Data.maxToken + 1
  return Data.maxToken
end

function _M.chkToken(gate, fd, baseBytes, ip, port, source)
  util.log("[login][Cmd][chkToken]")
  local msgName, msgTable = pbmap.unpack(baseBytes)
  if msgName ~= "ReqSyncPort" then
    return
  end

  if msgTable.portType == 1 then
    util.log("[login][Cmd][chkToken]portType1")
    local token = getNewToken()
    Data.waitChk[token] = {
      token = token,
      fd = fd,
      recvAddr = source,
    }
    skynet.sleep(10)
    socket.udp_connect(fd, ip, 8001)
    socket.write(fd, pbmap.pack("RetSyncPort", {
      token = token,
    }))

  elseif msgTable.portType == 2 then
    util.log("[login][Cmd][chkToken]portType2")
    local token = msgTable.token or -1
    local info = Data.waitChk[token]
    if not info then
      return
    end
    local agent = skynet.newservice("Agent")
    skynet.call(agent, "lua", "start", {
      mode = "udp",
      fd = fd,
      sendAddr = source,
      recvAddr = info.recvAddr,
    })
    skynet.send(SVR.gate, "lua", "forward", source, agent)
    Data.waitChk[token] = nil

  end
end

---用户登录
---@param source number 源地址
---@param account string 用户名
---@param password string 密码
---@return integer errorCode 错误码
---@return table info 用户的信息
function _M.login(source, account, password)
  util.log("[Login][Cmd][login]"..
           " source->"..tostring(source)..
           " account->"..tostring(account)..
           " password->"..tostring(password))
  -- 检查是否已注册
  local errorCode = skynet.call(SVR.dataCenter, "lua", "chkIsRegisterByAccount", account)
  if errorCode == ERROR_CODE.BASE_FAILED then
    return ERROR_CODE.LOGIN_ACOUNT_NOT_EXISTS
  end
  -- 检查是否已登录
  local _, info = skynet.call(SVR.database, "lua", "getPlayerInfoByAccount", account)
  errorCode = skynet.call(SVR.dataCenter, "lua", "chkIsLoginByUid", info.uid)
  if errorCode == ERROR_CODE.BASE_SUCESS then
    return ERROR_CODE.LOGIN_SIGNED_IN_ALREADY
  end
  -- 检查密码
  if password ~= info.password then
    return ERROR_CODE.LOGIN_PASSWORD_WRONG
  end
  -- 向数据中心登记客户端已登录
  errorCode = skynet.call(SVR.dataCenter, "lua", "setPlayerLogin", info.uid, source)
  if errorCode ~= ERROR_CODE.BASE_SUCESS then
    return errorCode
  end
  return ERROR_CODE.BASE_SUCESS, info
end

---用户登出
---@param source number 源地址
---@param uid integer uid
function _M.logout(source, uid)
  util.log("[Login][Cmd][logout]"..
           " source->"..tostring(source)..
           " uid->"..tostring(uid))
  skynet.call(SVR.dataCenter, "lua", "setPlayerLogout", uid)
end

---用户注册
---@param source number 源地址
---@param account string 账号
---@param password string 密码
---@param name string 名字
---@return integer errorCode 错误码
function _M.register(source, account, password, name)
  util.log("[Login][Cmd][register]"..
           " source->"..tostring(source)..
           " account->"..tostring(account)..
           " password->"..tostring(password)..
           " name->"..tostring(name))
  local errorCode, result = skynet.call(SVR.database, "lua", "setPlayerInfo", {
    account = account,
    password = password,
    name = name,
  })
  if errorCode == ERROR_CODE.DB_MYSQL_DUPLICATE_ENTRY then
    return ERROR_CODE.REGISTER_ACOUNT_EXISTS
  elseif errorCode ~= ERROR_CODE.BASE_SUCESS then
    return errorCode, result
  end
  skynet.call(SVR.dataCenter, "lua", "setPlayerRegister", tostring(account))
  return ERROR_CODE.BASE_SUCESS
end

return _M