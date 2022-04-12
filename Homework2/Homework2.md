


<p><strong> Programming exercise: Group G</strong></p>
<p><strong> 1. Interfaces: Presentation-Logic Tier</strong></p>
<pre><code>* booking(int userID, int courtID, DATE date, TIME time) : boolean
* listCourt(int sportCentresID) : List
* listSportCentres(int citiesID) : List
* courtStatus(int courtID, int sportCentresID) : boolean ( true : available)
* addSportCentres(SportCentres SportCentre, int cityID) : boolean
* addCourt(Courts court, int sportcentresID, int cityID) : boolean
* listBook(int userID) : List
* updateCourt(Courts court) : boolean
</code></pre>


<p><strong> 2. Interfaces: Logic-Data Tier</strong></p>
<pre><code>* insert(tableNames, HashMap<String,String> values) : boolean
* update(tableName, HashMap<String,String> values) : boolean
* retrieve(String tableName, String tableColumn, Condition condition) : List
* joinTable(String table1, String table2, String joinType, Condition condition) : boolean
* deleteRow(String tableName, String columnName, Condition condition) : boolean
</code></pre>
<p><strong> 3. Entity-Relationship Diagram (ERD)</strong></p>
<pre><code><img alt="ERD" src="https://i.imgur.com/12wEARy.jpg"/>
</code></pre>



<p><strong> 4. Database Explanation</strong></p>
<pre><code>* Attribute of cities : id (identity type which will be automatically increase when a new row inserted), name
* Attribute of sport centers : id, name, address
* Attribute of staff : social id, name, phone
* Attribute of court : id, name, status (indicate that those the badminton court free or not)
* Attribute of customer : social id, name, phone
* Each cities can contains multiple sport centers and each sport center will belong to at most 1 city
* Each sport center can has multiple court
* Each court can only has 1 booking at a time and each customer can book more than 1 court. There are other attributes for a booking that are book date (the date that the customer book the court), book from (indicate the time that customer book the court) and duration (indicate the duration that the customer book the court)
* Each sport center must be supervised by at most 1 staff at a time and each person can only supervise 1 sport center
</code></pre>
<p><strong> 5. Activity Diagram: Customer</strong></p>
<pre><code><img alt="AD for User/Customer" src="https://i.imgur.com/LM0MPY1.png"/>
</code></pre>

<p><strong> 6. Activity Diagram: Staff</strong></p>
<pre><code><img src="https://i.imgur.com/X1k570p.png" alt="AD for Staff"/>
</code></pre>

<p><strong> 7. Mockups</strong></p>
<pre><code>Booking view:
<img alt="Booking view" src="https://i.imgur.com/4E10s3u.png"/> </code> </pre>









Booking view:

<pre><code> <img alt="Booking view]" src="https://i.imgur.com/OEEUBaw.png"/> </code></pre>



Booking result view:

<pre><code> <img alt="Booking result view" src="https://i.imgur.com/iD1N8XP.png"/> </code>
</pre>


<pre><code> <img src = "https://i.imgur.com/p0wnuK1.png" alt = "Staff view" />  </code></pre>

Menu view:
<pre> <code> <img  alt = "Menu view" src="https://i.imgur.com/Kg3kMot.png"/></code></pre>

Main page:
<pre><code> <img alt = "Main page" src="https://i.imgur.com/HG1BdXE.png"/></code></pre>

