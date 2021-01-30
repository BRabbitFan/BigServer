-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-30 16:00:54
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 16:52:26
-- FilePath     : /BigServer/GlobalDefine/ErrorCode.lua
-- Description  : 错误码/状态码
-- -----------------------------

--[[

  状态码由6位数字构成
  1位   : 基本状态 1->成功 2->失败 3->错误 4->其他 (失败是合法的错误, 如比大小输了)
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
  -- 基本状态
  BASE_SUCESS          = 100001,  -- 成功
  BASE_SUCESS_WITH_MSG = 100002,  -- 成功, 并携带一条string信息
  BASE_FAILED          = 200001,  -- 失败
  BASE_FAILED_WITH_MSG = 200002,  -- 失败, 并携带一条string信息
--BASE_ERROR           = 300001,  -- 错误 (禁用)
  BASE_ERROR_WITH_MSG  = 300002,  -- 错误, 并携带一条string信息

  -- Login服务相关(01)
  REGISTER_ACOUNT_EXISTS    = 301001,  -- 注册失败, 用户名已存在
  REGISTER_ACOUNT_ILLEGAL   = 301002,  -- 注册失败, 用户名非法
  REGISTER_PASSWORD_ILLEGAL = 301003,  -- 注册失败, 密码非法
  LOGIN_ACOUNT_NON_EXISTS   = 301004,  -- 登录失败, 用户名不存在
  LOGIN_PASSWORD_WRONG      = 301005,  -- 登录失败, 密码错误
  LOGIN_SIGNED_IN_ALREADY   = 301006,  -- 登录失败, 已登录
}