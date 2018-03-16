use Northwind
--�w.1
select orderid, sum(unitprice*quantity*(1-discount)) as [Wartosc zamowienia]
from [order details]
group by orderid
order by [wartosc zamowienia] desc

select top 10 orderid, sum(unitprice*quantity*(1-discount)) as [Wartosc zamowienia]
from [order details]
group by orderid
order by [wartosc zamowienia] desc

select top 10 with ties orderid, sum(unitprice*quantity*(1-discount)) as [Wartosc zamowienia]
from [order details]
group by orderid
order by [wartosc zamowienia] desc

--�w.2
select productid,count(*) as [total unit]
from [order details]
where productid < 3
group by productid
order by productid

select productid,count (*) as [total unit]
from [order details]
group by productid
order by productid

select productid, sum(quantity) as total, sum(unitprice*quantity*(1-discount)) as [Wartosc zamowienia]
from [order details]
group by productid
having sum(quantity) > 250
order by productid

--�w.3
select productid, orderid, sum(quantity) as total
from [order details]
group by rollup (productid, orderid)

select productid, orderid, sum(quantity) as total
from [order details]
where productid =50
group by productid, orderid
with rollup

--3. Znaczenie warto�ci NULL w kolumnie productid
--i order id: pola o takiej warto�ci nie uczestnicz�
--w grupowaniu (mo�na po nich zlokalizowa� miejsca, gdzie
--dokonywane s� sumowania), tzw. NULL zgrupowany

select ProductID, grouping(productid) as gr_PID, OrderID,grouping(orderid) as gr_OID,sum(Quantity) as suma
from [order details]
group by ProductID, OrderID with cube
order by ProductID, OrderID


--5. Podsumowaniami s� wiersze, w kt�rych wyst�powa�y warto�ci
--	NULL pod productid lub orderid wraz z warto�ci� 1 w kolumnie
--	GROUPING - wiadomo�� o zagregowaniu kolumny


