
CREATE PROCEDURE [adw].[Load_Pdw_12_ClmsDetailsPartA]
AS
	/* prepare logging */
	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 8	  -- AST load
	DECLARE @ClientKey INT	 = 9; -- aetnaComm
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.ClmsAetComTx'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Details'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT	@InpCnt = COUNT(*) 
	FROM	adi.ClmsAetComTx cl
	JOIN	ast.ClaimHeader_03_LatestEffectiveClaimsHeader lt
	ON		cl.src_clm_id = lt.clmSKey
	JOIN	ast.pstcLnsDeDupUrns ln
	ON		ln.URN = lt.clmHdrURN; --SELECT	@InpCnt
	
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

    INSERT INTO adw.Claims_Details  
		  (SEQ_CLAIM_ID,
			CLAIM_NUMBER,
			LINE_NUMBER,
			SUB_LINE_CODE,
			[SUBSCRIBER_ID],
			DETAIL_SVC_DATE,
			SVC_TO_DATE,
			REVENUE_CODE,
			QUANTITY,
			PAID_AMT,
			BILLED_AMT,
			PROCEDURE_CODE,
			MODIFIER_CODE_1,
			MODIFIER_CODE_2,
			MODIFIER_CODE_3,
			MODIFIER_CODE_4,
			PLACE_OF_SVC_CODE1,
			PLACE_OF_SVC_CODE2,
			PLACE_OF_SVC_CODE3,
			NDC_CODE,
			RX_GENERIC_BRAND_IND,
			RX_SUPPLY_DAYS,
			RX_DISPENSING_FEE_AMT,
			RX_INGREDIENT_AMT,
			RX_FORMULARY_IND,
			RX_DATE_PRESCRIPTION_WRITTEN,
			RX_DATE_PRESCRIPTION_FILLED,
			PRESCRIBING_PROV_TYPE_ID,	
			PRESCRIBING_PROV_ID,
			BRAND_NAME,
			DRUG_STRENGTH_DESC,
			GPI,
			GPI_DESC,
			CONTROLLED_DRUG_IND,
			COMPOUND_CODE,
			SrcAdiTableName,
			SrcAdiKey,
			LoadDate)		  
		OUTPUT Inserted.ClaimsDetailsKey INTO #OutputTbl(ID)
		SELECT  RTRIM(cl.src_clm_id)			AS seq_Claim_ID					
			,RTRIM(cl.src_clm_id)				AS claim_number 				
			,cl.src_claim_line_id_2				AS line_Number 					
			,0									AS SUB_LINE_CODE 				
			,CONVERT(VARCHAR(50), CONVERT(numeric(18,0), LTRIM(RTRIM(cl.member_id))))			--,SUBSCRIBER_ID   
			,ISNULL(cl.srv_start_dt, '1/1/1900')AS DETAIL_SVC_DATE 				
			,ISNULL(cl.srv_stop_dt, '1/1/1900')	AS SVC_TO_DATE 						
            ,cl.revenue_cd						AS REVENUE_CODE 			  	
            ,0					  				AS QUANTITY							
            ,cl.paid_amt						AS Paid_amt      							
            ,cl.billed_amt						AS BILLED_AMT				  	
            ,cl.prcdr_cd						AS PROCEDURE_CODE				
            ,cl.prcdr_modifier_cd_1				AS MODIFIER_CODE_1 				
            ,cl.prcdr_modifier_cd_2				AS MODIFIER_CODE_2 				
			,cl.prcdr_modifier_cd_3				AS MODIFIER_CODE_3 				
            ,''									AS MODIFIER_CODE_4 							
            ,''									AS PLACE_OF_SVC_CODE1																			
			,''									AS PLACE_OF_SVC_CODE2 				
			,'' 								AS PLACE_OF_SVC_CODE3			
			,''									AS NDC_CODE						
			,''									AS RX_GENERIC_BRAND_IND			
			,''									AS RX_SUPPLY_DAYS				
			,''									AS RX_DISPENSING_FEE_AMT																			
			,''									AS RX_INGREDIENT_AMT			
			,''									AS RX_FORMULARY_IND				
			,''									AS RX_DATE_PRESCRIPTION_WRITTEN
			,''									AS RX_DATE_PRESCRIPTION_FILLED	
			,''									AS PRESCRIBING_PROV_TYPE_ID		  
			,''									AS PRESCRIBING_PROV_ID				   
			,''									AS BRAND_NAME					
			,''									AS DRUG_STRENGTH_DESC			
			,''									AS GPI							
			,''									AS GPI_DESC						
			,''									AS CONTROLLED_DRUG_IND			
			,''									AS COMPOUND_CODE				
			,'ClmsAetComTx'						AS SrcAdiTableName
			,cl.ClmsAetComTxKey					AS SrcAdiKey					
			,GetDate()							AS LoadDate						
			  -- implicit CreatedDate, CreatedBy, LastUpdatedDate, LastUpdatedBy
       FROM adi.ClmsAetComTx cl
	   JOIN			ast.ClaimHeader_03_LatestEffectiveClaimsHeader lt
	   ON			cl.src_clm_id = lt.clmSKey
	   JOIN			ast.pstcLnsDeDupUrns ln
	   ON			ln.URN = lt.clmHdrURN
	   ORDER BY		src_clm_id, src_claim_line_id_2
       
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

