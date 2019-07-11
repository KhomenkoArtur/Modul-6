Use Modul6;

go

--1. Написати команду, яка повертає список продуктів, складений в алфавітному порядку міст де вони знаходяться
-- + порядковий номер деталі в списку (наскрізна нумерація для порядкового номера)

Select productid,name, city,
ROW_NUMBER() Over(Order by city ) as RowNumber
from products

--2. Написати команду, яка повертає список продуктів, складений в алфавітному порядку міст де вони знаходяться
-- + порядковий номер в межах одного міста (відсортований за іменем продукту)

Select productid,name, city,
ROW_NUMBER() Over(PARTITION by city Order by name ) as RowNumber
from products

--3. Використовуючи за основу попередній запит написати запит, який повертає міста з порядковим номером 1.

Select *
	from (Select productid,name, city,
			ROW_NUMBER() Over(PARTITION by city Order by name ) as RowNumber
				from products) as RowNumber

		Where RowNumber = 1

--4. Написати запит, який повертає список продуктів, деталей, їхні поставки, 
--загальну кількість поставок для кожного продукту і загальну кількість поставок для кожної деталі.
Select s.productid, s.detailid, s.quantity,
	SUM(s.quantity) Over(Partition by s.productid ) as all_quantity_per_prod,
	SUM(s.quantity) Over(Partition by s.detailid ) as all_quantity_per_det
	from [dbo].[products] as p 
		join [dbo].[supplies] as s ON p.productid = s.productid
			join details as d ON s.detailid = d.detailid

--5. Організувати посторінковий вивід інформації з таблиці поставок, відсортований за  постачальниками,
--вивести записи з 10 по 15 запис, додатково вивести порядковий номер стрічки і загальну кількість записів 
--у таблиці поставок.

Select *
	from (Select *,
		ROW_NUMBER () over(order by supplierid) as RowNumber,
		Count(*) over() as tot
		from [dbo].[supplies]) as a	
Where RowNumber between 10 and 15

--6. Написати запит, що розраховує середню кількість елементів в поставці і виводить ті поставки,
-- де кількість елементів менше середньої.
Select *
	from (Select supplierid, detailid,productid,quantity,
			AVG(quantity) over()as avg_quantity  
				from supplies) as ss
	Where quantity < avg_quantity				
