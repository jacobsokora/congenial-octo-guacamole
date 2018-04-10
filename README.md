# congenial-octo-guacamole
Ride sharing app for CS3380

Users table:
* id bigint not null auto_increment
* firstName varchar(30) not null
* lastName varchar(30) not null
* password varchar(64) not null (hashed)
* email varchar(255) not null unique
* phone varchar(15) not null unique
* photo blob

Rides table:
* id bigint not null auto_increment
* driverId bigint not null fk -> users.id
* startLocation varchar(255) not null
* endLocation varchar(255) not null
* note varchar(255)
* date datetime not null
* availableSeats int not null

Riders table:
* rideId bigint not null fk -> rides.id
* riderId bigint not null fk -> users.id
* pickupLocation varchar(255) not null
* note varchar(255)
