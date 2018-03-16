use Northwind
--æw.1
select companyname, sum (quantity) as sum
from customers inner join orders on customers.customerid=orders.customerid
			   inner join [order details] on orders.orderid=[order details].orderid
group by customers.customerid, customers.companyname

select companyname, sum (quantity) as sum
from customers inner join orders on customers.customerid=orders.customerid
			   inner join [order details] on orders.orderid=[order details].orderid
group by customers.customerid, customers.companyname
having sum (quantity) > 250

select orders.orderid, companyname, sum(quantity*unitprice*(1-discount)) as total
from customers inner join orders on customers.customerid=orders.customerid
			   inner join [order details] on [order details].orderid=orders.orderid
group by orders.orderid, customers.companyname
order by orderid

select orders.orderid, companyname, sum(quantity*unitprice*(1-discount)) as total, firstname, lastname
from customers inner join orders on customers.customerid=orders.customerid
			   inner join [order details] on [order details].orderid=orders.orderid
			   inner join employees on orders.employeeid=employees.employeeid
group by firstname, lastname, orders.orderid, customers.companyname
having sum(quantity) > 250


--æw.2
select categoryname, sum(quantity) as sum
from categories inner join products on categories.categoryid=products.categoryid
				inner join [order details] on products.productid=[order details].productid
group by categoryname

select c.categoryname, sum(od.quantity * od.unitprice * (1 - od.discount)) as total
from categories as c inner join products as p on c.categoryid = p.categoryid 
					 inner join [order details] as od on p.productid = od.productid
group by c.categoryid, c.categoryname

select c.categoryname, sum(od.quantity * od.unitprice * (1 - od.discount)) as total
from categories as c inner join products as p on c.categoryid = p.categoryid 
					 inner join [order details] as od on p.productid = od.productid
group by c.categoryid, c.categoryname
order by 2

select c.categoryname, sum(od.quantity * od.unitprice * (1 - od.discount)) as total
from categories as c inner join products as p on c.categoryid = p.categoryid 
					 inner join [order details] as od on p.productid = od.productid
group by c.categoryid, c.categoryname
order by sum(od.quantity)

--æw.3
select s.companyname, count (orderid) 'zamowienia'
from orders  inner join shippers as s on orders.shipvia=s.shipperid
group by s.companyname, s.shipperid

select top 1 s.companyname, count (orderid) 'zamowienia'
from orders  inner join shippers as s on orders.shipvia=s.shipperid and year(orders.shippeddate) = 1997
group by s.companyname, s.shipperid
order by 2 desc

select top 1 firstname,lastname, count(o.orderid) as total
from employees as e inner join orders as o on e.employeeid=o.employeeid and year(o.shippeddate) = 1997
group by firstname,lastname
order by total desc


--æw.4
select firstname, lastname, sum(od.unitprice * od.quantity * (1-od.discount)) as total
from employees as e inner join orders as o on e.employeeid=o.employeeid
					inner join [order details] as od on o.orderid=od.orderid
group by firstname, lastname


select top 1 firstname, lastname, sum(od.unitprice * od.quantity * (1-od.discount)) as total
from employees as e inner join orders as o on e.employeeid=o.employeeid and year(o.orderdate)=1997
					inner join [order details] as od on o.orderid=od.orderid
group by firstname, lastname
order by 3 desc


select e.firstname, e.lastname, sum(od.unitprice * od.quantity * (1-od.discount)) as total
from employees as e inner join orders as o on e.employeeid=o.employeeid
					inner join [order details] as od on o.orderid=od.orderid
					inner join employees as e2 on e2.reportsto=e.employeeid
group by e.firstname, e.lastname


select e.firstname, e.lastname, e.employeeid, sum(od.unitprice * od.quantity * (1-od.discount)) as total
from employees as e left outer join  employees as e2 on e2.reportsto=e.employeeid
					inner join orders as o on e.employeeid=o.employeeid
					inner join [order details] as od on o.orderid=od.orderid
where e2.EmployeeID is null
group by e.firstname, e.lastname, e.employeeid




