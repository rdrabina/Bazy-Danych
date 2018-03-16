use Northwind
--æw.1
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

--æw.2
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

--æw.3
select productid, orderid, sum(quantity) as total
from [order details]
group by rollup (productid, orderid)

select productid, orderid, sum(quantity) as total
from [order details]
where productid =50
group by productid, orderid
with rollup

--3. Znaczenie wartoœci NULL w kolumnie productid
--i order id: pola o takiej wartoœci nie uczestnicz¹
--w grupowaniu (mo¿na po nich zlokalizowaæ miejsca, gdzie
--dokonywane s¹ sumowania), tzw. NULL zgrupowany

select ProductID, grouping(productid) as gr_PID, OrderID,grouping(orderid) as gr_OID,sum(Quantity) as suma
from [order details]
group by ProductID, OrderID with cube
order by ProductID, OrderID


--5. Podsumowaniami s¹ wiersze, w których wystêpowa³y wartoœci
--	NULL pod productid lub orderid wraz z wartoœci¹ 1 w kolumnie
--	GROUPING - wiadomoœæ o zagregowaniu kolumny


