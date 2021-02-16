## protobuf相关
0. 每个message的首字段为协议ID, 在MessageId.proto定义. 
1. 每个系统单独使用一个.proto文件定义协议. 
2. 若多个系统需要用到同样的message, 则将其在BaseMessage.proto中定义  
    -  应该尽量复用BaseMessage.proro中的message, 尽量避免重复定义. 