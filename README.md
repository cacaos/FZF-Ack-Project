# FZF-Ack-Project

> 使用 **FZF** / **Ack**检索时,指定检索名录为项目根目录

*仅当编译时加入 **|+file_in_path|** 特性才有效*

### 安装:

- vim8:
  获取FZF-Ack-Project文件夹, 移动至`$vim\vimfiles\pack\{script-name}\start\`目录下

### 使用:

- FZF

```shell
  #检索项目中任意位置文件
  #FZF
  :FZF -q filename projectDir
  #RFZF
  :RFZF filename
```
- Ack

```shell
  #检索项目中任意位置字符
  #Ack
  :Ack str projectDir
  #RAck
  :RAck str 
```
### 自定义
```vim
# 设置项目标识文件
let g:Project_Identification_Files = ['pom.xml','.gitignore','README','build.xml', 'Makefile', '.project', '.vimrc']
```
**根据项目标识文件来确定项目根目录,若找不到有效标识文件,将持续向上查找至盘符根目录 : )*

