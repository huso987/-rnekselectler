-- 40) Aylara g�re sipari� say�lar�n� ,toplam sipari� tutuar�n� ,toplam adet olarak  
-- sat�lan �r�n say�s�n� getiren sorgu
select MONTH(sh.OrderDate) as aylar,
       COUNT(sh.SalesOrderID) as sipaissayisi,
	   SUM(sh.TotalDue) as total,
	   SUM(sd.OrderQty) as �r�ntotal
from Sales.SalesOrderHeader as sh inner join Sales.SalesOrderDetail sd on sh.SalesOrderID=sd.SalesOrderID
group by MONTH(sh.OrderDate)
order by aylar;
-- ******************************************************************************
--39) Herbir m��terinin kategorilere g�re yapt�klar� al��veri� tutarlar�n� getiriniz.
-- (�� s�tun: M��teri ID, Kategori, toplam tutar) 
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
-- 38) �al��anlar�n yapt�klar� sipari�lerin toplam tutar�n� azdan �o�a do�ru s�ralay�n�z 
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
-- 37)�r�n ad�n� ve sat�� sipari�i kimli�ini listeleyen sql sorgusunu yaz�n�z.
--(hem s�ral� hem de s�ras�z  �r�nler listeye dahil edilir) 
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
-- 36) �� unvanlar� 'Sat��' ile ba�layan t�m �al��anlar�n ilk ad ,
--ikinci ad ,soyad� ve i� unvan�n� listeleyen sql sorgusunu yaz�n�z
SELECT 
    p.FirstName as ilkad,
	p.MiddleName as ikinciad,
	p.LastName as soyad,
    e.JobTitle AS �sUnvani
FROM 
    HumanResources.Employee AS e
JOIN 
    Person.Person AS p ON e.BusinessEntityID=p.BusinessEntityID
WHERE 
    e.JobTitle LIKE 'Sales%'

-- **********************************************************************************************
-- 35) Avustralya'da bulunan ki�ilerin isim(FirstName) s�tunundaki karakter 
-- say�s�n� ,isim ve soyadlar�n� listeleyen sql sorgusunu yaz�n�z.

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
-- 34) ABD d���nda ve ad� "Pa" ile ba�layan �ehirlerin Adres1,Adres2,postakodu ve �lke b�lge 
-- kodlar�n� listleyen sql sorgusunu yaz�n�z

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
-- 33) K�rm�z� veya Mavi renkli t�m �r�nlerin isim, renk ve liste fiyat�n�,
-- liste fiyat�na g�re s�ralayan sql sorgusunu yaz�n�z

SELECT 
      p.Name as isim,
	  p.Color as renk,
	  p.ListPrice as listefiyati
FROM Production.Product as p
WHERE p.Color IN ('Red','Blue')
order by p.ListPrice  -- or    order by p.ListPrice ASC

-- **********************************************************************************************
-- 32) ID'si 43659 ve 43664  olan sipari�lerin toplam�n�, ortalamas� ,minimum 
-- ve maksimum sipari� miktar�n� ve say�s�n� bulan sql sorgusunu yaz�n�z

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
-- 31) Soyad� 'L' harfi ile ba�layan ki�ilerin ID (BusinessEntityID),ad
-- soyad ve telefon numaras�n� listeleyen sql sorgusu yaz�n�z.
SELECT P.BusinessEntityID as ID,
       P.FirstName as ad,
	   P.LastName as soyad,
	   Pn.PhoneNumber as telefonnumaras�
       FROM Person.Person P inner join Person.PersonPhone  Pn on P.BusinessEntityID=Pn.BusinessEntityID
	   WHERE P.LastName LIKE 'L%' 

-- **********************************************************************************************
-- 30)'Sat�n Alma M�d�r�'  olarak atanan ki�ilerin ID (BusinessEntityID),isim ve soyad�n�;
-- soyada g�re artan s�rada listeleyen sql sorgusu yaz�n�z


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
-- 29) �r�n kalitesi 500 den fazla olan ve 'A' veya 'C' veya 'H' raf�nda bulunan her bir 
-- �r�n�n ID's�n� ve toplam miktar�n�,�r�n  ID's�ne g�re artan s�rada listeleyen sql sorgusunu yaz�n�z
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
--28)Her �ehirde �al��an say�s�n� almak i�in sql sorgusu yaz�n�z ,sonucu �ehre g�re artan d�zende s�ralay�n
--(iki s�tun:�ehir ve �al��an say�s�)
select 
       a.City as �ehir,
	   count(e.BusinessEntityID) as �al��an
from HumanResources.Employee as e 
     inner join Person.Person as p on e.BusinessEntityID=p.BusinessEntityID
	 inner join Person.BusinessEntity as b on p.BusinessEntityID=b.BusinessEntityID
     inner join Person.BusinessEntityAddress as ba on b.BusinessEntityID=ba.BusinessEntityID
     inner join Person.Address as a on a.AddressID=ba.AddressID
group by a.City
order by a.City ASC
-- **********************************************************************************************
-- 27)�r�nleri sat�� adet say�s�na g�re �oktan aza do�ru s�ralay�n�z.(�� s�tun :ProductID,ProductName,adet)
select
     p.ProductID as Id,
	 p.Name as name,
	 sum(s.OrderQty) as adet
from  Production.Product as p 
      inner join Sales.SalesOrderDetail as s on p.ProductID=s.ProductID
group by p.ProductID,p.Name
order by adet desc

-- **********************************************************************************************
-- 26) �lkelere g�re toplam sipari� tutarlar�n� �oktan aza do�ru getiriniz
select
      c.Name as �lke,
	  Sum(s.TotalDue) as miktar
from Sales.SalesOrderHeader as s
      inner join Sales.SalesTerritory as st on s.TerritoryID=st.TerritoryID
	  inner join  Person.CountryRegion as c on st.CountryRegionCode=c.CountryRegionCode
group by  c.Name
order by  miktar desc
-- **********************************************************************************************
-- 25) Her bir m��terinin toplam adet olarak ka� �r�n ald���n� yazd�ran bir sorgu yaz�n�z ,
-- �oktan aza do�ru s�ralay�n�z
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
-- 24)SalesPersonID, salesyear, totalsales, salesquotayear, salesquota ve amt_above_or_below_quota s�tunlar�n� bulmak 
-- i�in SQL'de bir sorgu yaz�n.Sonu� k�mesini ,SalesPersonID ve SalesYear s�tunlar�nda artan d�zende s�ralay�n

select sp.BusinessEntityID as person�d,
       YEAR(soh.DueDate) as salesyear,
       SUM(soh.TotalDue) as totalsales,
	   SUM(sp.SalesQuota) as quata
from Sales.SalesOrderHeader as soh
           inner join Sales.SalesPerson as sp on sp.TerritoryID=soh.TerritoryID
group by sp.BusinessEntityID ,YEAR(soh.DueDate)

-- **********************************************************************************************
--23) SalesOrderID i almak i�in SQL'de bir sorgu yaz�n.Belirli TerritoryID i�in herhangi bir sipari� yoksa 
-- NULL d�nd�r�l�r .TerritoryID,CountryRegionCode, ve SalesOrderID d�nd�r�r. Sonu�lar SalesOrderID ye g�re s�ralan�r,
-- b�ylece NULL 'lar en �stte g�r�n�r.

select 
     st.TerritoryID as TerritoryID,
	 st.CountryRegionCode as �lke,
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
-- 22) Orta ad�n NULL ' dan farkl� oldu�u sat�rlar� bulmak i�in SQL'de bir sorgu yaz�n.��letme varl�k kimli�i
-- ki�i t�r� , ad , ikinci ad, ve soyad�n� d�nd�r�n.Sonu� k�mesini ad �zerinden artan d�zende s�ralay�n
SELECT BusinessEntityID, PersonType, FirstName, MiddleName, LastName
FROM Person.Person
WHERE MiddleName IS NOT NULL
ORDER BY FirstName ASC
-- **********************************************************************************************
-- 21) Belirli bir �al��an�n �nceki �� ayl�k d�nemlere g�re sat�� kotalar�ndaki farkl� d�nd�rmek i�in SQL 'de
-- bir sorgu yaz�n.Sonu�lar� ,i�letme kimli�i 277 ve kota tarihi 2012 veya 2013 olan sat�� g�revlisine g�re
-- s�raly�n.
SELECT s.BusinessEntityID, 
       s.QuotaDate,
       s.SalesQuota - lag(s.SalesQuota) OVER (PARTITION BY s.BusinessEntityID ORDER BY s.QuotaDate) AS SalesQuotaDifference
FROM Sales.SalesPersonQuotaHistory s
WHERE s.BusinessEntityID = 277
  AND YEAR(s.QuotaDate) IN (2012, 2013)
ORDER BY s.QuotaDate
-- **********************************************************************************************
-- 20) Alan kodu 415 olan t�m telefon numaralar�n� bulmak i�in SQL 'de  bir sorgu yaz�n.Ad�,Soyad�n� ve
-- telefon numaras�n� d�nd�r�r.Sonu� k�mesini soyad�na g�re artan d�zende s�raly�n.
select
      p.FirstName as ad,
	  p.LastName as soyad,
	  pp.PhoneNumber as telefon
from Person.Person as p 
     inner join Person.PersonPhone as pp on p.BusinessEntityID=pp.BusinessEntityID
where  pp.PhoneNumber LIKE '415%'
-- **********************************************************************************************
-- 19)iki sorgunun birle�iminden olu�an bir sorgu yaz�n.1.sorgudan 2. sorguda da bulunmayan herhangi bir i�letme
-- kimli�i d�nd�r�n.Sonu� k�mesini businessentityID 'de artan d�zende s�ralay�n.
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
-- 18) Her i� unvan� i�in en y�ksek saatlik �creti d�nd�rmek i�in SQL'de bir sorgu yaz�n.Ba�l�klar�,maksimum
--  �deme oran� 40 dolardan fazla olan erkekler veya maksimum �deme oran� 42 dolardan fazla olan
-- kad�nlar taraf�ndan sahip olunanlarla s�n�rland�r�r.
SELECT e.JobTitle, MAX(eph.Rate) AS MaxHourlyRate
FROM HumanResources.Employee as e
     inner join HumanResources.EmployeePayHistory as eph on e.BusinessEntityID=eph.BusinessEntityID
WHERE e.Gender = 'M' AND eph.Rate > 40
    OR e.Gender = 'F' AND eph.Rate > 42
GROUP BY e.JobTitle;
-- **********************************************************************************************
-- 17)