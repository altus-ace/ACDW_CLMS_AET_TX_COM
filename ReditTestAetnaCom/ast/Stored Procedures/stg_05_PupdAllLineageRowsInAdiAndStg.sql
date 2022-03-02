





CREATE PROCEDURE [ast].[stg_05_PupdAllLineageRowsInAdiAndStg](@DataDate DATE) --  [ast].[stg_05_PupdAllLineageRowsInAdiAndStg]'2021-10-18'

AS



BEGIN
BEGIN TRAN
BEGIN TRY

			
BEGIN
DECLARE @Clientkey INT = 9
	 /* Update adi MbrLoadStatus: 1 = loaded to stg, 2 means never load to status, rule failure */
    MERGE ACECAREDW.adi.MbrAetCom TRG
    USING (	SELECT adiData.mbrAetComMbr 
	   				, DATEFROMPARTS(SUBSTRING(adiData.EffectiveMonth, 1, 4), SUBSTRING(adiData.EffectiveMonth, 5, 2), 1) RowEffMonthStart
	   				, DATEADD(day, -1, (DATEADD(month, 1, (DATEFROMPARTS(SUBSTRING(adiData.EffectiveMonth, 1, 4), SUBSTRING(adiData.EffectiveMonth, 5, 2), 1))))) RowEffMonthEnd 	       	          
	   				, CASE WHEN (astData.mbrStg2_MbrDataUrn is null) THEN 2 ELSE 1 END AS NewMbrLS
	        FROM ACECAREDW.adi.MbrAetCom adiData
	   	    LEFT JOIN (	SELECT * 
						FROM ast.MbrStg2_MbrData astData	    
	   					WHERE astData.DataDate = @DataDate
	   				    AND astData.ClientKey = @Clientkey
					 ) astData
	   		ON	adiData.mbrAetComMbr = astData.AdiKey
	   		  --and astData.AdiTableName = 'adi.MbrAetMaTx'
			WHERE adiData.MbrLoadStatus = 0
		  )src 
	ON	 Trg.mbrAetComMbr = src.mbrAetComMbr
	WHEN MATCHED THEN 
	   UPDATE SET trg.MbrLoadStatus = src.NewMbrLS
	   ;



END




COMMIT
END TRY
BEGIN CATCH
EXECUTE [adw].[usp_MPI_Error_handler]
END CATCH


END

