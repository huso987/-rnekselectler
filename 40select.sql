-- 40) Aylara göre sipariþ sayýlarýný ,toplam sipariþ tutuarýný ,toplam adet olarak  
-- satýlan ürün sayýsýný getiren sorgu
select MONTH(sh.OrderDate) as aylar,
       COUNT(sh.SalesOrderID) as sipaissayisi,
	   SUM(sh.TotalDue) as total,
	   SUM(sd.OrderQty) as ürüntotal
from Sales.SalesOrderHeader as sh inner join Sales.SalesOrderDetail sd on sh.SalesOrderID=sd.SalesOrderID
group by MONTH(sh.OrderDate)
order by aylar;
-- ******************************************************************************
--39) Herbir müþterinin kategorilere göre yaptýklarý alýþveriþ tutarlarýný getiriniz.
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
-- 38) Çalýþanlarýn yaptýklarý sipariþlerin toplam tutarýný azdan çoða doðru sýralayýnýz 
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
-- 37)Ürün adýný ve satýþ sipariþi kimliðini listeleyen sql sorgusunu yazýnýz.
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
-- 36) Ýþ unvanlarý 'Satýþ' ile baþlayan tüm çalýþanlarýn ilk ad ,
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
-- 35) Avustralya'da bulunan kiþilerin isim(FirstName) sütunundaki karakter 
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
-- 34) ABD dýþýnda ve adý "Pa" ile baþlayan þehirlerin Adres1,Adres2,postakodu ve ülke bölge 
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
-- 33) Kýrmýzý veya Mavi renkli tüm ürünlerin isim, renk ve liste fiyatýný,
-- liste fiyatýna göre sýralayan sql sorgusunu yazýnýz

SELECT 
      p.Name as isim,
	  p.Color as renk,
	  p.ListPrice as listefiyati
FROM Production.Product as p
WHERE p.Color IN ('Red','Blue')
order by p.ListPrice  -- or    order by p.ListPrice ASC

-- **********************************************************************************************
-- 32) ID'si 43659 ve 43664  olan sipariþlerin toplamýný, ortalamasý ,minimum 
-- ve maksimum sipariþ miktarýný ve sayýsýný bulan sql sorgusunu yazýnýz

SELECT
    SUM(ot.OrderQty) AS ToplamSiparis,
    AVG(ot.OrderQty) AS OrtalamaSiparis,
    MIN(ot.OrderQty) AS MinimumSiparis,
    MAX(ot.OrderQty) AS MaximumSiparis,
    COUNT(ot.OrderQty) AS SiparisSayisi
FROM
    Sales.SalesOrderDetail AS ot
WHERE
    ot.SalesOrderID IN (43659, 43664)

-- **********************************************************************************************
-- 31) Soyadý 'L' harfi ile baþlayan kiþilerin ID (BusinessEntityID),ad
-- soyad ve telefon numarasýný listeleyen sql sorgusu yazýnýz.
SELECT P.BusinessEntityID as ID,
       P.FirstName as ad,
	   P.LastName as soyad,
	   Pn.PhoneNumber as telefonnumarasý
       FROM Person.Person P inner join Person.PersonPhone  Pn on P.BusinessEntityID=Pn.BusinessEntityID
	   WHERE P.LastName LIKE 'L%' 

-- **********************************************************************************************
-- 30)'Satýn Alma Müdürü'  olarak atanan kiþilerin ID (BusinessEntityID),isim ve soyadýný;
-- soyada göre artan sýrada listeleyen sql sorgusu yazýnýz


SELECT 
    p.BusinessEntityID as ID,
    p.FirstName as ilkad,
	p.LastName as soyad
FROM 
    HumanResources.Employee AS e
JOIN 
    Person.Person AS p ON e.BusinessEntityID=p.BusinessEntityID
WHERE 
    e.JobTitle LIKE 'Purchasing Manager%'
ORDER BY p.LastName 

-- **********************************************************************************************
-- 29) Ürün kalitesi 500 den fazla olan ve 'A' veya 'C' veya 'H' rafýnda bulunan her bir 
-- ürünün ID'sýný ve toplam miktarýný,ürün  ID'sýne göre artan sýrada listeleyen sql sorgusunu yazýnýz
SELECT
    p.ProductID AS ID,
    SUM(s.OrderQty) AS ToplamMiktar
FROM
    Production.Product AS p
    INNER JOIN Sales.SalesOrderDetail AS s ON p.ProductID=s.ProductID
WHERE
    p.ProductLine IN ('A', 'C', 'H')
    AND p.StandardCost > 500
GROUP BY
    p.ProductID
ORDER BY
    p.ProductID ASC

-- **********************************************************************************************
--28)Her þehirde çalýþan sayýsýný almak için sql sorgusu yazýnýz ,sonucu þehre göre artan düzende sýralayýn
--(iki sütun:Þehir ve çalýþan sayýsý)
select 
       a.City as þehir,
	   count(e.BusinessEntityID) as çalýþan
from HumanResources.Employee as e 
     inner join Person.Person as p on e.BusinessEntityID=p.BusinessEntityID
	 inner join Person.BusinessEntity as b on p.BusinessEntityID=b.BusinessEntityID
     inner join Person.BusinessEntityAddress as ba on b.BusinessEntityID=ba.BusinessEntityID
     inner join Person.Address as a on a.AddressID=ba.AddressID
group by a.City
order by a.City ASC
-- **********************************************************************************************
-- 27)Ürünleri satýþ adet sayýsýna göre çoktan aza doðru sýralayýnýz.(Üç sütun :ProductID,ProductName,adet)
select
     p.ProductID as Id,
	 p.Name as name,
	 sum(s.OrderQty) as adet
from  Production.Product as p 
      inner join Sales.SalesOrderDetail as s on p.ProductID=s.ProductID
group by p.ProductID,p.Name
order by adet desc

-- **********************************************************************************************
-- 26) Ülkelere göre toplam sipariþ tutarlarýný çoktan aza doðru getiriniz
select
      c.Name as Ülke,
	  Sum(s.TotalDue) as miktar
from Sales.SalesOrderHeader as s
      inner join Sales.SalesTerritory as st on s.TerritoryID=st.TerritoryID
	  inner join  Person.CountryRegion as c on st.CountryRegionCode=c.CountryRegionCode
group by  c.Name
order by  miktar desc
-- **********************************************************************************************
-- 25) Her bir müþterinin toplam adet olarak kaç ürün aldýðýný yazdýran bir sorgu yazýnýz ,
-- çoktan aza doðru sýralayýnýz
select  
    SOH.CustomerID,
    p.FirstName,
    p.LastName,
    COUNT(SOD.ProductID) AS TotalQuantity
from Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.SalesOrderDetail AS SOD ON SOH.SalesOrderID = SOD.SalesOrderID
    INNER JOIN Person.Person AS P ON SOH.CustomerID = P.BusinessEntityID
group by  SOH.CustomerID, p.FirstName,p.LastName
ORDER BY
    TotalQuantity DESC

-- **********************************************************************************************
-- 24)SalesPersonID, salesyear, totalsales, salesquotayear, salesquota ve amt_above_or_below_quota sütunlarýný bulmak 
-- için SQL'de bir sorgu yazýn.Sonuç kümesini ,SalesPersonID ve SalesYear sütunlarýnda artan düzende sýralayýn

select sp.BusinessEntityID as personýd,
       YEAR(soh.DueDate) as salesyear,
       SUM(soh.TotalDue) as totalsales,
	   SUM(sp.SalesQuota) as quata
from Sales.SalesOrderHeader as soh
           inner join Sales.SalesPerson as sp on sp.TerritoryID=soh.TerritoryID
group by sp.BusinessEntityID ,YEAR(soh.DueDate)

-- **********************************************************************************************
--23) SalesOrderID i almak için SQL'de bir sorgu yazýn.Belirli TerritoryID için herhangi bir sipariþ yoksa 
-- NULL döndürülür .TerritoryID,CountryRegionCode, ve SalesOrderID döndürür. Sonuçlar SalesOrderID ye göre sýralanýr,
-- böylece NULL 'lar en üstte görünür.

select 
     st.TerritoryID as TerritoryID,
	 st.CountryRegionCode as ülke,
	 CASE 
        WHEN EXISTS (
            SELECT 1
            FROM Sales.SalesOrderHeader as soh inner join Sales.SalesTerritory as st on soh.TerritoryID=st.TerritoryID
            WHERE st.SalesYTD != 0 AND st.SalesLastYear !=0
        ) THEN SalesOrderID
        ELSE NULL
    END AS SalesOrderID
from Sales.SalesOrderHeader as soh 
      inner join Sales.SalesTerritory as st on soh.TerritoryID=st.TerritoryID
order by SalesOrderID
-- **********************************************************************************************
-- 22) Orta adýn NULL ' dan farklý olduðu satýrlarý bulmak için SQL'de bir sorgu yazýn.Ýþletme varlýk kimliði
-- kiþi türü , ad , ikinci ad, ve soyadýný döndürün.Sonuç kümesini ad üzerinden artan düzende sýralayýn
SELECT BusinessEntityID, PersonType, FirstName, MiddleName, LastName
FROM Person.Person
WHERE MiddleName IS NOT NULL
ORDER BY FirstName ASC
-- **********************************************************************************************
-- 21) Belirli bir çalýþanýn önceki üç aylýk dönemlere göre satýþ kotalarýndaki farklý döndürmek için SQL 'de
-- bir sorgu yazýn.Sonuçlarý ,iþletme kimliði 277 ve kota tarihi 2012 veya 2013 olan satýþ görevlisine göre
-- sýralyýn.
SELECT s.BusinessEntityID, 
       s.QuotaDate,
       s.SalesQuota - lag(s.SalesQuota) OVER (PARTITION BY s.BusinessEntityID ORDER BY s.QuotaDate) AS SalesQuotaDifference
FROM Sales.SalesPersonQuotaHistory s
WHERE s.BusinessEntityID = 277
  AND YEAR(s.QuotaDate) IN (2012, 2013)
ORDER BY s.QuotaDate
-- **********************************************************************************************
-- 20) Alan kodu 415 olan tüm telefon numaralarýný bulmak için SQL 'de  bir sorgu yazýn.Adý,Soyadýný ve
-- telefon numarasýný döndürür.Sonuç kümesini soyadýna göre artan düzende sýralyýn.
select
      p.FirstName as ad,
	  p.LastName as soyad,
	  pp.PhoneNumber as telefon
from Person.Person as p 
     inner join Person.PersonPhone as pp on p.BusinessEntityID=pp.BusinessEntityID
where  pp.PhoneNumber LIKE '415%'
-- **********************************************************************************************
-- 19)iki sorgunun birleþiminden oluþan bir sorgu yazýn.1.sorgudan 2. sorguda da bulunmayan herhangi bir iþletme
-- kimliði döndürün.Sonuç kümesini businessentityID 'de artan düzende sýralayýn.
select
      p.BusinessEntityID as ID,
	  p.FirstName as ad,
	  p.LastName as soyad
from Person.Person as p 
where p.MiddleName is null 

UNION

SELECT p.BusinessEntityID,
       p.FirstName as ad,
	   p.LastName as soyad
FROM Person.Person as p 
WHERE p.BusinessEntityID NOT IN (
    SELECT p.BusinessEntityID
    FROM Person.Person as p 
    WHERE p.MiddleName is null 
)
ORDER BY p.BusinessEntityID ASC;
-- **********************************************************************************************
-- 18) Her iþ unvaný için en yüksek saatlik ücreti döndürmek için SQL'de bir sorgu yazýn.Baþlýklarý,maksimum
--  ödeme oraný 40 dolardan fazla olan erkekler veya maksimum ödeme oraný 42 dolardan fazla olan
-- kadýnlar tarafýndan sahip olunanlarla sýnýrlandýrýr.
SELECT e.JobTitle, MAX(eph.Rate) AS MaxHourlyRate
FROM HumanResources.Employee as e
     inner join HumanResources.EmployeePayHistory as eph on e.BusinessEntityID=eph.BusinessEntityID
WHERE e.Gender = 'M' AND eph.Rate > 40
    OR e.Gender = 'F' AND eph.Rate > 42
GROUP BY e.JobTitle;
-- **********************************************************************************************
-- 17)