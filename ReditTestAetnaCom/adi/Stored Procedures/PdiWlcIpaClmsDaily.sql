CREATE PROCEDURE [adi].[PdiWlcIpaClmsDaily]
AS 
    DECLARE @AuditID Int = 0;
    DECLARE @PackName Varchar(100); 
    DECLARE @startTime Datetime = getdate();
    DECLARE @srcName VARCHAR(20) = 'ast.WlcIpaClmsDaily';
    DECLARE @destName VARCHAR(20) = 'adi.WlcIpaClmsDaily';
    DECLARE @errName VARCHAR(20) = 'None';
    DECLARE @srcCnt int ;
    DECLARE @destCnt int;
    DECLARE @errCnt INT = 0;
    DECLARe @finTime DATETIME;
   
    SELECT @srcCnt = s.astUrn
    FROM ast.WlcIpaClmsDaily s
    SELECT @PackName = OBJECT_NAME(@@PROCID);

    EXEC amd.sp_AceEtlOpenAuditHeader  @auditID output, @packName, @startTime, @srcName, @destname, @errName;

    DECLARE @Output TABLE (aNewClmKey INT NOT NULL PRIMARY KEY);

    MERGE adi.WlcIpaClmsDaily trg
    USING(SELECT s.LastName, s.FirstName, 
             CONVERT(DATE, s.DOB) AS dob, s.SubscriberID, s.ProviderID, s.ProviderLastName, s.ProviderFirstName, 
              s.ProviderAddress, s.CityStateZip, s.PcName, 
    		CONVERT(DATE, s.DetailSVCDate) AS DetailSVCDate, 
    		CONVERT(DATE, s.SVCDate) AS SvcDate, s.AuthNumber, 
              s.[Procedure], s.Description, s.Modifier, 
    		CONVERT(NUMERIC(5,2),s.Quantity) AS Quantity, 
              s.Diagnosis_1, s.Diagnosis_2, s.Diagnosis_3, s.Diagnosis_4, s.Diagnosis_5, s.Diagnosis_6, 
              CONVERT(Money, s.ProfNet) as ProfNet,
              CONVERT(Money, s.Billed) AS Billed,
              CONVERT(Money, s.Allowed) AS Allowed, 
              CONVERT(Money, s.Copay) AS Copay, 
              s.DRG, s.Claim, s.Line#, s.LCode, s.POS, 
              CONVERT(DATE, s.[Date]) AS [Date], s.ProfInst, 
              CONVERT(MONEY, s.Carrier) AS Carrier, s.Reason, s.AltPCode, s.IPA, 
              CONVERT(MONEY, s.TotalBilledAmt) AS TotalBilledAmt, 
              s.DetailHold, s.HeaderHold, s.LoadDate, s.DataDate, s.srcFileName
    	   FROM ast.WlcIpaClmsDaily s) src
    ON trg.subscriberID = src.subscriberID
        AND trg.providerID = src.ProviderID
        AND trg.SvcDate = src.SvcDate
        AND trg.[Procedure] = src.[Procedure]
        AND trg.Claim = src.Claim
        AND trg.Line# = src.Line#
        AND trg.DataDate = src.DataDate
    WHEN NOT MATCHED BY TARGET THEN  
        INSERT (LastName, FirstName, 
    	   DOB, SubscriberID, ProviderID, ProviderLastName, ProviderFirstName, 
    	   ProviderAddress, CityStateZip, PcName, 
    	   DetailSVCDate, 
    	   SVCDate, AuthNumber, 
    	   [Procedure], Description, Modifier, 
    	   Quantity, 
    	   Diagnosis_1, Diagnosis_2, Diagnosis_3, Diagnosis_4, Diagnosis_5, Diagnosis_6, 
    	   ProfNet, 
    	   Billed, 
    	   Allowed, 
    	   Copay, 
    	   DRG, Claim, Line#, LCode, POS, 
    	   [Date], ProfInst, 
    	   Carrier, Reason, AltPCode, IPA, 
    	   TotalBilledAmt, 
    	   DetailHold, HeaderHold, LoadDate, DataDate, srcFileName
           )
        VALUES(src.LastName, src.FirstName, 
    	   src.DOB, src.SubscriberID, src.ProviderID, src.ProviderLastName, src.ProviderFirstName, 
    	   src.ProviderAddress, src.CityStateZip, src.PcName, 
    	   src.DetailSVCDate, 
    	   src.SVCDate, src.AuthNumber, 
    	   src.[Procedure], src.Description, src.Modifier, 
    	   src.Quantity, 
    	   src.Diagnosis_1, src.Diagnosis_2, src.Diagnosis_3, src.Diagnosis_4, src.Diagnosis_5, src.Diagnosis_6, 
    	   src.ProfNet,
    	   src.Billed,
    	   src.Allowed, 
    	   src.Copay, 
    	   src.DRG, src.Claim, src.Line#, src.LCode, src.POS, 
    	   src.[Date], src.ProfInst, 
    	   src.Carrier, src.Reason, src.AltPCode, src.IPA, 
    	   src.TotalBilledAmt, 
    	   src.DetailHold, src.HeaderHold, src.LoadDate, src.DataDate, src.srcFileName)
        OUTPUT inserted.[adiKey] INTO @Output(aNewClmKey)
        ;
    
    SELECT @destCnt = COUNT(o.aNewClmKey) FROM @Output o;
    SET @finTime = getdate();
    EXEC amd.sp_AceEtlCloseAuditHeader @AuditID, @finTime, @srcCnt, @destCnt, @errCnt;

	


    
