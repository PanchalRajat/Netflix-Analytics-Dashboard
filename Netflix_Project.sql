create database netflix_analysis;

use netflix_analysis;

CREATE TABLE netflix (
    show_id VARCHAR(10),
    type VARCHAR(20),
    title TEXT,
    director TEXT,
    cast TEXT,
    country TEXT,
    date_added TEXT,
    release_year TEXT,
    rating VARCHAR(10),
    duration VARCHAR(30),
    listed_in TEXT,
    description TEXT
);

select * from netflix;

select type, count(*) as total
from netflix
group by type;

SELECT COUNT(*) FROM netflix;

alter table netflix
modify column release_year int;

select listed_in, count(*) as total
from netflix
group by listed_in
order by total desc
limit 10;

select release_year, count(*) as total
from netflix
group by release_year
order by release_year;

select country, count(*) as total
from netflix
where country is not null
group by country
order by total desc
limit 10;

select director, count(*) as total
from netflix
where director is not null
group by director
order by total desc
limit 20;

