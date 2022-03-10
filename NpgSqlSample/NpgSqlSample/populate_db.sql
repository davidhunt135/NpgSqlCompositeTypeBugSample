drop type if exists sample1.composite cascade;
drop type if exists sample1.composite_child cascade;
create type sample1.composite_child as (name text);
create type sample1.composite as (name text, child sample1.composite_child, child_array sample1.composite_child[]);


drop type if exists sample2.composite cascade;
drop type if exists sample2.composite_child cascade;
create type sample2.composite_child as (name text);
create type sample2.composite as (name text, child sample2.composite_child, child_array sample2.composite_child[]);

drop table if exists sample1.composite_table;
create table sample1.composite_table
(
    id serial primary key,
    name_composite sample1.composite
);

drop table if exists sample2.composite_table;
create table sample2.composite_table
(
    id             serial primary key,
    name_composite sample2.composite
);

insert into sample1.composite_table (name_composite)
VALUES (ROW('test11', ROW('child test11'), ARRAY[ROW('child test111'), ROW('child test112')]::sample1.composite_child[]));
insert into sample1.composite_table (name_composite)
VALUES (ROW('test12', ROW('child test12'), ARRAY[ROW('child test121'), ROW('child test122')]::sample1.composite_child[]));
insert into sample1.composite_table (name_composite)
VALUES (ROW('test13', ROW('child test13'), ARRAY[ROW('child test131'), ROW('child test132')]::sample1.composite_child[]));
insert into sample1.composite_table (name_composite)
VALUES (ROW('test14', ROW('child test14'), ARRAY[ROW('child test141'), ROW('child test142')]::sample1.composite_child[]));
insert into sample1.composite_table (name_composite)
VALUES (ROW('test15', ROW('child test15'), ARRAY[ROW('child test151'), ROW('child test152')]::sample1.composite_child[]));

insert into sample2.composite_table (name_composite)
VALUES (ROW('test21', ROW('child test21'), ARRAY[ROW('child test211'), ROW('child test212')]::sample2.composite_child[]));
insert into sample2.composite_table (name_composite)
VALUES (ROW('test22', ROW('child test22'), ARRAY[ROW('child test221'), ROW('child test222')]::sample2.composite_child[]));
insert into sample2.composite_table (name_composite)
VALUES (ROW('test23', ROW('child test23'), ARRAY[ROW('child test231'), ROW('child test232')]::sample2.composite_child[]));
insert into sample2.composite_table (name_composite)
VALUES (ROW('test24', ROW('child test24'), ARRAY[ROW('child test241'), ROW('child test242')]::sample2.composite_child[]));
insert into sample2.composite_table (name_composite)
VALUES (ROW('test25', ROW('child test25'), ARRAY[ROW('child test251'), ROW('child test252')]::sample2.composite_child[]));

select * from sample1.composite_table;
select * from sample2.composite_table;