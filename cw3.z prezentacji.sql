use Northwind

--1 
SELECT  CategoryName,CompanyName,  SUM(Quantity) AS total 
	FROM  Categories AS C
		INNER JOIN Products AS P
			ON P.CategoryID = C.CategoryID
		INNER JOIN [Order Details] AS OD
			ON OD.ProductID = P.ProductID
		INNER JOIN Orders AS O
			ON OD.OrderID = O.OrderID
		INNER JOIN Customers AS Cu
			on O.CustomerID=Cu.CustomerID
		GROUP BY CategoryName,CompanyName

--2
SELECT CompanyName, OD.OrderID, C.CustomerID, SUM(Quantity) AS total
	FROM Customers AS C 
		INNER JOIN Orders AS O
			ON C.CustomerID=O.CustomerID
		INNER JOIN [Order Details] AS OD
			ON O.OrderID=OD.OrderID
GROUP BY CompanyName, OD.OrderID, C.CustomerID

--3
SELECT CompanyName, OD.OrderID, C.CustomerID, SUM(Quantity) AS total
	FROM Customers AS C 
		INNER JOIN Orders AS O
			ON C.CustomerID=O.CustomerID
		INNER JOIN [Order Details] AS OD
			ON O.OrderID=OD.OrderID
GROUP BY CompanyName, OD.OrderID, C.CustomerID
HAVING SUM(Quantity) >250

--4
SELECT CompanyName, P.ProductName
	FROM Customers AS C
		INNER JOIN Orders AS O
			ON C.CustomerID=O.CustomerID
		INNER JOIN [Order Details] AS OD
			ON O.OrderID=OD.OrderID
		INNER JOIN Products AS P
			ON OD.ProductID=P.ProductID
GROUP BY CompanyName, P.ProductName

--5
SELECT CompanyName, C.CustomerID, O.OrderID, SUM(Quantity * UnitPrice * (1 - Discount)) AS total
	FROM Customers AS C
		LEFT OUTER JOIN Orders AS O
			ON O.CustomerID = C.CustomerID
		LEFT OUTER JOIN [Order Details] AS OD
			ON OD.OrderID = O.OrderID
		GROUP BY CompanyName, O.OrderID, C.CustomerID;
--6
USE library
SELECT firstname, lastname, l.copy_no
	FROM member AS m
		LEFT OUTER JOIN loan AS L
			ON l.member_no = m.member_no AND l.copy_no IS NULL
		LEFT OUTER JOIN loanhist as LH
			ON lh.member_no = m.member_no AND lh.copy_no IS NULL