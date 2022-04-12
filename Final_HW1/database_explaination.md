Database explaination

* Attribute of cities : id (identity type which will be automatically increase when a new row inserted), name
* Attribute of sport centers : id, name, address
* Attribute of staff : social id, name, phone
* Attribute of court : id, name, status (indicate that those the badminton court free or not)
* Attribute of customer : social id, name, phone
* Each cities can contains multiple sport centers and each sport centers will belong to at most 1 city
* Each sport center can has multiple court
* Each court can only has 1 booking at a time and each customer can book more than 1 court. There are other attributes for a booking that are book date (the date that the customer book the court), book from (indicate the time that customer book the court) and duration (indicate the duration that the customer book the court)
* Each sport center must be supervised by at most 1 staff at a time and each person can only supervise 1 sport center
