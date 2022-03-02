
CREATE PROCEDURE [adw].[Load_PDW_RemoveModelNDX]
AS 
    -- headers
    select 'add index management code'
    /*
    DROP INDEX [Ndx_ClmsHdr_DrgCode] ON [adw].[Claims_Headers]
    DROP INDEX Ndx_ClmsHdr_PrimrySvcDt ON adw.Claims_Headers
    DROP INDEX Ndx_SeqClmId ON adw.Claims_Headers
    DROP INDEX [NDX_ClmsHdr_SubID_PrimSvcDt] ON [adw].[Claims_Headers]
    DROP INDEX [Ndx_ClmsHdr_SubscriberID] ON [adw].[Claims_Headers]
    DROP INDEX [Ndx_ClmsHeader_ProvSpec] ON [adw].[Claims_Headers]
    /* disable update trigger */
    ALTER table [adw].[Claims_Headers] DISABLE TRIGGER [ClaimsHeaders_AfterUpdate] 

    -- diags
    DROP INDEX [Ndx_ClmDgs_ClmID] ON adw.claims_diags;
    DROP INDEX [Ndx_ClmDiag_UniqIDSubIDDiagNumDiagCdDiagPOA] ON adw.claims_diags;
    DROP INDEX [Ndx_ClmsDiags_DiagCode] ON adw.claims_diags;
    DROP INDEX [NdxCD_DiagNum] ON adw.claims_diags;
    DROP INDEX [NdxClmDgs_Seq_Claim_ID] ON adw.claims_diags;

    ALTER TABLE adw.Claims_Diags disable TRIGGER [ClaimsDiags_AfterUpdate];
    ALTER TABLE adw.Claims_Headers disable TRIGGER [ClaimsHeaders_AfterUpdate];
    */
