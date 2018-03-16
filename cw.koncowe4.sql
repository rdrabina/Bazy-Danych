use Northwind

--1.1
select ShipperID, CompanyName
from Shippers
-- z tego wiemy, ze firma United Package ma ID=2

select CompanyName, Phone, CustomerID
from Customers 
where CustomerID in
	(select CustomerID 
	from Orders 
	where ShipVia=2 and year(ShippedDate)='1997')

select distinct CompanyName, Phone 
from Customers as C
inner join Orders as O on O.CustomerID=C.CustomerID 
where O.ShipVia=2 and year(ShippedDate)='1997'


--1.2
select CategoryName, CategoryID
from Categories
--Confections ma ID=3

select CompanyName, Phone 
from Customers 
where CustomerID in (
	select CustomerID 
	from Orders 
	where OrderID in (
		select OrderID 
		from [Order Details] 
		where ProductID in (
			select ProductID 
			from Products 
			where CategoryID=3
		)
	)
) 
order by CompanyName

select distinct CompanyName, Phone 
from Customers as C
inner join Orders as O on O.CustomerID=C.CustomerID 
inner join [Order Details] as OD on OD.OrderID=O.OrderID 
inner join Products as P on P.ProductID=OD.ProductID 
where P.CategoryID=3 order by CompanyName


--1.3
select CompanyName, Phone 
from Customers 
where CustomerID not in (
	select CustomerID 
	from Orders 
	where OrderID in (
		select OrderID 
		from [Order Details] 
		where ProductID in (
			select ProductID 
			from Products 
			where CategoryID=3
		)
	)
) 
order by CompanyName

select CompanyName, Phone 
from Customers
except  
select CompanyName, Phone 
from Customers as C 
inner join Orders as O on O.CustomerID=C.CustomerID 
inner join [Order Details] as OD on OD.OrderID=O.OrderID
inner join Products as P on P.ProductID=OD.ProductID
where P.CategoryID=3
		

--2.1
select ProductName, (select max(quantity)
					from [Order Details] as OD 
					where OD.ProductID=P.ProductID) as MAX_Q 
from Products as P
order by ProductName

select ProductName, max(Quantity) as MAX_Q 
from Products as P, [Order Details] as OD
where OD.ProductID=P.ProductID 
group by ProductName 
order by ProductName

--2.2
select ProductName 
from Products 
where UnitPrice < (select AVG(UnitPrice) 
				   from Products) 
order by ProductName

select A.ProductName, A.UnitPrice 
from Products as A 
cross join Products as B 
group by A.ProductName, A.UnitPrice 
having A.UnitPrice < AVG(B.UnitPrice) 
order by A.ProductName

--2.3

select A.ProductName 
from Products as A 
inner join Products as B on A.ProductID=B.ProductID 
where A.UnitPrice < (select AVG(UnitPrice) 
				   from Products as B 
				   where A.CategoryID=B.CategoryID) 
order by A.ProductName

select A.ProductName 
from Products as A 
inner join Products as B on A.CategoryID=B.CategoryID
group by A.ProductName, A.UnitPrice 
having A.UnitPrice < AVG(B.UnitPrice) order by A.ProductName


--2.4
select ProductName, UnitPrice, (select AVG(UnitPrice) 
									from Products), UnitPrice-(select AVG(UnitPrice) 
															   from Products) 
from Products
order by ProductName

select A.ProductName, A.UnitPrice, AVG(A.UnitPrice), A.UnitPrice-AVG(B.UnitPrice) 
from Products as A 
cross join Products as B
group by A.ProductName, A.UnitPrice 
order by A.ProductName

--2.5
select A.ProductName, (select CategoryName 
					   from Categories as B 
					   where B.CategoryID=A.CategoryID), UnitPrice, (select AVG(UnitPrice) 
																	 from Products as B 
																	 where A.CategoryID=B.CategoryID), UnitPrice-(select AVG(UnitPrice) 
																												  from Products as B 
																												  where A.CategoryID=B.CategoryID)
from Products as A 
order by ProductName

select A.ProductName, CategoryName, A.UnitPrice, AVG(B.UnitPrice), A.UnitPrice-AVG(B.UnitPrice) 
from Products as A
inner join Categories on Categories.CategoryID=A.CategoryID 
inner join Products as B on A.CategoryID=B.CategoryID 
group by A.ProductName, CategoryName, A.UnitPrice


--3.1
select sum((1-Discount)*UnitPrice*Quantity) + (select Freight 
											   from Orders 
											   where OrderID=10250) 
from [Order Details]
where [Order Details].OrderID=10250

select sum((1-Discount)*UnitPrice*Quantity) + Freight from [Order Details] as A
inner join Orders as B on B.OrderID=A.OrderID 
group by A.OrderID, Freight 
having A.OrderID=10250

--3.2
select sum((1-Discount)*UnitPrice*Quantity) + (select Freight 
											   from Orders as B 
											   where B.OrderID=A.OrderID) 
from [Order Details] as A
group by A.OrderID

select sum((1-Discount)*UnitPrice*Quantity) + Freight 
from [Order Details] as A 
inner join Orders as B on B.OrderID=A.OrderID 
group by A.OrderID, Freight

--3.3
select CompanyName, Address, City, PostalCode, Country 
from Customers as A 
where not exists (select CustomerID 
				  from Orders as B 
				  where A.CustomerID = B.CustomerID and year(OrderDate)=1997)

select CompanyName, Address, City, PostalCode, Country 
from Customers as A
except 
select CompanyName, Address, City, PostalCode, Country 
from Customers as A 
inner join Orders as B on A.CustomerID=B.CustomerID
where year(OrderDate)=1997

--3.4
select distinct ProductName 
from Products as P
inner join [Order Details] as OD on OD.ProductID=P.ProductID
inner join Orders as A on A.OrderID=OD.OrderID 
where (select count(*) 
	   from Orders as B 
	   where A.CustomerID=B.CustomerID)>1
order by ProductName

select distinct ProductName 
from Products 
except 
select distinct ProductName 
from Products as P
inner join [Order Details] as OD on OD.ProductID=P.ProductID 
inner join Orders as O on O.OrderDate=OD.OrderID 
group by ProductName	
having count(*) <= 1 
order by ProductName


--4.1:
--widac, ze sa sumy s¹ inne :c 
select E.FirstName, E.LastName, ((select sum(OD.Quantity*OD.UnitPrice*(1-OD.Discount) ) 
from [Order Details] as OD 
inner join Orders as O on O.OrderID=OD.OrderID 
where O.EmployeeID=E.EmployeeID) +
	(select sum(Freight) 
	from Orders
	where Orders.EmployeeID=E.EmployeeID)) 
from Employees as E 
order by E.FirstName

select E.FirstName, E.LastName, (sum(Quantity*UnitPrice*(1-Discount)) + sum(Freight)) 
from Employees as E 
inner join Orders as O on O.EmployeeID=E.EmployeeID 
inner join [Order Details] as OD on OD.OrderID=O.OrderID 
group by E.FirstName, E.LastName
order by E.FirstName


--4.2:
--inna suma :c
select top 1 E.FirstName, E.LastName, ((select sum(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) 
from [Order Details] as OD 
inner join Orders as O on O.OrderID=OD.OrderID 
where O.EmployeeID=E.EmployeeID and year(O.OrderDate)=1997) + 
		(select sum(Freight) 
		from Orders 
		where Orders.EmployeeID=E.EmployeeID and year(Orders.OrderDate)=1997)) 
	from Employees as E
order by 3 DESC

select top 1 E.FirstName, E.LastName, (sum(Quantity*UnitPrice*(1-Discount)) + sum (Freight)) 
from Employees as E
inner join Orders as O on O.EmployeeID=E.EmployeeID 
inner join [Order Details] as OD on OD.OrderID=O.OrderID
where year(O.OrderDate)=1997 and O.OrderID=OD.OrderID 
group by E.FirstName, E.LastName 
order by 3 DESC

--4.3:
--a)
select distinct E.FirstName, E.LastName, ((select sum(UnitPrice * Quantity *(1-Discount)) 
from [Order Details] as OD
inner join Orders as O on OD.OrderID=O.OrderID 
where O.EmployeeID=E.EmployeeID) + 
		(select sum(Freight) 
		from Orders 
		where Orders.EmployeeID=E.EmployeeID)) 
	from Employees as E where E.EmployeeID in 
			(select distinct ReportsTo 
			from Employees 
			where ReportsTo is not null)
 
--b)
select distinct E.FirstName, E.LastName, ((select sum(UnitPrice * Quantity *(1-Discount)) 
from [Order Details] as OD
inner join Orders as O on OD.OrderID=O.OrderID 
where O.EmployeeID=E.EmployeeID) + 
			(select sum(Freight) 
		from Orders 
		where Orders.EmployeeID=E.EmployeeID)) 
	from Employees as E 
	where E.EmployeeID not in
	(select distinct ReportsTo 
	from Employees 
	where ReportsTo is not null)

--4.4:
--a)
select distinct E.FirstName, E.LastName, ((select sum(UnitPrice * Quantity *(1-Discount)) 
from [Order Details] as OD 
inner join Orders as O on OD.OrderID=O.OrderID
where O.EmployeeID=E.EmployeeID) + 
			(select sum(Freight) 
		from Orders 
		where Orders.EmployeeID=E.EmployeeID)), 
			(select top 1 ShippedDate 
		from Orders
		where E.EmployeeID=Orders.EmployeeID 
		order by 1 DESC) 
	from Employees as E where E.EmployeeID in 
		(select distinct ReportsTo 
		from Employees 
		where ReportsTo is not null)

--b)
select distinct E.FirstName, E.LastName, ((select sum(UnitPrice * Quantity *(1-Discount)) 
from [Order Details] as OD 
inner join Orders as O on OD.OrderID=O.OrderID 
where O.EmployeeID=E.EmployeeID) + 
			(select sum(Freight) 
			from Orders 
			where Orders.EmployeeID=E.EmployeeID)),
			(select top 1 ShippedDate 
			from Orders
			where E.EmployeeID=Orders.EmployeeID order by 1 DESC) 
			from Employees as E 
			where E.EmployeeID not in
			(select distinct ReportsTo 
			from Employees 
			where ReportsTo is not null)
