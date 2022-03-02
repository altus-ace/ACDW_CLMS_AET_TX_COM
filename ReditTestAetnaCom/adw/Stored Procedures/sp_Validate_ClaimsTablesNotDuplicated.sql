CREATE PROCEDURE [adw].[sp_Validate_ClaimsTablesNotDuplicated]
AS 
BEGIN
    -- adw.claims_Headers: de duped by tbl key
    -- adw.claims member de duped by tbl key
    /*-- adw.Claims Procs are there dups? */
	   SELECT *
	   FROM (
	   SELECT p.URN, 
	          p.SEQ_CLAIM_ID, 
	          p.SUBSCRIBER_ID, 
	          p.ProcNumber, 
	          p.ProcCode, 
	          p.ProcDate, 
	          p.LoadDate, 
	          p.CreatedDate,        
	   	  ROW_NUMBER() OVER(PARTITION BY 
	   				 p.SEQ_CLAIM_ID, 
	   				    p.SUBSCRIBER_ID, 
	   				    p.ProcNumber, 
	   				    p.ProcCode, 
	   				    p.ProcDate
	   				ORDER BY URN DESC) arn       
	   FROM adw.Claims_Procs p
	   )s 
	   WHERE s.arn > 1;	  

    /* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
    /* -- adw. claims diags */
        SELECT *
    	   FROM (SELECT p.URN, 
    			  p.SEQ_CLAIM_ID, 
    			  p.SUBSCRIBER_ID, 
    			  p.ICD_FLAG, 
    			  p.diagNumber, 
    			  p.diagCode, 
    			  p.diagPoa, 
    			  p.LoadDate, 
    			  p.CreatedDate, 
    			  ROW_NUMBER() OVER (
    				PARTITION BY p.SEQ_CLAIM_ID, 
    			 				p.SUBSCRIBER_ID, 
    			 				p.ICD_FLAG, 
    			 				p.diagNumber, 
    			 				p.diagCode
    			 			ORDER BY p.URN DESC) AS arn
    			 FROM adw.Claims_Diags p
    	   )s 
    	   WHERE s.arn > 1;
    
    	   
    
    /* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
    /* -- adw. claims detials */
    	   SELECT *
    	   FROM (SELECT d.URN,        
    	   	   	  d.SEQ_CLAIM_ID, 
    	   	          d.LINE_NUMBER, 
    	   	          d.DETAIL_SVC_DATE, 
    	   	          d.SVC_TO_DATE,         
    	   	   	 ROW_NUMBER() OVER (PARTITION BY d.SEQ_CLAIM_ID, 
    	   	   					   d.LINE_NUMBER, 
    	   	   					   d.DETAIL_SVC_DATE, 
    	   	   					   d.SVC_TO_DATE, 
    	   	   					   d.PROCEDURE_CODE, 
    	   	   					   d.REVENUE_CODE,
    	   	   					   d.QUANTITY,
    	   	   					   d.BILLED_AMT, 
    	   	   					   d.PAID_AMT,               
    	   	   					   d.GPI      
    	   	   					   ORDER BY URN DESC ) arn
    	   	   FROM adw.claims_details d
    	   ) src
    	   where src.Arn > 1
	   /* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
	   /* fix dups */    
	   /* -- drop table #CDDups; 
	   
	   CREATE table #CDDups(urn INT NOT NULL
	       ,SEQ_CLAIM_ID VARCHAR(50) 
	       ,LINE_NUMBER smallINt 
	       ,DETAIL_SVC_DATE date
	       ,SVC_TO_DATE date
	       ,arn INT NOT NULL);
	   */
	   /*
	   INSERT INTO #CDDups(urn, SEQ_CLAIM_ID, LINE_NUMBER, DETAIL_SVC_DATE, SVC_TO_DATE, arn)
	   SELECT d.URN,        
	   	  d.SEQ_CLAIM_ID, 
	          d.LINE_NUMBER, 
	          d.DETAIL_SVC_DATE, 
	          d.SVC_TO_DATE,         
	   	 ROW_NUMBER() OVER (PARTITION BY d.SEQ_CLAIM_ID, 
	   					   d.LINE_NUMBER, 
	   					   d.DETAIL_SVC_DATE, 
	   					   d.SVC_TO_DATE, 
	   					   d.PROCEDURE_CODE, 
	   					   d.REVENUE_CODE,
	   					   d.QUANTITY,
	   					   d.BILLED_AMT, 
	   					   d.PAID_AMT,               
	   					   d.GPI      
	   					   ORDER BY URN DESC ) arn
	   FROM adw.claims_details d
	   --WHERE d.SEQ_CLAIM_ID = '2018304900105'
	   ORDER BY line_number;

	   /* are the dups in the update table? */
	   SELECT top 1 *
	   FROM #CDDups
	   where arn > 1
	   
	   /* do the update */
	   BEGIN TRAN delDups;
	   
	   DELETE d 
		  SELECT 
		  FROM adw.Claims_Details d
		      JOIN (SELECT urn FROM #CDDups WHERE arn > 1) dup ON d.urn = dup.urn
		  
	   --ROLLBACK TRAN delDups
	   --COMMIT TRAN delDups
	   /* update the ndx
	   UPDATE STATISTICS adw.Claims_Details
	   
	   */
	   */
END;
