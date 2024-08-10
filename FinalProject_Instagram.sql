create table Users(
	user_id serial primary key,
	name varchar(50) not null,
	email varchar(100) unique not null,
	phone_number varchar(20) unique
);


create table Posts(
	post_id serial primary key,
	user_id int not null,
	caption text,
	image_url varchar(200),
	create_at timestamp default current_timestamp,
	foreign key(user_id) references Users(user_id)
);

create table Comments (
	comment_id serial primary key,
	post_id int not null,
	user_id int not null,
	comment_text text,
	created_at timestamp default current_timestamp,
	foreign key (user_id) references Users(user_id),
	foreign key(post_id) references Posts(post_id)
);



create table Likes(
	like_id serial primary key,
	post_id int not null,
	user_id int not null,
	created_at timestamp default current_timestamp,
	foreign key(post_id) references Posts(post_id),
	foreign key(user_id) references Users(user_id)
);


create table Followers(
	follower_id serial primary key,
	user_id int not null,
	follower_user_id int not null,
	created_at timestamp default current_timestamp,
	foreign key(user_id) references Users(user_id),
	foreign key (follower_user_id) references Users(user_id)
);



INSERT INTO Users (name, email, phone_number)
VALUES
    ('John Smith', 'johnsmith@gmail.com', '1234567890'),
    ('Jane Doe', 'janedoe@yahoo.com', '0987654321'),
    ('Bob Johnson', 'bjohnson@gmail.com', '1112223333'),
    ('Alice Brown', 'abrown@yahoo.com', NULL),
    ('Mike Davis', 'mdavis@gmail.com', '5556667777');


INSERT INTO Posts (user_id, caption, image_url)
VALUES
    (1, 'Beautiful sunset', '<https://www.example.com/sunset.jpg>'),
    (2, 'My new puppy', '<https://www.example.com/puppy.jpg>'),
    (3, 'Delicious pizza', '<https://www.example.com/pizza.jpg>'),
    (4, 'Throwback to my vacation', '<https://www.example.com/vacation.jpg>'),
    (5, 'Amazing concert', '<https://www.example.com/concert.jpg>');

INSERT INTO Comments (post_id, user_id, comment_text)
VALUES
    (1, 2, 'Wow! Stunning.'),
    (1, 3, 'Beautiful colors.'),
    (2, 1, 'What a cutie!'),
    (2, 4, 'Aww, I want one.'),
    (3, 5, 'Yum!'),
    (4, 1, 'Looks like an awesome trip.'),
    (5, 3, 'Wish I was there!');

INSERT INTO Likes (post_id, user_id)
VALUES
    (1, 2),
    (1, 4),
    (2, 1),
    (2, 3),
    (3, 5),
    (4, 1),
    (4, 2),
    (4, 3),
    (5, 4),
    (5, 5);

INSERT INTO Followers (user_id, follower_user_id)
VALUES
    (1, 2),
    (2, 1),
    (1, 3),
    (3, 1),
    (1, 4),
    (4, 1),
    (1, 5),
    (5, 1);

select * from Users;

select * from Posts;

select * from Likes;

select * from Followers;


-- updating the caption of post_id 5

update Posts
set caption = 'bts concert is very amazing'
where post_id =5;


select * from Posts;

-- selecting all  the posts where user_id is 2

select * from Posts where user_id =2;


-- Selecting all the posts and ordering them by created_at in descending order

select * from Posts 
order by create_at desc;


-- Counting the number of likes for each post and showing only the posts with more than equal to 2 likes

select p.post_id,count(l.like_id) as like_count from Likes as l
left join Posts as p 
on l.like_id=p.post_id
group by p.post_id	
having count(l.like_id)  >= 2;


-- Finding the total number of likes for all posts

select SUM(num_likes) as total_likes
	from
	(select count(l.like_id)as num_likes from Posts as p
join Likes as l
on l.like_id=p.post_id
group by p.post_id
) as liked_post
;



-- Ranking the posts based on the number of likes


select post_id,total_like,rank() over (order by total_like) as rank from
	(select p.post_id,count(l.like_id)as total_like from Posts as p
join Likes as l
on l.like_id = p.post_id
group by p.post_id	
) as post_likes
;

-- Finding all the users who have commented on post_id 2

select name from Users 
where user_id IN		
(select user_id from Comments 
where post_id = 2);

-- Finding all the posts and their comments using a Common Table Expression (CTE)
with post_comments as(
	select p.post_id,p.caption,c.comment_text from Posts as p
	join Comments  AS c
	on c.comment_id=p.post_id
)

select * from post_comments;


-- Categorizing the posts based on the number of likes

select post_id,
	case
	    when like_counts = 0 then 'no likes'
	    when like_counts > 1 then 'good likes'
		else 'anything else'
	end as like_cat
from (
	select p.post_id,count(l.like_id)as like_counts from Posts as p
	join Likes as l
	on l.like_id=p.post_id
	group by p.post_id
) as like_counts;

-- Finding all the posts created in the last month
select * from Posts
where create_at >= cast(date_trunc('month',current_timestamp - interval '1 month')as date);


