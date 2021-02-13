# GROUP YOUR INVENTORY LOGICALLY
Running a playbook without an inventory requires several command-line flags.

Best practice is to group servers and network devices by their What (application, stack or microservice), Where (datacenter or region), and When (development stage):

What: db, web, leaf, spine
Where: east, west, floor_19, building_A
When: dev, test, staging, prod
Avoid spaces, hyphens, and preceding numbers (use floor_19, not 19th_floor) in your group names. Group names are case sensitive.

This tiny example data center illustrates a basic group structure. You can group groups using the syntax [metagroupname:children] and listing groups as members of the metagroup. Here, the group network includes all leafs and all spines; the group datacenter includes all network devices plus all webservers.


<hr>
<br/>
..... TO BE CONTINUED