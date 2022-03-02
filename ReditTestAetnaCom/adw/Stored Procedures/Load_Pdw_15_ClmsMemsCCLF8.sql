---DONT RUN SP UNTIL VALIDATION FROM ADI
CREATE PROCEDURE [adw].[Load_Pdw_15_ClmsMemsCCLF8]
AS -- insert Claims.Members

	/* prepare logging */
	DECLARE @AuditId INT;    
	DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
	DECLARE @JobType SmallInt = 8	  -- Adw load
	DECLARE @ClientKey INT	 = 9; -- aetnaComm
	DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.ClmsAetComTx'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Member'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
	FROM adi.ClmsAetComTx cl
	  JOIN	(SELECT DISTINCT src_subscriber_id 
			 FROM adi.ClmsAetComTx
			 WHERE src_subscriber_id <> '********   '
		  	) a
	ON		cl.src_subscriber_id = a.src_subscriber_id
	 --SELECT @InpCnt

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
	CREATE TABLE #OutputTbl (ID VARCHAR(50) NOT NULL PRIMARY KEY);	

    INSERT INTO adw.Claims_Member
           (SUBSCRIBER_ID
		   , IsActiveMember
           ,DOB
           ,MEMB_LAST_NAME
           ,MEMB_MIDDLE_INITIAL
           ,MEMB_FIRST_NAME        
		   ,MEDICAID_NO
		   ,MEDICARE_NO
           ,Gender
           ,MEMB_ZIP
		   ,COMPANY_CODE
		   ,LINE_OF_BUSINESS_DESC
		   ,SrcAdiTableName
		   ,SrcAdiKey
		   ,LoadDate
		   )
	OUTPUT inserted.SUBSCRIBER_ID INTO #OutputTbl(ID)
    SELECT 
	    m.src_subscriber_id					AS SUBSCRIBER_ID		    
		,1									AS IsActiveMember
		,m.subscriber_brth_dt				AS DOB				  	   
		,m.mem_last_nm						AS MEMB_LAST_NAME		    
		,''									AS MEMB_MIDDLE_INITIAL	    
		,m.mem_first_nm						AS MEMB_FIRST_NAME	    
		, ''								AS MEDICAID_NO
		, ''								AS MEDICARE_NO
		,m.mem_gender						AS GENDER			    
		,m.zip_cd							AS MEMB_ZIP			    
		,''									AS COMPANY_CODE
		,''									AS LINE_OF_BUSINESS_DESC
		,'ClmsAetComTx'						AS SrcAdiTableName
		, m.ClmsAetComTxKey					AS SrcAdiKey
		, GetDate()							AS LoadDate
		-- implicit: CreatedDate, CreatedBy, LastUpdatedDate, LastUpdatedBy select * 
    FROM adi.ClmsAetComTx m    
    JOIN			(
					SELECT * FROM
					
					(	SELECT   src_subscriber_id, ClmsAetComTxKey
								, ROW_NUMBER() OVER(PARTITION BY src_subscriber_id ORDER BY Datadate DESC) RwCnt
						FROM	adi.ClmsAetComTx a
						WHERE	a.src_subscriber_id <> '********'
					)b
					WHERE		b.RwCnt = 1
					AND			src_subscriber_id <> ''
					) z
	ON	 m.ClmsAetComTxKey = z.ClmsAetComTxKey;
	;

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
	   
	