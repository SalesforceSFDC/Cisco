## Migrating Account first and then the Opportunity 
* While migrating Account, create a field on Account called External Id and mark it as External Id and unique. 
* Store the record id of source org in this external id field. 
* So now you have the Accounts from your source org loaded in target org with record ids of source org stored in External id field on target org. 
* When you load opportunities, choose Upsert operation instead of insert an map Account Id field with External Id instead of Id. You can follow the same process for all the other lookups present on Opportunity.
