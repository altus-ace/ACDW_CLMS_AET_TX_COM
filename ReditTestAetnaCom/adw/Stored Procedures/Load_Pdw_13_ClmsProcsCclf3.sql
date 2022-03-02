CREATE PROCEDURE [adw].[Load_Pdw_13_ClmsProcsCclf3]
AS
    --Task 3 Insert Proc: -- Insert to proc    
	/* prepare logging */
	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 8	  -- AST load
	DECLARE @ClientKey INT	 = 9; -- aetnaComm
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.ClmsAetComTx'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Procs'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
	FROM	adi.ClmsAetComTx cl
	JOIN	ast.ClaimHeader_03_LatestEffectiveClaimsHeader lt
	ON		cl.src_clm_id = lt.clmSKey
	JOIN	ast.pstcPrcDeDupUrns ln
	ON		ln.URN = cl.ClmsAetComTxKey
	 
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
	CREATE TABLE #OutputTbl (ID INT NOT NULL PRIMARY KEY);	
    INSERT INTO adw.Claims_Procs
               (SEQ_CLAIM_ID
				,SUBSCRIBER_ID
				,ProcNumber
				,ProcCode
				,ProcDate
				,LoadDate
				,SrcAdiTableName
				,SrcAdiKey
				-- implicit: ,CreatedDate ,CreatedBy,LastUpdatedDate,LastUpdatedBy
				)	
	OUTPUT Inserted.URN INTO #OutputTbl(ID)
    SELECT RTRIM(cp.src_clm_id)					AS SEQ_CLAIM_ID
        , cp.src_subscriber_id				AS subscriberID
        , cp.prcdr_group_nbr				AS ProcNum
        , cp. prcdr_cd						AS ProcCode
        , '1900-01-01'						AS ProcDate
		, getdate()							AS LoadDate
		, 'ClmsAetComTx'					AS SrcAdiTableName
		, ClmsAetComTxKey					AS SrcAdiKey
		-- implicit: 	CreatedDate,CreatedBy,LastUpdatedDate,LastUpdatedBy
    FROM	adi.ClmsAetComTx cp
	JOIN	ast.ClaimHeader_03_LatestEffectiveClaimsHeader lt
	ON		cp.src_clm_id = lt.clmSKey     --order by SEQ_CLAIM_ID, src_claim_line_id_2
	JOIN	ast.pstcPrcDeDupUrns ln
	ON		ln.URN = cp.ClmsAetComTxKey
    ORDER BY cp.src_clm_id, cp.src_claim_line_id_2;

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

	   
	  