-- Michael Hercules Sirico
--
-- func1on PreReqsFor(courseNum)
-- Returns the immediate prerequisites for the passed-in course number. 
--
--
create or replace function prereqsfor(int, REFCURSOR) returns refcursor as 
$$
declare
   courseFor int         := $1;
   resultset   REFCURSOR := $2;
begin
   open resultset for 
      select courses.name, courses.num, courses.credits
      from courses inner join prerequisites on prerequisites.prereqnum = courses.num
       where courseFor = prerequisites.prereqnum;
   return resultset;
end;
$$ 
language plpgsql;

select prereqsfor(499, 'prereqsfortest');
Fetch all from prereqsfortest;


--
-- func2on IsPreReqFor(courseNum)
-- Returns the courses for which the passed-in course number is an immediate pre-requisite.
--
--
create or replace function isprereqsfor(int, REFCURSOR) returns refcursor as 
$$
declare
   isCourse int          := $1;
   resultset   REFCURSOR := $2;
begin
   open resultset for 
      select courses.name, courses.num, courses.credits
      from courses inner join prerequisites on prerequisites.coursenum = courses.num
       where isCourse = prerequisites.prereqnum;
   return resultset;
end;
$$ 
language plpgsql;

select isprereqsfor(120, 'isprereqsfortest');
Fetch all from isprereqsfortest;