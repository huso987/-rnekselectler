-- 1) Aylara göre sipariþ sayýlarýný ,toplam sipariþ tutuarýný ,toplam adet olarak  
-- satýlan ürün sayýsýný getiren sorgu
select MONTH(sh.OrderDate) as aylar,
       COUNT(sh.SalesOrderID) as sipaissayisi,
	   SUM(sh.TotalDue) as total,
	   SUM(sd.OrderQty) as ürüntotal
from Sales.SalesOrderHeader as sh inner join Sales.SalesOrderDetail sd on sh.SalesOrderID=sd.SalesOrderID
group by MONTH(sh.OrderDate)
order by aylar;
-- ******************************************************************************
--2) Herbir müþterinin kategorilere göre yaptýklarý alýþveriþ tutarlarýný getiriniz.
-- (Üç sütun: Müþteri ID, Kategori, toplam tutar) 
select   C.CustomerID,
		 PC.Name AS Kategori,
		 SUM(SOD.LineTotal) AS ToplamTutar
from Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.SalesOrderDetail AS SOD ON SOH.SalesOrderID = SOD.SalesOrderID
    INNER JOIN Sales.Customer AS C ON SOH.CustomerID = C.CustomerID
    INNER JOIN Production.Product AS P ON SOD.ProductID = P.ProductID
    INNER JOIN Production.ProductCategory AS PC ON P.ProductSubcategoryID = PC.ProductCategoryID
GROUP BY C.CustomerID,
         PC.Name
ORDER BY C.CustomerID;
-- *****************************************************************************************
-- 3) Çalýþanlarýn yaptýklarý sipariþlerin toplam tutarýný azdan çoða doðru sýralayýnýz 
SELECT 
    P.FirstName + ' ' + P.LastName AS CalisanAdi,
    SUM(SOH.TotalDue) AS ToplamTutar
FROM 
    Sales.SalesOrderHeader SOH
    INNER JOIN Sales.SalesPerson SP ON SOH.SalesPersonID = SP.BusinessEntityID
    INNER JOIN Person.Person P ON SP.BusinessEntityID = P.BusinessEntityID
GROUP BY 
    P.FirstName, P.LastName
ORDER BY 
    ToplamTutar ASC;
-- ******************************************************************************************
-- 4)Ürün adýný ve satýþ sipariþi kimliðini listeleyen sql sorgusunu yazýnýz.
--(hem sýralý hem de sýrasýz  ürünler listeye dahil edilir) 
SELECT 
    p.Name AS UrunAdi,
    sod.SalesOrderID AS SatisSiparisKimligi
FROM 
    Production.Product AS p
INNER JOIN 
    Sales.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID
ORDER BY 
    p.Name ASC;

-- **********************************************************************************************
-- 5) Ýþ unvanlarý 'Satýþ' ile baþlayan tüm çalýþanlarýn ilk ad ,
--ikinci ad ,soyadý ve iþ unvanýný listeleyen sql sorgusunu yazýnýz
SELECT 
    p.FirstName as ilkad,
	p.MiddleName as ikinciad,
	p.LastName as soyad,
    e.JobTitle AS ÝsUnvani
FROM 
    HumanResources.Employee AS e
JOIN 
    Person.Person AS p ON e.BusinessEntityID=p.BusinessEntityID
WHERE 
    e.JobTitle LIKE 'Sales%'

-- **********************************************************************************************
-- 6) Avustralya'da bulunan kiþilerin isim(FirstName) sütunundaki karakter 
-- sayýsýný ,isim ve soyadlarýný listeleyen sql sorgusunu yazýnýz.

select 
        LEN(p.FirstName) as karaktersayisi,
		p.FirstName as isim,
		p.LastName as soyad
from Person.Person as p 
		   inner join Person.BusinessEntity as b on p.BusinessEntityID=b.BusinessEntityID
           inner join Person.BusinessEntityAddress as ba on b.BusinessEntityID=ba.BusinessEntityID
		   inner join Person.Address as a on a.AddressID=ba.AddressID
		   inner join Person.StateProvince as s on s.StateProvinceID=a.StateProvinceID
		   inner join Person.CountryRegion as cr on cr.CountryRegionCode=s.CountryRegionCode
WHERE cr.Name LIKE 'Australia%'

-- **********************************************************************************************
-- 7) ABD dýþýnda ve adý "Pa" ile baþlayan þehirlerin Adres1,Adres2,postakodu ve ülke bölge 
-- kodlarýný listleyen sql sorgusunu yazýnýz

SELECT 
    a.AddressLine1 AS Adres1,
    a.AddressLine2 AS Adres2,
    a.PostalCode AS PostaKodu,
    s.CountryRegionCode AS UlkeBolgeKodu
FROM 
    Person.Address AS a
JOIN 
    Person.StateProvince AS s ON a.StateProvinceID = s.StateProvinceID
WHERE 
    s.CountryRegionCode != 'US'
    AND a.City LIKE 'Pa%'

-- **********************************************************************************************
-- 8) Kýrmýzý veya Mavi renkli tüm ürünlerin ismini