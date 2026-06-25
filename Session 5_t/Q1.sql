SELECT 7 as month,
count(DISTINCT a.user_id) as monthly_active_users
from user_actions a 
left join user_actions b 
on a.user_id=b.user_id
where EXTRACT(MONTH from a.event_date)=7
and EXTRACT(YEAR from a.event_date)=2022
and EXTRACT(MONTH from b.event_date)=6
and EXTRACT(YEAR from b.event_date)=2022;