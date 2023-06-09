select * from Professoren;

#  Renaming
############################################################
select s.Name, v.Titel from studenten as s, hoeren as h, Vorlesungen as v
   where s.MatrNr = h.MatrNr and h.VorlNr =  v.VorlNr;
#  The following commented SQL statement  is not optimal because of overhead for student lessening
# select s1.Name, s2.Name, h1.MatrNr, h2.MatrNr from studenten s1, studenten s2, hoeren h1, hoeren h2;
select s1.Name, s2.Name, h1.MatrNr, h2.MatrNr from studenten  as s1 , hoeren as h1, hoeren as h2, studenten as s2
    where (h1.VorlNr = h2.VorlNr and h1.MatrNr = s1.MatrNr and h2.MatrNr = s2.MatrNr);

# Without conjugation 'as' variable s2 can be work!
select s2.Name from studenten s2, studenten  as s1 , hoeren as h1, hoeren as h2
    where (h1.VorlNr = h2.VorlNr and h1.MatrNr = s1.MatrNr and h2.MatrNr = s2.MatrNr and s1.MatrNr = 26120);

with s1 as (select MatrNr as 'S_MatrNr', Name as 'S_Name' from  studenten where MatrNr = 26120 ),
     h1 as (select MatrNr as 'H_MatrNr' from hoeren )
     select Name, VorlNr  from studenten,  hoeren, s1, h1 where H_MatrNr = s1.S_MatrNr;
#
# with s1 as (select MatrNr , Name  from  studenten where MatrNr = 26120 ),
#      h1 as (select MatrNr, VorlNr from hoeren )
#      select Name, VorlNr  from studenten,  hoeren, s1, h1 where H_MatrNr = s1.MatrNr;
#
#      select s1.Name, h2.MatrNr from studenten as s2, hoeren as h2 join s1 using() h1;
#

#  Set operations
#############################################################
select Name from studenten join Assistenten using(Name);
select Name from studenten left join Assistenten using (Name) where Assistenten.Name is null;

# select s1.Name from studenten s1
#
# select A1.Name  Assistenten A1

# Selection
#############################################################
select PersNr, Name, Rang from Professoren;
select PersNr, Name, Rang from Professoren order by Rang;
# To order decreasing add 'desc' at the end of the attribute
select PersNr, Name, Rang from Professoren order by Rang desc;
select PersNr, Name, Rang from Professoren order by Rang desc, Name desc;

# Here a combination of the increasing 'Range' and decreasing '.Name'
select PersNr, Name, Rang from Professoren order by Rang , Name desc;

# Sub-selection
################
# Correlation(PersNr = gelesenVon)! For professor with no lecture listed null.
select PersNr, Name, (select sum(SWS) from Vorlesungen where PersNr = gelesenVon)
    as Lehrbelastung from Professoren;
#  The result in the sub-query will not be printed because all Prof did not present a lecture e.g.
select p.PersNr, p.Name from Professoren p where exists (select sum(SWS) # Kopernikus
from Vorlesungen v where v.gelesenVon =  p.PersNr = 2125); # O(|p|*|v|)

# Without control of it  the sub-query will be validated therefor the cost is O(|P|).
select p.PersNr  from Professoren p where p.PersNr in (select  gelesenVon from Vorlesungen);

#  This shows only professor who presents some lecture
select T.* from (select p.PersNr, p.Name, sum(v.SWS) as 'Lehrbelastung' from Vorlesungen v , Professoren p
    where v.gelesenVon = p.PersNr group by p.PersNr, p.Name) T;

# The assistant older his professor
select A.Name, p.Name from (Assistenten A join Professoren P on A.Boss = p.PersNr)
    where p.GebDatum > A.GebDatum; # 'Join' is highly optimized in RDBMS
#  the students who have minimum semester number
select Name from studenten where Semester <= all (select Semester from studenten);


# all students who are visited  a lecture with 4 hours
select s.*, count(*) as 'num' from studenten s where s.MatrNr  # Using() and on () are the same.
        in  (select MatrNr from hoeren h join  Vorlesungen V
              using(VorlNr) where V.SWS =4) group by s.MatrNr;
#  Students who attended all lecture with 4 hours
select s.* from studenten s where not exists (select v.SWS, v.VorlNr from Vorlesungen v where v.SWS = 4
and not exists (select * from hoeren h where v.VorlNr = h.VorlNr and h.MatrNr = s.MatrNr));

select p.* from pruefen p where p.Note < (select avg(p.Note) from pruefen p);
# students who attended at least 20% of all lectures
 (select MatrNr from hoeren  group by MatrNr
      having count(*) >= 0.2 *(select count(*) from Vorlesungen));

# students who attended in some lecture but at most 10% of all lectures
with h as (select MatrNr from hoeren group by MatrNr
      having count(*) <= 0.1 * (select count(*) from Vorlesungen))
select * from studenten s right outer join h using(MatrNr);
# students who attended at most 10% of all lectures (It can be that student never attended on the lecture!)
with s1 as (select MatrNr from hoeren  group by MatrNr
      having count(*) <= 0.1 *(select count(*) from Vorlesungen) union
    select s.MatrNr from studenten s left outer join hoeren h
         using (MatrNr) where isnull(h.MatrNr) )
select * from studenten st right outer join s1 using(MatrNr)  ;

# specific columns namely entities from sub-selection
select K.* from (select p.MatrNr, p.Note from pruefen p
    where p.Note < (select avg(Note) from pruefen )) K where K.MatrNr = 0 ;


#  Join and Semi-Join
###############################################################################
with Pr as (select p.MatrNr as 'P_MatrNr', p.Note as 'P_Note' from pruefen p
        where p.Note < (select avg(Note) from pruefen )),
     St as (select S.MatrNr, S.Name from studenten as S)
select * from Pr join St on P_MatrNr = St.MatrNr;
#  the same result as the above by 'inner-join'
with Pr as (select p.MatrNr as 'P_MatrNr', p.Note as 'P_Note' from pruefen p
        where p.Note < (select avg(Note) from pruefen )),
     St as (select S.MatrNr, S.Name from studenten as S)
select * from Pr inner join St on P_MatrNr = St.MatrNr;

#  Focus of the right side therefore some entries can happen with null value.
with Pr as (select p.MatrNr as 'P_MatrNr', p.Note as 'P_Note' from pruefen p
        where p.Note < (select avg(Note) from pruefen )),
     St as (select S.MatrNr, S.Name from studenten as S)
select * from Pr right outer join St on P_MatrNr = St.MatrNr;
# the same as like first statement in the join
with Pr as (select p.MatrNr as 'P_MatrNr', p.Note as 'P_Note' from pruefen p
        where p.Note < (select avg(Note) from pruefen )),
     St as (select S.MatrNr, S.Name from studenten as S)
select * from Pr left outer join St on P_MatrNr = St.MatrNr;
#Here the redundancy column 'MatrNr' is discarded using intersection
with Pr as (select p.MatrNr , p.Note as 'P_Note' from pruefen p
        where p.Note < (select avg(Note) from pruefen )), # To use 'MatrNr' we have to distinguish the attribute for two different schema(table)
     St as (select S.MatrNr, S.Name from studenten as S)
select * from St  join Pr using (MatrNr) where Pr.MatrNr = St.MatrNr;
#  Exam
#####################################################
# The list of all lecture names with all students who are at them attended
with st as (select s.MatrNr, h.VorlNr from studenten  s, hoeren  h
           where s.MatrNr = h.MatrNr ), # group by VorLNr is not possible because MatrNr not subset of VorLNr
     pr as (select p.PersNr, v.VorlNr, v.gelesenVon, v.Titel from Professoren p, Vorlesungen v
             where v.gelesenVon = p.PersNr)
     select pr.Titel, st.MatrNr from st join pr using(VorlNr) where pr.VorlNr = st.VorlNr ;
########################################################
# The list of student numbers attended of the lectures presented by Socrates.
# 1)with lecture title
with st as (select s.MatrNr, h.VorlNr from studenten  s, hoeren  h
           where s.MatrNr = h.MatrNr ), # group by VorLNr is not possible because MatrNr not subset of VorLNr
     pr as (select p.PersNr, v.VorlNr, v.gelesenVon, v.Titel from Professoren p, Vorlesungen v
             where v.gelesenVon = p.PersNr and  p.PersNr = 2125 )
     select pr.Titel, st.MatrNr from st join pr  using(VorlNr) where pr.VorlNr = st.VorlNr ;
# 2) only student number
select M.* from (select s.MatrNr from studenten s, Professoren p, hoeren h, Vorlesungen v
    where  s.MatrNr = h.MatrNr and h.VorlNr = v.VorlNr
      and v.gelesenVon = p.PersNr and p.PersNr = 2125) M;
# 3) The same result as 2)
select * from studenten right outer join hoeren h using (MatrNr) where h.VorlNr in (
    select v.VorlNr from Vorlesungen v where  v.gelesenVon = 2125);
###########################################################
# The lecture that Fichte had attended and presented by professor Socrates
with st as (select s.MatrNr, h.VorlNr from studenten  s, hoeren  h
           where s.MatrNr = h.MatrNr and s.MatrNr = 26120), # group by VorLNr is not possible because MatrNr not subset of VorLNr
     pr as (select p.PersNr, v.VorlNr, v.gelesenVon, v.Titel from Professoren p, Vorlesungen v
             where v.gelesenVon = p.PersNr and p.PersNr = 2125 )
     select pr.Titel, st.MatrNr from st join pr  using(VorlNr) where pr.VorlNr = st.VorlNr ;

#regarding to Exam 03.2021 Af3a
#################################
#  1) title and student number
#  Instead 'P.*' you can use 'p.Title'. This show the lecture at whose exam the student jonas was participated
select P.* from (select v.Titel from studenten s,Professoren pr, Vorlesungen v, pruefen pru
    where pru.MatrNr = s.MatrNr and s.MatrNr = 25403 and pru.VorlNr = v.VorlNr and pr.PersNr = v.gelesenVon
    and pru.PersNr = pr.PersNr and pr.PersNr = 2125) p; # the condition 'pr.PersNr = v.gelesenVon' is not

# The same as the last one instead '=' you can use 'in'

select v.Titel  from Vorlesungen v where v.VorlNr = (select pru.VorlNr from pruefen pru, studenten s
where pru.MatrNr = s.MatrNr and s.Name = 'Jonas' and pru.PersNr = (
    select p.PersNr from Professoren p where p.Name = 'Sokrates') );
#  b)

# b)
select s.MatrNr from studenten s where s.MatrNr in (select h.MatrNr from hoeren h, Vorlesungen v
where h.VorlNr = v.VorlNr and v.gelesenVon in (select p.PersNr from Professoren p where p.Name = 'Sokrates'))

# the condition 'pr.PersNr = v.gelesenVon' is not necessary, focus is at the relation 'pruefen'
select P.* from (select v.Titel from studenten s,Professoren pr, Vorlesungen v, pruefen pru
    where pru.MatrNr = s.MatrNr and s.MatrNr = 25403 and pru.VorlNr = v.VorlNr
    and pru.PersNr = pr.PersNr and pr.PersNr = 2125) p;
#  the same result but arose with repetition regarding the number of the exam which is applied by Socrates.
with st as (select s.MatrNr, pru.VorlNr from studenten  s, pruefen pru, Professoren p
           where s.MatrNr = pru.MatrNr and s.MatrNr = 25403 and pru.PersNr = p.PersNr and p.PersNr = 2125), #and pru.VorlNr = v.VorlNr), # group by VorLNr is not possible because MatrNr not subset of VorLNr
     pr as (select p.PersNr, v.VorlNr, v.Titel from Professoren p, Vorlesungen v, pruefen pru
             where pru.PersNr = p.PersNr  and p.PersNr = 2125 )
     select pr.Titel, st.MatrNr from pr join st  using(VorlNr) where pr.VorlNr = st.VorlNr ;


# Exam 03.2021 , Af 5
###############################
#  a)
select s.Name, s.MatrNr  from studenten s left outer join hoeren h
    using(MatrNr) where isnull(h.MatrNr);
# the same as the last one
select s.Name, s.MatrNr from studenten s where s.MatrNr not in (select MatrNr from hoeren h);

#  b)
select s.Name, s.MatrNr from studenten s where s.MatrNr in (select h.MatrNr from hoeren h
    group by h.MatrNr having count(h.MatrNr) >= 2);

# the same as the last one
 with h as (select MatrNr  from hoeren group by MatrNr having count(*) >= 2)
select s.Name, s.MatrNr from studenten s right outer join h using (MatrNr);
# c)
########
# First try
with v1 as ( select v.VorlNr from Vorlesungen v, voraussetzen vo where v.VorlNr = vo.Vorgaenger),
     v2 as ( select v.VorlNr from Vorlesungen v, voraussetzen vn where v.VorlNr = vn.Nachfolger)
select * from v1 join v2 using (VorlNr);

# To avoid redundancies existed in the 'vorassetzen' table the expression must be grouped by 'VorlNr'

# Solution to c) part 1
select v.Titel from Vorlesungen v where v.VorlNr in (select Nachfolger from voraussetzen vo);

# the same as the last one
with v1 as (select v.VorlNr from Vorlesungen v, voraussetzen vo
                        where v.VorlNr = vo.Vorgaenger group by VorlNr)
select Titel  from Vorlesungen right outer join v1 using (VorlNr) ;
# The same result as the last one
with v1 as (select v.VorlNr from Vorlesungen v, voraussetzen vo where v.VorlNr = vo.Vorgaenger)
select Titel  from Vorlesungen right outer join v1 using (VorlNr) group by VorlNr;
# Solution to c) part 2
select v.Titel from Vorlesungen v where v.VorlNr in (select Vorgaenger from voraussetzen vo);

# The same result as the last one
with v1 as (select v.VorlNr from Vorlesungen v, voraussetzen vo where v.VorlNr = vo.Nachfolger)
select Titel  from Vorlesungen right outer join v1 using (VorlNr) group by VorlNr;

# the successor and predecessor lectures
select v.Titel from Vorlesungen v where v.VorlNr in (select Vorgaenger from voraussetzen vo
    union select Nachfolger from voraussetzen);


# d)
select avg(Semester) as 'MeanSemester' from studenten right outer join hoeren h using(MatrNr)
  where h.VorlNr in (select VorlNr from Vorlesungen v where v.Titel = 'Grundzuege');

# the same as the last one but the above is more optimized(because of join operator)
select avg(Semester)  as 'avg_semester' from studenten s where s.MatrNr in(
    select h.MatrNr from hoeren h where h.VorlNr in (select v.VorlNr from Vorlesungen v
        where v.Titel = 'Grundzuege') );

# e)
# Redundancy because there is no condition corresponding to the relations
create or replace view  exam as (select pro.Name as 'ProfName', v.Titel, s.Name as StudentName, pru.Note
    from Professoren pro, Vorlesungen v, studenten s, pruefen pru);
# Correction of the above expression but with redundancy of
create or replace view exam as (select pro.Name as 'ProfName', v.Titel as 'ExamName',
                                       s.Name as StudentName, pru.Note
    from Professoren pro, Vorlesungen v, studenten s, pruefen pru where pro.PersNr = pru.PersNr and
                                        v.VorlNr = pru.VorlNr and s.MatrNr = pru.MatrNr);
# f)
# here again redundancy from Prof
select e.ExamName from exam e where ProfName = 'Sokrates';

# to avoid the above redundancy use group
select e.ExamName from exam e where  e.ProfName = 'Sokrates' group by e.ExamName  ;

############################################################
# Exam db-Muster
############################################################
# Af5
################
# a)
################
select Name from studenten where Semester >= 9;

# b)
################
select s.Name from studenten s  right outer join hoeren h using (MatrNr)
where h.VorlNr in(select v.VorlNr from Vorlesungen v where v.Titel = 'Grundzuege');

# The same as the last one
select Name from studenten join hoeren h using(MatrNr) # the condition VorlNr = h.VorlNr is necessary.
        where (select VorlNr from Vorlesungen where VorlNr = h.VorlNr and Titel = 'Grundzuege');
# The same as the last one
select s.Name from studenten s where s.MatrNr in(select h.MatrNr from hoeren h
    where h.VorlNr in(select v.VorlNr from Vorlesungen v where v.Titel = 'Grundzuege'));
# c)
#################
# The first expression is the result abut that is asked. But I think the next expression is more reasonable
select s.Name as ' studentName', sum(v.SWS) as 'sum_SWS'  from studenten s, Vorlesungen v where s.MatrNr in (
    select MatrNr from pruefen where VorlNr = v.VorlNr ) group by MatrNr;

# Every student participated iat exam whose SEW is fixed in the semester. Therefore SUN´M(SWS) is non-scenes
select s.Name, v.SWS  from studenten s, Vorlesungen v where s.MatrNr in (
    select MatrNr from pruefen where s.MatrNr =MatrNr and v.VorlNr = VorlNr);

# the same result as the first expression
with st as ( select s.Name as 'studentName', s.MatrNr from studenten s right outer join pruefen using (MatrNr)),
     vo as ( select sum(v.SWS) as 'sum_SWS', p.MatrNr from Vorlesungen v, pruefen p where v.VorlNr = p.VorlNr group by MatrNr)
select studentName, sum_SWS from st join vo using (MatrNr);

#  this one gives not only the name of student who participated at sum exam in one column
#  but also the sum all lectures which are to exam.
select s.Name from studenten s right outer join pruefen using(MatrNr) union
select sum(v.SWS) from Vorlesungen v right outer join pruefen using (VorlNr);

#  the same results for the tow next expression before the part d)
with st as ( select s.Name, s.MatrNr from studenten s right outer join pruefen using (MatrNr)),
     vo as ( select  p.MatrNr from pruefen p left outer join Vorlesungen using (VorlNr))
select st.Name from st right outer join vo using (MatrNr);

with st as ( select s.Name, p.MatrNr from studenten s, pruefen p where s.MatrNr = p.MatrNr),
     vo as ( select v.SWS, p.MatrNr from Vorlesungen v, pruefen p where v.VorlNr = p.VorlNr)
select st.Name from st  right outer join vo using (MatrNr);

# d)
#####################
# The first expression is the result abut that is asked.
select s.Name from studenten s where s.MatrNr in (select pru.MatrNr  from pruefen pru, Professoren p
    where pru.PersNr = p.PersNr and p.Name = 'Sokrates' and  pru.Note in
    (select min(Note) from pruefen  where PersNr = p.PersNr));
# The same result as the first
select s.Name from studenten s join pruefen pru using (MatrNr)
    where pru.PersNr in (select p.PersNr from Professoren p
    where p.Name = 'Sokrates' and  pru.Note in
    (select min(Note) from pruefen p2 where p2.PersNr = pru.PersNr) );

# # the same result as the first expression but left outer join is not allowed (only 'join'/ 'right outer join')
with st as ( select pru.MatrNr, pru.Note, pru.PersNr from pruefen pru left outer join Professoren P
    using(PersNr) where P.Name = 'Sokrates' and
                        pru.Note in(select min(Note) from pruefen  where PersNr =pru.PersNr) )
select Name from studenten join st using (MatrNr);

# The 'min()' function in the next expression get only on argument for any 'pru.PersNr'. Thus doesn't work truly.
select s.Name from studenten s join pruefen pru using (MatrNr)
    where pru.PersNr in (select p.PersNr from Professoren p
    where pru.PersNr = p.PersNr and p.Name = 'Sokrates' and  pru.Note having min(Note));

# e)
###############
# The first expression is the result abut that is asked but the next expression is more optimized
select p.Name from Professoren p
    where p.PersNr not in(select gelesenVon from Vorlesungen);
# Because using join is the following more optimized than the last one. Notice to the 'left (outer) join'
select p.Name from Professoren p left outer join Vorlesungen V
    on p.PersNr = V.gelesenVon where isnull(gelesenVon);

# f)
###############
create table Projekte(
    Name varchar(50) unique not null ,
    ProjNr integer unique ,
    LeiterNr integer,
    StartTermin varchar(30) ,
    Laufzeit integer ,
#   constraint
    primary key (ProjNr) ,
    foreign key (LeiterNr) references Professoren(PersNr),
    check (Laufzeit between 6 and 36)
);
##################################################
# g)
##################################################
# i)
########
alter table Projekte add (
    ProjektGeber varchar(30) not null
    );

# ii)
########
# Insert a project without  Name , leader number and project sponsor
insert into Projekte( ProjNr, StartTermin, Laufzeit)
values (2, '31.12.2021', 31);
# Modify the table around default
alter table Projekte modify Name varchar(30) not null default 'SokratesWuensch';
alter table Projekte modify ProjektGeber varchar(30) not null default 'SokratesFreund';
alter table Projekte modify ProjNr integer default 14;

# delete duplication project name to prepare insertion for leader number with 'Socrates'
delete from Projekte where Name = 'SokratesWuensch';

# Insert a project leader number with 'Socrates'
insert Projekte(LeiterNr) select PersNr
from Professoren p where p.Name = 'Sokrates';

# Update the table for project number whose leader is 'Socrates'
update Projekte
set ProjNr = 13
where LeiterNr in (select PersNr from Professoren where Name = 'Sokrates');
# iii)
########
update Projekte
set LeiterNr = (select PersNr from Professoren where Name = 'Kant')
where LeiterNr in (select PersNr from Professoren where Name = 'Sokrates');

# iv)
######
#  First add Project with name 'Grid Computing'
insert into Projekte (Name)
values ('Grid Computing');
# Now delete the project with that name
delete from Projekte where Name = 'Grid Computing';

# v)
######
drop table Projekte;

####################################################

# h)
###########
create view lecture_from_Juelich as (select * from Vorlesungen v
where gelesenVon in (select PersNr from Professoren where Standort = 'Jülich'));

######################################################
# Exam 0921
######################################################

# Auf2
##############################

# a)
##########
# i)
select v.Titel from Vorlesungen v where v.Titel regexp 'ik';

# ii)
select s.MatrNr, s.Name from studenten s where s.MatrNr in (select MatrNr from hoeren
    where VorlNr in (select v.VorlNr from Vorlesungen v where v.Titel regexp 'ik'));

with st as (select s.MatrNr, s.Name, Titel from studenten s, Vorlesungen where s.MatrNr
      in (select MatrNr from hoeren where VorlNr in (select v.VorlNr from Vorlesungen v
      where v.Titel regexp 'ik') )
    );
with st as (select s.MatrNr, s.Name, h.VorlNr from studenten s, hoeren h
    where s.MatrNr = h.MatrNr and h.VorlNr in (select v.VorlNr from Vorlesungen v
    where v.Titel regexp 'ik') ),
     vor as ( select v.VorlNr, v.Titel  from Vorlesungen v, hoeren ho
     where v.Titel regexp 'ik' and ho.VorlNr = v.VorlNr)
select st.MatrNr, st.Name, vor.Titel from st, vor natural join hoeren;

select s.MatrNr, s.Name from studenten s right outer join hoeren h on s.MatrNr = h.MatrNr;
select s.MatrNr, s.Name from studenten s right outer join hoeren h using (MatrNr)
where h.VorlNr;

# iii)
select p.Name, v.Titel from Professoren p, Vorlesungen v where p.PersNr = v.gelesenVon;
# b)
##########
select s.Name, s.MatrNr from studenten s right outer join pruefen p on s.MatrNr = p.MatrNr
where p.PersNr  in (select PersNr from Professoren where Name = 'Kant') and p.Note = 1;


# Af6
###############################

# a)
#######
# person table
create table Person(
    idPerson integer unique not null ,
    Name varchar(50) ,
    GebJahr integer ,
#     Constraint
primary key (idPerson)
);

# City table
create table Stadt(
    idStadt integer unique not null ,
    Name varchar(35) ,
#     Constraints
primary key (idStadt)
);

# b)
########
create table wohntin(
    person integer not null ,
    stadt  integer not null ,
#     Constraints
primary key (person, stadt) ,
foreign key (person) references Person(idPerson) ,
foreign key (stadt) references  Stadt(idStadt)
);

# c)
#######
# to preparation for Ids in the city and Person
alter table Person modify idPerson integer unique not null default 0241120;
alter table Stadt modify idStadt integer unique not null default 5206819;
insert into Person (Name)
values ('Müler');

insert into Stadt (Name)
values ('Aachen');
# We know only about city and person. The corresponding Ids are arbitrary
insert into wohntin select idPerson, idStadt from Person p , Stadt s
where p.Name = 'Müler' and s.Name = 'Aachen';

# d)
#######

update hoeren
set MatrNr = 29556
where VorlNr = 5049;
# Here the result is exact about what is asked in the exam but there is of course redundancy
select s.Name, s.MatrNr from studenten s right outer join hoeren h using (MatrNr)
    where h.VorlNr in (select VorlNr from hoeren group by VorlNr having count(VorlNr) >1) ;

# here is similar to the last one but without redundancy
select s.Name, s.MatrNr from studenten s right outer join hoeren h using (MatrNr)
where h.VorlNr in (select VorlNr from hoeren group by VorlNr having count(VorlNr) >1) group by MatrNr;

# wrong result this shows only the people who has attended in some lecture
# for example the lecture where [Alexander,29556] has visit consist of one student namely Alexander
select s.Name, s.MatrNr from studenten s where s.MatrNr in (select h.MatrNr from hoeren h
    where h.MatrNr = s.MatrNr );

# Here using the count() the focus is of the repetition of lecture but w.r.t. student (not only lecture)
with v as ( select h.MatrNr, count(h.VorlNr) as 'num' from hoeren h  join Vorlesungen v
    using (VorlNr) group by MatrNr)
select s.Name, s.MatrNr from studenten s right outer join v using (MatrNr) where num > 1;

# Teh same result as the last one
with v as ( select h.MatrNr, count(h.VorlNr) as 'num' from hoeren h   group by MatrNr)
select s.Name, s.MatrNr from studenten s right outer join v using (MatrNr) where num > 1;

# e)
######
# with st as (select s.MatrNr from studenten s where  s.MatrNr in (select min(Note)  from pruefen))
select s.MatrNr from studenten s  join pruefen p using(MatrNr)
where p.Note in (select min(Note)  from pruefen);
select s.Name, min(Note) from studenten s, pruefen p where  p.MatrNr = s.MatrNr group by p.MatrNr;
select Note from studenten s, pruefen p where  p.MatrNr = s.MatrNr;
select s.Name from studenten s where s.MatrNr in (select MatrNr from pruefen );
select s.MatrNr, s.Name from studenten s right outer join pruefen p using (MatrNr)
where p.Note = (select min(Note) from pruefen where p.Note = Note and p.MatrNr = MatrNr);

select s.MatrNr, s.Name from studenten s where s.MatrNr in (select MatrNr from pruefen pru group by MatrNr
    having min(Note));

with st as (select s.MatrNr, s.Name, p.Note from studenten s, pruefen p where s.MatrNr in (select MatrNr from pruefen group by MatrNr
             having min(Note))),
     pru as ( select p.MatrNr, p.Note from pruefen p group by MatrNr having min(Note))

select  MatrNr, Name, st.Note from st right outer join pruefen using (MatrNr,Note);

select s.MatrNr, s.Name, pru.Note from studenten s, pruefen pru where s.MatrNr in (select MatrNr from pruefen pru group by MatrNr
    having min(Note)) and (pru.MatrNr, pru.Note) in (select MatrNr, Note from pruefen  group by MatrNr having min(Note));

select s.MatrNr, s.Name  from studenten s left outer join pruefen p using (MatrNr) where s.MatrNr in (select MatrNr from pruefen group by MatrNr
             having min(Note));
select s.MatrNr, s.Name  from studenten s, pruefen p  where s.MatrNr in (select MatrNr from pruefen group by MatrNr
             having min(Note));

select s.MatrNr, s.Name  from studenten s, pruefen p  where s.MatrNr in (select MatrNr from pruefen group by MatrNr
             having min(Note)) and  s.MatrNr = p.MatrNr;
select s.MatrNr, s.Name, min(Note)  from studenten s, pruefen p  where s.MatrNr in (select MatrNr from pruefen group by MatrNr
             having min(Note) ) group by MatrNr;

select s.MatrNr, s.Name, Note  from studenten s, pruefen p  where s.MatrNr in (select MatrNr from pruefen group by MatrNr
             having min(p.Note)) group by MatrNr;

select s.MatrNr, s.Name, Note  from studenten s, pruefen p where p.MatrNr = s.MatrNr group by MatrNr, Note having min(Note) ;

select s.MatrNr  from studenten s, pruefen p  where s.MatrNr in (select MatrNr from pruefen group by MatrNr
             having min(Note)) group by s.MatrNr having min(Note) ;
select p.Note from pruefen p right outer join studenten s using (MatrNr) where s.MatrNr  in (select MatrNr from pruefen  group by MatrNr
             having min(Note) );
####################################################################################################################
select s.MatrNr, s.Name from studenten s, pruefen p  where s.MatrNr = p.MatrNr group by s.MatrNr having min(Note) ;#
####################################################################################################################
with x as (select s.MatrNr  from studenten s, pruefen p  where s.MatrNr = p.MatrNr group by s.MatrNr having min(Note))

select p.Note from pruefen p right outer join x using(MatrNr) group by Note having  min(Note);
# Aggregation/ Group functions
#############################################################
select avg(Semester) from studenten;

# Group some column of the table to show some statistical things about that
#  To check the dependency entities group plays important role. In other words the entities grouped by other ones are dependent on them!

select gelesenVon, sum(SWS), count(*) as semester from Vorlesungen group by gelesenVon;
# specific columns namely entities from sub-selection
select K.* from (select p.MatrNr, p.Note from pruefen p
    where p.Note < (select avg(Note) from pruefen )) K where K.MatrNr = 0 ;

select T.* from (select S.MatrNr, S.Name, count(*) as lectureCount
        from studenten  S, hoeren  h where s.MatrNr = h.MatrNr
        group by S.MatrNr, S.Name) T where T.lectureCount >2; # Alternative  with 'as' ) as T where T.lectureCount >2;

# Application of table
##############################################################

create table teacher(
    PersNr integer primary key ,
    Name varchar(50) not null, # default 'xyz',
   `Rank` char(2) check(`Rank` in ('D2''D3''D4')) default 'D2', # Rank is reserved in SQL, therefor
    Room integer unique                                         # has to be written in quotation.
);

#  Reference an attribute to attribute of other table without foreign key
create table lecture(
    LecNr integer primary key ,
    Title varchar(50) not null ,
    SWH integer check ( SWH between 1 and 8),
    given_by integer references teacher # optional teacher(persnr),
                                        # foreign key  is not imported in this table
);
#  import the reference as foreign key
create table lecture(
    LecNr integer ,
    Title varchar(50) not null ,
    SWH integer ,
    given_by integer ,
    # Constraints
    primary key(LecNr) ,
    foreign key (given_by) references teacher(PersNr),
    check ( SWH between 1 and 8)
);
create table requirement( # require is reserved in SQL, therefor has to be written in quotation.
    predecessor integer ,
    successor integer ,
#     Constraints
    primary key (predecessor, successor),
    foreign key (predecessor) references lecture(LecNr),
    foreign key (successor) references lecture(LecNr)
);
# without foreign key
insert into lecture(LecNr, Title, SWH)
values(123, 'wisdom', 3);
insert into teacher(PersNr, Name, `Rank`) values(12345,'','D2'); # This statement doesn't work because the Name
                                                  # doesn't default value and is not null defined!

# To change/modify definition of components namely attribute a table which already created.
###############
alter table teacher modify Name varchar(50) not null default 'xyz';
#  change the declaration of components namely attributes of a table
update teacher
set PersNr = 12345
where `Rank` = 'D2';

# View
create view seminar as ( select Title, SWH from lecture where SWH > 2);
update seminar set SWH =5 where SWH > 2;

#  To delete a table/view if it is "not referenced" in other tables!
###############
drop  view seminar;