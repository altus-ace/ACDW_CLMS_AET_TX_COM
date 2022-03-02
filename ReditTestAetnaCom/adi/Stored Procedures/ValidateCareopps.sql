


CREATE PROCEDURE [adi].[ValidateCareopps]

AS

BEGIN

	DECLARE @DataDate DATE = (SELECT MAX(DataDate)
							FROM [adi].[AetnaCommGIC_ActionList])
							SELECT @DataDate
	/*Get Max Dates and Record Counts*/
	SELECT	 COUNT(*)RecCnt,LoadDate
			 ,DataDate, RowStatus
	FROM	 [adi].[AetnaCommGIC_ActionList]
	WHERE	 RowStatus = 0
	GROUP BY LoadDate
			,DataDate, RowStatus
		ORDER BY LoadDate DESC
			,DataDate DESC
	
	
	SELECT DISTINCT Measure AS TotalMatchMeasureNames
			,Source,Destination
	FROM [adi].[AetnaCommGIC_ActionList] adi
	JOIN	(
				SELECT	Source		
						,Destination
						,IsActive,ACTIVE--,*
				FROM	lst.ListAceMapping
				WHERE	ClientKey = 9
				AND		MappingTypeKey = 14
				AND	ACTIVE = 'Y'
				)lst
	ON	adi.Measure = lst.Source
	WHERE	DataDate =  @DataDate
	AND		Destination LIKE '%AET_COM%'
	ORDER BY Destination DESC
	

	SELECT DISTINCT Measure AS TotalCountMeasureNames
			,Source,Destination
	FROM [adi].[AetnaCommGIC_ActionList] adi
	LEFT JOIN	(
				SELECT	Source		
						,Destination
						,IsActive,ACTIVE--,*
				FROM	lst.ListAceMapping
				WHERE	ClientKey = 9
				AND		MappingTypeKey = 14
				AND	ACTIVE = 'Y'
				)lst
	ON	adi.Measure = lst.Source
	WHERE	DataDate =  @DataDate
	ORDER BY Destination DESC
	
	SELECT DISTINCT measure--,actionrequired--,memberid,*
	FROM [ACDW_CLMS_AET_TX_COM].[adi].[AetnaCommGIC_ActionList]
	WHERE DataDate = @DataDate
	AND ActionRequired	IN ('Action needed now'
								 ,'Action needed next month'
								 ,'Action needed in 2 months'
								 ,'New Member-Check MR')

	SELECT DISTINCT measure--,actionrequired--,memberid,*
	FROM [ACDW_CLMS_AET_TX_COM].[adi].[AetnaCommGIC_ActionList]
	WHERE DataDate = @DataDate
	AND ActionRequired	NOT IN ('Action needed now'
								 ,'Action needed next month'
								 ,'Action needed in 2 months'
								 ,'New Member-Check MR')

	SELECT Measure,Source,Destination 
	FROM (
			SELECT DISTINCT measure--,actionrequired--,memberid,*
			FROM [ACDW_CLMS_AET_TX_COM].[adi].[AetnaCommGIC_ActionList]
			WHERE DataDate = @DataDate
			AND ActionRequired	 IN ('Action needed now'
										 ,'Action needed next month'
										 ,'Action needed in 2 months'
										 ,'New Member-Check MR')
		 )src
	 LEFT JOIN  lst.ListAceMapping a
	 ON Measure = Source
	 WHERE ClientKey = 9
	 AND  ACTIVE = 'Y'	

	SELECT Measure,Source,Destination 
	FROM (
			SELECT DISTINCT measure--,actionrequired--,memberid,*
			FROM [ACDW_CLMS_AET_TX_COM].[adi].[AetnaCommGIC_ActionList]
			WHERE DataDate = @DataDate
			AND ActionRequired	NOT IN ('Action needed now'
										 ,'Action needed next month'
										 ,'Action needed in 2 months'
										 ,'New Member-Check MR')
		 )src
	 LEFT JOIN  lst.ListAceMapping a
	 ON Measure = Source
	 WHERE ClientKey = 9
	 AND  ACTIVE = 'Y'

	END
	
		/*
	
	---Staging
		
		
	SELECT COUNT(*)RecCnt
			,astRowStatus
			,QmMsrId,QmCntCat
			,MbrCareOpToPlnFlg
			,MbrCOPInContractFlg
			,MbrActiveFlg ----   SELECT DISTINCT QmMsrId
	FROM	ast.QM_ResultByMember_History
	WHERE	QMDate = '2022-01-15'
	AND		astRowStatus = 'Valid'
	GROUP BY astRowStatus
			,QmMsrId,QmCntCat
			,MbrCareOpToPlnFlg
			,MbrCOPInContractFlg
			,MbrActiveFlg
	ORDER BY QmMsrId,QmCntCat
		
	--ADW

	SELECT          COUNT(*)
                       ,[QmMsrId]
                       ,[QmCntCat] -- SELECT DISTINCT QmMsrId
       FROM            [adw].[QM_ResultByMember_History]
       WHERE           QMDate = '2022-01-15'
       AND             ClientKey = 9
       GROUP BY        [QmMsrId]
                       ,[QmCntCat]
       ORDER BY        [QmMsrId],[QmCntCat]

	SELECT	*
	FROM	adw.QM_ResultByValueCodeDetails_History
	WHERE	QMDate = '2022-01-15'

	SELECT	COUNT(*)
			,MbrActiveFlg
			,MbrCareOpToPlnFlg
			,MbrCOPInContractFlg
	FROM	adw.FailedCareOpps
	WHERE   QMDate = '2022-01-15'
	GROUP BY MbrActiveFlg
			,MbrCareOpToPlnFlg
			,MbrCOPInContractFlg
	*/
	--  SELECT * FROM adw.FailedCareOpps where QMDate = '2021-12-15'