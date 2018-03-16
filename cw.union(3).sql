use library
select firstname, lastname, count(*) as [ilosc dzieci]
from member inner join adult on adult.member_no=member.member_no
			inner join juvenile on juvenile.adult_member_no=adult.member_no
where adult.state like 'AZ'
group by member.member_no, member.lastname, member.firstname 
having count(*) > 2

union

select firstname, lastname, count (*) as [ilosc dzieci]
from member inner join adult on member.member_no=adult.member_no	
			inner join juvenile on juvenile.adult_member_no=adult.member_no
where adult.state like 'CA'
group by member.member_no, member.lastname, member.firstname 
having count(*) > 3

