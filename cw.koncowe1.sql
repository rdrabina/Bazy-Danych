use library
--æw1
select title, title_no 
from title

select title 
from title 
where title_no=10

select member_no, fine_assessed 
from loanhist 
where fine_assessed between 8 and 9

select title_no, author 
from title 
where author like 'Charles Dickens' or author like 'Jane Austen'

select title_no, title 
from title 
where title like '%adventures%'

select member_no, fine_assessed, fine_paid 
from loanhist 
where isnull(fine_assessed,0)> isnull(fine_paid,0) + isnull(fine_waived,0)

select distinct city, state 
from adult

--æw.2
select title 
from title 
order by title 

select member_no, isbn, fine_assessed,fine_assessed*2 
as [double fine] 
from loanhist 
where isnull (fine_assessed,0)>0

select firstname + middleinitial + lastname 
as 'email_name'
from member 
where lastname like 'Anderson'

select lower(firstname+middleinitial+substring(lastname,1,2))
as 'email_name' 
from member
where lastname like 'Anderson'

select 'The title is: ' + title +', title number ' + convert (varchar(2),title_no) 
from title