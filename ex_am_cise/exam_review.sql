#
# Exam 0921 or SS2021
####################################################

##############################
# Af 2)
##############################

######## a)
#i)
select v.Titel from Vorlesungen v where  v.Titel regexp 'ik';

#ii)



select s.MatrNr, s.Name ,v.Titel from studenten s, Vorlesungen v join hoeren h using(VorlNr) where
                         v.Titel regexp 'ik' and s.MatrNr  = h.MatrNr;

select s.MatrNr, s.Name, vor.Titel from studenten s, Vorlesungen vor join hoeren h on vor.VorlNr = h.VorlNr where
                         vor.Titel regexp 'ik' and s.MatrNr= h.MatrNr;
#-----
# Notice: This expression gives only the name and student number
select s.MatrNr, s.Name from studenten s where s.MatrNr in (select MatrNr from hoeren
    where VorlNr in (select v.VorlNr from Vorlesungen v where v.Titel regexp 'ik'));
#-----
#iii)
select p.Name, v.Titel from Professoren p left outer join Vorlesungen v on p.PersNr = v.gelesenVon;#

#------ only prof who has some lecture/s:
select p.Name, v.Titel from Professoren p, Vorlesungen v where p.PersNr = v.gelesenVon;
#oder:

select p.Name, v.Titel from Professoren p  join Vorlesungen v on p.PersNr = v.gelesenVon;

####### b)

select s.* from studenten s where s.MatrNr in (select p.MatrNr from pruefen p where p.PersNr in (
    select PersNr from Professoren where Name = 'Kant') and p.Note = 1);
#oder:
select s.Name, s.MatrNr from studenten s join pruefen p on s.MatrNr = p.MatrNr
where p.PersNr  in (select PersNr from Professoren where Name = 'Kant') and p.Note = 1;

select s.Name, s.MatrNr from studenten s join pruefen p on s.MatrNr = p.MatrNr and p.Note = 1
  join Professoren using(PersNr) where Professoren.Name = 'Kant';

# Af6
###################
# a)
######
create table Person (
    idPerson integer unique ,
    Name varchar(50),
    GebJahr integer ,
#     constraints
primary key (idPerson)

);

create table Stadt(
    idStadt integer unique ,
    Name    varchar(50) ,
#     Constraints
primary key (idStadt)
);

# b)
#######
create table wohntin(
    person integer unique ,
    City   integer unique ,
#     Constraints
primary key (person, City),
foreign key (person) references Person(idPerson) ,
foreign key (City)   references Stadt(idStadt)
);

# c)
######
insert into Person (idPerson, Name)
values (0241, 'Müller');

insert into Stadt (idStadt, Name)
values (52068, 'Aachen');

insert into wohntin select idPerson, idStadt from Person p, Stadt s where
p.Name = 'Müller' and s.Name = 'Aachen';



# d)
######
select s.Name, s.MatrNr from studenten s where s.Name in (select  p.Name from Professoren p where p.Name = s.Name);
#the next one shows the students who have the same prof as teacher (this can have redundancy)
select s.Name, s.MatrNr from studenten s right outer join hoeren h using (MatrNr)
where h.VorlNr in (select VorlNr from hoeren group by VorlNr having count(VorlNr) >1) group by MatrNr;
# here is similar to the last one but without redundancy
select s.Name, s.MatrNr from studenten s right outer join hoeren h using (MatrNr)
where h.VorlNr in (select VorlNr from hoeren group by VorlNr having count(VorlNr) >1) group by MatrNr;

select  s.MatrNr, s.Name from studenten s join Professoren P on s.Name = P.Name;

# e)
######
# 1 is first for only students who has done at least an exam
with st as (select s.Name, s.MatrNr from studenten s),
     pr as (select p.MatrNr, min(p.Note) as 'Best Note' from pruefen p group by (p.MatrNr))
select * from st join pr using(MatrNr) where pr.MatrNr = st.MatrNr;
# alternative to 1 using 'natural join'
with st as (select s.Name, s.MatrNr from studenten s),
     pr as (select p.MatrNr, min(p.Note) as 'Best Note' from pruefen p group by (p.MatrNr))
select * from st natural join pr;

# The second one is like to the first case with a specific best note
with st as (select s.Name, s.MatrNr from studenten s),
     pr as (select p.MatrNr, min(p.Note) as 'Best Note' from pruefen p group by (p.MatrNr))
select * from st join pr using(MatrNr) where pr.MatrNr = st.MatrNr and `Best Note`= 3;

  #where pr.MatrNr = st.MatrNr;
#     union select MatrNr, Name from studenten;

# select s.Name, s.MatrNr from studenten s where s.MatrNr in ()
select v.Titel  from Vorlesungen v where v.VorlNr = (select pru.VorlNr from pruefen pru, studenten s
where pru.MatrNr = s.MatrNr and s.Name = 'Jonas' and pru.PersNr = (
    select p.PersNr from Professoren p where p.Name = 'Sokrates') );

# b)
select s.MatrNr from studenten s where s.MatrNr in (select h.MatrNr from hoeren h, Vorlesungen v
where h.VorlNr = v.VorlNr and v.gelesenVon in (select p.PersNr from Professoren p where p.Name = 'Sokrates'));

select s.Name, s.MatrNr from studenten s where s.MatrNr not in (select MatrNr from hoeren h);
select s.Name, s.MatrNr from studenten s left outer join hoeren h on s.MatrNr = h.MatrNr
where isnull(h.MatrNr);
select s.Name, s.MatrNr from studenten s where s.MatrNr in (select h.MatrNr from hoeren h
    group by h.MatrNr having count(h.MatrNr) >= 2);
# the same as the last one
select v.Titel from Vorlesungen v where v.VorlNr in (select Nachfolger from voraussetzen vo);
# the same as the last one
select v.Titel from Vorlesungen v where v.VorlNr in (select Vorgaenger from voraussetzen vo);
# the successor and predecessor lectures
select v.Titel from Vorlesungen v where v.VorlNr in (select Vorgaenger from voraussetzen vo
    union select Nachfolger from voraussetzen);

select avg(Semester)  as 'avg_semester' from studenten s where s.MatrNr in(
    select h.MatrNr from hoeren h where h.VorlNr in (select v.VorlNr from Vorlesungen v
        where v.Titel = 'Grundzuege') );

create or replace view exam as(select p.Name as 'ProfName', v.Titel as 'lecture', s.Name as 'stName',
    pru.Note from Professoren p, Vorlesungen v, studenten s, pruefen pru
where p.PersNr = pru.PersNr and v.VorlNr = pru.VorlNr and s.MatrNr = pru.MatrNr);

select e.ExamName from exam e where e.ProfName ='Russel' group by e.ExamName;
select s.Name from studenten s where s.Semester >= 9;
select s.Name from studenten s  right outer join hoeren h using (MatrNr)
where h.VorlNr in(select v.VorlNr from Vorlesungen v where v.Titel = 'Grundzuege');

select s.Name from studenten s where s.MatrNr in(select h.MatrNr from hoeren h
    where h.VorlNr in(select v.VorlNr from Vorlesungen v where v.Titel = 'Grundzuege'));

select s.Name, sum(SWS) from studenten s, Vorlesungen v where s.MatrNr in (
    select pru.MatrNr from pruefen pru where  pru.VorlNr = v.VorlNr
    ) group by MatrNr;

select s.Name from studenten s where s.MatrNr in (select pru.MatrNr
    from pruefen pru join Professoren p using (PersNr)
    where p.Name = 'Sokrates' and pru.Note in (
        select min(Note) from pruefen where Note = pru.Note
    )) group by MatrNr;

select s.Name from studenten s join pruefen pru using (MatrNr) where pru.PersNr in (
    select p.PersNr from Professoren p where p.Name = 'Sokrates' and pru.Note in (
        select min(Note) from pruefen where p.PersNr = PersNr) );
select s.Name from studenten s where s.MatrNr in ( select pru.MatrNr from pruefen pru, Professoren p
    where pru.PersNr = p.PersNr and p.Name = 'Sokrates' and pru.Note in (
        select min(Note) from pruefen where PersNr = p.PersNr));
#e exam 9_6_2

select p.Name from Professoren p where p.PersNr not in (select gelesenVon from Vorlesungen);

create table Projekte(
   Name varchar(35) not null default 'alexanderwuensch' ,
   ProjNr integer not null default 0241 ,
   PersNr integer not null ,
   Startet varchar(30) not null ,
   LaufZeit integer not null ,
#    constraints
primary key (ProjNr),
foreign key (PersNr) references Professoren(PersNr),
check ( LaufZeit between 6 and 36)
);

alter table Projekte add (
    projektGeber varchar(35) not null default 'AlexandersFreund'
    );
insert into Projekte ( PersNr, Startet, LaufZeit)
values ((select PersNr from Professoren where Name = 'Sokrates'),'27.01.2022', 32);

update Projekte
set Name = 'Alexanderwuensch'
where Name = 'alexanderwuensch';
drop table Projekte;

select s.MatrNr from studenten s where s.MatrNr in (select h.MatrNr from hoeren h join Vorlesungen v
 using(VorlNr) where v.gelesenVon in (select p.PersNr from Professoren p where p.Name = 'Sokrates'));

# the last is exact what was in the task but gives redundancy
# because some students participate at more than on lecture of Sokrates

select s.MatrNr from studenten s join hoeren h on s.MatrNr = h.MatrNr where h.VorlNr in (
select v.VorlNr from Vorlesungen v where v.gelesenVon=2125);



# e
# with s as(s.MatrNr, s.Name, from studenten s) s.MatrNr, s.Name, from studenten s

#############################################################################################################
#exam WS2021-2022
#############################################################################################################

#  Af5
###############################################################################################

##################
# a)
select v.Titel from Vorlesungen v where  v.VorlNr in (select Nachfolger from voraussetzen
                     where Vorgaenger in (select VorlNr from Vorlesungen where Titel= 'Grundzuege'))
and v.VorlNr in (select Nachfolger from voraussetzen
                     where Vorgaenger in (select VorlNr from Vorlesungen where Titel= 'Ethik'));

##################
# b)

select s.Name, s.MatrNr, v.Titel from studenten s, Vorlesungen v join pruefen p on v.VorlNr = p.VorlNr where
v.gelesenVon in (select prof.PersNr from Professoren prof where prof.Name='Kopernikus') and s.MatrNr = p.MatrNr;

# or:
select s.Name, s.MatrNr, v.Titel from studenten s, Vorlesungen v join pruefen p on v.VorlNr = p.VorlNr where
s.MatrNr = p.MatrNr and v.gelesenVon in (select prof.PersNr from Professoren prof where prof.Name='Kopernikus');

##################



#  Af7
###############################################################################################
# a)
#####
select v.VorlNr from Vorlesungen v where v.Titel regexp 'Theo';

# b)
######
# with p as ( select p.Name, p.PersNr, count(PersNr)  from Professoren p where p.PersNr in (
#     select Boss from Assistenten))
# select p.Name, p.PersNr, count(A.PersNr) from p, Assistenten A group by  p.PersNr and A.PersNr
# in(select A from P );

select p.Name, p.PersNr, count(PersNr)  as 'Assist_num' from Professoren p where p.PersNr in (
    select Boss from Assistenten) group by PersNr;

# This gives only professor with Assistant
select p.Name, p.PersNr, count(p.PersNr) as 'Assist_count' from Professoren p right outer join Assistenten A
    on p.PersNr = A.Boss group by p.PersNr;

# Similar to the last one
select p.Name, p.PersNr, count(* )  as 'Assist_count' from Professoren p left outer join Assistenten A
    on p.PersNr = A.Boss where !ISNULL(A.Boss) group by A.PersNr;

select p.Name, p.PersNr, count(* )  as 'Assist_count' from Professoren p left outer join Assistenten A
    on p.PersNr = A.Boss where !ISNULL(A.Boss) group by A.Boss;

select p.Name, p.PersNr, count(* )  as 'Assist_count' from Professoren p left outer join Assistenten A
    on p.PersNr = A.Boss where !ISNULL(A.PersNr) group by A.Boss;


# with pr as (select p.Name, p.PersNr from Professoren p where )

select p.Name, p.PersNr, count(*) as 'Assist_count' from Professoren p left outer join Assistenten A
    on p.PersNr = A.Boss where !ISNULL(A.Boss) group by A.Boss;


# true sql?


# c
##########
select v.Titel from Vorlesungen v where v.gelesenVon in (select A.Boss from
                           Assistenten A where  ISNULL(A.PersNr%2=A.Boss%2 ));

select v.Titel from Vorlesungen v where v.gelesenVon in (select A.Boss from
                           Assistenten A where A.PersNr%2=A.Boss%2 );

select v.Titel from Vorlesungen v where v.gelesenVon in (select A.Boss from
                           Assistenten A where A.PersNr%2=A.Boss%2 );


# d)
#######

select s.Name, s.MatrNr from studenten s join Assistenten A on s.Name = A.Name;



# hier passiert redunduncy Idee dabei ligit bei der count  assistanten abhängig kursen der Professor abgibt
select s.Name, s.MatrNr from studenten s right outer join hoeren h using (MatrNr)
    where h.VorlNr in (select VorlNr from hoeren group by VorlNr having count(VorlNr) >1) ;
# hieir ohne redundancy

select s.Name, s.MatrNr from studenten s right outer join hoeren h using (MatrNr)
where h.VorlNr in (select VorlNr from hoeren group by VorlNr having count(VorlNr) >1) group by MatrNr;

# e)
#######
with av as (select p.MatrNr,p.VorlNr from pruefen p where p.Note > (select avg(Note) from pruefen ))
select v.VorlNr, v.Titel, s.Name, s.MatrNr  from studenten s, Vorlesungen v join av on v.VorlNr=av.VorlNr
where s.MatrNr=av.MatrNr;

# f)
#######
# ohne Anzahl der Studenten:
select p.Name, p.PersNr from Professoren p where p.Name regexp ('^(A|C)') and  p.PersNr in (
select gelesenVon from Vorlesungen  group by gelesenVon having count(SWS) < 10);

select p.Name, p.PersNr, count(s.MatrNr) from Professoren p, studenten s where p.Name regexp ('^(A|C)') and
p.PersNr in (select gelesenVon from Vorlesungen group by gelesenVon having count(SWS) < 10) and s.MatrNr in (
    select  from hoeren
    );

