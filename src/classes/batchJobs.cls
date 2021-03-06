public class batchJobs{
 
    public List<BatchJob> batchJobs;
    public Integer numberOfJobs {get; set;}
    public String processName {get; set;}
 
    public List<BatchJob> getBatchJobs(){
        //Create new list of BatchJobs, a wrapper class that includes the job and percent complete.
        batchJobs = new List<BatchJob>();
 
        //If number of jobs was not defined, default to 20
        if(numberOfJobs== null || numberofJobs <= 0){
            numberofJobs = 20;
        }
        if(processName == ''){
            processName = 'testOppTrigger';
        }
 		
 		String idJob = '';
 		for(ApexClass ap : [Select a.Id From ApexClass a WHERE a.Name = :processName limit 1])
 			idJob = ap.id;
 
        //Query the Batch apex jobs CreatedDate >= YESTERDAY AND 
        for(AsyncApexJob a : [select TotalJobItems, Status, NumberOfErrors, MethodName, JobType, JobItemsProcessed, Id, CreatedDate, CreatedBy.Name, CreatedById, CompletedDate, ApexClassId, ApexClass.Name From AsyncApexJob where JobType = 'BatchApex' AND ApexClassId = :idJob order by CreatedDate desc limit :numberOfJobs]){
            Double itemsProcessed = a.JobItemsProcessed;
            Double totalItems = a.TotalJobItems;
 
            BatchJob j = new BatchJob();
            j.job = a;
 
            //Determine the pecent complete based on the number of batches complete
            if(totalItems == 0){
                //A little check here as we don't want to divide by 0.
                j.percentComplete = 0;
            }else{
                j.percentComplete = ((itemsProcessed  / totalItems) * 100.0).intValue();
            }
            if(a.Status == 'Completed')
                 j.percentComplete = 100;
                 
            batchJobs.add(j);
        }
        return batchJobs;
    }
 
    //This is the wrapper class the includes the job itself and a value for the percent complete
    public Class BatchJob{
        public AsyncApexJob job {get; set;}
        public Integer percentComplete {get; set;}
    }
 
    /*--------------------TEST METHOD------------------------*/
    static testMethod void batchStatusBarTest(){
        batchJobs controller = new batchJobs();
        controller.processName = 'VCSBalanceBatchJob';         
        controller.getBatchJobs();
    }
}