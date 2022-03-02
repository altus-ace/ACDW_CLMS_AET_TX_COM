
	
	CREATE PROCEDURE	[ast].[plsCareopps_Quality_Action_List]( ---  [ast].[plsCareopps_Quality_Action_List]'2021-11-15',9,'2021-10-30' 
							@QMDATE DATE
							,@ClientKey INT
							,@DataDate DATE)
	AS


	BEGIN
	BEGIN TRY
	BEGIN TRAN

					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1    
					DECLARE @JobType SmallInt = 9	  
					DECLARE @ClientID INT	 = @ClientKey; 
					DECLARE @JobName VARCHAR(100) = 'AetnaCOMM_CareOpps';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = 'ALTUS_ClinicalReportingPackage'
					DECLARE @DestName VARCHAR(100) = '[ast].[QM_ResultByMember_History]'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
					DECLARE @OutputTbl TABLE (ID INT) 
	---Step 1a Create a temp table to hold records
		
		IF OBJECT_ID('tempdb..#AetCom_CareOpps') IS NOT NULL DROP TABLE #AetCom_CareOpps
		CREATE TABLE  #AetCom_CareOpps ([pstQM_ResultByMbr_HistoryKey] [int] IDENTITY(1,1) NOT NULL,[astRowStatus] [varchar](20) DEFAULT'P' NOT NULL,
								[srcFileName] [varchar](150) NULL,
								[adiTableName] [varchar](100) NOT NULL,	[adiKey] [int] NOT NULL,[DataDate] [date] NOT NULL,	
								[CreateDate] [datetime] NOT NULL,
								[CreateBy] [varchar](50) NOT NULL,[ClientKey] [int] NOT NULL,[ClientMemberKey] [varchar](50) NOT NULL 
								,[QmMsrId] [varchar](100) NULL,[QmCntCat] [varchar](10) NULL,[QMDate] [date] NULL
								,[MbrCOPStatus] [varchar](50) NULL
								,srcQMID VARCHAR(50),PlanName VARCHAR(50), srcQmDescription VARCHAR(50)
								)

					SELECT				@InpCnt = COUNT(adiKey)
					FROM				#AetCom_CareOpps
								
					--SELECT				 @InpCnt  

		EXEC		amd.sp_AceEtlAudit_Open 
					@AuditID = @AuditID OUTPUT
					, @AuditStatus = @JobStatus
					, @JobType = @JobType
					, @ClientKey = @ClientKey
					, @JobName = @JobName
					, @ActionStartTime = @ActionStart
					, @InputSourceName = @SrcName
					, @DestinationName = @DestName
					, @ErrorName = @ErrorName
	
	--1c Create a tmp table to hold population
	IF OBJECT_ID('tempdb..#COP') IS NOT NULL DROP TABLE #COP --- --  DECLARE @DataDate DATE = '2021-10-30' DECLARE @QMDATE DATE = '2021-11-15'  DECLARE @ClientKey INT = 9
	SELECT DISTINCT	ClientMemberKey
			,[QmMsrId]
			,QmCntCat 
			,QMDATE
			,MbrCOPStatus
			,AdiKey
			,srcFileName
			,DataDate
			,AdiTableName
			,CreateDate
			,CreateBy
			,ClientKey
			,srcQMID
			,srcQmDescription
			INTO	#COP
	FROM   (  
			SELECT DISTINCT ClientMemberKey
					,acepln.QmMsrId
					,src.QmCntCat
					,QMDATE
					,MbrCOPStatus
					,src.AdiKey
					,src.srcFileName
					,src.DataDate
					,src.AdiTableName
					,src.CreateDate
					,src.CreateBy
					,src.ClientKey
					,acepln.Destination AS srcQMID
					,src.MeasureName AS srcQmDescription
			FROM	( /*Get dataset for processing*/ 
					SELECT DISTINCT (SELECT CONVERT(VARCHAR(50), CONVERT(NUMERIC(20, 0), adi.MEMBERID))) AS ClientMemberKey
							,CASE WHEN adi.ActionRequired	
							  IN ('Action needed now'
								 ,'Action needed next month'
								 ,'Action needed in 2 months'
								 ,'New Member-Check MR')
							  AND Measure IN (SELECT Source 
											FROM lst.ListAceMapping
											WHERE ClientKey = @ClientKey
											AND ACTIVE = 'Y'
											)
							  THEN 'DEN' ELSE '' END				AS QmCntCat
							,adi.Measure							AS MeasureName
							,adi.ActionRequired						AS MbrCOPStatus
							,adi.ActionListKey						AS AdiKey
							,adi.[SrcFileName]						AS srcFileName
							,adi.[DataDate]							AS DataDate
							,'[adi].[AetnaCommGIC_ActionList]'		AS AdiTableName
							,adi.[CreatedDate]						AS CreateDate
							,SUSER_NAME()							AS CreateBy
							,(SELECT ClientKey	
								FROM lst.list_client 
								WHERE ClientShortName = 'AetCom') AS ClientKey
							, @QMDATE AS QMDATE ----  SELECT TOP 3 *
					FROM [adi].[AetnaCommGIC_ActionList] adi
					WHERE	RowStatus = 0
					AND		DataDate =  @DataDate 
					)src
			LEFT JOIN   /*Match on the lookup tables for matching values*/
					(	SELECT DISTINCT IsActive
									,Source
									,Destination
									,MeasureID AS [QmMsrId]
							FROM [lst].[ListAceMapping] ace
							LEFT JOIN	(SELECT DISTINCT MeasureID
												,MeasureDESC
												,PlanName
											FROM  lst.lstCareOpToPlan
											WHERE ClientKey = @ClientKey 
											AND   ACTIVE = 'Y'
										) qm		
							ON		ace.Destination=qm.MeasureID
							WHERE ClientKey = @ClientKey
							AND	MappingTypeKey = 14
							AND ace.Active = 'Y'
					) acePln
			ON		src.MeasureName = acePln.Source
	)srcOut
	
	-- SELECT * FROM #COP WHERE QmMsrId IS NULL
	/*Step 2:
		Inserting DEN from tmp table*/
	INSERT INTO	#AetCom_CareOpps(
					[srcFileName]
					, [adiTableName]
					, [adiKey]
					, [DataDate]
					, [CreateDate]
					, [CreateBy]
					, [ClientKey]
					, [ClientMemberKey]
					, [QmMsrId]
					, [QmCntCat]
					, [QMDate]
					, [MbrCOPStatus]
					, [srcQMID]
					, [srcQmDescription])
		SELECT		src.SrcFileName
					,src.AdiTableName
					,src.Adikey
					,src.DataDate
					,src.CreateDate
					,src.CreateBy
					,src.ClientKey
					,src.[ClientMemberKey]
					,src.QmMsrId
					,src.QmCntCat
					,src.QMDate
					,src.MbrCOPStatus
					,src.srcQMID
					,src.srcQmDescription
		FROM		#COP src
		WHERE		QmCntCat = 'DEN'


		/*Step 3
		 Inserting COP from tmp Table*/

			BEGIN

		INSERT INTO	#AetCom_CareOpps(
					[srcFileName]
					, [adiTableName]
					, [adiKey]
					, [DataDate]
					, [CreateDate]
					, [CreateBy]
					, [ClientKey]
					, [ClientMemberKey]
					, [MbrCOPStatus]
					, [QmMsrId]
					, [QmCntCat]
					, [QMDate]
					, [srcQMID]
					, [srcQmDescription])
		SELECT		srcFileName
					,AdiTableName
					,adiKey
					,DataDate
					,[CreateDate]
					,[CreateBy]
					,ClientKey
					,ClientMemberKey
					,[MbrCOPStatus] 
					,[QmMsrId]
					,CASE WHEN QmCntCat = 'DEN' THEN 'COP' ELSE '' END QMCntCat
					,mbr.[QMDate]
					,srcQMID
					,srcQmDescription
		FROM		#COP mbr
		WHERE		QmCntCat = 'DEN'

		
		
		END

		
		/*Step 4: Calculating Invalid Records*/

		BEGIN
		INSERT INTO	#AetCom_CareOpps(
					[srcFileName]
					, [adiTableName]
					, [adiKey]
					, [DataDate]
					, [CreateDate]
					, [CreateBy]
					, [ClientKey]
					, [ClientMemberKey]
					, [MbrCOPStatus]
					, [QmMsrId]
					, [QmCntCat]
					, [QMDate]
					, [srcQMID]
					, [srcQmDescription]
					)
		SELECT		srcFileName
					,AdiTableName
					,adiKey
					,DataDate
					,[CreateDate]
					,[CreateBy]
					,ClientKey
					,ClientMemberKey
					,[MbrCOPStatus] 
					,[QmMsrId]
					,[QmCntCat]
					,[QMDate]
					,srcQMID
					,srcQmDescription
		FROM		#COP mbr
		WHERE		QmMsrId IS NULL
		AND			QmCntCat = ''
		UNION
		SELECT		srcFileName
					,AdiTableName
					,adiKey
					,DataDate
					,[CreateDate]
					,[CreateBy]
					,ClientKey
					,ClientMemberKey
					,[MbrCOPStatus] 
					,[QmMsrId]
					,[QmCntCat]
					,[QMDate]
					,srcQMID
					,srcQmDescription
		FROM		#COP mbr
		WHERE		QmMsrId IS NOT NULL
		AND			QmCntCat = ''

		END
		-- Insert into staging
		BEGIN

		INSERT INTO		[ast].[QM_ResultByMember_History](
						[astRowStatus]
						, [srcFileName]
						, [adiTableName]
						, [adiKey]
						, [LoadDate]
						, [CreateDate]
						, [CreateBy]
						, [ClientKey]
						, [ClientMemberKey]
						, [QmMsrId]
						, [QmCntCat]
						, [QMDate]
						, [srcQMID]
						, [srcQmDescription])
		
		SELECT			'Loaded'
						, [srcFileName]
						, [adiTableName]
						, [adiKey]
						, [DataDate]
						, [CreateDate]
						, [CreateBy]
						, [ClientKey]
						, [ClientMemberKey]
						, [QmMsrId]
						, [QmCntCat]
						, [QMDate]
						, [srcQMID]
						, [srcQmDescription]
		FROM			#AetCom_CareOpps
		
	
		END

		--Update adi RowStatus
		BEGIN
		UPDATE [adi].[AetnaCommGIC_ActionList]
		SET RowStatus = 1
		WHERE RowStatus = 0
		END

					SET					@ActionStart  = GETDATE();
					SET					@JobStatus =2  
					    				
					EXEC				ACECAREDW.amd.sp_AceEtlAudit_Close 
										@Audit_Id = @AuditID
										, @ActionStopTime = @ActionStart
										, @SourceCount = @InpCnt		  
										, @DestinationCount = @OutCnt
										, @ErrorCount = @ErrCnt
										, @JobStatus = @JobStatus   

		/*Validation_Tmp*/
		SELECT		COUNT(*)
                        ,[QmMsrId]
                        ,[QmCntCat] 
		FROM		#AetCom_CareOpps
		WHERE           QMDate = @QMDATE
        AND             ClientKey = @ClientKey
        GROUP BY        [QmMsrId]
                        ,[QmCntCat]
        ORDER BY        [QmMsrId],[QmCntCat]
		

		DROP TABLE #AetCom_CareOpps
		DROP TABLE #COP

		COMMIT
		END TRY

		BEGIN CATCH
		EXECUTE [dbo].[usp_QM_Error_handler]
		END CATCH

		END
		
		
		--Validation
		SELECT          COUNT(*)
                        ,[QmMsrId]
                        ,[QmCntCat]
        FROM            [ast].[QM_ResultByMember_History]
        WHERE           QMDate = @QMDATE
        AND             ClientKey = @ClientKey
        GROUP BY        [QmMsrId]
                        ,[QmCntCat]
        ORDER BY        [QmMsrId],[QmCntCat]






 
  
