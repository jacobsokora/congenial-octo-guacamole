# Scavenger hunt app for CS3380
## Team Members
Jacob Sokora

Connor Penrod

Jasmine Tan

## Project Description
# Meet ScavengeQR, the world's first comprehensive scavenger hunt management and information system.

**We're dragging scavenger hunting into the 21st century with state-of-the-art quick response code technology and a socially-engineered mobile eSport paradigm.**

**With the ability to construct, search, and participate in hunts from around the world, ScavengeQR is leading the world in immersive scavenger hunting experiences.**

## Entity-Relationship Diagram

![alt text](https://github.com/jacobsokora/congenial-octo-guacamole/blob/master/erd.png)
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
| ownerId | varchar(40) | no | none | none | yes |
| name | varchar(64) | no | none | primary | yes |
|location | varchar(255) | no | none | none | no |
| date | datetime | no | none | none | no |
| description | varchar(5) | yes | none | none | no |

## CRUD
Create: Users can create scanvenger hunts and clues

Read: App can display hunts and clues

Update: Users can edit clues 

Delete: Users can delete scavenger hunts 

## Demonstration
https://www.youtube.com/watch?v=zBF9sKKn5jc
