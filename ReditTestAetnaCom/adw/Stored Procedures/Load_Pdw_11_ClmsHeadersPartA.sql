
CREATE PROCEDURE [adw].[Load_Pdw_11_ClmsHeadersPartA]
AS    

	/* prepare logging */
	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 8	  -- AST load
	DECLARE @ClientKey INT	 = 9; -- aetnaComm
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.ClmsAetComTx'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Headers'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT	 @InpCnt = COUNT(*) 
	FROM	 adi.ClmsAetComTx ch
	JOIN	 ast.ClaimHeader_03_LatestEffectiveClaimsHeader lr 
	ON		 ch.ClmsAetComTxKey = lr.clmHdrURN; --SELECT	 @InpCnt

	EXEC amd.sp_AceEtlAudit_Open 
        @AuditID = @AuditID OUTPUT
        , @AuditStatus = @JobStatus
        , @JobType = @JobType
        , @ClientKey = @ClientKey
        , @JobName = @JobName
        , @ActionStartTime = @ActionStart
        , @InputSourceName = @SrcName
        , @DestinationName = @DestName
        , @ErrorName = @ErrorName
        ;
	CREATE TABLE #OutputTbl (Seq_claim_ID VARCHAR(50) PRIMARY KEY NOT NULL);	

    -- 1. Insert cliams Using LastClmRow set 
    BEGIN TRAN LoadPartAHeader	
    INSERT INTO adw.Claims_Headers(		
					SEQ_CLAIM_ID					
					,SUBSCRIBER_ID          
					,CLAIM_NUMBER           
					,CATEGORY_OF_SVC        
					,PAT_CONTROL_NO
					,ICD_PRIM_DIAG          
					,PRIMARY_SVC_DATE       
					,SVC_TO_DATE            
					,CLAIM_THRU_DATE        
					,POST_DATE              
					,CHECK_DATE             
					,CHECK_NUMBER           
					,DATE_RECEIVED          
					,ADJUD_DATE             
					,CMS_CertificationNumber
					,SVC_PROV_ID            
					,SVC_PROV_FULL_NAME     
					,SVC_PROV_NPI           
					,PROV_SPEC              
					,PROV_TYPE              
					,PROVIDER_PAR_STAT      
					,ATT_PROV_ID            
					,ATT_PROV_FULL_NAME     
					,ATT_PROV_NPI           
					,REF_PROV_ID            
					,REF_PROV_FULL_NAME     
					,VENDOR_ID              
					,VEND_FULL_NAME         
					,IRS_TAX_ID             
					,DRG_CODE               
					,BILL_TYPE              
					,ADMISSION_DATE         
					,AUTH_NUMBER            
					,ADMIT_SOURCE_CODE      
					,ADMIT_HOUR             
					,DISCHARGE_HOUR         
					,PATIENT_STATUS         
					,CLAIM_STATUS           
					,PROCESSING_STATUS      
					,CLAIM_TYPE             
					,TOTAL_BILLED_AMT       
					,TOTAL_PAID_AMT         
					,CalcdTotalBilledAmount 
					,BENE_PTNT_STUS_CD      
					,DISCHARGE_DISPO
					,srcAdiTableName
					,SrcAdiKey              
					,LoadDate
					)        
	OUTPUT INSERTED.SEQ_CLAIM_ID INTO #OutputTbl(Seq_claim_ID)			
     SELECT		
	    RTRIM(ch.src_clm_id)								AS	SEQ_CLAIM_ID				--SEQ_CLAIM_ID			
		--,ch.src_subscriber_id								AS	SUBSCRIBER_ID          		--,SUBSCRIBER_ID          
		, CONVERT(VARCHAR(50), CONVERT(numeric(18,0), LTRIM(RTRIM(ch.member_id))))			--,SUBSCRIBER_ID          
		,RTRIM(lr.clmSKey)									AS	CLAIM_NUMBER           		--,CLAIM_NUMBER           
		,CASE ch.srv_benefit_cd 																
			WHEN '10' THEN 'OTHER'															
			WHEN '20' THEN 'OTHER'															
			WHEN '30' THEN 'OTHER'															
			WHEN '40' THEN 'OUTPATIENT'														
			WHEN '50' THEN 'HOSPICE'														
			WHEN '60' THEN 'INPATIENT'														
			WHEN '70' THEN 'PHYSICIAN'														
			WHEN '71' THEN 'PHYSICIAN'														
			WHEN '72' THEN 'PHYSICIAN'														
			WHEN '81' THEN 'PHYSICIAN DME'													
			WHEN '81' THEN 'PHYSICIAN DME'													
			ELSE ch.srv_benefit_cd	END 					AS	CATEGORY_OF_SVC        		--,CATEGORY_OF_SVC        
		,''													AS	PAT_CONTROL_NO				--,PAT_CONTROL_NO
		,ch.pri_icd9_dx_cd									AS	ICD_PRIM_DIAG          		--,ICD_PRIM_DIAG          
		,ch.srv_start_dt									AS	PRIMARY_SVC_DATE       		--,PRIMARY_SVC_DATE       
		,ch.srv_stop_dt										AS	SVC_TO_DATE            		--,SVC_TO_DATE            
		,ch.srv_stop_dt										AS	CLAIM_THRU_DATE        		--,CLAIM_THRU_DATE        
		,ch.paid_dt_OR_adjn_dt								AS	POST_DATE              		--,POST_DATE              
		,'01/01/1900'										AS	CHECK_DATE             		--,CHECK_DATE             
		,''													AS	CHECK_NUMBER           		--,CHECK_NUMBER           
		,'01/01/1900'										AS	DATE_RECEIVED          		--,DATE_RECEIVED          
		,'01/01/1900'										AS	ADJUD_DATE             		--,ADJUD_DATE             
		,''													AS  CMS_CertNum					--,CMS_CertificationNumber
		,''													AS	SVC_PROV_ID            		--,SVC_PROV_ID            
		,''													AS	SVC_PROV_FULL_NAME     		--,SVC_PROV_FULL_NAME     
		,ch.srv_prvdr_npi									AS	SVC_PROV_NPI           		--,SVC_PROV_NPI           
		,ch.specialty_cd									AS	PROV_SPEC              		--,PROV_SPEC              
		,ch.provider_type_cd								AS	PROV_TYPE              		--,PROV_TYPE              
		,''													AS	PROVIDER_PAR_STAT      		--,PROVIDER_PAR_STAT      
		,''													AS	ATT_PROV_ID            		--,ATT_PROV_ID            
		,''													AS	ATT_PROV_FULL_NAME     		--,ATT_PROV_FULL_NAME     
		,ch.srv_prvdr_npi									AS	ATT_PROV_NPI           		--,ATT_PROV_NPI           
		,''													AS	REF_PROV_ID            		--,REF_PROV_ID            
		,''													AS	REF_PROV_FULL_NAME     		--,REF_PROV_FULL_NAME     
		,''													AS	VENDOR_ID              		--,VENDOR_ID              
		,''													AS	VEND_FULL_NAME      		--,VEND_FULL_NAME         will be a look up from NPPES   
		,''													AS	IRS_TAX_ID             		--,IRS_TAX_ID             
		,ch.drg_cd											AS	DRG_CODE               		--,DRG_CODE               --Remove leading zero						
		,''													AS	BILL_TYPE              		--,BILL_TYPE              
		,ch.SRC_ADMIT_DT									AS	ADMISSION_DATE         		--,ADMISSION_DATE         
		,''													AS	AUTH_NUMBER            		--,AUTH_NUMBER            
		,''													AS	ADMIT_SOURCE_CODE      		--,ADMIT_SOURCE_CODE      
		,''													AS	ADMIT_HOUR             		--,ADMIT_HOUR             
		,''													AS	DISCHARGE_HOUR         		--,DISCHARGE_HOUR         
		,''													AS	PATIENT_STATUS         		--,PATIENT_STATUS         
		,ch.clm_ln_status_cd								AS	CLAIM_STATUS           		--,CLAIM_STATUS           
		,ch.clm_ln_type_cd									AS	PROCESSING_STATUS      		--,PROCESSING_STATUS      
		,ch.srv_benefit_cd									AS	CLAIM_TYPE             		--,CLAIM_TYPE             
		,ch.billed_amt										AS	TOTAL_BILLED_AMT       		--,TOTAL_BILLED_AMT       
		,ch.paid_amt										AS	TOTAL_PAID_AMT         		--,TOTAL_PAID_AMT         
		,'' 												AS	CalcdTotalBilledAmount 		--,CalcdTotalBilledAmount 
		,'' 												AS	BENE_PTNT_STUS_CD      		--,BENE_PTNT_STUS_CD      
		,ch.dschrg_status_cd								AS  discharge_Dispo				--,DISCHARGE_DISPO
		, 'ClmsAetComTx'									AS  SrcAdiTableName
		,ch.ClmsAetComTxKey									AS	SrcAdiKey              		--,SrcAdiKey              
		,GetDate()											AS	LoadDate               		--,LoadDate
		--	implicitly loaded by defaults: CreatedDate,CreatedBy,LastUpdatedDate,LastUpdatedBy,
	FROM adi.ClmsAetComTx ch
	JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader lr
	ON	 ch.ClmsAetComTxKey = lr.clmHdrURN ORDER BY src_clm_id
    ;

	COMMIT TRAN LoadPartAHeader;

	-- if this fails it just stops. How should this work, structure from the WLC or AET COM care Op load, acedw do this soon.
	SELECT @OutCnt = COUNT(*) FROM #OutputTbl; 
	SET @ActionStart = GETDATE();    
	SET @JobStatus =2  -- complete
    
	EXEC amd.sp_AceEtlAudit_Close 
        @Audit_Id = @AuditID
        , @ActionStopTime = @ActionStart
        , @SourceCount = @InpCnt		  
        , @DestinationCount = @OutCnt
        , @ErrorCount = @ErrCnt
        , @JobStatus = @JobStatus
	   ;
	

	