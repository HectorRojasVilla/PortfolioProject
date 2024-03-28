-- Seleccionaremos los nombres y apellidos de nuestros clientes para enviarles un email 
select first_name, last_name, email from customer

-- Queremos saber cuales son las categorias que tenemos para el tipo de peliculas

select distinct rating from film

-- Queremos saber el email de un cliente que dejo su billetera en la tienda
-- En la billetera obtendremos solo nombre y apellido el cual es Nancy Thomas 

select first_name, last_name, email from customer 
where first_name like 'Nancy'
and last_name like 'Thomas'

-- En la tienda nos preguntan por la descripcion de una pelicula llamada 
-- 'Outlaw Hanky'

select title, description from film 
where title like 'Outlaw Hanky'

-- Queremos llamar por telefono a un cliente que no ha regresado las peliculas
-- para ello nos basaremos en su direccion '259 Ipoh Drive'

Select address, phone from address
where address like '259 Ipoh Drive'

-- Seleccionando solo a los clientes que tienen un registro en el distrito de California ya que 
-- Tendran una notificacion a su email 

select district, email from address
inner join customer on 
address.address_id = customer.address_id
where district like 'California'

-- Un cliente es gran fan de NIck Wahlber y quisiera saber cuales son las peliculas en 
-- las que el actor tiene una participancion 

select title, first_name, last_name from film_actor
inner join actor 
on  film_actor.actor_id = actor.actor_id
inner join film 
on film_actor.film_id = film.film_id
where first_name = 'Nick'
and last_name = 'Wahlberg'

-- Buscar cuales fueron los clientes que mas gastaron con el staaf numero 2 
-- arriba de los 110 dolares 

select distinct customer_id, sum(amount) from payment 
where staff_id = '2'
group by customer_id
having sum(amount)>110
-- Queremos saber cuales peliculas empiezan con la letra J 

select COUNT(*) from film 
where title like 'J%'

-- What customer has the highest customer ID number whose name 
-- starts with an 'E' and has an address ID lower than 500?
-- limitandolo solo a un cliente

Select * from customer
where address_id < 500
and first_name like 'E%'
order by customer_id desc
limit 1

-- Tenemos dos staff y queremos saber quien de ellos hizo mas cobros, 
-- no el que genero mas ganancia, solo quien hizo mas cobros 

select staff_id,count(*) from payment 
group by staff_id

-- El corporativo quiere saber cual es el promedio del replacement_cost 
-- con el tipo de pelicula 

select rating, round(avg(replacement_cost),2) from film 
group by rating 

-- Queremos premiar a los 5 clientes que mas han gasto con nosotros
-- Debemos obtener su informacion para mandarles un email y su customer_id 

select customer_id, sum(amount) from payment
group by customer_id
order by sum(amount) desc 
limit 5

-- Lanzaremos una membresia platino para los clientes que tengan 
-- 40 o mas transacciones en la tienda 

select count(customer_id), customer_id from payment
group by customer_id
having count(customer_id)>=40
order by count(customer_id) desc

-- Cuales son los customer_id de los clientes que gastan mas de 
-- $100 en transacciones con el staff #2

select customer_id,sum(amount) from payment
where staff_id = '2' 
group by customer_id
having sum(amount) > 100
order by sum(amount) desc 

-- Con ello puedes hacer las consultas necesarias para poder obtener la informacion 
-- mas imporatnte de acuerdo a las tablas y datos dados por la base de datos

