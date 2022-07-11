-- 1
select c.name, count(f.film_id) f from category c inner join film_category f 
using(category_id)
group by c.name
order by f desc; 


-- 2
select a.first_name, a.last_name, sum(f.rental_duration)
from actor a join film_actor using(actor_id) join
film f using(film_id)
group by (a.first_name, a.last_name)
order by 3 desc
limit 10;


-- 3
select c.name, sum(p.amount) from
category c join film_category using (category_id)
join film using(film_id)
join inventory using(film_id)
join rental using(inventory_id)
join payment p using(rental_id)
group by 1
order by 2 desc
limit 1; 


-- 4
select f.title from film f left join inventory i using(film_id) 
where i.film_id is null; 


-- 5
with tbl as (
	select concat(actor.first_name, ' ', actor.last_name) as actor_id, count(film.film_id) as film_sum from category
	JOIN film_category USING(category_id)
	JOIN film USING(film_id)
	JOIN film_actor USING(film_id)
	JOIN actor USING(actor_id)
	where category.name = 'Children'
	group by 1
)
select * from tbl where actor_id in (select tbl.actor_id where film_sum in 
									 (select distinct film_sum from tbl order by 1 desc
									 limit 3))
order by 2 desc; 


-- 6 
select city.city, sum(customer.active) as act_cln, count(customer.active) - 
sum(customer.active) as inact_cln from customer 
JOIN address USING(address_id)
JOIN city USING(city_id)
group by 1
order by 3 desc;


-- 7
with tbl as (select category.name as category, rental.return_date as ret, rental.rental_date as ren, city.city from
city
	JOIN address USING(city_id)
	JOIN customer USING(address_id)
	JOIN rental USING(customer_id)
	JOIN inventory USING(inventory_id)
	JOIN film USING(film_id)
	JOIN film_category USING(film_id)
	JOIN category USING(category_id)
where rental.return_date is not null)
(select category, sum(ret - ren) as timedelta from tbl
where city like 'A%' or city like 'a%'
group by 1 order by 2 desc limit 1)
union all
(select category, sum(ret - ren) as timedelta from tbl
where city like '%-%'
group by 1 order by 2 desc limit 1);



