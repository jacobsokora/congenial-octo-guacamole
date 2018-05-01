# congenial-octo-guacamole
Scavenger hunt app for CS3380

Users table: (REMOVED)
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
* id bigint not null auto_increment
* huntId bigint not null fk -> hunts.id
* clueText varchar(255) not null
* clueCode varchar(5) not null

PHP SQL service requests should be capable of:
* Getting all scavenger hunts
* Getting each clue for a specific scavenger hunt based on its order number
* Getting the code for a single clue
* Adding scavenger hunts to a user account (when they create one)
* Adding clues to a scavenger hunt
* Removing scavenger hunts
* Removing clues (and then updating the order numbers of the other clues)

App should be capable of:
* Viewing all scavenger hunts
* Displaying the first clue of a scavenger hunt
  * Displaying successive clues after appropriate code is entered
* Adding a scavenger hunt
* Adding clues
* Removing scavenger hunts
* Removing clues

Sample JSON for 'gethunts' GET request:
```
[
 {
  "id":"1",
  "name":"Hunt1",
  "description":"A hunt",
  "location":"Tokyo",
  "clues":
  [
   {"clueText":"CLUE1","clueCode":"ABCD"},
   {"clueText":"CLUE2","clueCode":"EFGH"}
  ]
 },
 {
  "id":"5",
  "name":"Jasmines scavenger hunt",
  "description":"something something chains and whips",
  "location":"Jasmines basement",
  "clues":
  []
 }
]
```
