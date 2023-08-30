-- Create the database.
/*
in order to continually update possible changes every
iteration the database will be dropped and created 
again, instead of using the line bellow
*/
-- CREATE DATABASE IF NOT EXISTS twitter_db;
DROP DATABASE IF EXISTS twitter_db;
CREATE DATABASE twitter_db;

-- Select the database to be used
USE twitter_db;

-- Create users table
/*
For the same reasons of keeping everything up to date the command
drop if exists will be used.
It is important to set the constraints appropiately in order 
to fullfill the app expecifications, i.e. unique and not null 
user_handle, mail, etc.
CHAR vs VARCHAR 
	- CHAR: less memmory needed but slower queries
    - VARCHAR: more memmory but faster queries
*/
DROP TABLE IF EXISTS users;
CREATE TABLE users(
	user_id INT AUTO_INCREMENT, 
    user_handle VARCHAR(50) NOT NULL UNIQUE, 
    email_address VARCHAR(100) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phonenumber CHAR(10) UNIQUE, 
    follower_count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT (NOW()), 
    PRIMARY KEY (user_id)
);


-- Create table followers
DROP TABLE IF EXISTS followers;
CREATE TABLE followers (
	follower_id INT NOT NULL, 
    following_id INT NOT NULL,
    -- IMPORTANT: create the relation between tables, we cannot create followers that
    -- that are not register in users table
    FOREIGN KEY (follower_id) REFERENCES users(user_id), 
    FOREIGN KEY (following_id) REFERENCES users(user_id), 
	PRIMARY KEY (follower_id, following_id)
    /* This primay key definition ensures the constraint that a user cannot
    follow more than one time other user since the relation 
    follower_id --> following_id has to be UNIQUE. */
);
-- Define followers constraints
-- Avoid auto following
ALTER TABLE followers
ADD CONSTRAINT check_follower_id
CHECK (follower_id != following_id);

-- Triggers
/*
We can add instructions that will be performed whenever that action
is triggered by some other occurence in the DB. 
For example, an interesting trigger is to update the followers count 
of a user whenever someone starts following him, that is, when an entry
is added to the table followers: 
follwer_id -> following_id 
then 
following_id, follower_count += 1
*/
DELIMITER $$
CREATE TRIGGER increase_follower_count
	AFTER INSERT ON followers    -- <----- This object we are inserted is later referred and access as the NEW object
    FOR EACH ROW
    BEGIN 
		UPDATE users SET follower_count = follower_count + 1
        WHERE user_id = NEW.following_id;
	END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER decrease_follower_count
	AFTER DELETE ON followers    -- <----- This object we are inserted is later referred and access as the NEW object
    FOR EACH ROW
    BEGIN 
		UPDATE users SET follower_count = follower_count - 1
        WHERE user_id = NEW.following_id;
	END $$
DELIMITER ;

-- Insert some example users to user's table.
INSERT INTO users (user_handle, email_address, first_name, last_name, phonenumber)
VALUES 
("max_rh", "mxrdhr@gmail.com", "Máximo", "Rodríguez", "999999999"), 
("midudev", "midudev@gmail.com", "Miguel", "Ángel", "234234234"), 
("jane_doe", "jane_doe@example.com", "Jane", "Doe", "123456789"), 
("john_smith", "john_smith@example.com", "John", "Smith", "987654321"), 
("lisa_jackson", "lisa_jackson@example.com", "Lisa", "Jackson", "555555555"), 
("alex_wong", "alex_wong@example.com", "Alex", "Wong", "777777777"), 
("sara_hernandez", "sara_hernandez@example.com", "Sara", "Hernandez", "111111111");

INSERT INTO followers (follower_id, following_id)
VALUES 
(1, 2), (1, 3), (4, 3), (2, 1), 
(7, 3), (2, 7), (6, 1), (4, 2);

-- Example get the 3 users with more followers.
SELECT user_handle, first_name, COUNT(followers.following_id) AS total_followers FROM users
JOIN followers ON users.user_id = followers.following_id
GROUP BY following_id
ORDER BY total_followers DESC
LIMIT 3;

-- Create tweets table
DROP TABLE IF EXISTS tweets;
CREATE TABLE tweets (
	tweet_id INT NOT NULL AUTO_INCREMENT, 
    user_id INT NOT NULL, 
    tweet_text VARCHAR(280) NOT NULL, 
    num_likes INT NOT NULL DEFAULT (0),
    num_retweets INT NOT NULL DEFAULT (0), 
    num_comments INT NOT NULL DEFAULT (0),
    created_at TIMESTAMP NOT NULL DEFAULT (NOW()), 
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    PRIMARY KEY (tweet_id)
);

-- Add some example tweets
INSERT INTO tweets (user_id, tweet_text)
VALUES 
(1, "hey first day using tweetter"), 
(7, "hiiii <3"), 
(5, "Morning coffee and some quiet time, best way to start the day ☕️"),
(3, "Heading out for a quick run, need to beat my personal record! 🏃‍♀️"),
(7, "Lazy Sunday vibes, just binge-watching my favorite series all day 📺"),
(2, "Back at the gym after a long break, feeling the burn already 💪"),
(6, "Experimenting with watercolors today, hoping for a masterpiece 🎨"),
(4, "Spontaneous road trip with friends, good music and open roads ahead 🚗🎶"),
(1, "Trying out meditation for the first time, aiming for inner peace 🧘‍♂️"),
(5, "Morning coffee and some quiet time, best way to start the day ☕️"),
(3, "Heading out for a quick run, need to beat my personal record! 🏃‍♀️"),
(7, "Lazy Sunday vibes, just binge-watching my favorite series all day 📺"),
(2, "Back at the gym after a long break, feeling the burn already 💪"),
(6, "Experimenting with watercolors today, hoping for a masterpiece 🎨"),
(4, "Spontaneous road trip with friends, good music and open roads ahead 🚗🎶"),
(1, "Trying out meditation for the first time, aiming for inner peace 🧘‍♂️");

-- Get how the number of tweets for every user
SELECT users.user_id, users.first_name, COUNT(tweets.user_id) AS total_tweets
FROM tweets
JOIN users on tweets.user_id = users.user_id
GROUP BY tweets.user_id
ORDER BY total_tweets DESC;

-- Subqueries example
-- -- Get the users with more than 2 tweets
SELECT user_id, first_name FROM users
WHERE user_id IN (
	SELECT user_id FROM tweets
	GROUP BY user_id
	HAVING COUNT(tweet_id) > 2
);


