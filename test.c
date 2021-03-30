/*
 * @Author       : BRabbitFan
 * @Date         : 2021-03-29 20:46:13
 * @LastEditer   : BRabbitFan
 * @LastEditTime : 2021-03-29 20:53:46
 * @FilePath     : /BigServer/test.c
 * @Description  : 
 */


#define PTYPE_TEXT      0   // text      文本消息
#define PTYPE_RESPONSE  1   // response  回应包消息
#define PTYPE_MULTICAST 2   // multicast 广播消息
#define PTYPE_CLIENT    3   // client    客户端消息
#define PTYPE_SYSTEM    4   // system    系统消息
#define PTYPE_HARBOR    5   // harbor    跨节点消息
#define PTYPE_SOCKET    6   // socket    套接字消息
#define PTYPE_ERROR     7   // error     错误消息
#define PTYPE_QUEUE     8   // queue     队列消息
#define PTYPE_DEBUG     9   // debug     debug消息
#define PTYPE_LUA       10  // lua       普通消息
#define PTYPE_SNAX      11  // snax      snax服务消息
