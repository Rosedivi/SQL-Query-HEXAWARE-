/*create table vehicle(
vehicleid int primary key,
make varchar(20),
model varchar (20),
v_year int,
dailyrate int,
v_status varchar(20) check(v_status in ('avail', 'notavail')),
passcapacity int,
engcapacity int);

create table customer(
custid int primary key,
f_name varchar(20),
l_name varchar(20),
email varchar(50),
p_no int);

create table lease (
leaseid int primary key,
vehicleid int,
custid int,
startdate date,
enddate date,
l_type varchar(20) check (l_type in ('daily', 'month')),
foreign key (vehicleid) references vehicle(vehicleid),
foreign key (custid) references customer(custid));

create table payment(
payid int primary key,
leaseid int,
paydate date,
amount int,
foreign key (leaseid) references lease(leaseid));

insert into vehicle (vehicleid, make, model, v_year, dailyrate, v_status, passcapacity, engcapacity) values
(1, 'toyota', 'Camry', 2022, 50, 'avail', 4, 1450),
(2, 'zonda', 'Civic', 2023, 45, 'avail', 7, 1500),
(3, 'skowda', 'Focus', 2022, 48, 'notavail', 4, 1400),
(4, 'renault', 'Altima', 2023, 52, 'avail', 7, 1200),
(5, 'rolet', 'Malibu', 2022, 47, 'avail', 4, 1800),
(6, 'audi', 'Sonata', 2023, 49, 'notavail', 7, 1400),
(7, 'BMW', '3 Series', 2023, 60, 'avail', 7, 2499);

insert into customer (custid,f_name,l_name,email,p_no)values
(1,'roja','sri','roja@gmail.com',90876543),
(2,'booja','rashmi','booja@gmail.com',93876543),
(3,'sanjay','vikram','sv@gmail.com',92876543),
(4,'prasa','kanna','prasa@gmail.com',95876543),
(5,'krish','moorthy','km@gmail.com',91876543),
(6,'saha','muthu','saha@gmail.com',96876543),
(7,'mohammed','khan','khan@gmail.com',98876543);

insert into lease(leaseid,vehicleid,custid,startdate,enddate,l_type) values
(1,2,1, '2025-05-01', '2025-05-03', 'daily'),
(2,3,5, '2022-06-03', '2023-06-02', 'month'),
(3,4,3, '2024-06-08', '2024-06-13', 'daily'),
(4,5,4, '2025-04-25', '2024-04-26', 'month'),
(5,1,7, '2025-3-11', '2025-05-12', 'month'),
(6,6,2, '2025-05-03', '2025-05-04', 'daily'),
(7,7,6, '2025-05-23', '2025-05-22', 'daily');*/

/*insert into payment (payid, leaseid, paydate, amount)values 
(1,1,'2025-05-03',150),
(2,2,'2024-09-18',160),
(3,3,'2025-09-17',180),
(4,4,'2023-07-15',200),
(5,5,'2022-06-12',300),
(6,6,'2021-09-09',500),
(7,7,'2023-08-07',900);*/

select *from customer
select *from vehicle
select *from payment
select *from lease

/* Update the daily rate for a skowda car to 68.*/
update vehicle set dailyrate =100 where make = 'skowda';
select *from vehicle;

/*Delete a specific customer and all associated leases and payments*/
delete from payment where leaseid in (select leaseid from lease where custid =2);
delete from payment where leaseid in (select custid from lease where leaseid=6);

select * from payment;

/*Rename the "paymentDate" column in the Payment table to "transactionDate"*/
/*alter table payment column paydate to transdate;*/

/*Find a specific customer by email*/ 
select *from customer where email = 'km@gmail.com';
select *from payment where amount=900;

/*Get active leases for a specific customer*/
select *from lease where custid = 6 and enddate >='2025-05-04';
select *from lease where vehicleid = 5 and enddate >='2025-05-03';

/* Find all payments made by a customer with a specific phone number.*/
select *from payment where amount = (select custid from customer where p_no = 90876543);
select *from payment where amount = (select custid from customer where f_name='saha');

/*Calculate the average daily rate of all available cars*/
select avg(dailyrate) from vehicle where v_status= 'avail';
select count(*) from vehicle where vehicleid=2;

/*Find the car with the highest daily rate.*/ 
select max(dailyrate) from vehicle;

 /*Retrieve all cars leased by a specific customer.*/
select * from lease where custid=1;

/*Find the details of the most recent lease.*/ 
select *from lease where enddate between '2025-03-11' and '2025-04-27';

 /*List all payments made in the year 2023*/
 select count(*) from payment where year(paydate)='2023';
 select * from payment where month(paydate)='08';

 /*Retrieve customers who have not made any payments.*/
 select * from customer inner join lease on customer.custid = lease.custid 
 left join payment on lease.leaseid = payment.leaseid
where payment.payid is null;

select * from customer inner join lease on customer.custid = lease.custid 
 left outer join payment on lease.leaseid = payment.leaseid
where payment.payid is not null;

/*Retrieve Car Details and Their Total Payments.*/
select vehicle.vehicleid, sum(payment.amount) from vehicle left outer join lease on vehicle.vehicleid = lease.vehicleid
inner join payment on lease.leaseid = payment.leaseid
group by vehicle.vehicleid;

/*Calculate Total Payments for Each Customer.*/ 
select customer.custid,sum(payment.amount) from customer full outer join  lease on customer.custid =lease.custid inner join 
payment on payment.leaseid=lease.leaseid group by customer.custid;


 /*List Car Details for Each Lease*/
 select *from lease inner join vehicle on lease.vehicleid = vehicle.vehicleid;


 /*Retrieve Details of Active Leases with Customer and Car Information.*/
 select lease.leaseid ,customer.custid, customer.f_name, customer.l_name, customer.email, customer.p_no, 
 vehicle.vehicleid, vehicle.make, vehicle.model, vehicle.v_year, vehicle.dailyrate, vehicle.v_status
from lease inner join customer on lease.custid = customer.custid inner join
vehicle on lease.vehicleid = vehicle.vehicleid where lease.enddate> '2025-04-28';

/*Find the Customer Who Has Spent the Most on Leases*/
select max(payment.amount) from lease full outer join customer on lease.leaseid=customer.custid
full outer join payment on lease.leaseid=payment.leaseid;

/*18. List All Cars with Their Current Lease Information.*/
select vehicle.vehicleid,lease.leaseid from vehicle left outer join lease  
on vehicle.vehicleid = lease.vehicleid and lease.enddate >= '2025-04-28'
left outer join customer on lease.custid = customer.custid;
