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
