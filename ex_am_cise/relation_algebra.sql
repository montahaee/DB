select * from kemper.Professoren;

select M.*, A.*, R.* from mitarbeiter M LEFT OUTER JOIN (abteilung A LEFT JOIN rolle R on R.id = A.id) on M.id= A.id;

select W.*, P.* from warengruppe W LEFT OUTER JOIN produkt p on W.id = p.id;

select W.*, P.* from warengruppe W LEFT JOIN produkt p on W.id = p.id;

select W.*, P.* from warengruppe W LEFT OUTER JOIN produkt p on W.id = p.warengruppe_id;

select W.*, P.* from warengruppe W LEFT JOIN produkt p on W.id = p.warengruppe_id;

# Selection
##################################################################################################
select * from produkt;



select p.bezeichnung as 'pizaa', p.stueckpreis as 'price' from produkt p;

select p.bezeichnung  as 'pizza', p.stueckpreis as 'price'
      from produkt p where p.bezeichnung like '%pizza%' and p.stueckpreis < 2.30;
# If you forgoten to write "like" afer condition namely where the result will be printed compleatly
select p.bezeichnung  as 'pizza', p.stueckpreis as 'price'
      from produkt p where p.bezeichnung and p.stueckpreis < 2.30;
# Subselection
################################
select K.* from (
                select p.bezeichnung as 'pizza', p.stueckpreis as 'price'
    from produkt p where p.stueckpreis < 2.3
                    ) K where K.pizza like '%piz%'; # using '%' to regualr experssion

select K.* from (
                select p.bezeichnung as 'pizza', p.stueckpreis as 'price'
    from produkt p where p.stueckpreis >2.2 and p.stueckpreis <2.3
                    ) K where K.pizza like '%pizza%';

select K.* from (
                select p.bezeichnung as 'pizza', p.stueckpreis as 'price'
    from produkt p where p.stueckpreis >2.2 or p.stueckpreis < 2.3  # the condition after or does not influence at the final result
                    ) K where K.pizza like '%piz%';

#  Set Operation
###################################################################
select p1.* from produkt p1 where p1.stueckpreis <  3.00
union
select p2.*  from produkt p2 where p2.stueckpreis > 2.20;


select p1.* from produkt p1 where p1.stueckpreis <  3.00
intersect
select p2.*  from produkt p2 where p2.stueckpreis > 2.20;


#  Projection (a selection without condition) (unlike to mathematics is not graunjteed uniqness after union tow relations in SQL)
####################################################################
select stueckpreis, umsatzsteuer from produkt order by stueckpreis;

select P.id, P.stueckpreis, P.umsatzsteuer from produkt P ;

#  Cartesian Product (a selection of two or more relations without conditions)
####################################################################

select A.id, A.name, S.id, S.ort
from abteilung A, standort S;

# thetta Join is a cartesian product with conditions (see where in the belowe client statements)
####################################################################
select P.id, P.bezeichnung, P.warengruppe_id, W.id, W.bezeichnung
from produkt P, warengruppe W where p.warengruppe_id= W.id;

# The result is the same as thetta join
select P.id, P.bezeichnung, P.warengruppe_id, W.id, W.bezeichnung
from produkt P inner join warengruppe W on p.warengruppe_id= W.id;

####################################################################
select  p.id as prod_id, p.bezeichnung as 'bez'
     from produkt p where p.bezeichnung like  '%piz%';

#Temporary result set
with prods as(
    select id as 'prod_id', bezeichnung as 'bez'from produkt
) select * from prods where bez like '%piz%';

# join
##################################################################################
select id as 'pid', bezeichnung as 'pbez', warengruppe_id as 'wid' from produkt;
select id as 'wid', bezeichnung as 'wbez' from warengruppe;

# Natural Join
#####################################################################################
with wg as (select id as 'wid', bezeichnung as 'wbez' from warengruppe),
     pd as (select id as 'pid', bezeichnung as 'pbez', warengruppe_id as 'wid' from produkt)
select * from pd join wg on pd.wid = wg.wid;

# To eliminate the double coulumns "pd.wid" and "wg.wid" in the above statement in one column wid we use natural join.
with wg as (select id as 'wid', bezeichnung as 'wbez' from warengruppe),
     pd as (select id as 'pid', bezeichnung as 'pbez', warengruppe_id as 'wid' from produkt)
select * from  pd natural join wg;

##################################################################################

#Semi Join
##################################################################################
# Notice no condition with natural join
with wg as (select id as 'wid', bezeichnung as 'wbez' from warengruppe),
     pd as (select id as 'pid', bezeichnung as 'pbez', warengruppe_id as 'wid' from produkt)
select pd.pid, pd.pbez, pd.wid from pd natural join wg;

# Equivalent
with wg as (select id as 'wid', bezeichnung as 'webz' from warengruppe),
     pd as (select id as 'p.id', bezeichnung as 'pebz', warengruppe_id as 'wid' from produkt)
select pd.* from pd natural join wg;
#################################################################################

#Outer Join
###############################################################################
#left and right
select T.name, T.mitarbeiter_id from tier T;
select T.name, M.name
from tier T inner join mitarbeiter M on T.mitarbeiter_id = M.id;

#left
select T.name, M.name
from tier T left outer join mitarbeiter M
on M.id = T.mitarbeiter_id;

#right
select T.name, M.name
from tier T right outer join mitarbeiter M
on M.id = T.mitarbeiter_id;
# Equivalent to right outer if you only change
# the position of the schema before and after left outer join
select T.name, M.name
from mitarbeiter M  left outer join tier T
on M.id = T.mitarbeiter_id;

#union of right and left outer
select T.name, M.name
from tier T left outer join mitarbeiter M
on M.id = T.mitarbeiter_id
union
select T.name, M.name
from tier T right outer join mitarbeiter M
on M.id = T.mitarbeiter_id;

select T.name, M.name
from mitarbeiter M right outer join tier T
on M.id = T.mitarbeiter_id
union
select T.name, M.name
from mitarbeiter M left outer join tier T
on M.id = T.mitarbeiter_id;
###############################################################

# A short view of comparsion between inner and outer join
################################################################
select B.id, B.kunde_id,K.id, K.name
from bestellung B inner join  kunde K
on B.kunde_id = K.id;

#the same result as the above. The focus is on the order(GE. Bestellung)
select B.id, B.kunde_id,K.id, K.name
from bestellung B left outer join  kunde K
on B.kunde_id = K.id;

#Now but the focus is on the custommer (GE. Kunde) and the result will be different
 select B.id, B.kunde_id,K.id, K.name
from bestellung B right outer join  kunde K
on B.kunde_id = K.id;

# Aggregation/ Group functions
###############################################################################
select min(stueckpreis), max(stueckpreis), sum(stueckpreis), count(stueckpreis),
       sum(stueckpreis)/ count(stueckpreis), avg(stueckpreis), stddev_pop(stueckpreis),
       sqrt(var_pop(stueckpreis)) from produkt;
#  The number of the enteries namely rowes
select count(*), warengruppe_id, avg(stueckpreis) from produkt
where warengruppe_id < 2;

select count(distinct stueckpreis), warengruppe_id, avg(distinct stueckpreis) from produkt
where warengruppe_id < 2;
select * from produkt;
# Test if there are dependenies between entities (columns)
select p.stueckpreis, p.umsatzsteuer, count(*) as products
     from produkt p group by  umsatzsteuer;

select p.stueckpreis, p.umsatzsteuer, p.bezeichnung, count(*) as products
     from produkt p group by  stueckpreis;
select p.stueckpreis, p.umsatzsteuer, p.bezeichnung, count(*) as prducts
     from produkt p group by stueckpreis, umsatzsteuer;
# Intention
##########################################################################