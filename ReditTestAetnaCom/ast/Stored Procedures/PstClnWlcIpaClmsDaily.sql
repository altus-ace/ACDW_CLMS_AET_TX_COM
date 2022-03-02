CREATE PROCEDURE [ast].[PstClnWlcIpaClmsDaily]
AS
   DECLARE @CntIn Int = 0 ;
   DECLARE @CntClean INT = 0;   
   DECLARE @CntError INT = 0;
   DECLARE @Audit_ID INT	   = 0;
    
   DECLARE @DataSrcName VARCHAR(100) = 'dbo.Claims_Headers';
   DECLARE @DataTrgName VARCHAR(100) = 'dbo.Claims_Member';   
   DECLARE @DataErrName VARCHAR(100) = 'N/A';
   DECLARE @JobName VARCHAR(100) = (SELECT OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID));
   DECLARE @JobExecTime DATETIME2 = GETDATE();
   DECLARE @OutputTbl TABLE (ID INT);	   

   EXEC amd.sp_AceEtlOpenAuditHeader 
		  @AuditID	    = @Audit_ID OUTPUT,              -- int
		  @EtlJobName	    = @JobName,                        
	       @ActionStartTime = @JobExecTime, -- datetime2(7)
	       @InputSourceName = @DataSrcName,                    -- varchar(200)
	       @DestinationName = @DataTrgName,                    -- varchar(200)
	       @ErrorName	    = @DataErrName            -- varchar(200)
		  ;
   
   SELECT @cntIn = count(w.astUrn) 
	   FROM ast.WlcIpaClmsDaily w;

    /* to do:
      1. Add logging code here 
		  DONE a. set up variables
		  DONE b. call intial sp
		  DONE c. add output capture for merge
		  d. call final sp 
    */   
   MERGE	  ast.WlcIpaClmsDaily trg
   USING (SELECT w.astUrn,       
			 w.DOB,
			 w.SubscriberID,
			 --w.srcFileName, w.LoadDate, w.DataDate, w.CreatedBy, w.CreatedDate,
    			 /*fields to CLEAN */
    			 w.ProviderID SrcPROV_ID,
			 SUBSTRING(w.ProviderID,CHARINDEX('N',w.ProviderID)+1, LEN(w.providerId)- charindex('"',reverse(w.ProviderID))- CHARINDEX('N',w.ProviderID)) as PROV_ID,
			 w.AuthNumber as SrcAUTH_NUMBER,       
			 SUBSTRING(w.AuthNumber,CHARINDEX('"',w.AuthNumber)+1, LEN(w.AuthNumber)- charindex('"',reverse(w.AuthNumber))- CHARINDEX('"',w.AuthNumber)) as AUTH_NUMBER,
			 w.Diagnosis_1 AS SrcDiag_1,
			 SUBSTRING(w.Diagnosis_1,CHARINDEX('"',w.Diagnosis_1)+1, LEN(w.Diagnosis_1)- charindex('"',reverse(w.Diagnosis_1))- CHARINDEX('"',w.Diagnosis_1)) as Diag_1,
			 w.Diagnosis_2 AS SrcDiag_2,
    			 SUBSTRING(w.Diagnosis_2,CHARINDEX('"',w.Diagnosis_2)+1, LEN(w.Diagnosis_2)- charindex('"',reverse(w.Diagnosis_2))- CHARINDEX('"',w.Diagnosis_2)) as Diag_2,
    			 w.Diagnosis_3 AS SrcDiag_3,
    			 SUBSTRING(w.Diagnosis_3,CHARINDEX('"',w.Diagnosis_3)+1, LEN(w.Diagnosis_3)- charindex('"',reverse(w.Diagnosis_3))- CHARINDEX('"',w.Diagnosis_3)) as Diag_3,
			 w.Diagnosis_4 AS SrcDiag_4,
    			 SUBSTRING(w.Diagnosis_4,CHARINDEX('"',w.Diagnosis_4)+1, LEN(w.Diagnosis_4)- charindex('"',reverse(w.Diagnosis_4))- CHARINDEX('"',w.Diagnosis_4)) as Diag_4,
			 w.Diagnosis_5 AS SrcDiag_5,
    			 SUBSTRING(w.Diagnosis_5,CHARINDEX('"',w.Diagnosis_5)+1, LEN(w.Diagnosis_5)- charindex('"',reverse(w.Diagnosis_5))- CHARINDEX('"',w.Diagnosis_5)) as Diag_5,
			 w.Diagnosis_6 AS SrcDiag_6,
    			 SUBSTRING(w.Diagnosis_6,CHARINDEX('"',w.Diagnosis_6)+1, LEN(w.Diagnosis_6)- charindex('"',reverse(w.Diagnosis_6))- CHARINDEX('"',w.Diagnosis_6)) as Diag_6,
			 w.ProfNet AS SrcProf_Net,
    			 SUBSTRING(w.ProfNet,charindex('"',w.profNet)+1, CHARINDEX(',',w.profnet)-1- charindex('"',w.profNet)-1) as Prof_Net,
			 w.Billed AS SrcBilled_01,
    			 SUBSTRING(w.Billed,charindex('"',w.Billed)+1, CHARINDEX(',',w.Billed)-1- charindex('"',w.Billed)-1) as Billed_01,
			 w.Allowed AS SrcAllowed_01,
    			 SUBSTRING(w.Allowed,charindex('"',w.Allowed)+1, CHARINDEX(',',w.Allowed)-1- charindex('"',w.Allowed)-1) as Allowed_01,
			 w.Copay AS SrcCoPay_01,
    			 SUBSTRING(w.Copay,charindex('"',w.Copay)+1, CHARINDEX(',',w.Copay)-1- charindex('"',w.Copay)-1) as Copay_01,
    			 w.Carrier AS SrcCarrier_01,
    			 SUBSTRING(w.Copay,charindex('"',w.Carrier)+1, CHARINDEX(',',w.Carrier)-1- charindex('"',w.Carrier)-1) as Carrier_01,
			 w.TotalBilledAmt AS SrcTotalBilledAmt_01,
    			 SUBSTRING(w.TotalBilledAmt,charindex('"',w.TotalBilledAmt)+1, CHARINDEX(',',w.TotalBilledAmt)-1- charindex('"',w.TotalBilledAmt)-1) as TotalBilledAmt_01       
			 , 1 AS IsCleaned
	   FROM ast.WlcIpaClmsDaily w
	   WHERE w.IsCleaned = 0  -- only use non-cleaned as src
	   )src
    ON trg.astUrn	= src.astUrn	 
    WHEN MATCHED THEN UPDATE 
	   SET
		  trg.ProviderID	  = src.PROV_ID
	   ,	  trg.AuthNumber	  = src.AUTH_NUMBER
	   ,	  trg.Diagnosis_1	  = src.Diag_1
	   ,	  trg.Diagnosis_2	  = src.Diag_2
	   ,	  trg.Diagnosis_3	  = src.Diag_3
	   ,	  trg.Diagnosis_4	  = src.Diag_4
	   ,	  trg.Diagnosis_5	  = src.Diag_5
	   ,	  trg.Diagnosis_6	  = src.Diag_6
	   ,	  trg.ProfNet		  = src.Prof_Net
	   ,	  trg.Billed		  = src.Billed_01
	   ,	  trg.Allowed		  = src.Allowed_01
	   ,	  trg.Copay		  = src.Copay_01
	   ,	  trg.Carrier		  = src.Carrier_01
	   ,	  trg.TotalBilledAmt  = src.TotalBilledAmt_01
	   ,   trg.IsCleaned	  = src.IsCleaned
    OUTPUT inserted.astUrn
    INTO @OutputTbl(ID)
    ;

    SELECT @CntClean =  COUNT(distinct t.ID) FROM @OutputTbl t;
    SET @JobExecTime = GETDATE();
	    
    EXEC amd.sp_AceEtlCloseAuditHeader
		  @audit_id = @Audit_ID,                          
	       @ActionStopTime = @JobExecTime,				
	       @SourceCount = @CntIn,                        
	       @DestinationCount = @CntClean,                
	       @ErrorCount = @CntError                       
		  ;
