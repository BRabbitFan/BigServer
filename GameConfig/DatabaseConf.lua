-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-15 17:28:48
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-16 15:02:22
-- FilePath     : /BigServer/GameConfig/DatabaseConf.lua
-- Description  : 数据库配置
-- -----------------------------

return {
  MYSQL_CONF = {
    host = "127.0.0.1",
    port = 3306,
    database = "big_server",
    user = "jhfan",
    password = "0324Fanjh1556",
    maxPacketSize = (1024 * 1024),
  },

  MYSQL_ERRNO = {
    DUPLICATE_ENTRY = 1062;
  },

  REDIS_CONF = {
    host = "127.0.0.1",
    port = 6379,
    db = 1,
    auth = nil,
  },

  REDIS_KEY_HEAD = {
    USER_INFO = "user_info_",  -- user_info_(uid)
    ACCOUNT_TO_UID = "account_to_uid",
  },

}
