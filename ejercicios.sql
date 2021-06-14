/*1. ¿Qué consulta ejecutaría para obtener los ingresos totales para marzo de 2012?*/
use lead_gen_business;
select
date_format(charged_datetime,'%M') as month,
sum(billing.amount) as revenue
from billing
where billing.charged_datetime >= '2012/03/01' 
and billing.charged_datetime <= '2012/03/31';

/*2. ¿Qué consulta ejecutaría para obtener los ingresos totales recaudados del cliente con una identificación de 2?*/
use lead_gen_business;
select
clients.client_id as client_id,
sum(billing.amount) as total_revenue
from clients
inner join billing on clients.client_id = billing.client_id
where clients.client_id = 2;

/*3. ¿Qué consulta ejecutaría para obtener todos los sitios que posee client = 10?*/
use lead_gen_business;
select
sites.domain_name as website,
clients.client_id as client_id
from clients
inner join sites on clients.client_id = sites.client_id
where clients.client_id = 10;

/*4. ¿Qué consulta ejecutaría para obtener el número total de sitios creados por mes por año para el cliente con una identificación de 1? ¿Qué pasa con el cliente = 20?*/
use lead_gen_business;
select
clients.client_id as client_id,
count(sites.site_id) as number_of_websites,
date_format(sites.created_datetime,'%M') as month_created,
date_format(sites.created_datetime,'%Y') as year_created
from clients
inner join sites on clients.client_id = sites.client_id
where clients.client_id = 1
group by sites.site_id;
select
clients.client_id as client_id,
count(sites.site_id) as number_of_websites,
date_format(sites.created_datetime,'%M') as month_created,
date_format(sites.created_datetime,'%Y') as year_created
from clients
inner join sites on clients.client_id = sites.client_id
where clients.client_id = 20;

/*5. ¿Qué consulta ejecutaría para obtener el número total de clientes potenciales generados para cada uno de los sitios entre el 1 de enero de 2011 y el 15 de febrero de 2011?*/
use lead_gen_business;
select
sites.domain_name as website,
count(leads.site_id) as number_of_leads,
date_format(leads.registered_datetime,'%M %e, %Y') as date_generated
from sites
inner join leads on sites.site_id = leads.site_id
where leads.registered_datetime >= '2011/01/01' 
and leads.registered_datetime <= '2011/02/15'
group by leads.leads_id;

/*6. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total de clientes potenciales que hemos generado para cada uno de nuestros clientes entre el 1 de enero de 2011 y el 31 de diciembre de 2011?*/
use lead_gen_business;
select
concat(clients.first_name,' ',clients.last_name) as client_name,
count(leads.site_id) as number_of_leads
from leads
inner join sites on leads.site_id =  sites.site_id
inner join clients on sites.client_id = clients.client_id
where leads.registered_datetime >= '2011/01/01' 
and leads.registered_datetime <= '2011/12/31'
group by client_name
order by clients.client_id;

/*7. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total de clientes potenciales que hemos generado para cada cliente cada mes entre los meses 1 y 6 del año 2011?*/
use lead_gen_business;
select
concat(clients.first_name,' ',clients.last_name) as client_name,
count(leads.leads_id) as number_of_leads,
date_format(leads.registered_datetime,'%M') as month_generated
from clients
inner join sites on clients.client_id = sites.client_id
inner join leads on sites.site_id = leads.site_id
where leads.registered_datetime >= '2011/01/01' 
and leads.registered_datetime <= '2011/06/30'
group by leads.leads_id;

/*8. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total de clientes potenciales que hemos generado para cada uno de los sitios de nuestros clientes entre el 1 de enero de 2011 y el 31 de diciembre de 2011? Solicite esta consulta por ID de cliente. Presente una segunda consulta que muestre todos los clientes, los nombres del sitio y el número total de clientes potenciales generados en cada sitio en todo momento.*/
use lead_gen_business;
select
concat(clients.first_name,' ',clients.last_name) as client_name,
sites.domain_name as website,
count(leads.site_id) as number_of_leads,
date_format(leads.registered_datetime,'%M %e, %Y') as date_generated
from clients
inner join sites on clients.client_id = sites.client_id
inner join leads on sites.site_id = leads.site_id
where leads.registered_datetime >= '2011/01/01' 
and leads.registered_datetime <= '2011/12/31'
group by leads.site_id
order by clients.client_id,leads.site_id;
select
concat(clients.first_name,' ',clients.last_name) as client_name,
sites.domain_name as website,
count(leads.leads_id) as number_of_leads
from clients
left join sites on clients.client_id = sites.client_id
left join leads on sites.site_id = leads.site_id
group by leads.site_id
order by clients.client_id,leads.site_id;

/*9. Escriba una sola consulta que recupere los ingresos totales recaudados de cada cliente para cada mes del año. Pídalo por ID de cliente.*/
use lead_gen_business;
select
concat(clients.first_name,' ',clients.last_name) as client_name,
sum(billing.amount) as revenue,
date_format(billing.charged_datetime,'%M') as month_charge,
date_format(billing.charged_datetime,'%Y') as year_charge
from billing
inner join clients on billing.client_id = clients.client_id
group by year(billing.charged_datetime),monthname(billing.charged_datetime),clients.client_id
order by clients.client_id asc;

/*10. Escriba una sola consulta que recupere todos los sitios que posee cada cliente. Agrupe los resultados para que cada fila muestre un nuevo cliente. Se volverá más claro cuando agregue un nuevo campo llamado 'sitios' que tiene todos los sitios que posee el cliente. (SUGERENCIA: use GROUP_CONCAT)*/
use lead_gen_business;
select
concat(clients.first_name,' ',clients.last_name) as client_name,
group_concat(sites.domain_name separator ' / ') as sites
from sites
inner join clients on sites.client_id = clients.client_id
group by clients.client_id;
