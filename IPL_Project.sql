use ipl_project;

select * from deliveries limit 10;
select * from matches limit 10;

select count(*)
from deliveries d
join matches m
on d.match_id = m.id;

CREATE TABLE player_stats AS
SELECT 
    batsman,
    SUM(batsman_runs) AS total_runs,
    count(case when wide_runs = 0 then 1 end) as balls_faced,
    (SUM(batsman_runs) / COUNT(case when wide_runs = 0 then 1 end)) * 100 AS strike_rate,
    SUM(CASE WHEN batsman_runs = 4 THEN 1 ELSE 0 END) AS fours,
    SUM(CASE WHEN batsman_runs = 6 THEN 1 ELSE 0 END) AS sixes
FROM deliveries
GROUP BY batsman;

SELECT * FROM player_stats LIMIT 10;


create table bowler_stats as
	select
		bowler,
        count(case when wide_runs = 0 then 1 end) as balls_bowled,
        sum(total_runs) as runs_conceded,
        count(player_dismissed) as wickets,
        (sum(total_runs) / count(case when wide_runs = 0 then 1 end)) * 6 as economy
from deliveries 
group by bowler;

select * from bowler_stats limit 10;

create table match_summary as
select
	m.id as match_id,
    m.season,
    m.team1,
    m.team2,
    m.winner,
    m.venue,
    sum(d.total_runs) as total_runs
from matches m
join deliveries d
on m.id = d.match_id
group by m.id, m.season, m.team1, m.team2, m.winner, m.venue;

select * from match_summary limit 10;


create table team_match_runs as
select
	match_id,
    batting_team,
    sum(total_runs) as team_runs
from deliveries
group by match_id, batting_team;

select * from team_match_runs limit 10;


select
	t1.match_id,
    t1.batting_team as team1,
    t1.team_runs as team1_runs,
    t2.batting_team as team2,
    t2.team_runs as team2_runs,
    case 
		when t1.team_runs > t2.team_runs then t1.batting_team
        else t2.batting_team
	end as predicted_winner
from team_match_runs t1
join team_match_runs t2
on t1.match_id = t2.match_id
and t1.batting_team <> t2.batting_team;

select 
	m.id as match_id,
	m.winner as actual_winner,
    case
		When t1.team_runs > t2.team_runs then t1.batting_team
        else t2.batting_team
	end as predicted_winner
from matches m
join team_match_runs t1
on m.id = t1.match_id
join team_match_runs t2
on m.id = t2.match_id
and t1.batting_team < t2.batting_team;


select
	m.id as match_id,
    m.winner as actual_winner,
    case
		when t1.team_runs > t2.team_runs then t1.batting_team
        else t2.batting_team
	end as predicted_winner
from matches m
join team_match_runs t1
on m.id = t1.match_id
join team_match_runs t2
on m.id = t2.match_id
and t1.batting_team < t2.batting_team
where m.winner <>
	case
		when t1.team_runs > t2.team_runs then t1.batting_team
        else t2.batting_team
	end;
    
SELECT 
    COUNT(*) AS total_matches,
    SUM(CASE 
        WHEN m.winner = 
            CASE 
                WHEN t1.team_runs > t2.team_runs THEN t1.batting_team
                ELSE t2.batting_team
            END 
        THEN 1 ELSE 0 
    END) AS correct_predictions,
    (SUM(CASE 
        WHEN m.winner = 
            CASE 
                WHEN t1.team_runs > t2.team_runs THEN t1.batting_team
                ELSE t2.batting_team
            END 
        THEN 1 ELSE 0 
    END) / COUNT(*)) * 100 AS accuracy_percentage
FROM matches m
JOIN team_match_runs t1
ON m.id = t1.match_id
JOIN team_match_runs t2
ON m.id = t2.match_id
AND t1.batting_team < t2.batting_team;

select * from player_stats;
SELECT * FROM bowler_stats;