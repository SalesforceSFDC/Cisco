CCCM Note Data Migration Steps

*******For some Domains, the Site External ID is null. Why is this?
*******Ask business, is it okay for us to use Data Migration user as the Requested By field?
*******Do we need to populate the Expiration Date field?



(Always make sure all filters are cleared when Copy and Pasting)
1. Pull Notes Report from CCCM

2. Filter out all rows with Note length >1900 and delete, using the Length column.
	Delete any where Length is 0 or Blank (aka the Notes field is empty).
		Then delete Length column.

3. Create a new column and add a comma to the "Site Name: Site External ID" column values by using:
	=CONCATENATE(K2,",")
	
4. Filter "Site Name: DBSource" for only BLIS and BRM (Not SaaS) as well as "Category" for only Site Note (No Domain Note)

5. Copy and paste whole "Site Name: Site External ID" column and paste into another sheet

6. Add a filter to this column so that the BLANKS are removed (Since some rows may not contain value for "Site Name: Site External ID" field

7. Copy and paste whole new column and send to Yue Chen

8. Yue Chen will use this ID list to pull mapping:
	(1000 id MAX in each query execution)
		siteid_IT	siteid_ENGG	  site url					account	  source  date
		159143		320308		  plbonaventure.webex.com	206103	  BLIS	  4/7/2017 1:39

9. Receive updated excel from Yue Chen (Make sure the vlookup master table has no spaces in between)

10. (While the BLIS/BRM and Category column are still filtered) Perform VLOOKUP and label column "VLOOKUP" - only visible roles should be "vlookup-ed"
		=VLOOKUP(K2,Sheet3!$A$1:$B$1227,2,FALSE) where K2 = "Site Name: Site External ID"
		
11. Clear all Filters (Category, DBSource, etc.) and Copy and Paste by Value for the above vlookup column and name it "SBP Site ID" (then delete the "VLOOKUP" column)

12. Insert new blank column and name it "Note_External_Id__c" and use below function to have new "SBP Site ID" for values which matched in VLOOKUP,
	or original "Site Name: Site External ID" if "SBP Site ID  is blank for that row
		=IF(ISBLANK(G2),H2,G2) where G2 = "SBP Site ID" and H2 = "Site Name: Site External ID"

13. Filter out "Note_External_Id__c" column where the row value is #N/A and delete the "Note_External_Id__c" Value if it is blank
		(aka if dbsource = BLIS/BRM and it has no matching SBP site id, we will delete those rows)
			For the rows where "Note_External_Id__c" value is 0 (where they have , do what????
		also, where site external id is blank and they are db source= BLIS/BRM and site note category (there are more blank than that if you take out db source/category filters)
		
		
14. Make sure all filters are clear (they should be) and Copy and Paste by Value for the above column (then delete old "Note_External_Id__c" column)

15. Move "Notes" column to the right side

16. Insert a new blank column and name it "Container_Value__c" and use below function:
		=IF(B4="Site Note", I4, IF(B4="Domain Note", M4, E4)) where B4 = "Category", I4 = "Site Name: Lookup", M4 = "Site Name: Domain", and E4 = "Org Name: Org Name"
			(Double check afterwards using Filters)

17. Filter out "Container_Value__c" column where value is 0 and check if any are Domain Note which has no value in Domain Name column, but they have a value in Site Name column.
	Maybe just copy and paste ONE by ONE for if they have a Domain. And delete the rest of the zero rows

18. Make sure all filters are clear and Copy and Paste by Value for the above column (then delete old "Container_Value__c" column)

19. Insert a new blank column and name it "SHN_Key__c" and use below function:
		=IF(B4="Site Note", "URL",IF(B4="Domain Note","Domain","Org")) where B4 = "Category"
			(Double check afterwards using Filters)

20. Make sure all filters are clear and Copy and Paste by Value for the above column (then delete old "SHN_Key__c" column)

21. Delete the following columns:
		"Note Name"
		"Category"
		"SBP Site ID"
		"Site Name: Site External ID"
		"Comma column"
		"Org Name: DBSource"
		"Site Name: DBSource"
		"Site Name: Lookup"
		"Site Name: Domain"
		"Org Name: Org ID"
		"Org Name: Org Name"

22. Replace Columns names with the following Field API Names: 
		SHN_Key__c
		Note_External_Id__c
		Container_Value__c
		Notes__c

23. Add a new column and name it Requested_By__c
	And add Data Migration User 18 digit ID for all the rows
	Add another new column for the Expiration Date and use Today + 90 days as the value for all rows

24. Review Success and Errors file imported using Data Loader
#
I don’t think you have access to the below user story. I added everything in the email, so that you can start. Feel free to reach out to Chandra with any questions. As I mentioned we like to have this completed by EOW if possible so that QA can test. Let us know the ETA.


@ Vamsi, can you help Vuk with the required access to Rally, Dev, Stage, … ?

https://rally1.rallydev.com/#/110682888092d/detail/userstory/122693313876
#
- Org
- Domain
- Site

Criteria to pull the note from CCCM:

   	DB Source equals  Null
   	AND Category equals Domain Note,Org Note,Site Note
 	AND Active equals True

Report link: https://cccm.my.salesforce.com/00O0B00000305o5

Please find attached the current note object definitions in CCCM and CSOne. consider this as a initial version to compile the final mapping sheet. 

User story template to be filled:

1 BUSINESS BENEFIT (PROVIDE OBJECTIVE INFO WHERE EVER IT IS APPLICABLE)
2 RCA AND ANY CURRENT WORKAROUND (WHEREEVER IT IS APPLICABLE) - N/A
3 TECHNICAL SOLUTION PROPOSED - provided under task details
4 IMPACT OF THE TECHNICAL SOLUTION/CHANGE - one time data migration
5 REQUESTER FOR THIS CHANGE AND IMPACTED USERS
6 USER ACCEPTANCE CRITERIA
#
1. Pull the data from Note__c object from CCCM 
2. Prepare the data migration file(.csv format) and have the volookup for the site id for the BLIS sites 
3. Create Container Type Value, Container Type Id field on Special_Handling_Note object in CSOne
4. Add Org, Site, Domain picklist values on SHN_Key__c field on Special_Handling_Note object
5. increase Notes__c field length from 1900 to 32768 --> Biz agreed to clean up the CCCM notes to 1900 char hence field length will not be increased.
6. Use data loader to import the file compiled in step 2.
7. validate the data in CSOne 
	
