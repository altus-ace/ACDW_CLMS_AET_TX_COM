CREATE PROCEDURE [adw].[Load_Pdw_14_ClmsDiagsCclf4]
AS 
   
   /* prepare logging */
	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 8	  -- AST load
	DECLARE @ClientKey INT	 = 9; -- aetnaComm
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.ClmsAetComTx'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Diags'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
	FROM   adi.ClmsAetComTx cp 		
    JOIN   ast.pstcDgDeDupUrns  dd		   
	ON     cp.ClmsAetComTxKey = dd.urn
    JOIN   ast.ClaimHeader_03_LatestEffectiveClaimsHeader lr   
	ON     cp.src_clm_id = lr.clmSKey	 --SELECT @InpCnt
		;

	EXEC amd.sp_AceEtlAudit_Open 
        @AuditID = @AuditID OUTPUT
        , @AuditStatus = @JobStatus
        , @JobType = @JobType
        , @ClientKey = @ClientKey
        , @JobName = @JobName
        , @ActionStartTime = @ActionStart
        , @InputSourceName = @SrcName
        , @DestinationName = @DestName
        , @ErrorName	   = @ErrorName
        ;
	CREATE TABLE #OutputTbl (ID INT NOT NULL PRIMARY KEY);	
    INSERT INTO  adw.Claims_Diags
           ([SEQ_CLAIM_ID]
           ,[SUBSCRIBER_ID]
           ,[ICD_FLAG]
           ,[diagNumber]
           ,[diagCode]
		   ,[diagCodeWithoutDot]
           ,[diagPoa]
		   ,LoadDate
		   ,SrcAdiTableName
		   ,SrcAdiKey)
	OUTPUT INSERTED.URN INTO #OutputTbl(ID)
    SELECT RTRIM(cp.src_clm_id)					AS SEQ_CLAIM_ID   
			,cp.src_subscriber_id				AS SUBSCRIBER_ID
			,cp.ICD10_Indicator					AS ICD_FLAG   
			,''									AS diagNumber     
			,cp.pri_icd9_dx_cd					AS diagCode
			,REPLACE(cp.pri_icd9_dx_cd,'.','')	AS diagCodeWithoutDot
			,cp.poa_cd_1						AS diagPoa        
			,getdate()							AS LoadDate
			,'adi.ClmsAetComTx'					AS SrcAdiTableName
			,cp.ClmsAetComTxKey					AS SrcAdiKey
			-- Implicit: CreatedDate,	CreatedBy,LastUpdatedDate,LastUpdatedBy	
     FROM   adi.ClmsAetComTx cp 		
	 JOIN   ast.pstcDgDeDupUrns  dd		   
	 ON     cp.ClmsAetComTxKey = dd.urn
	 JOIN   ast.ClaimHeader_03_LatestEffectiveClaimsHeader lr   
	 ON     cp.src_clm_id = lr.clmSKey	
	 ORDER BY cp.src_clm_id, lr.clmSKey;

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

	