

	    
CREATE PROCEDURE [ast].[stg_01_pls_ProcessMbrMemberLoadFrmStaging] --- [ast].[stg_01_pls_ProcessMbrMemberLoadFrmStaging]'2022-02-01','2022-02-01',9 
							(@EffectiveDate DATE
							, @LoadDate DATE
							,@ClientKey INT)
AS	

BEGIN
BEGIN TRAN
BEGIN TRY


BEGIN
		

					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1    
					DECLARE @JobType SmallInt = 9	
					DECLARE @JobName VARCHAR(100) = 'Dev_ProcessIntoStagingFromAdi';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = '[ACECAREDW].adi.mbrAetCom'
					DECLARE @DestName VARCHAR(100) = '[ast].[MbrStg2_MbrData]'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
					DECLARE @RowStatus INT = 0;
					DECLARE @RowStatusValue VARCHAR(10) = 'Loaded';
					DECLARE @LobName VARCHAR(50) = (SELECT LobName FROM lst.List_Client WHERE ClientKey = 9)
					DECLARE @AdiTableName VARCHAR(50) = 'adi.MbrAetMCom';
					DECLARE @EffectiveMonth VARCHAR(7) = (SELECT MAX(EffectiveMonth) 
												FROM ACECAREDW.adi.MbrAetCom 
												WHERE EffectiveMonth NOT IN (SELECT MAX(EffectiveMonth) FROM ACECAREDW.adi.MbrAetCom));

	SELECT				@InpCnt = COUNT(m.mbrAetComMbr)     
	FROM				ACECAREDW.adi.MbrAetCom  m
	WHERE				LoadDate = @LoadDate 
	AND					m.EffectiveMonth = @EffectiveMonth
	
	SELECT				@InpCnt, @LoadDate
	
	
	EXEC				amd.sp_AceEtlAudit_Open 
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
    
   BEGIN
		--  DECLARE @LoadDate DATE = '2021-12-01' DECLARE @ClientKey INT = 9 	
		IF OBJECT_ID('tempdb..#Prr') IS NOT NULL DROP TABLE #Prr
		CREATE TABLE #Prr(NPI VARCHAR(50),ClientNPI VARCHAR(50),AttribTIN VARCHAR(50),ClientTIN VARCHAR(50),MemberID VARCHAR(50))

		INSERT INTO #Prr(NPI,ClientNPI,AttribTIN,ClientTIN,MemberID)
		EXECUTE  [adi].[GetMbrNpiAndTin_AetnaCOMM] @LoadDate,0,@ClientKey 
   END

    /*Step 1: Create DataSet to be loaded into staging for member ID Attribute */
		IF OBJECT_ID('tempdb..#mbrAetnaCOM') IS NOT NULL DROP TABLE #mbrAetnaCOM
					-- DECLARE @ClientKey INT = 9 DECLARE @LoadDate DATE = '2021-12-01'; DECLARE @RowStatusValue VARCHAR(10) = 'Loaded' DECLARE @EffectiveDate DATE = '2021-12-01'
    	SELECT DISTINCT CurrentRowsToLoad.CLientMemberKey
				, c.ClientKey
				, [adi].[udf_ConvertToCamelCase](adiMbrs.[LastName])			AS	LastName
				, [adi].[udf_ConvertToCamelCase](adiMbrs.[Member_First_Name])	AS	FirstName
				, adiMbrs.[Middle_Name]			AS  MiddleName
				, adiMbrs.[Member_Gender]		AS  GENDER
				, adiMbrs.[Member_Date_of_Birth] AS  DOB
				, adiMbrs.[Members_SSN]				AS SSN
				, ''							AS Hicn					
				, ''							AS AutoAssign
				, '1900-01-01'					AS ClientEffectiveDate
				, '1900-01-01'					AS ClientExpirationDate
				, ''							AS mbrMEDICARE_ID
				, ''							AS mbrMEDICAID_NO
				, adimbrs.Aetna_Card_ID			AS mbrInsuranceCardIdNum		      															  
		        , lstpln.TargetValue			AS plnProductPlan
				, lstSubpln.TargetValue			AS plnProductSubPlan
				, lstSubpln.TargetValue			AS plnProductSubPlanName
				, lstCsPln.TargetValue			AS CsplnProductSubPlanName
				, adiMbrs.[Individual_Original_Effective_date_at_Aetna] AS plnClientEffective
				, adiMbrs.SrcFileName
				, CurrentRowsToLoad.AdiTableName 
				, CurrentRowsToLoad.adiKey
				, adiMbrs.LoadDate				AS LoadDate
				, adiMbrs.DataDate				AS DataDAte
				, @RowStatusValue				AS stgRowStatus		
				, 'TX'							AS MbrState 
				, pr.NPI
				, pr.AttribTIN TIN
				, adiMbrs.[Attributed_Provider_NPI_Number] AS srcNPI
				, adiMbrs.Line_of_Business srcPLN
				, adiMbrs.mbrAetComMbr
				, adimbrs.Attribution_Original_Effective_Date AS MemberOriginalEffectiveDate
				, @EffectiveDate					AS EffectiveDate
				, [Attributed_Provider_Tax_ID_Number_TIN] AS srcTIN
				INTO #mbrAetnaCOM   --- SELECT * FROM #mbrAetnaCOM
		FROM (	SELECT		 *
					FROM	ACECAREDW.adi.MbrAetCom m 
			 ) adiMbrs
		JOIN	lst.List_Client c ON c.ClientKey = @ClientKey
		JOIN	(	SELECT t.ClientMemberKey, t.EffectiveMonth
						, t.CurrentLoadingEffectiveMonth
						, t.adiKey, t.adiTableName
						, t.LoadDate,t.DataDate
		  				FROM [adi].[tvf_MbrAetCom_GetCurrentMembers](@LoadDate) t
		  		  ) AS CurrentRowsToLoad 
		ON			adiMbrs.mbrAetComMbr = CurrentRowsToLoad.AdiKey  
		LEFT JOIN(	SELECT	ClientKey, TargetSystem, SourceValue,ExpirationDate
								,EffectiveDate,TargetValue
					FROM		lst.lstPlanMapping
					WHERE		ClientKey = @ClientKey
					AND			TargetSystem = 'ACDW_Plan'
					AND			@LoadDate BETWEEN EffectiveDate AND ExpirationDate) lstpln  
		ON	adiMbrs.[Line_of_Business] = lstpln.SourceValue 
		LEFT JOIN(	SELECT	ClientKey, TargetSystem, SourceValue,ExpirationDate
								,EffectiveDate,TargetValue
					FROM		lst.lstPlanMapping
					WHERE		ClientKey = @ClientKey
					AND			TargetSystem = 'ACDW_SubPlan'
					AND			@LoadDate BETWEEN EffectiveDate AND ExpirationDate) lstSubpln  
		ON adiMbrs.[Line_of_Business] = lstSubpln.SourceValue 
		LEFT JOIN(	SELECT	ClientKey, TargetSystem, SourceValue,ExpirationDate
								,EffectiveDate,TargetValue
					FROM		lst.lstPlanMapping
					WHERE		ClientKey = @ClientKey
					AND			TargetSystem = 'CS_AHS'
					AND			@LoadDate BETWEEN EffectiveDate AND ExpirationDate) lstCspln  
		ON adiMbrs.[Line_of_Business] = lstCspln.SourceValue 
		      /* Checking for NPIs */
		LEFT JOIN (SELECT DISTINCT pr.AttribTIN
								, pr.NPI
								,pr.MemberID
		  			FROM #Prr PR   
				  ) pr
		ON adiMbrs.[Attributed_Provider_NPI_Number] = pr.NPI
		AND CONVERT(VARCHAR(50), CONVERT(NUMERIC(20, 0), adiMbrs.MEMBER_ID)) = pr.MemberID   
		-- ORDER BY CLIENTMEMBERKEY

		BEGIN
		/*Insert into staging for onward processing*/
	   INSERT INTO ast.MbrStg2_MbrData 
			(ClientSubscriberId
				, ClientKey
				, mbrLastName
				, mbrFirstName
				, mbrMiddleName
				, mbrGENDER
				, mbrDob
				, [mbrSSN]
				, HICN 
				, prvNPI 
				, prvTIN 
				, prvAutoAssign
				, mbrMEDICARE_ID
				, mbrMEDICAID_NO
				, mbrInsuranceCardIdNum		      
				, prvClientEffective
				, prvClientExpiration 
				, plnProductPlan
				, plnProductSubPlan
				, plnProductSubPlanName
				, CsplnProductSubPlanName 
				, plnClientPlanEffective
				, plnClientPlanEndDate
				, SrcFileName
				, AdiTableName
				, AdiKey
				, LoadDate
				, DataDate
				, stgRowStatus
				, mbrState
				, srcNPI
				, srcPLN
				, Member_Dual_Eligible_Flag
				, plnMbrIsDualCoverage
				, MBI
				, mbrPrimaryLanguage
				, MemberOriginalEffectiveDate
				, MemberOriginalEndDate
				, EffectiveDate
				, LOB
				, srcTIN
				)
	   SELECT	src.ClientMemberKey					AS ClientSubscriberId
				, src.ClientKey						AS ClientKey
				, src.LastName						AS mbrLastName
				, src.FirstName						AS mbrFirstName
				, src.MiddleName					AS mbrMiddleName
				, src.Gender						AS mbrGender
				, src.DOB							AS mbrDob
				, src.SSN							AS [mbrSSN]
				, src.HICN							AS HICN
				, src.NPI							AS prvNPI
				, src.TIN							AS prvTIN
				, src.AutoAssign					AS prvAutoAssign
				, src.mbrMEDICARE_ID				AS mbrMEDICARE_ID
				, src.mbrMEDICAID_NO				AS mbrMEDICAID_NO
				, src.mbrInsuranceCardIdNum			AS mbrInsuranceCardIdNum
				, src.MemberOriginalEffectiveDate	AS prvClientEffective
				, '2099-12-31'						AS prvClientExpiration
				, src.PlnProductPlan				AS PlnProductPlan
				, src.plnProductSUbPlan				AS plnProductSUbPlan
				, src.plnProductSubPlanName			AS plnProductSubPlanName
				, CsplnProductSubPlanName			AS CsplnProductSubPlanName
				, src.plnClientEffective			AS plnClientEffective
				, '2099-12-31'						AS plnClientPlanEndDate
				, src.SrcFileName					AS SrcFileName
				, src.adiTableName					AS adiTableName
				, src.adiKey						AS adiKey
				, src.LoadDate						AS LoadDate
				, src.DataDate						AS DataDate
				, src.stgRowStatus					AS stgRowStatus
				, src.MbrState						AS MbrState
				, src.srcNPI						AS srcNPI
				, src.srcPLN						AS srcPLN
				, 0									AS Member_Dual_Eligible_Flag
				, 0									AS plnMbrIsDualCoverage
				, ''								AS MBI
				, ''								AS mbrPrimaryLanguage
				, MemberOriginalEffectiveDate		AS MemberOriginalEffectiveDate
				, '2099-12-31'						AS MemberOriginalEndDate
				, EffectiveDate						AS EffectiveDate
				, @LobName							AS LOB
				, srcTIN							AS srcTIN
	 FROM	#mbrAetnaCOM src
  
	END

   /*Creating Dataset to load Mbrs Phone, Addresses and Email into staging*/

   BEGIN
   IF OBJECT_ID('tempdb..#mbrAet') IS NOT NULL DROP TABLE #mbrAet
    --- DECLARE @AdiTableName char(1) = 'p' DECLARE @ClientKey INT = 9 DECLARE @DataDate DATE = '2021-10-18'
	SELECT DISTINCT mf.ClientMemberKey
				, m.SrcFileName
				, mf.LoadDate
				, m.DataDate
				, mf.adiTableName										AS adiTableName
				, mf.adiKey												AS adiKey
				, ISNULL(adw.AceCleanPhoneNumber(m.Member_PhoneNUm),'')	AS PhoneNumber
				, [pt].lstPhoneTypeKey
				, [at].lstAddressTypeKey
				, [adi].[udf_ConvertToCamelCase](m.Member_Address_Line1)		AS Member_Address_Line1
				, [adi].[udf_ConvertToCamelCase](m.Member_Address_Line2)		AS Member_Address_Line2
				, [adi].[udf_ConvertToCamelCase](m.Member_City)					AS Member_City
				, m.Member_State												AS Member_State
				, m.Member_County_code  
				, m.Member_Zipcode  
				, 'Loaded'										AS  stgRowStatus
				, c.ClientKey									AS  ClientKey
				, 0												AS  PhoneCarrierType
				, 0												AS  PhoneIsPrimary  
				, 0												AS  lstEmailTypeKey	
				, ''											AS	EmailAddress	
				, 0												AS  EmailIsPrimary
				INTO #mbrAet
	      FROM ACECAREDW.adi.MbrAetCom m
	      JOIN lst.List_Client c 
		  ON   c.ClientKey = @ClientKey
	      JOIN (	SELECT t.ClientMemberKey
						, t.EffectiveMonth
						, t.CurrentLoadingEffectiveMonth
						, t.adiKey
						, t.adiTableName
						, t.LoadDate
						, t.DataDate
	      			FROM adi.[tvf_MbrAetCom_GetCurrentMembers](@LoadDate) t
	      		) mf 
		  ON	m.mbrAetComMbr = mf.AdiKey   
		  JOIN	ast.mbrStg2_MbrData ast
		  ON	ast.Adikey = mf.AdiKey 	        
	      JOIN	(	SELECT pt.lstPhoneTypeKey
						 FROM lst.lstPhoneType pt
						WHERE pt.PhoneTypeCode = 'H'
				)pt
		  ON	1 = 1
	      JOIN	(	SELECT pt.lstAddressTypeKey
	      			 FROM lst.lstAddressType pt
	      			 WHERE pt.AddressTypeCode = 'H'
				) [at] 
		  ON 1 = 1	


	END

	/*Loading into staging for Members Address, Phone and Email*/
	 INSERT INTO  ast.MbrStg2_PhoneAddEmail
				([ClientMemberKey]
					, [SrcFileName]
					, [LoadDate]
					, [DataDate]
					, [AdiTableName]
					, [AdiKey]
					, [PhoneNumber]
					, [lstPhoneTypeKey]
					, [lstAddressTypeKey]
					, [AddAddress1]
					, [AddAddress2]
					, [AddCity]
					, [AddState]
					, [AddCounty]
					, [AddZip]
					, [stgRowStatus]
					, [ClientKey]
					, [PhoneCarrierType]
					, [PhoneIsPrimary] 
					, [lstEmailTypeKey]	
					, [EmailAddress]	
					, [EmailIsPrimary]
					, [CellPhone]
					, [HomePhone]
					)
	   SELECT	src.ClientMemberKey
					, src.SrcFileName 
					, src.LoadDate
					, src.DataDate
	   				, src.adiTableName
					, src.adiKey
					, src.PhoneNumber
	   				, src.lstPhoneTypeKey
					, src.lstAddressTypeKey
	   				, src.Member_Address_Line1
					, src.Member_Address_Line2
					, src.Member_City
					, src.Member_State
	   				, src.Member_County_code
					, src.Member_Zipcode  
					, src.stgRowStatus
					, src.ClientKey
					, src.[PhoneCarrierType]
					, src.[PhoneIsPrimary] 
					, src.[lstEmailTypeKey]	
					, src.[EmailAddress]	
					, src.[EmailIsPrimary]
					, ''			AS [CellPhone]
					, ''			AS [HomePhone]
		FROM	#mbrAet src
		
		

					SET					@ActionStart  = GETDATE();
					SET					@JobStatus =2  
					EXEC				amd.sp_AceEtlAudit_Close @Audit_Id = @AuditID
																, @ActionStopTime = @ActionStart
																, @SourceCount = @InpCnt
																, @DestinationCount = @OutCnt
																, @ErrorCount = @ErrCnt	
																, @JobStatus = @JobStatus


					DROP TABLE #mbrAet
					DROP TABLE #mbrAetnaCOM
END
			SET					@ActionStart  = GETDATE();
			SET					@JobStatus =2  
	    				
			EXEC				amd.sp_AceEtlAudit_Close 
								@Audit_Id = @AuditID
								, @ActionStopTime = @ActionStart
								, @SourceCount = @InpCnt		  
								, @DestinationCount = @OutCnt
								, @ErrorCount = @ErrCnt
								, @JobStatus = @JobStatus

COMMIT
END TRY
BEGIN CATCH
EXECUTE [adw].[usp_MPI_Error_handler]
END CATCH

END
