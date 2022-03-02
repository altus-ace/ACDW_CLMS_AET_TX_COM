-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- change log
-- add Datedate and use the last date from file name  
-- =============================================
CREATE PROCEDURE [adi].[ImportClmsAetComTx](
    @OriginalFileName varchar(100) ,
	@SrcFileName varchar(100) ,
	--@LoadDate date NOT ,
	--CreatedDate date NOT ,
	@CreatedBy varchar(50),
	--LastUpdatedDate datetime NOT ,
	@LastUpdatedBy varchar(50),
	@ps_unique_id varchar(16) ,
	@customer_nbr varchar(8) ,
	@group_nbr varchar(8) ,
	@idn_indicator char(3),
	@subgroup_nbr varchar(8) ,
	@account_nbr char(5) ,
	@file_id char(2) ,
	@clm_ln_type_cd char(1),
	@non_prfrrd_srv_cd_1 char(1) ,
	@plsp_prod_cd char(2) ,
	@product_ln_cd char(2),
	@classification_cd char(1) ,
	@bnft_pkg_id char(5) ,
	@plan_id char(5) ,
	@non_prfrrd_srv_cd_2 char(1) ,
	@fund_ctg_cd char(1) ,
	@src_subscriber_id varchar(11) ,
	@emp_last_nm varchar(30) ,
	@emp_first_nm varchar(30) ,
	@emp_gender char(1) ,
	@subscriber_brth_dt varchar(10) ,
	@subs_zip_cd varchar(5) ,
	@subs_st_postal_cd char(2) ,
	@coverage_type_cd char(1) ,
	@ssn_nbr varchar(11) ,
	@member_id varchar(20) ,
	@src_clm_mbr_id char(2) ,
	@mem_last_nm varchar(30) ,
	@mem_first_nm varchar(30) ,
	@mem_gender char(1) ,
	@mbr_rtp_type_cd char(1) ,
	@birth_dt varchar(10) ,
	@src_clm_id varchar(19) ,
	@src_claim_line_id_1 char(2) ,
	@prev_clm_seg_id char(2) ,
	@derived_tcn_nbr varchar(15) ,
	@src_claim_line_id_2 char(3) ,
	@claim_line_id varchar(20),
	@ntwk_srv_area_id char(5) ,
	@paid_prvdr_nsa_id char(5) ,
	@srv_capacity_cd char(1) ,
	@tax_id_format_cd_1 char(1) ,
	@tax_id_nbr_1 varchar(9) ,
	@print_nm_1 varchar(40) ,
	@tax_id_format_cd_2 char(1) ,
	@tax_id_nbr_2 varchar(9) ,
	@srv_prvdr_id varchar(20),
	@print_nm_2 varchar(40) ,
	@address_line_1_txt varchar(35) ,
	@address_line_2_txt varchar(35) ,
	@city_nm varchar(30) ,
	@state_postal_cd char(2) ,
	@zip_cd char(5) ,
	@provider_type_cd varchar(3) ,
	@specialty_cd char(5) ,
	@payee_cd char(1) ,
	@paid_prvdr_par_cd char(1) ,
	@received_dt varchar(10),
	@adjn_dt varchar(10) ,
	@srv_start_dt varchar(10) ,
	@srv_stop_dt varchar(10) ,
	@paid_dt_OR_adjn_dt varchar(10) ,
	@FILLER_1 varchar(6) ,
	@FILLER_2 varchar(6) ,
	@FILLER_3 varchar(6) ,
	@mdc_cd char(2) ,
	@drg_cd char(3) ,
	@prcdr_cd char(5) ,
	@prcdr_modifier_cd_1 char(2) ,
	@prcdr_type_cd char(1) ,
	@ICD10_Indicator char(5) ,
	@MED_COST_SUBCTG_CD char(5) ,
	@prcdr_group_nbr char(5) ,
	@type_srv_cd char(2) ,
	@srv_benefit_cd char(3) ,
	@tooth_1_nbr char(5) ,
	@plc_srv_cd char(2) ,
	@dschrg_status_cd char(2) ,
	@revenue_cd char(4) ,
	@hcfa_bill_type_cd char(3) ,
	@unit_cnt varchar(20) ,
	@src_unit_cnt varchar(20) ,
	@src_billed_amt varchar(20) ,
	@billed_amt varchar(20),
	@not_covered_amt_1 varchar(20) ,
	@not_covered_amt_2 varchar(20) ,
	@not_covered_amt_3 varchar(20) ,
	@clm_ln_msg_cd_1 char(4) ,
	@clm_ln_msg_cd_2 char(4) ,
	@clm_ln_msg_cd_3 char(4) ,
	@covered_amt varchar(20) ,
	@allowed_amt varchar(20) ,
	@ReservedForFutureUse varchar(10) ,
	@srv_copay_amt varchar(20) ,
	@src_srv_copay_amt varchar(20) ,
	@deductible_amt varchar(20),
	@coinsurance_amt varchar(20) ,
	@src_coins_amt varchar(20) ,
	@bnft_payable_amt varchar(20) ,
	@paid_amt varchar(20),
	@cob_paid_amt varchar(20) ,
	@ahf_bfd_amt varchar(20) ,
	@ahf_paid_amt varchar(20) ,
	@negot_savings_amt varchar(20) ,
	@r_c_savings_amt varchar(20) ,
	@cob_savings_amt varchar(20) ,
	@src_cob_svngs_amt varchar(20) ,
	@pri_payer_cvg_cd char(1) ,
	@cob_type_cd char(1) ,
	@cob_cd char(1) ,
	@prcdr_cd_ndc varchar(11) ,
	@src_clm_mbr_id_2 varchar(22) ,
	@clm_ln_status_cd char(1) ,
	@src_member_id varchar(22) ,
	@reversal_cd char(2) ,
	@admit_cnt char(2) ,
	@admin_savings_amt varchar(20) ,
	@adj_prvdr_dsgnn_cd char(3) ,
	@aex_plan_dsgntn_cd char(1) ,
	@benefit_tier_cd char(2) ,
	@aex_prvdr_spctg_cd char(4) ,
	@prod_distnctn_cd char(1) ,
	@billed_eligible_amt varchar(20),
	@SPCLTY_CTG_CLS_CD char(3) ,
	@poa_cd_1 char(1) ,
	@poa_cd_2 char(1) ,
	@poa_cd_3 char(1) ,
	@FILLER_4 char(6) ,
	@FILLER_5 varchar(6) ,
	@FILLER_6 varchar(6) ,
	@pricing_mthd_cd char(1) ,
	@type_class_cd char(1) ,
	@specialty_ctg_cd char(4) ,
	@srv_prvdr_npi varchar(20) ,
	@ttl_ded_met_ind char(1) ,
	@ttl_interest_amt varchar(20),
	@ttl_surcharge_amt varchar(20) ,
	@SRV_SPCLTY_CTG_CD char(4) ,
	@HCFA_PLC_SRV_CD char(2) ,
	@HCFA_ADMIT_SRC_CD char(1) ,
	@HCFA_ADMIT_TYPE_CD_1 char(1) ,
	@SRC_ADMIT_DT varchar(10) ,
	@SRC_DISCHARGE_DT varchar(10) ,
	@prcdr_modifier_cd_2 char(2) ,
	@prcdr_modifier_cd_3 char(2) ,
	@poa_cd_4 char(1) ,
	@poa_cd_5 char(1) ,
	@poa_cd_6 char(1) ,
	@poa_cd_7 char(1) ,
	@poa_cd_8 char(1) ,
	@poa_cd_9 char(1) ,
	@poa_cd_10 char(1) ,
	@pri_icd9_dx_cd varchar(8) ,
	@icd9_dx_cd_2 varchar(8) ,
	@icd9_dx_cd_3 varchar(8) ,
	@icd9_dx_cd_4 varchar(8) ,
	@icd9_dx_cd_5 varchar(8) ,
	@icd9_dx_cd_6 varchar(8) ,
	@icd9_dx_cd_7 varchar(8) ,
	@icd9_dx_cd_8 varchar(8) ,
	@icd9_dx_cd_9 varchar(8) ,
	@icd9_dx_cd_10 varchar(8) ,
	@icd9_prcdr_cd1 varchar(7) ,
	@icd9_prcdr_cd2 varchar(7) ,
	@icd9_prcdr_cd3 varchar(7) ,
	@icd9_prcdr_cd4 varchar(7) ,
	@icd9_prcdr_cd5 varchar(7) ,
	@icd9_prcdr_cd6 varchar(7) ,
	@ahf_det_order_cd char(3) ,
	@ahf_mbr_coins_amt varchar(20),
	@ahf_mbr_copay_amt varchar(20) ,
	@ahf_mbr_ded_amt varchar(20) ,
	@SensitivityIndicator char(1) ,
	@hcfa_admit_type_cd_2 char(1) ,
	@FILLER_7 varchar(20) ,
	@ORG_CD varchar(10) ,
	@valueX char(1) 
   
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- ADD ACE ETL AUDIT
	--DECLARE @AuditID AS INT, @ActionStartDateTime AS datetime2, @ActionStopDateTime as datetime2
	
--	SET @ActionStartDateTime = GETDATE(); 
	
	--'2017-12-16 11:15:23.2393473'
    
	--EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 1, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, 'ACECARDW.adi.copUhcPcor', '';
--	--EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR',  @ActionStartDateTime , 'Test', 'ACECARDW.adi.copUhcPcor', '' ;



 --IF (@Physician <>'' AND @FirstName <> '' AND @LastName <> ''  AND @MemberID <> '') 
 BEGIN
 INSERT INTO adi.ClmsAetComTx
   (
    OriginalFileName,
	SrcFileName,
	LoadDate ,
	Datadate,
	CreatedDate,
	CreatedBy,
	LastUpdatedDate,
	LastUpdatedBy ,
	ps_unique_id ,
	customer_nbr ,
	group_nbr ,
	idn_indicator ,
	subgroup_nbr ,
	account_nbr ,
	[file_id] ,
	clm_ln_type_cd ,
	non_prfrrd_srv_cd_1 ,
	plsp_prod_cd ,
	product_ln_cd ,
	classification_cd ,
	bnft_pkg_id ,
	plan_id ,
	non_prfrrd_srv_cd_2,
	fund_ctg_cd ,
	src_subscriber_id ,
	emp_last_nm ,
	emp_first_nm ,
	emp_gender,
	subscriber_brth_dt ,
	subs_zip_cd ,
	subs_st_postal_cd ,
	coverage_type_cd,
	ssn_nbr,
	member_id ,
	src_clm_mbr_id ,
	mem_last_nm ,
	mem_first_nm ,
	mem_gender ,
	mbr_rtp_type_cd ,
	birth_dt ,
	src_clm_id ,
	src_claim_line_id_1 ,
	prev_clm_seg_id ,
	derived_tcn_nbr ,
	src_claim_line_id_2,
	claim_line_id ,
	ntwk_srv_area_id ,
	paid_prvdr_nsa_id ,
	srv_capacity_cd ,
	tax_id_format_cd_1 ,
	tax_id_nbr_1,
	print_nm_1 ,
	tax_id_format_cd_2,
	tax_id_nbr_2 ,
	srv_prvdr_id ,
	print_nm_2 ,
	address_line_1_txt ,
	address_line_2_txt ,
	city_nm ,
	state_postal_cd,
	zip_cd ,
	provider_type_cd ,
	specialty_cd ,
	payee_cd ,
	paid_prvdr_par_cd ,
	received_dt ,
	adjn_dt  ,
	srv_start_dt  ,
	srv_stop_dt  ,
	paid_dt_OR_adjn_dt  ,
	FILLER_1 ,
	FILLER_2 ,
	FILLER_3 ,
	mdc_cd ,
	drg_cd ,
	prcdr_cd ,
	prcdr_modifier_cd_1 ,
	prcdr_type_cd ,
	ICD10_Indicator ,
	MED_COST_SUBCTG_CD ,
	prcdr_group_nbr ,
	type_srv_cd ,
	srv_benefit_cd,
	tooth_1_nbr ,
	plc_srv_cd ,
	dschrg_status_cd ,
	revenue_cd ,
	hcfa_bill_type_cd ,
	unit_cnt ,
	src_unit_cnt ,
	src_billed_amt ,
	billed_amt ,
	not_covered_amt_1 ,
	not_covered_amt_2 ,
	not_covered_amt_3 ,
	clm_ln_msg_cd_1 ,
	clm_ln_msg_cd_2 ,
	clm_ln_msg_cd_3 ,
	covered_amt ,
	allowed_amt ,
	ReservedForFutureUse ,
	srv_copay_amt ,
	src_srv_copay_amt ,
	deductible_amt ,
	coinsurance_amt ,
	src_coins_amt ,
	bnft_payable_amt ,
	paid_amt ,
	cob_paid_amt ,
	ahf_bfd_amt ,
	ahf_paid_amt ,
	negot_savings_amt ,
	r_c_savings_amt ,
	cob_savings_amt ,
	src_cob_svngs_amt ,
	pri_payer_cvg_cd ,
	cob_type_cd ,
	cob_cd ,
	prcdr_cd_ndc,
	src_clm_mbr_id_2 ,
	clm_ln_status_cd ,
	src_member_id ,
	reversal_cd ,
	admit_cnt ,
	admin_savings_amt ,
	adj_prvdr_dsgnn_cd ,
	aex_plan_dsgntn_cd ,
	benefit_tier_cd,
	aex_prvdr_spctg_cd ,
	prod_distnctn_cd ,
	billed_eligible_amt,
	SPCLTY_CTG_CLS_CD ,
	poa_cd_1 ,
	poa_cd_2 ,
	poa_cd_3 ,
	FILLER_4 ,
	FILLER_5 ,
	FILLER_6 ,
	pricing_mthd_cd ,
	type_class_cd ,
	specialty_ctg_cd ,
	srv_prvdr_npi,
	ttl_ded_met_ind ,
	ttl_interest_amt ,
	ttl_surcharge_amt ,
	SRV_SPCLTY_CTG_CD ,
	HCFA_PLC_SRV_CD ,
	HCFA_ADMIT_SRC_CD ,
	HCFA_ADMIT_TYPE_CD_1 ,
	SRC_ADMIT_DT ,
	SRC_DISCHARGE_DT ,
	prcdr_modifier_cd_2 ,
	prcdr_modifier_cd_3 ,
	poa_cd_4 ,
	poa_cd_5 ,
	poa_cd_6 ,
	poa_cd_7 ,
	poa_cd_8 ,
	poa_cd_9 ,
	poa_cd_10 ,
	pri_icd9_dx_cd ,
	icd9_dx_cd_2 ,
	icd9_dx_cd_3 ,
	icd9_dx_cd_4 ,
	icd9_dx_cd_5 ,
	icd9_dx_cd_6 ,
	icd9_dx_cd_7 ,
	icd9_dx_cd_8 ,
	icd9_dx_cd_9 ,
	icd9_dx_cd_10 ,
	icd9_prcdr_cd1 ,
	icd9_prcdr_cd2 ,
	icd9_prcdr_cd3 ,
	icd9_prcdr_cd4 ,
	icd9_prcdr_cd5 ,
	icd9_prcdr_cd6 ,
	ahf_det_order_cd ,
	ahf_mbr_coins_amt ,
	ahf_mbr_copay_amt ,
	ahf_mbr_ded_amt ,
	SensitivityIndicator ,
	hcfa_admit_type_cd_2 ,
	FILLER_7 ,
	ORG_CD ,
	valueX 
   
            )
     VALUES
   (
    @OriginalFileName  ,
	@SrcFileName ,
	--@LoadDate date NOT 
	DATEADD(mm, DATEDIFF(mm,0, GETDATE()), 0),
	GETDATE(),
	--CONVERT(DATE, LEFT(RIGHT(RTRIM(@OriginalFileName), 12), 8)),
	--CreatedDate date NOT ,
	GETDATE(),
	@CreatedBy ,
	GETDATE(),
	--LastUpdatedDate datetime NOT ,
	@LastUpdatedBy ,
	@ps_unique_id  ,
	@customer_nbr  ,
	@group_nbr  ,
	@idn_indicator ,
	@subgroup_nbr  ,
	@account_nbr  ,
	@file_id ,
	@clm_ln_type_cd ,
	@non_prfrrd_srv_cd_1  ,
	@plsp_prod_cd  ,
	@product_ln_cd ,
	@classification_cd  ,
	@bnft_pkg_id  ,
	@plan_id  ,
	@non_prfrrd_srv_cd_2  ,
	@fund_ctg_cd  ,
	@src_subscriber_id  ,
	@emp_last_nm  ,
	@emp_first_nm  ,
	@emp_gender  ,
	CASE WHEN (	@subscriber_brth_dt = '')
	THEN NULL 
	ELSE CONVERT(date, 	@subscriber_brth_dt)
	END  ,

	@subs_zip_cd  ,
	@subs_st_postal_cd  ,
	@coverage_type_cd  ,
	@ssn_nbr  ,
	@member_id  ,
	@src_clm_mbr_id  ,
	@mem_last_nm  ,
	@mem_first_nm  ,
	@mem_gender  ,
	@mbr_rtp_type_cd  ,
	CASE WHEN (@birth_dt = '')
	THEN NULL 
	ELSE CONVERT(date, @birth_dt)
	END  ,
	@src_clm_id  ,
	@src_claim_line_id_1  ,
	@prev_clm_seg_id  ,
	@derived_tcn_nbr  ,
	@src_claim_line_id_2  ,
	@claim_line_id  ,
	@ntwk_srv_area_id ,
	@paid_prvdr_nsa_id  ,
	@srv_capacity_cd  ,
	@tax_id_format_cd_1  ,
	@tax_id_nbr_1  ,
	@print_nm_1  ,
	@tax_id_format_cd_2 ,
	@tax_id_nbr_2  ,
	@srv_prvdr_id ,
	@print_nm_2  ,
	@address_line_1_txt ,
	@address_line_2_txt  ,
	@city_nm  ,
	@state_postal_cd ,
	@zip_cd  ,
	@provider_type_cd  ,
	@specialty_cd  ,
	@payee_cd  ,
	@paid_prvdr_par_cd  ,
	CASE WHEN (@received_dt = '')
	THEN NULL 
	ELSE CONVERT(date, @received_dt)
	END ,
    CASE WHEN (@adjn_dt  = '')
	THEN NULL 
	ELSE CONVERT(date, @adjn_dt )
	END ,
	 CASE WHEN (@srv_start_dt  = '')
	THEN NULL 
	ELSE CONVERT(date, @srv_start_dt)
	END ,
    CASE WHEN (@srv_stop_dt   = '')
	THEN NULL 
	ELSE CONVERT(date,	@srv_stop_dt )
	END ,
	CASE WHEN (@paid_dt_OR_adjn_dt  = '')
	THEN NULL 
	ELSE CONVERT(date, @paid_dt_OR_adjn_dt)
	END ,
	@FILLER_1  ,
	@FILLER_2  ,
	@FILLER_3  ,
	@mdc_cd  ,
	@drg_cd  ,
	@prcdr_cd  ,
	@prcdr_modifier_cd_1  ,
	@prcdr_type_cd  ,
	@ICD10_Indicator  ,
	@MED_COST_SUBCTG_CD  ,
	@prcdr_group_nbr  ,
	@type_srv_cd  ,
	@srv_benefit_cd  ,
	@tooth_1_nbr  ,
	@plc_srv_cd  ,
	@dschrg_status_cd  ,
	@revenue_cd  ,
	@hcfa_bill_type_cd  ,
	CASE WHEN (@unit_cnt  = '')
	THEN NULL
	ELSE CONVERT(decimal, @unit_cnt)
	END ,
    CASE WHEN (@src_unit_cnt  = '')
	THEN NULL
	ELSE CONVERT(decimal, @src_unit_cnt)
	END ,

	CASE WHEN (@src_billed_amt  = '')
	THEN NULL
	ELSE CONVERT(decimal, @src_billed_amt)
	END ,

	CASE WHEN (@billed_amt  = '')
	THEN NULL
	ELSE CONVERT(decimal, @billed_amt)
	END ,
	CASE WHEN (@not_covered_amt_1   = '')
	THEN NULL
	ELSE CONVERT(decimal, @not_covered_amt_1)
	END ,
	CASE WHEN (@not_covered_amt_2   = '')
	THEN NULL
	ELSE CONVERT(decimal, @not_covered_amt_2)
	END ,
	CASE WHEN (@not_covered_amt_3   = '')
	THEN NULL
	ELSE CONVERT(decimal, @not_covered_amt_3)
	END ,

	@clm_ln_msg_cd_1  ,
	@clm_ln_msg_cd_2  ,
	@clm_ln_msg_cd_3  ,
		CASE WHEN (@covered_amt   = '')
	THEN NULL
	ELSE CONVERT(decimal, @covered_amt)
	END ,
	CASE WHEN (@allowed_amt   = '')
	THEN NULL
	ELSE CONVERT(decimal, @allowed_amt)
	END ,

	
	@ReservedForFutureUse  ,
	CASE WHEN (@srv_copay_amt   = '')
	THEN NULL
	ELSE CONVERT(decimal, @srv_copay_amt)
	END ,
			CASE WHEN (@src_srv_copay_amt   = '')
	THEN NULL
	ELSE CONVERT(decimal, @src_srv_copay_amt)
	END ,
	CASE WHEN (@deductible_amt   = '')
	THEN NULL
	ELSE CONVERT(decimal, @deductible_amt)
	END ,
	
	CASE WHEN (@coinsurance_amt   = '')
	THEN NULL
	ELSE CONVERT(decimal, @coinsurance_amt)
	END ,
    CASE WHEN (@src_coins_amt   = '')
	THEN NULL
	ELSE CONVERT(decimal, @src_coins_amt)
	END ,
	    CASE WHEN (@bnft_payable_amt  = '')
	THEN NULL
	ELSE CONVERT(decimal, @bnft_payable_amt )
	END ,
	CASE WHEN (@paid_amt  = '')
	THEN NULL
	ELSE CONVERT(decimal, @paid_amt)
	END,
	CASE WHEN (@cob_paid_amt  = '')
	THEN NULL
	ELSE CONVERT(decimal, @cob_paid_amt)
	END,
	CASE WHEN (@ahf_bfd_amt  = '')
	THEN NULL
	ELSE CONVERT(decimal, @ahf_bfd_amt)
	END,
	CASE WHEN (@ahf_paid_amt  = '')
	THEN NULL
	ELSE CONVERT(decimal, @ahf_paid_amt)
	END,
		CASE WHEN (@negot_savings_amt  = '')
	THEN NULL
	ELSE CONVERT(decimal, @negot_savings_amt)
	END,
    CASE WHEN (@r_c_savings_amt  = '')
	THEN NULL
	ELSE CONVERT(decimal, @r_c_savings_amt )
	END,
	  CASE WHEN (@cob_savings_amt   = '')
	THEN NULL
	ELSE CONVERT(decimal, @cob_savings_amt )
	END,
	CASE WHEN (@src_cob_svngs_amt    = '')
	THEN NULL
	ELSE CONVERT(decimal, @src_cob_svngs_amt )
	END,

	@pri_payer_cvg_cd  ,
	@cob_type_cd  ,
	@cob_cd  ,
	@prcdr_cd_ndc  ,
	@src_clm_mbr_id_2  ,
	@clm_ln_status_cd  ,
	@src_member_id  ,
	@reversal_cd  ,
	@admit_cnt  ,
	CASE WHEN (@admin_savings_amt  = '')
	THEN NULL
	ELSE CONVERT(decimal, @admin_savings_amt)
	END,
	@adj_prvdr_dsgnn_cd  ,
	@aex_plan_dsgntn_cd  ,
	@benefit_tier_cd  ,
	@aex_prvdr_spctg_cd  ,
	@prod_distnctn_cd  ,
	CASE WHEN (@billed_eligible_amt   = '')
	THEN NULL
	ELSE CONVERT(decimal, @billed_eligible_amt)
	END,
	@SPCLTY_CTG_CLS_CD ,
	@poa_cd_1  ,
	@poa_cd_2 ,
	@poa_cd_3 ,
	@FILLER_4  ,
	@FILLER_5  ,
	@FILLER_6  ,
	@pricing_mthd_cd  ,
	@type_class_cd  ,
	@specialty_ctg_cd  ,
	@srv_prvdr_npi  ,
	@ttl_ded_met_ind  ,
	CASE WHEN (@ttl_interest_amt  = '')
	THEN NULL
	ELSE CONVERT(decimal, @ttl_interest_amt)
	END,
	CASE WHEN (@ttl_surcharge_amt   = '')
	THEN NULL
	ELSE CONVERT(decimal, @ttl_surcharge_amt)
	END,

	@SRV_SPCLTY_CTG_CD  ,
	@HCFA_PLC_SRV_CD  ,
	@HCFA_ADMIT_SRC_CD  ,
	@HCFA_ADMIT_TYPE_CD_1  ,
	@SRC_ADMIT_DT  ,
	@SRC_DISCHARGE_DT ,
	@prcdr_modifier_cd_2  ,
	@prcdr_modifier_cd_3  ,
	@poa_cd_4  ,
	@poa_cd_5  ,
	@poa_cd_6  ,
	@poa_cd_7 ,
	@poa_cd_8,
	@poa_cd_9  ,
	@poa_cd_10  ,
	@pri_icd9_dx_cd  ,
	@icd9_dx_cd_2 ,
	@icd9_dx_cd_3  ,
	@icd9_dx_cd_4  ,
	@icd9_dx_cd_5,
	@icd9_dx_cd_6 ,
	@icd9_dx_cd_7 ,
	@icd9_dx_cd_8  ,
	@icd9_dx_cd_9  ,
	@icd9_dx_cd_10  ,
	@icd9_prcdr_cd1  ,
	@icd9_prcdr_cd2  ,
	@icd9_prcdr_cd3 ,
	@icd9_prcdr_cd4,
	@icd9_prcdr_cd5  ,
	@icd9_prcdr_cd6  ,
	@ahf_det_order_cd  ,
	CASE WHEN (@ahf_mbr_coins_amt   = '')
	THEN NULL
	ELSE CONVERT(decimal, @ahf_mbr_coins_amt )
	END,
	CASE WHEN (@ahf_mbr_copay_amt  = '')
	THEN NULL
	ELSE CONVERT(decimal, @ahf_mbr_copay_amt)
	END,
		CASE WHEN (@ahf_mbr_ded_amt   = '')
	THEN NULL
	ELSE CONVERT(decimal, @ahf_mbr_ded_amt)
	END,
	@SensitivityIndicator  ,
	@hcfa_admit_type_cd_2  ,
	@FILLER_7  ,
	@ORG_CD  ,
	@valueX 
   )
   END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, 'ACECARDW.adi.copUhcPcor', '';

END




