


CREATE function [adi].[tvf_MbrAetCom_GetCurrentMembers](@LoadDate DATE )
    RETURNS TABLE
AS RETURN 
(
    --    DECLARE @LOaddate date = '08/29/2019';   
    SELECT src.ClientMemberKey, 
       src.EffectiveMonth, 
       src.CurrentLoadingEffectiveMonth, 
       src.adiKey, 
       src.adiTableName, 
       src.LoadDate
	   ,src.DataDate
    FROM(SELECT CONVERT(VARCHAR(50), CONVERT(NUMERIC(20, 0), c.MEMBER_ID)) AS ClientMemberKey, 
               c.EffectiveMonth, 
               DATEFROMPARTS(SUBSTRING(c.EffectiveMonth, 1, 4), SUBSTRING(c.EffectiveMonth, 5, 2), 1) CurrentLoadingEffectiveMonth, 
               c.mbrAetComMbr AS adiKey, 
               'adi.MbrAetCom' AS adiTableName, 
               c.LoadDate
			   ,c.DataDate
        FROM ACECAREDW.adi.MbrAetCom c
        --WHERE c.CreatedDate = @LoadDate
	   WHERE c.LoadDate = @LoadDate
		  and c.mbrLoadStatus = 0
	   ) src
    WHERE src.CurrentLoadingEffectiveMonth = DateFromParts(Year(@LoadDate), Month(@LoadDate), 1)    
)


