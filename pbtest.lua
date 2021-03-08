package.path = "./3rd/lua-protobuf/?.lua;" .. package.path
package.cpath = "./3rd/lua-protobuf/?.so;" .. package.cpath
local protoc = require "protoc"
local pb = require "pb"
local serpent = require "serpent"

local util = require "Util.BaseUtil"


-- pb.loadfile "Proto/test.pb"
-- pb.loadfile "Proto/MessageId.pb"

-- -- protoc:load [[
-- --   message Phone {
-- --     optional string name        = 1;
-- --     optional int64  phonenumber = 2;
-- --  }
-- --  message Person {
-- --     optional string name     = 1;
-- --     optional int32  age      = 2;
-- --     optional string address  = 3;
-- --     repeated Phone  contacts = 4;
-- --  }
-- -- ]]

-- local data = {
--   id = 10000,
--   name = "fanjunhong",
--   age = 21,
--   email = "fanjh1999@gmail.com",
--   phone = {
--     {type = "WORK", number = "17689278657"},
--     {type = "HOME", number = "15059103986"},
--   },
--   mmssgg = {
--     date = 123,
--     sss = "321312",
--   },
-- }

-- local bytes = pb.encode("Packet.Person", data)
-- print(pb.tohex(bytes))

-- local msg = pb.decode("Packet.Person", bytes)
-- local str = util.tabToStr(msg, "block")
-- print(str)
-- local tab = util.strToTab(str)
-- print(tab.name)
-- print(tab.age)
-- print(tab.email)
-- print(tab.phone[1].type, tab.phone[1].number)
-- print(tab.phone[2].type, tab.phone[2].number)
-- print(tab.mmssgg.sss)


pb.loadfile "Proto/Base.pb"

-- local data = {
--   messageId = "MSG_B",
--   msg_b = {
--     num = 123,
--   }
-- }

-- local bytes = pb.encode("MSG.Message", data)
-- print(bytes)
-- print(pb.tohex(bytes))

-- local msg = pb.decode("MSG.Message", bytes)
-- -- local str = util.tabToStr(msg, "block")
-- -- print(str)
-- print(msg.messageId)
-- local realMsg = {}
-- if msg.messageId == "MSG_B" then
--   realMsg = msg.msg_b
-- end
-- print(util.tabToStr(realMsg, "block"))

local data = {
  num = 123,
}

local byte = pb.encode("MSG.msg_b", data)

local msgData = {
  message_name = "msg_b",
  message_byte = byte,
}

local b = pb.encode("MSG.Msg", msgData)

local d = pb.decode("MSG.Msg", b)
local msgName = d.message_name
print(msgName)

local d2 = pb.decode("MSG."..msgName, d.message_byte)
print(util.tabToStr(d2, "block"))