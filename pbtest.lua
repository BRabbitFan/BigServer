package.path = "./3rd/lua-protobuf/?.lua;" .. package.path
package.cpath = "./3rd/lua-protobuf/?.so;" .. package.cpath
local protoc = require "protoc"
local pb = require "pb"
local serpent = require "serpent"

local trans = require "util.trans"


pb.loadfile "proto/test.pb"
pb.loadfile "proto/examp.pb"

-- protoc:load [[
--   message Phone {
--     optional string name        = 1;
--     optional int64  phonenumber = 2;
--  }
--  message Person {
--     optional string name     = 1;
--     optional int32  age      = 2;
--     optional string address  = 3;
--     repeated Phone  contacts = 4;
--  }
-- ]]

local data = {
  name = "fanjunhong",
  age = 21,
  email = "fanjh1999@gmail.com",
  phone = {
    {type = "WORK", number = "17689278657"},
    {type = "HOME", number = "15059103986"},
  }
}

local bytes = pb.encode("Packet.Person", data)
print(pb.tohex(bytes))

local msg = pb.decode("Packet.Person", bytes)
local str = trans.tabToStr(msg, "block")
print(str)
local tab = trans.strToTab(str)
print(tab.name)
print(tab.age)
print(tab.email)
print(tab.phone[1].type, tab.phone[1].number)
print(tab.phone[2].type, tab.phone[2].number)

data = {
  exname = "testex",
}

bytes = pb.encode("Packet.EX", data)
print(pb.tohex(bytes))

local msg = pb.decode("Packet.EX", bytes)
local str = trans.tabToStr(msg, "block")
print(str)