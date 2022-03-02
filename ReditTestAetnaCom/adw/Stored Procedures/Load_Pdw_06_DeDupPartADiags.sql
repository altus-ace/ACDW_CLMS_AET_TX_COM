﻿CREATE  PROCEDURE [adw].[Load_Pdw_06_DeDupPartADiags]
AS 

     /* -- 6. de dup diags

	   get diags sets by claim and line and adj and ???
	   deduplicate for cases:
		  1. deal with duplicates: all relavant details are the same
		  2. deal with adjustments: if details sub line code is different
		  3. deal with???? will determin as we move forward

	   sort by file date or???
	   
	   insert into ast claims dedup diags urns table [pstcDgDeDupUrns]
    */

	DECLARE @DataDate DATE;

	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 9	  -- 9: Ast Load, 10: Ast Transform, 11:Ast Validation	
	DECLARE @ClientKey INT	 = 3; -- aetnaMA
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.ClmsAetComTx'
    DECLARE @DestName VARCHAR(100) = 'ast.pstcDgDeDupUrns'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
	FROM		(	SELECT cd.ClmsAetComTxKey AS URN, cd.src_clm_id, src_claim_line_id_2, pri_icd9_dx_cd, adjn_dt,paid_dt_OR_adjn_dt,LoadDate, reversal_cd 
						,ROW_NUMBER()OVER(PARTITION BY src_clm_id, src_claim_line_id_2, pri_icd9_dx_cd, adjn_dt,paid_dt_OR_adjn_dt
						,LoadDate,reversal_cd ORDER BY LoadDate DESC) aDupID
					FROM adi.ClmsAetComTx cd
					JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader  LatestEffectiveCHeader 
					ON  cd.src_clm_id = LatestEffectiveCHeader.clmSKey
				) s
	WHERE s.aDupID = 1; 
	

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

    TRUNCATE table [ast].[pstcDgDeDupUrns];

    INSERT INTO ast.pstcDgDeDupUrns (urn)
	OUTPUT inserted.urn INTO #OutputTbl(ID)
    SELECT s.URN
    FROM		(	SELECT cd.ClmsAetComTxKey AS URN, cd.src_clm_id, src_claim_line_id_2, pri_icd9_dx_cd, adjn_dt,paid_dt_OR_adjn_dt,LoadDate, reversal_cd 
						,ROW_NUMBER()OVER(PARTITION BY src_clm_id, src_claim_line_id_2, pri_icd9_dx_cd, adjn_dt,paid_dt_OR_adjn_dt
						,LoadDate,reversal_cd ORDER BY LoadDate DESC) aDupID
					FROM adi.ClmsAetComTx cd
					JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader  LatestEffectiveCHeader 
					ON  cd.src_clm_id = LatestEffectiveCHeader.clmSKey
				) s
		  WHERE s.aDupID = 1;

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
	  