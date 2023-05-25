# Airbnb-数据分析报告

## 前言

- 数据报告最好具备以下5个部分：（1）分析背景或目的；（2）分析维度说明；（3）数据分析验证；（4）结论汇总；（5）业务建议。
- 专题分析，则需具备关键的两个部分：（1）数据分析验证；（2）结论建议。

## 1. 分析背景与目的

### 1.1 分析背景

 Airbnb成立于2008年，短短9年时间成为了短租民宿行业的巨头，并且仍在不断的冲击着传统酒店行业，抢占着这一市场。目前Airbnb作为一款社区平台类产品，其业务遍布了191个国家，我们的分析主要以探索为主，旨在发现Airbnb在做好了产品体验、房源美感、民宿共享服务之后，其务是否存在可以改进的地方。

Airbnb目前的市场背景：

- 短租民宿行业的绝对巨头；业务布局区域极广，和Facebook有的一拼，当时Airbnb的业务遍布全球191个国家。
- 产品和业务发展成熟，无论是客户端还是后端供应链系统，其研发的成熟型在当时可谓屈指可数。

### 1.2 提出分析问题

**探索airbnb产品的业务存在哪些可以改进的地方？**

获客：一款产品的发展中必然伴随着不断的迭代。例如在常见的AARRR模型中，第一个A（即获客）至关重要，因此提高新用户获取的数量和质量是不断监测并优化的一个工作，哪些渠道的效果更好，企业就要及时调整和增加此渠道的投入，哪些渠道的效果很差，就要及时查找原因并给出解决。

转化：转化即商业收益，因此转化漏斗分析也是数据分析中的关键环节，因此需要了解整个产品的业务转化情况，针对哪些流失率较高的漏斗环节进行改进？

针对分析的目的，提出以下三个方向目的：

- Airbnb的目标**用户群体**具有什么样的特征，以便于在付费投放获客时，精准的圈定出产品用户画像的人群，使获客的ROI变得更好。
- Airbnb获客阶段，哪些**推广渠道**是优质的，优质的条件 = 量大+转化率高。
- 在转化漏斗中哪里哪一个环节的流失率高，或者说哪一环节存在可提升的潜在机会。

## 2. 分析维度

将着重从airbnb的**用户画像**、**推广渠道分析、转化漏斗分析\*三个\***方面进行分析，去探索和分析airbnb在产品和业务上有哪些可以改进的地方，并给出实际性的建议，以提升和改进airbnb的渠道推广策略和产品设计。

### 2.1 用户画像分析

用户性别的分布特征、用户年龄的分布特征、用户地区的分布分布、中国地区去国外预定的地区占比。

### 2.2 推广渠道分析
每月新增用户、不同用户端的注册量、不同推广渠道的注册量、不同营销内容的注册量、不同推广渠道的转化率、不同营销内容的转化率

### 2.3 转化漏斗分析
注册用户占比、活跃用户（非僵尸用户）占比、下单用户占比、实际支付用户占比、复购用户占比

## 3. 数据表理解与预处理

### 3.1 数据集描述

数据集介绍：此数据集是kaggle上的一个竞赛项目，官方目的主要是用来制作目的地信息的预测模型。此数据聚集包含两张数据表，其中train_user表中为用户数据，sessions表中为行为数据。

数据集量：

- train_user：21w * 15
- sessions：104w * 6

### 3.2 列名称理解

**数据表名称：train_users**

| 字段名称                |                      |
| ----------------------- | -------------------- |
| id                      | 用户ID               |
| date_account_created    | 帐户创建日期         |
| date_first_booking      | 首次预订日期         |
| gender                  | 性别                 |
| age                     | 年龄                 |
| signup_method           | 注册方式             |
| signup_flow             | 用户注册页面         |
| language                | 语言偏好             |
| affiliate_channel       | 营销方式             |
| affiliate_provider      | 营销来源的供应商     |
| first_affiliate_tracked | 注册前第一个营销广告 |
| signup_app              | 注册来源             |
| first_device_type       | 注册时设备类型       |
| first_browser           | 注册浏览器           |
| country_destination     | 目的地国家           |

**数据表名称：sessions**

| 字段名称      | 字段含义                      |
| ------------- | ----------------------------- |
| user_id       | 主键；与users表中的“id”列连接 |
| action        | 埋点名称                      |
| action_type   | 操作事件类型                  |
| action_detail | 操作事件描述                  |
| device_type   | 设备类型                      |

### 3.2 数据预处理

数据分析之前需要对数据进行简单的加工处理，数据预处理是一个必不可少的步骤。

#### （1）重复值处理

- train_users：作为用户信息表，未避免重复用户影响统计，需要检验ID是否有重复值。
- sessions ：为用户会话记录表，存在一个用户多条记录，无需处理。

按照业务理解，用户表中的id应当是唯一非重复的，所以只需要**排查train_users中是否存在重复值**。执行SQL后得出：count_id = 0。说明train_users数据表中不存在重复值。

#### （2）缺失值处理

数据缺失数量较多，以下为**存在缺失值的列及处理办法**：

| 字段                    | 缺失值说明                           |
| ----------------------- | ------------------------------------ |
| date_first_booking      | 首次预定时间：存在缺失值数量124544个 |
| gender                  | 性别：存在缺失值数量95688个          |
| age                     | 年龄：存在缺失值数量87991个          |
| first_affiliate_tracked | 注册渠道：存在缺失值数量6065个       |
| first_browser           | 注册浏览器：存在缺失值数量27266个    |
| action_type             | 操作类型：存在缺失值数量1126204      |
| action_detail           | 操作详情：存在缺失值数量1126204个。  |

缺失原因推测及处理：date_first_booking(首次预定时间)数据如果缺失，在业务上可以理解为此用户为“未预定用户”，也就是没有下单的用户。性别、年龄由于客户端中这部分信息选填，空值为用户未填写。其他四个数据是由于前端统计时数据没有统计到。

处理：多数空值不需要处理；如果使用到字段如果出现空缺，可以简单的在***where条件排除掉空数据，再进行分析\***。

#### （3）异常值处理

- date_account_created异常值处理：date_account_created中最小值为‘0000-00-00 00:00:00’；因为此异常数据只有1条，所以删除此条数据。
- age（年龄）异常值处理：age（年龄）的异常数据非常多；0～150之间的数值都有，并且包含了2014、2015等数值。推测这些"脏数据"产生的原因是用户在客户端随意填写造成，分析时需要剔除这些异常数据。
### 3.4 数据清洗中使用的SQL

```sql
#检查数据中是否包含重复值
SELECT id, COUNT(id) AS count_id
FROM data.train_users
GROUP BY id
HAVING count_id > 1;

#通过以下SQL对每一列进行查询，通过替换where之后的条件，查询每一列包含的空值数量。
SELECT date_first_booking, COUNT(date_first_booking)
FROM data.train_users
WHERE date_first_booking = '0000-00-00 00:00:00';


#通过查看数据的极值（极大值、极小值）是否符合实际情况，来判断数据中是否存在异常值。
SELECT  min(age),max(age) FROM data.train_users;

#异常值处理：对于年龄不在7～75区间的数据删除（设置为0-空值）
SET sql_safe_updates = 1;
UPDATE data.train_users
SET age = 0
WHERE id NOT IN (
		SELECT id
		FROM (
			SELECT id
			FROM data.train_users
			WHERE age <= 75
				AND age >= 7
		) a
	);
```

## 4. 用户画像分析

### 4.1 用户性别分布特征

- 女性用户数量=63041、男性用户数量=54440，其中女性用户多于男性用户。

![image-20230416123915794](C:\Users\dong3\AppData\Roaming\Typora\typora-user-images\image-20230416123915794.png)

### 4.2 用户年龄分布

- airbnb的用户主要为“青年群体”（24岁~40岁）

![image-20230416125016254](C:\Users\dong3\AppData\Roaming\Typora\typora-user-images\image-20230416125016254.png)

### 4.3 用户不同地区（根据语言）分布

- 使用最多的语言排名前5的分别是英文、中文、法文、西班牙文、朝鲜文。
- 有超过90%的用户是英语国家（欧美）；airbnb是2013年开始进入中国市场的（此数据集止于2014年），所以此时中文用户数量虽然排名第二，但是占比却非常小。

![image-20230416125632146](C:\Users\dong3\AppData\Roaming\Typora\typora-user-images\image-20230416125632146.png)

![image-20230416125727421](C:\Users\dong3\AppData\Roaming\Typora\typora-user-images\image-20230416125727421.png)

### 4.4 中国用户去国外预订的地区占比

- 中国人去国外预定民宿最主要集中在美国、然后是法国，除了这两个国家外，样本中其他国家的数量非常少。
- 中国用户去国外预定，占比最多的是美国。其余国家占比很小，总和不到20%。

![image-20230416130240429](C:\Users\dong3\AppData\Roaming\Typora\typora-user-images\image-20230416130240429.png)

### 4.5 本章使用的SQL语句

```sql
#用户中女性用户的数量。
SELECT COUNT(id) AS '男性用户数量'
FROM data.train_users
WHERE gender = 'MALE';

#用户中男性用户的数量。
SELECT COUNT(id) AS '女性用户数量'
FROM data.train_users
WHERE gender = 'FEMALE';

#用户不同年龄的数量。
SELECT age, COUNT(id)
FROM data.train_users
GROUP BY age
HAVING age <> 0
ORDER BY age;

#用户不同语言的分布（通过手机系统语言数据）；
SELECT language, COUNT(language) AS lg_num
FROM data.train_users
GROUP BY language
ORDER BY lg_num;

#中国用户去国外预定的地区
SELECT language, country_destination, COUNT(country_destination) AS cd_num
FROM data.train_users
GROUP BY language, country_destination
HAVING language = 'zh'
ORDER BY cd_num DESC;
```


## 5. 流量渠道分析

### 5.1 每月新增用户

- airbnb用户增长呈几何倍数，并且从2012年2月之后开始快速增长。
- 此产品新用户的增加**存在季节性规律**：每年的7～10月，产品都会迎来用户增长的高峰，推测为夏季（北半球）是旅行的旺季，而短租本身就是旅行消费的一种。

![image-20230416131859132](C:\Users\dong3\AppData\Roaming\Typora\typora-user-images\image-20230416131859132.png)

### 5.2 不同用户端的注册量

- 此数据为2014年之前的数据，当时智能手机还没有像现在一样普及，用户的注册设备PC大于移动设备。苹果设备数量大于其他设备数量。

![image-20230416132436076](C:\Users\dong3\AppData\Roaming\Typora\typora-user-images\image-20230416132436076.png)

### 5.3 推广渠道分析

![image-20230416133356164](C:\Users\dong3\AppData\Roaming\Typora\typora-user-images\image-20230416133356164.png)

### 5.4 分析过程使用的SQL

```sql
#查询每个月（date_account_created）新增注册用户的数量
SELECT date_format(date_account_created, '%Y-%M') AS year_moth, COUNT(id)
FROM data.train_users
GROUP BY date_format(date_account_created, '%Y-%M')
ORDER BY year_moth;

#查询不同设备来源（first_device_type）注册的数量
SELECT first_device_type, COUNT(id) AS fdt_num
FROM data.train_users
GROUP BY first_device_type
ORDER BY fdt_num DESC;

#不同推广方式+渠道的注册数量
SELECT affiliate_channel, affiliate_provider, COUNT(id) AS ac_num
FROM data.train_users
GROUP BY affiliate_channel, affiliate_provider
ORDER BY ac_num DESC;

#不同推广方式+渠道的转化率
SELECT affiliate_channel, affiliate_provider, 
SUM(CASE WHEN date_first_booking <> '0000-00-00 00:00:00' THEN 1 ELSE 0 END) / COUNT(id) AS ac_ratio
FROM data.train_users
GROUP BY affiliate_channel, affiliate_provider
ORDER BY ac_ratio DESC;

#不同营销广告内容的注册数量
SELECT first_affiliate_tracked, COUNT(id) AS fat_num
FROM data.train_users
GROUP BY first_affiliate_tracked
ORDER BY fat_num DESC;

#不同营销广告内容的转化率
SELECT first_affiliate_tracked, 
SUM(CASE WHEN date_first_booking <> '0000-00-00 00:00:00' THEN 1 ELSE 0 END) / COUNT(id) AS fat_ratio
FROM data.train_users
GROUP BY first_affiliate_tracked
ORDER BY fat_ratio DESC;
```

## 6. 转化漏斗分析

### 6.1 漏斗分析图

- 漏斗图制作方法：https://zhuanlan.zhihu.com/p/268401510
- 搜索房源-->申请预定是流失率最高的一个环节

![image-20230416141632908](C:\Users\dong3\AppData\Roaming\Typora\typora-user-images\image-20230416141632908.png)

### 6.2 分析SQL语句

```sql
#用户总数量：对sessions表中的user_id进行group by，再统计数量，得出sessions表中所有的用户数量。
SELECT COUNT(*)  AS ‘用户总数量’
FROM (
	SELECT user_id
	FROM data.sessions
	GROUP BY user_id
) new_sessions;


#活跃用户的定义：按照用户的操作总次数，如果用户操作产品大于等于10次，就可以说明用户为偏活跃的用户，另一方面说明此用户不是僵尸用户。
SELECT COUNT(*)  AS ‘活跃用户总数量’
FROM (
	SELECT user_id
	FROM data.sessions
	GROUP BY user_id
	HAVING COUNT(user_id) >= 10
) active;

#注册用户：通过sessions表中的用户与注册用户表进行内关联，统计出sessions表中已注册用户数量
SELECT COUNT(*) AS ‘注册用户总数量’
FROM (
	SELECT user_id
	FROM data.sessions
	GROUP BY user_id
) new_sessions
	INNER JOIN data.train_users tu ON new_sessions.user_id = tu.id;

#下单用户：用户行为中“reservations”为预定（下单）操作，通过统计进行了“reservations”的用户（group by去重），得出下单用户的数量
SELECT COUNT(*) AS ‘下单用户总数量’
FROM (
	SELECT user_id
	FROM data.sessions
	WHERE action_detail = 'reservations'
	GROUP BY user_id
) booking;

#实际支付用户：用户行为中“payment_instruments”为支付操作，通过统计进行了“payment_instruments”的用户（group by去重），得出实际支付用户的数量
SELECT COUNT(*) AS ‘实际支付用户总数量’
FROM (
	SELECT user_id
	FROM data.sessions
	WHERE action_detail = 'payment_instruments'
	GROUP BY user_id
) payed;

#复购用户：通过统计进行了“payment_instruments”操作次数大于1次的用户（group by去重），得出实际复购用户的数量
SELECT COUNT(*) AS ‘复购支付用户总数量’
FROM (
	SELECT user_id
	FROM data.sessions
	WHERE action_detail = 'reservations'
	GROUP BY user_id
	HAVING COUNT(user_id) >= 2
) re_booking;
```

## 7. 分析结论与建议

### 7.1 用户画像总结

**结论：**

- 用户性别中，女性偏多，差距并没有非常大
- 用户年龄以中青年为主
- 截止2014年，用户分布地区最多的为欧美地区，其次是中国
- 中国用户预订的最多的其他国家是美国，占比高达90%以上。

**建议：**

根据年龄分布特征，建议SEO或者付费广告投放时，投放广告的流量结构要尽可能的接近airbnb的用户人群，例如青年女性群体。

### 7.2 流量渠道总结

**结论：**

- 2012开始快速增长，并且速度很快。
- 7～10月是旅行旺季、此时也是airbnb用户增长的旺季。
- 谷歌渠道用户量最大，但转化率低；email-marketing、naver虽然注册用户量少，但是转化率高；需要综合ROI判断选择哪个渠道扩大规模。

**建议：**

- 综合考虑ROI表现最好的渠道，同时要结合市场战略和多个指标综合考虑；email-marketing、naver虽然注册用户量少，但是转化率高，可以尽可能的尝试扩大规模。

### 7.3 转化漏斗总结

和其他电商产品类似，用户主要在搜索房源-->申请预定中流失，产品和运营需要更多的在此环节投入更大的精力，另外产品申请预定-->支付的流失率远高于其他电商类产品。
