Below are the updates.

Showing the EventSeveritycount values in response(PFA) based on the count.please find the screenshot.


              Kunal- This is fine. Just check if there is no Event, there should not be any fields in the response.

The request URL (getcaseDetailsList) is :
https://apmi-stage.cisco.com/custcare/cm/v1.0-stage4/cases/details?loggedId=evaleriano&poseAsId=&contactIds=evaleriano&caseNumbers=683102883, 683102899, 683103884&contractNumbers=&picaIds=&openStatuses=&closedStatuses=&statusTypes=&severities=&allCases=T&hasRMAs=&hasBugs=&dateCreatedFrom=&dateCreatedTo=&lastUpdateFrom=&lastUpdateT=&serialNumbers=&deviceNames=&caseType=INV&eventSeverityCount=Y

Kunal- Looks good

If eventSeverityCount=N/’ ’  we doesn’t provide, existing functionality is working fine and based on the flag, adding the subquery to existing query.
Kunal- Looks good

Working on US185733, receiving an exception saying. ‘You have uncommited workpending’. Seems like before callout DML operation is happening, couldn’t figureout where it is. I will work on it and will update you the same.
Kunal- Move your code to future method postCaseCreateActions & before any dml put your code.

 

 

Please let me know if I have missed anything.

 

Regards,

Swarna Makam

 

From: Swarna Makam -X (swmakam - ACCENTURE LLP at Cisco) 
Sent: Wednesday, June 6, 2018 6:37 PM
To: Kunal Ghosh -X (kughosh - ACCENTURE LLP at Cisco) <kughosh@cisco.com>
Cc: Faramarz Yazdi -X (fayazdi - ACCENTURE LLP at Cisco) <fayazdi@cisco.com>
Subject: RE: Sprint 3- Updates

 

Hi Kunal,

 

As per discussion, as need to show the Event Severity count, I have written code for getting Severity count for list of cases  which are being passed in Request as ‘caseNumbers’.

 

Getting the logs like below :

EventSeverityMap 1723 {683102883:Information=1, 683102883:Warning=1, 683103884:Information=2, 683103884:Warning=3}

 

Code snippet:

 

String query = 'SELECT (Select id, Severity__C, SR_Number__C From caseEvents__r), Contact.CCO_ID__c, SubRefIdVASA_Formula__c ';

//US197619 Swmakam

Map<String,List<TA_Events__c>> eventsMap = new Map<String,List<TA_Events__c>>();

                    for(Case cse : caseList){

                        eventsMap.put(cse.c3_SR_Number__c , cse.caseEvents__r);

                    }

                    CSOneAPI_Logger.addInfo('ID_Set 1711 '+splitIntoSet(inputParams.get('caseNumbers').remove(' ')));

                    for(String srNumber : splitIntoSet(inputParams.get('caseNumbers').remove(' '))){

                        eventList = eventsMap.get(srNumber);

                        for(TA_Events__c evntRcrd :EventList){

                            if(EventSeverityMap.containsKey(evntRcrd.Sr_Number__c+':'+evntRcrd.severity__C)){

                      EventSeverityMap.put(evntRcrd.Sr_Number__c+':'+evntRcrd.severity__C, EventSeverityMap.get(evntRcrd.Sr_Number__c+':'+evntRcrd.severity__C)+1);

                            }

                            else{

                                EventSeverityMap.put(evntRcrd.Sr_Number__c+':'+evntRcrd.severity__C, 1);

                            }

                         }

                    }

                    CSOneAPI_Logger.addInfo('EventSeverityMap 1723 '+EventSeverityMap);//end US197619

 

 

But got stuck in showing the EventSeverityMap values in response. Could you please help me on this.

I tried doing ‘Group By’ but SOQL didn’t allow to add Group By, because already we are doing Order BY already and in sub query also we cannot perform  Group BY. Hence, I tried this approach.

 

Created a field ‘Due_Date__C’(Date datatype) on case object and exposed the “dueDate” key in Create/Update and GetcaseDetails API’s.

 

Regards,

Swarna Makam

 

From: Swarna Makam -X (swmakam - ACCENTURE LLP at Cisco) 
Sent: Monday, June 4, 2018 9:02 AM
To: Kunal Ghosh -X (kughosh - ACCENTURE LLP at Cisco) <kughosh@cisco.com>
Cc: Faramarz Yazdi -X (fayazdi - ACCENTURE LLP at Cisco) <fayazdi@cisco.com>
Subject: RE: Sprint 3- Updates

 

Hi Kunal,

 

Have made code changes in bulk delete. Please find the below screenshots.

Classes:

CSOneAPI_DeleteEvents

CSOneAPI_EventUtils

 

As per your comments in the below mail, all the event ids which are coming in request body, I am storing it and then deleting corresponding records.
I have tested in PostMan as workbench tool wouldn’t let me enter Json body as a request for Delete Operation.
Error Message for invalid EventID



Successful Deletion



 

Please Let me know if I have missed any thing.

 

Regards,

Swarna Makam

 

From: Kunal Ghosh -X (kughosh - ACCENTURE LLP at Cisco) 
Sent: Saturday, June 2, 2018 11:17 AM
To: Swarna Makam -X (swmakam - ACCENTURE LLP at Cisco) <swmakam@cisco.com>
Cc: Faramarz Yazdi -X (fayazdi - ACCENTURE LLP at Cisco) <fayazdi@cisco.com>
Subject: RE: Sprint 3- Updates

 

Hi Swarna,

 

Make it bulk delete & event ids will come in request body.

 

Regards,

Kunal Ghosh

 

From: Swarna Makam -X (swmakam - ACCENTURE LLP at Cisco) 
Sent: Thursday, May 31, 2018 5:30 AM
To: Kunal Ghosh -X (kughosh - ACCENTURE LLP at Cisco) <kughosh@cisco.com>
Cc: Faramarz Yazdi -X (fayazdi - ACCENTURE LLP at Cisco) <fayazdi@cisco.com>
Subject: RE: Sprint 3- Updates

 

Hi Kunal,

 

I have started working on DeleteEventAPI Userstory.

URL Mapping: /services/apexrest/upsertEvents/EventID(UniqueKEY)

Method: Delete

Getting the response as below



Could you please let me know ,

If it is a bulk delete, will TSX UI send us the deleting eventid’s in a list or in a Json format(as request body)
If it is a List, I need to write a logic to do comma separated and add it to a set then pass the set to Delete SOQL query.
If they are sending as request body, I will iterate to eventDetails Json List and fetch only EventID(Unique Key) if it is valid and add it to set then Delete .
Please let me know if anything is added to it.

 

Regards,

Swarna Makam

 

From: Swarna Makam -X (swmakam - ACCENTURE LLP at Cisco) 
Sent: Thursday, May 31, 2018 5:15 PM
To: Kunal Ghosh -X (kughosh - ACCENTURE LLP at Cisco) <kughosh@cisco.com>
Cc: Faramarz Yazdi -X (fayazdi - ACCENTURE LLP at Cisco) <fayazdi@cisco.com>
Subject: RE: Sprint 3- Updates

 

Hi Kunal,

 

I checked through caseCreate API for validation rule.

If I provide Type as TAC and Status = ‘Service Delivery Team’ throws below error message


If I provide Type as INV  and Status = ‘Service Delivery Team’ case is getting created.
 

If we provide invalid SR Number, throwing the below exception and stopping the upsert functionality. If it’s valid SRNumber, Upsert functionality is working fine.


 

Regards,

Swarna Makam

 

From: Kunal Ghosh -X (kughosh - ACCENTURE LLP at Cisco) 
Sent: Thursday, May 31, 2018 10:58 AM
To: Swarna Makam -X (swmakam - ACCENTURE LLP at Cisco) <swmakam@cisco.com>
Cc: Faramarz Yazdi -X (fayazdi - ACCENTURE LLP at Cisco) <fayazdi@cisco.com>
Subject: RE: Sprint 3- Updates

 

Hi Swarna,

 

Please check my inline comments

 

Regards,

Kunal Ghosh

 

From: Swarna Makam -X (swmakam - ACCENTURE LLP at Cisco) 
Sent: Wednesday, May 30, 2018 5:53 AM
To: Kunal Ghosh -X (kughosh - ACCENTURE LLP at Cisco) <kughosh@cisco.com>
Cc: Faramarz Yazdi -X (fayazdi - ACCENTURE LLP at Cisco) <fayazdi@cisco.com>
Subject: Sprint 3- Updates

 

Hi Kunal,

 

As discussed over call, I have

 

Created a new class with the name CSOneAPI_UpsertEvents and URL Mapping changed to “/UpsertEvent”
Eg: /services/apexrest/upsertEvents/683396311

              Kunal- This looks good



 

Updating/Creating records based on unique external EventID by verifying the parameters SR Number. Suppose if we provide wrong SRNumber, currently we are getting DML Exception ‘List index out of bounds: 0’.
Do you want me to show custom error message in the place of it?

              Kunal- First validation should be with the SR number . If that Sr number is present in CSOne go ahead with other upsert  logic.

Have created validation rule on case object.
Condition: IF(AND(!ISPICKVAL(Type,'INV'), ISPICKVAL(Status,'Service Delivery Team')) , True, False)

Error: Status 'Service Delivery Team' is applicable for INV type cases

              Kunal:- This looks good. Check with API also, if someone is trying to update this status for TAC case, how it is working

Working on getCasesList(caseSummaryAPI).
Kunal- Hold on this one. If you have some other user stories work on those.
