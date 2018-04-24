# congenial-octo-guacamole
Scavenger hunt app for CS3380

Users table:
* id bigint not null auto_increment
* firstName varchar(30) not null
* lastName varchar(30) not null
* password varchar(64) not null (hashed)
* email varchar(255) not null unique

Hunts table:
* id bigint not null auto_increment
* location varchar(255) not null
* date datetime not null
* description varchar(255) null

Clues table:
* huntId bigint not null fk -> hunts.id
* clueText varchar(255) not null
* clueCode varchar(5) not null
