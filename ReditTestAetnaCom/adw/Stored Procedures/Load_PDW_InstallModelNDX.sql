
CREATE PROCEDURE [adw].[Load_PDW_InstallModelNDX]
AS 

    -- claims_Headers
    CREATE NONCLUSTERED INDEX [Ndx_ClmsHdr_SubscriberID]
    ON adw.[Claims_Headers]([SUBSCRIBER_ID] ASC);

    
    CREATE NONCLUSTERED INDEX [NDX_ClmsHdr_SubID_PrimSvcDt]
        ON adw.[Claims_Headers]([SUBSCRIBER_ID] ASC, [PRIMARY_SVC_DATE] ASC)
        INCLUDE([SEQ_CLAIM_ID], [ADMISSION_DATE]);
        
    CREATE NONCLUSTERED INDEX [Ndx_CLmsHdr_PrmrySvcDt]
        ON adw.[Claims_Headers]([PRIMARY_SVC_DATE] ASC)
        INCLUDE([SEQ_CLAIM_ID], [SUBSCRIBER_ID]);
        
    CREATE NONCLUSTERED INDEX [Ndx_ClmsHdr_DrgCode]
        ON adw.[Claims_Headers]([DRG_CODE] ASC)
        INCLUDE([SEQ_CLAIM_ID], [SUBSCRIBER_ID]);
        
    CREATE NONCLUSTERED INDEX [Ndx_ClmsHeader_ProvSpec]
        ON adw.[Claims_Headers]([PROV_SPEC] ASC)
        INCLUDE([SEQ_CLAIM_ID], [SUBSCRIBER_ID], [CATEGORY_OF_SVC], [PRIMARY_SVC_DATE], [SVC_TO_DATE], [CLAIM_THRU_DATE], [ADMISSION_DATE]);
        
    CREATE NONCLUSTERED INDEX [Ndx_ClmsHdr_SeqClmId]
        ON adw.[Claims_Headers]([SEQ_CLAIM_ID] ASC)
        INCLUDE([SUBSCRIBER_ID], [PRIMARY_SVC_DATE], [CLAIM_THRU_DATE], [PROV_SPEC], [ADMISSION_DATE], [CATEGORY_OF_SVC], [SVC_TO_DATE]);
    
    ALTER table [adw].[Claims_Headers] ENABLE TRIGGER [ClaimsHeaders_AfterUpdate] 

    -- claims_diags
    CREATE NONCLUSTERED INDEX [Ndx_ClmDiag_UniqIDSubIDDiagNumDiagCdDiagPOA]
    ON adw.[Claims_Diags]([ICD_FLAG] ASC)
    INCLUDE([SEQ_CLAIM_ID], [SUBSCRIBER_ID], [diagNumber], [diagCode], [diagPoa]);
    
    CREATE NONCLUSTERED INDEX [NdxClmDgs_Seq_Claim_ID]
        ON adw.[Claims_Diags]([SEQ_CLAIM_ID] ASC);
    
    CREATE NONCLUSTERED INDEX [NdxCD_DiagNum]
        ON adw.[Claims_Diags]([diagNumber] ASC);
    
    CREATE NONCLUSTERED INDEX [Ndx_ClmDgs_ClmID]
        ON adw.[Claims_Diags]([SEQ_CLAIM_ID] ASC)
        INCLUDE([SUBSCRIBER_ID], [diagCode]);
    
    CREATE NONCLUSTERED INDEX [Ndx_ClmsDiags_DiagCode]
        ON adw.[Claims_Diags]([diagCode] ASC)
        INCLUDE([SEQ_CLAIM_ID], [SUBSCRIBER_ID]);
    
    ALTER TABLE adw.Claims_Diags ENABLE TRIGGER [ClaimsDiags_AfterUpdate];
    ALTER TABLE adw.Claims_Headers ENABLE TRIGGER [ClaimsHeaders_AfterUpdate];
