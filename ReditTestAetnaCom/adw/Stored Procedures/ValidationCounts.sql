CREATE PROCEDURE [adw].[ValidationCounts]
AS
/*
     SELECT 'Adi Counts' AS ValSet, 
     (
         SELECT COUNT(*)
         FROM adi.OKC_Claims
     ) AS cAdiHdr, 
     (
         SELECT COUNT(*)
         FROM adi.OKC_Services
     ) AS cAdiDtl, 
     (
         SELECT COUNT(*)
         FROM adi.OKC_Prescriptions
     ) AS cAdiRX, 
     (
         SELECT COUNT(s.OKC_ServicesKey)
         FROM adi.OKC_Services s
              JOIN adi.OKC_Claims c ON s.ICN = c.ICN
     ) AS cAdiDtlWithHdr, 
     (
         SELECT COUNT(p.OKC_PrescriptionsKey)
         FROM adi.OKC_Prescriptions p
              JOIN adi.OKC_Claims c ON p.ICN = c.ICN
     ) AS cAdiRxWithHdr, 
     (
         SELECT COUNT(*)
         FROM adi.OKC_ICD9_Diagnosis
     ) AS cAdiDiag, 
     (
         SELECT COUNT(p.OKC_DiagnosisKey)
         FROM adi.OKC_ICD9_Diagnosis p
              JOIN adi.OKC_Claims c ON p.ICN = c.ICN
     ) AS cAdiDiagWithHdr, 
     (
         SELECT COUNT(*)
         FROM adi.OKC_ICD9_Procedure
     ) AS cAdiProc, 
     (
         SELECT COUNT(p.OKC_Proc_Key)
         FROM adi.OKC_ICD9_Procedure p
              JOIN adi.OKC_Claims c ON p.ICN = c.ICN
     ) AS cAdiProcWithHdr, 
     (
         SELECT COUNT(*)
         FROM adi.OKC_ProviderInfo
     ) cAdiProv, 
     (
         SELECT COUNT(*)
         FROM adi.OKC_RecipientInfo
     ) cAdiRecip;
	*/
     -- Model counts
     SELECT 'Adw Counts' AS ValSet, 
     (
         SELECT COUNT(*) chdr
         FROM adw.Claims_Headers
     ) AS cHdr, 
     (
         SELECT COUNT(*) cDtl
         FROM adw.Claims_Details
     ) AS cDtl, 
     (
         SELECT COUNT(*) cDtl
         FROM adw.Claims_Details AS d
         WHERE NOT d.NDC_CODE IS NULL
     ) AS cDtlRx, 
     (
         SELECT COUNT(d.URN)
         FROM adw.Claims_Details d
              JOIN adw.Claims_Headers h ON d.SEQ_CLAIM_ID = h.SEQ_CLAIM_ID
     ) AS cDtlWithHdr, 
     (
         SELECT COUNT(d.URN)
         FROM adw.Claims_Details d
              JOIN adw.Claims_Headers h ON d.SEQ_CLAIM_ID = h.SEQ_CLAIM_ID
         WHERE NOT d.NDC_CODE IS NULL
     ) AS cDtlRxWithHdr, 
     (
         SELECT COUNT(*) cDia
         FROM adw.Claims_Diags
     ) AS cDia, 
     (
         SELECT COUNT(d.URN)
         FROM adw.Claims_Diags d
              JOIN adw.Claims_Headers h ON d.SEQ_CLAIM_ID = h.SEQ_CLAIM_ID
     ) AS cDiagWithHdr, 
     (
         SELECT COUNT(*) cPro
         FROM adw.Claims_Procs
     ) AS cPro, 
     (
         SELECT COUNT(d.URN)
         FROM adw.Claims_Procs d
              JOIN adw.Claims_Headers h ON d.SEQ_CLAIM_ID = h.SEQ_CLAIM_ID
     ) AS cProcWithHdr, 
     (
         SELECT COUNT(*) cCon
         FROM adw.Claims_Conditions
     ) AS cCon, 
     (
         SELECT COUNT(h.ATT_PROV_NPI)
         FROM adw.Claims_Headers h
     ) cHdrAttNpi, 
     (
         SELECT COUNT(h.VENDOR_ID)
         FROM adw.Claims_Headers h
     ) cHdrVndID, 
     (
         SELECT COUNT(h.SVC_PROV_NPI)
         FROM adw.Claims_Headers h
     ) cHdrSvcNpi, 
     (
         SELECT COUNT(*) cMem
         FROM adw.Claims_Member
     ) AS cMbr;
