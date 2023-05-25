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