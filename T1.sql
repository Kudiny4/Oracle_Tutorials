--���� ������� � ��������, ������� �������� � ����������� ��������� � �����.
--��� ������� ������ ���������:
-- -���������� ������� ���� � ��������� ������
-- -����������� ���������� ��������
-- -������������ ���������� ��������
--����������� �������� ������� � ���������� �������.

create table cities(name varchar2(100));
insert into cities(name) values('������   ');
insert into cities(name) values('������');
insert into cities(name) values('������ ');
insert into cities(name) values('�����    ');
insert into cities(name) values('�����     ');
insert into cities(name) values('�����������  '); 


select name, vowels, min(space), max(space) 
from(
select regexp_count(name, '�|�|�|�|�|�|�|�|�|�', 1, 'i') vowels,
replace(name, ' ') name,
regexp_count(name, ' ') space
from cities
)
group by name, vowels 
order by name;

