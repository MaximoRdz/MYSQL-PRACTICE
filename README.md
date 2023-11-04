## Table of Contents
1. [`twitter_db.sql`](https://github.com/MaximoRdz/MYSQL-PRACTICE/blob/main/twitter_db.sql)
### SQL Brief Summary
SQL is a language used for a database to query data. Insert, select, update and delete data from the table are the building blocks of SQL.
**RDBMS** (Relational DataBase Managements Systems): Software tool that controls the data (i.e. MySQL).
#### SELECT
1. Simple Queries
	```SQL 
	SELECT column1, column2, ...
	FROM mytable;
	```
	\* can be used to retrieve absolutely all the columns from the table.
1. Queries with constraints on numeric data
	```SQL 
	SELECT column1, column2, ...
	FROM mytable
	WHERE condition1
		AND/OR condition2
		AND/OR ...;
	```

	| Operator | Condition | SQL Example |
	| :--- | :---: | ---: |
	|=, !=, < <=, >, >=|Standard numerical operators|col_name != 4|
	|BETWEEN … AND …|Number is within range of two values (inclusive)|col_name BETWEEN 1.5 AND 10.5|
	|NOT BETWEEN … AND …|Number is not within range of two values (inclusive)|col_name NOT BETWEEN 1 AND 10|
	|IN (…)|Number exists in a list|col_name IN (2, 4, 6)|
	|NOT IN (…)|Number does not exist in a list|col_name NOT IN (1, 3, 5)|

1. Queries with constraints on text data

	| Operator | Condition | Example |
	|:---|:---:|---:|
	|=|Case sensitive exact string comparison (_notice the single equals_)|col_name = "abc"|
	|!= or <>|Case sensitive exact string inequality comparison|col_name != "abcd"|
	|LIKE|Case insensitive exact string comparison|col_name LIKE "ABC"|
	|NOT LIKE|Case insensitive exact string inequality comparison|col_name NOT LIKE "ABCD"|
	|%|Used anywhere in a string to match a sequence of zero or more characters (only with LIKE or NOT LIKE)|col_name LIKE "%AT%"  <br>(matches "AT", "ATTIC", "CAT" or even "BATS")|
	|_|Used anywhere in a string to match a single character (only with LIKE or NOT LIKE)|col_name LIKE "AN_"  <br>(matches "AND", but not "AN")|
	|IN (…)|String exists in a list|col_name IN ("A", "B", "C")|
	|NOT IN (…)|String does not exist in a list|col_name NOT IN ("D", "E", "F")|

1. Built-in database functions
	1. `COUNT(column)`: Retrieves the number of rows matching the query criteria
	2. `DISTINCT`: Removes duplicate values from a result set
	3. `LIMIT`: Restricts the number of rows retrieved from the database
	4. `OFFSET`: Used together with `LIMIT` to specify where to begin counting the number rows from
1. Ordering Results
	```sql
	SELECT column1, column2, … 
	FROM mytable 
	WHERE condition(s)
	ORDER BY column ASC/DESC;
	```

#### INSERT

### References 
- [SQL Bolt](https://sqlbolt.com/): Interactive well explained SQL fundamental lessons.
- [Advance DB Creation](https://www.youtube.com/watch?v=96s2i-H7e0w): MySQL database creation example. 
