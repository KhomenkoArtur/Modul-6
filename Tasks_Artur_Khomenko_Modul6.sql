Use Modul6;

go

--1


Select productid,name, city,
ROW_NUMBER() Over(Order by city ) as RowNumber
from products

--2

Select productid,name, city,
ROW_NUMBER() Over(PARTITION by city Order by name ) as RowNumber
from products

--3

Select *
	from (Select productid,name, city,
			ROW_NUMBER() Over(PARTITION by city Order by name ) as RowNumber
				from products) as RowNumber

		Where RowNumber = 1

--4
Select s.productid, s.detailid, s.quantity,
	SUM(s.quantity) Over(Partition by s.productid ) as all_quantity_per_prod,
	SUM(s.quantity) Over(Partition by s.detailid ) as all_quantity_per_det
	from [dbo].[products] as p 
		join [dbo].[supplies] as s ON p.productid = s.productid
			join details as d ON s.detailid = d.detailid

--5

Select *
	from (Select *,
		ROW_NUMBER () over(order by supplierid) as RowNumber,
		Count(*) over() as tot
		from [dbo].[supplies]) as a	
Where RowNumber between 10 and 15

--6
Select *
	from (Select supplierid, detailid,productid,quantity,
			AVG(quantity) over()as avg_quantity  
				from supplies) as ss
	Where quantity < avg_quantity				
