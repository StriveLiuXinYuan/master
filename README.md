# brat

关系标注工具

## 安装

首先安装python2环境：

```sh
conda env create -n py27 --python=2.7
conda activate py27
```

然后启动brat服务：

```sh
python standalone.py
```

## 标注规则配置

详细文档见：https://github.com/deepint/BERT-Finetuner/blob/master/docs/%E5%85%B3%E7%B3%BB%E6%95%B0%E6%8D%AE%E6%96%87%E6%A1%A3.md

### BRAT格式

BRAT格式 是 BRAT 标注工具存储的格式，BRAT 标注工具内网在线演示：[http://192.168.51.109:8001/index.xhtml#/test/REL/test](http://192.168.51.109:8001/index.xhtml#/test/REL/test)

默认用户名和密码都是ypw。

配置方法见：[config.py](config.py#L50)

BRAT格式有两个文件：

* test.txt
* test.ann

其中 txt 是原文格式，ann 是标注格式。

下面是 txt 的样例：

```
报警人张三（123456199501231234）被骗，转账方式：微信转账，报警人：微信号123456789，对方：微信昵称：李四，微信号：abcdefg，银行卡号6666888899992222123。
```

下面是 ann 的部分样例：

```
T1	姓名 3 5	张三
T2	身份证号 6 24	123456199501231234
T3	微信号 70 77	abcdefg
T4	网络昵称 63 65	李四
R2	昵称 Arg1:T3 Arg2:T4	
```

除此之外BRAT还有配置文件：

| 文件名 | 作用 |
| ---- | ---- |
| annotation.conf | 标注规则 |
| kb_shortcuts.conf | 快捷键 |
| tools.conf | 插件 |
| visual.conf | UI |

#### 标注规则

[annotation.conf](https://github.com/deepint/BERT-Finetuner/blob/master/config/brat/relation_person_v1.0_template/annotation.conf)

实体填写在 entities 下面，使用 tab 控制层级关系，在不可选择的项前面加感叹号：

```
[entities]

!人
	姓名
	名字昵称
	网络昵称
	组织机构
```

![image](https://user-images.githubusercontent.com/50283848/104266780-4b19ac00-54cb-11eb-9b70-07866444a92a.png)

关系填写在 relation 下面，格式如下：

```
[relations]

<PER>=姓名|指代词|名字昵称|网络昵称|组织机构|隐含实体
<NUM>=银行卡号|手机号|QQ号|微信号|其他账号|支付宝账号

# 拥有
拥有 Arg1:<PER>, Arg2:身份证号|银行卡号|手机号|网络昵称|QQ号|微信号|支付宝账号|车牌号|其他账号|指代词|隐含实体

# 银行卡关系
开户行 Arg1:银行卡号, Arg2:组织机构
开户名 Arg1:银行卡号, Arg2:姓名|组织机构
```

![image](https://user-images.githubusercontent.com/50283848/104266816-5cfb4f00-54cb-11eb-93b4-fe841b8aef99.png)

如果一些实体经常出现，可以配置一个别名，比如 `<PER>=姓名|指代词|名字昵称|网络昵称|组织机构|隐含实体`。

#### 快捷键

[kb_shortcuts.conf](https://github.com/deepint/BERT-Finetuner/blob/master/config/brat/relation_group_v1.1_template/kb_shortcuts.conf)

一行一个快捷键，空格分隔，目前使用率不高。

```
Y 拥有
Z 转账
L 联系
M 冒充
Q 其他亲属
S 社会关系
```

#### 插件

[tools.conf](https://github.com/deepint/BERT-Finetuner/blob/master/config/brat/relation_group_v1.1_template/tools.conf)

划词搜索，内网环境下无用。

#### UI

[visual.conf](https://github.com/deepint/BERT-Finetuner/blob/master/config/brat/relation_group_v1.1_template/visual.conf)

这个很重要，用好了可以提高工作效率。

简称，在关系标注里没有用上：

```
[labels]
Person | Person
Organization | Organization | Org
GPE | Geo-political entity | GPE
```

实体或关系的颜色：

```
[drawing]
姓名	bgColor:#8fb2ff
组织机构	bgColor:#6fffdf
地址	bgColor:#7fe2ff

影子实体	dashArray:3-3, arrowHead:none
```

具体配置需要查询 SVG 语法。

## 在原有brat上做的工程改进 

1. 支持中文
2. 中文箭头优化

如果需要中文自动换行，需要在生成数据时，在标点符号后面增加空格
