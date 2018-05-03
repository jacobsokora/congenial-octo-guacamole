# Scavenger hunt app for CS3380
## Team Members
Jacob Sokora

Connor Penrod

Jasmine Tan

## Project Description
a description of the application (a paragraph or two that tells what the application does and what purpose it serves).
the schema for the database (the table definitions).


## Entity-Relationship Diagram

![alt text](https://github.com/jacobsokora/congenial-octo-guacamole/blob/master/ERD.png)
## Database Schema
### Clues 
| Field | Type | Null | Default | Key | Auto Increment |
|:----:|:------:|:------:|:------:|:------:|:-------------:|
| id | bigint | no | none | primary | yes |
|huntId | bigint | no | none | none | no |
| clueText | varchar(255) | no | none | none | no |
| clueCode | varchar(5) | no | none | none | no |

### Hunts 
| Field | Type | Null | Default | Key | Auto Increment |
|:----:|:------:|:------:|:------:|:------:|:-------------:|
| id | bigint | no | none | primary | yes |
|location | varchar(255) | no | none | none | no |
| date | datetime | no | none | none | no |
| description | varchar(5) | yes | none | none | no |

## CRUD
Create: Users can create scanvenger hunts and clues

Read: App can display hunts and clues

Update: Users can edit clues 

Delete: Users can delete scavenger hunts 

## Demonstration
a video demonstration of the application. The URL to the video (on Youtube or other hosting) is to be provided.

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
 },
  {
  "id":"666",
  "name":"conio's hunt",
  "description":"bring me morels (not a real scavengar hunt).",
  "location":"morel mushroom forest",
  "clues":
  []
 }
]
```
