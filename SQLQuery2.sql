use RFM

select *
from ONLINERETAIL_2010_

TRUNCATE TABLE RFM1

INSERT INTO RFM1([Customer ID])
SELECT DISTINCT [Customer ID] FROM ONLINERETAIL_2010_


ALTER TABLE RFM1
ADD LastInvoiceDate datetime;

ALTER TABLE RFM1
ADD Recency int;

ALTER TABLE RFM1
ADD Frequency int;

ALTER TABLE RFM1
ADD Monetary int;

ALTER TABLE RFM1
ADD Recency_Scale int;

ALTER TABLE RFM1
ADD Frequency_Scale int;

ALTER TABLE RFM1
ADD Monotery_Scale datetime;

ALTER TABLE RFM1
ADD Segment varchar(100);


select*
from RFM1

UPDATE RFM1 SET InvoiceDate=(SELECT MAX(InvoiceDate) 
FROM ONLINERETAIL_2010_ where [Customer ID]=RFM1.[Customer ID])

select*
from RFM1

UPDATE RFM1 SET Recency=DATEDIFF(DAY,[LastInvoiceDate],'20111231')

UPDATE RFM1 SET Frequency=(SELECT COUNT(Distinct Invoice) FROM ONLINERETAIL_2010_ where [Customer ID]=RFM1.[Customer ID])

UPDATE RFM1 SET Monetary=(SELECT sum(Price*Quantity)  FROM ONLINERETAIL_2010_ where [Customer ID]=RFM1.[Customer ID])



UPDATE RFM1 SET Recency_Scale= 
(
 select RANK from
(
SELECT  *,
       NTILE(5) OVER(
       ORDER BY Recency desc) Rank
FROM RFM1
) t where  [Customer ID]=RFM1. [Customer ID])




update RFM1 SET Frequency_Scale= 
(
 select RANK from
(
SELECT  *,
       NTILE(5) OVER(
       ORDER BY Frequency) Rank
FROM RFM1
) T where  [Customer ID]=RFM1. [Customer ID])

select*
from RFM1


update RFM1 SET Monotery_Scale= 
(
 select RANK from
 (
SELECT  *,
       NTILE(5) OVER(
       ORDER BY Monetary) Rank
FROM RFM1 
) t where  [Customer ID]=RFM1. [Customer ID])



UPDATE RFM1 SET Segment ='Hibernating' 
WHERE Recency_Scale LIKE  '[1-2]%' AND Frequency_Scale LIKE '[1-2]%'  
UPDATE RFM1 SET Segment ='At_Risk' 
WHERE Recency_Scale LIKE  '[1-2]%' AND Frequency_Scale LIKE '[3-4]%'  
UPDATE RFM1 SET Segment ='Cant_Loose' 
WHERE Recency_Scale LIKE  '[1-2]%' AND Frequency_Scale LIKE '[5]%'  
UPDATE RFM1 SET Segment ='About_to_Sleep' 
WHERE Recency_Scale LIKE  '[3]%' AND Frequency_Scale LIKE '[1-2]%'  
UPDATE RFM1 SET Segment ='Need_Attention' 
WHERE Recency_Scale LIKE  '[3]%' AND Frequency_Scale LIKE '[3]%' 
UPDATE RFM1 SET Segment ='Loyal_Customers' 
WHERE Recency_Scale LIKE  '[3-4]%' AND Frequency_Scale LIKE '[4-5]%' 
UPDATE RFM1 SET Segment ='Promising' 
WHERE Recency_Scale LIKE  '[4]%' AND Frequency_Scale LIKE '[1]%' 
UPDATE RFM1 SET Segment ='New_Customers' 
WHERE Recency_Scale LIKE  '[5]%' AND Frequency_Scale LIKE '[1]%' 
UPDATE RFM1 SET Segment ='Potential_Loyalists' 
WHERE Recency_Scale LIKE  '[4-5]%' AND Frequency_Scale LIKE '[2-3]%' 
UPDATE RFM1 SET Segment ='Champions' 
WHERE Recency_Scale LIKE  '[5]%' AND Frequency_Scale LIKE '[4-5]%'


Select Segment,COUNT(*) as Count_ from RFM1

GROUP BY Segment
ORDER BY Count_ DESC