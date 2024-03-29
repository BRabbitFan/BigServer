-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-30 16:00:54
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-16 14:21:04
-- FilePath     : /BigServer/GlobalDefine/ErrorCode.lua
-- Description  : 错误码/状态码
-- -----------------------------

--[[

  状态码由6位数字构成
  1位   : 基本状态 1->成功 2->失败 3->错误 4->其他 (失败是合法的错误)
  2-3位 : 服务, 如 00->基础 01->Login 等
  4-6位 : 状态, 由各服务自行决定
  1 | 01 | 001

  状态命名 定义规则:
  1. 状态名统一使用lua常量名方式(大写+下划线)
  2. 状态名推荐格式: 操作_错误原因 如 REGISTER_ACOUNT_EXISTS
  3. 所有成功状态必须在基本状态内定义, 成功状态应尽量使用现有基本状态.
  4. 失败状态应该尽量在服务专属的范围内定义, 以在返回处得到更精确的提示, 应该避免携带消息.

--]]

return {
  -- 基本状态(00)
  BASE_SUCESS          = 100001,  -- 成功
  BASE_SUCESS_WITH_MSG = 100002,  -- 成功, 并携带一条string信息
  BASE_SUCESS_WITH_TAB = 100003,  -- 成功, 并携带一条table信息
  BASE_FAILED          = 200001,  -- 失败
  BASE_FAILED_WITH_MSG = 200002,  -- 失败, 并携带一条string信息
  BASE_FAILED_WITH_TAB = 200003,  -- 失败, 并携带一条table信息
--BASE_ERROR           = 300001,  -- 错误 (禁用)
  BASE_ERROR_WITH_MSG  = 300002,  -- 错误, 并携带一条string信息
  BASE_ERROR_WITH_TAB  = 300003,  -- 错误, 并携带一条table信息

  -- DataCenter服务相关(01)

  -- Database服务相关(02)
  DB_MYSQL_ERROR_WITH_MSG   = 202001,  -- Mysql执行失败, 并携带一条string信息
  DB_REDIS_ERROR_WITH_MSG   = 202002,  -- Redis执行失败, 并携带一条string信息
  DB_MYSQL_ERROR_WITH_TAB   = 202003,  -- Mysql执行失败, 并携带一条table信息
  DB_REDIS_ERROR_WITH_TAB   = 202004,  -- Redis执行失败, 并携带一条table信息
  DB_MYSQL_DUPLICATE_ENTRY  = 202005,  -- Mysql插入失败, 重复条目
  DB_REDIS_HGET_EMPTY       = 202006,  -- Redis HGET操作失败, 空返回
  DB_REDIS_GET_EMPTY        = 202007,  -- Redis GET操作失败, 空返回
  DB_ACCOUNT_EMPTY          = 202008,  -- 数据库操作失败, 没有此账号
  DB_REDIS_ERROR            = 302001,  -- Redis操作错误

  -- Agent服务相关(03)

  -- Login/Register服务相关(04)
  REGISTER_ACOUNT_EXISTS    = 204001,  -- 注册失败, 用户名已存在
  REGISTER_ACOUNT_ILLEGAL   = 204002,  -- 注册失败, 用户名非法
  REGISTER_PASSWORD_ILLEGAL = 204003,  -- 注册失败, 密码非法
  LOGIN_ACOUNT_NOT_EXISTS   = 204004,  -- 登录失败, 用户名不存在
  LOGIN_PASSWORD_WRONG      = 204005,  -- 登录失败, 密码错误
  LOGIN_SIGNED_IN_ALREADY   = 204006,  -- 登录失败, 已登录

  -- Hall服务相关(05)
  HALL_ROOM_NUM_MAX         = 205001,  -- 创建房间失败, 房间数量已满
  HALL_PLAYER_NUM_FULL      = 205002,  -- 进入房间失败, 房间已满员
  HALL_ROOM_MAP_SAME        = 205003,  -- 房间地图与之前的一致
  HALL_INFO_NOT_EXISTS      = 305001,  -- 查询大厅信息错误, 大厅信息不存在
  HALL_ROOM_NOT_EXISTS      = 305002,  -- 错误, 房间不存在

  -- Room服务相关(06)
  ROOM_PLAYER_FULL          = 206001,  -- 房间已满员
  ROOM_READY_SAME           = 206002,  -- 失败, 前后准备状态一致
  ROOM_NOT_MASTER           = 206003,  -- 失败, 玩家不是房主
  ROOM_MAP_SAME             = 206004,  -- 失败, 前后房间Id一致
  ROOM_PLAYER_NOT_EXISTS    = 306001,  -- 错误, 玩家不存在

  -- Race服务相关(07)
  RACE_NOT_ALL_READY        = 207001,  -- 失败, 有玩家还未准备
  RACE_PLAYER_NOT_EXISTS    = 307001,  -- 错误, 玩家不存在
}