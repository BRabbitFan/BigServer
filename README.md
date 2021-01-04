# BigProject -- Server
毕业设计服务器端  --BRabbitFan

---
# 介绍
## 运用技术
- 后端框架 : skynet  
- 消息序列化 : protobuf + lua-protobuf
- 数据存储 : redis + mysql
## 

---
# 安装
## 依赖
```zsh
# prorobuf
sudo apt install autoconf automake libtool curl make g++ unzip
```
## 子模块
- skynet  
```zsh
cd skynet
make linux
```
<!-- - lua-5.4.2
```bash
cd lua-5.4.2
make linux
sudo make install
``` -->
- lua-protobuf
```bash
cd lua-protobuf
gcc -O2 -shared -fPIC pb.c -o pb.so
```
- prorobuf
```zsh
# 依赖
sudo apt-get install autoconf automake libtool curl make g++ unzip
# 安装
cd protobuf
./autogen.sh
./configure
make
sudo make install
sudo ldconfig
```