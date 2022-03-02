-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- change log
-- add Datedate and use the last date from file name  
-- =============================================
CREATE PROCEDURE [adi].[ImportAetCom_ProvCost_Data](
    @OriginalFileName varchar (100),
	@SrcFileName varchar (100),
	@DataDate varchar(10),
	@FileDate varchar(10),
	--@LoadDate date  ,
	--@CreatedDate date   ,
	@CreatedBy varchar (50) ,
	--@LastUpdatedDate datetime  ,
	@LastUpdatedBy varchar (50),
	@ATTR_TAX_ID varchar (50) ,
	@ATTR_TAX_ID_NAME varchar (50) ,
	@ATTR_PRVDR_ID varchar (50) ,
	@ATTR_PRINT_NM varchar (50) ,
	@ATTR_ORG_CD varchar (50) ,
	@IPFac1_Paid_Amt  varchar(10)  ,
	@IPFac2a_Paid_Amt  varchar(10)    ,
	@IPFac2b_Paid_Amt  varchar(10)    ,
	@IPFac3_Paid_Amt  varchar(10)    ,
	@IPFac_Paid_Amt  varchar(10)    ,
	@AMBFac1_Paid_Amt  varchar(10)    ,
	@AMBFac2a_Paid_Amt  varchar(10)    ,
	@AMBFac2b_Paid_Amt  varchar(10)    ,
	@AMBFac3_Paid_Amt  varchar(10)    ,
	@AMBFac_Paid_Amt  varchar(10)    ,
	@Emerg1_Paid_Amt  varchar(10)    ,
	@Emerg2a_Paid_Amt  varchar(10)    ,
	@Emerg2b_Paid_Amt  varchar(10)    ,
	@Emerg3_Paid_Amt  varchar(10)    ,
	@Emerg_Paid_Amt  varchar(10)    ,
	@SpecPhy1_Paid_Amt  varchar(10)    ,
	@SpecPhy2a_Paid_Amt  varchar(10)    ,
	@SpecPhy2b_Paid_Amt  varchar(10)    ,
	@SpecPhy3_Paid_Amt  varchar(10)    ,
	@SpecPhy_Paid_Amt  varchar(10)    ,
	@PCPPhy1_Paid_Amt  varchar(10)    ,
	@PCPPhy2a_Paid_Amt  varchar(10)    ,
	@PCPPhy2b_Paid_Amt  varchar(10)    ,
	@PCPPhy3_Paid_Amt  varchar(10)    ,
	@PCPPhy_Paid_Amt  varchar(10)    ,
	@Rad1_Paid_Amt  varchar(10)    ,
	@Rad2a_Paid_Amt  varchar(10)    ,
	@Rad2b_Paid_Amt  varchar(10)    ,
	@Rad3_Paid_Amt  varchar(10)    ,
	@Rad_Paid_Amt  varchar(10)    ,
	@Lab1_Paid_Amt  varchar(10)    ,
	@Lab2a_Paid_Amt  varchar(10)    ,
	@Lab2b_Paid_Amt  varchar(10)    ,
	@Lab3_Paid_Amt  varchar(10)    ,
	@Lab_Paid_Amt  varchar(10)    ,
	@HomeHealth1_Paid_Amt  varchar(10)    ,
	@HomeHealth2a_Paid_Amt  varchar(10)    ,
	@HomeHealth2b_Paid_Amt  varchar(10)    ,
	@HomeHealth3_Paid_Amt  varchar(10)    ,
	@HomeHealth_Paid_Amt  varchar(10)    ,
	@MentHealth1_Paid_Amt  varchar(10)    ,
	@MentHealth2a_Paid_Amt  varchar(10)    ,
	@MentHealth2b_Paid_Amt  varchar(10)    ,
	@MentHealth3_Paid_Amt  varchar(10)    ,
	@MentHealth_Paid_Amt  varchar(10)    ,
	@MedRx1_Paid_Amt  varchar(10)    ,
	@MedRx2a_Paid_Amt  varchar(10)    ,
	@MedRx2b_Paid_Amt  varchar(10)    ,
	@MedRx3_Paid_Amt  varchar(10)    ,
	@MedRx_Paid_Amt  varchar(10)    ,
	@Other1_Paid_Amt  varchar(10)    ,
	@Other2a_Paid_Amt  varchar(10)    ,
	@Other2b_Paid_Amt  varchar(10)    ,
	@Other3_Paid_Amt  varchar(10)    ,
	@Other_Paid_Amt  varchar(10)    ,
	@ALL1_Paid_Amt  varchar(10)    ,
	@ALL2a_Paid_Amt  varchar(10)    ,
	@ALL2b_Paid_Amt  varchar(10)    ,
	@ALL3_Paid_Amt  varchar(10)    ,
	@ALL_Paid_Amt  varchar(10)    ,
	@IPFac1_Mem_Cnt  varchar(10),  
	@IPFac2a_Mem_Cnt  varchar(10),  
	@IPFac2b_Mem_Cnt  varchar(10),  
	@IPFac3_Mem_Cnt  varchar(10),  
	@IPFac_Mem_Cnt  varchar(10),  
	@AMBFac1_Mem_Cnt  varchar(10),  
	@AMBFac2a_Mem_Cnt  varchar(10),  
	@AMBFac2b_Mem_Cnt  varchar(10),  
	@AMBFac3_Mem_Cnt  varchar(10),  
	@AMBFac_Mem_Cnt  varchar(10),  
	@Emerg1_Mem_Cnt  varchar(10),  
	@Emerg2a_Mem_Cnt  varchar(10),  
	@Emerg2b_Mem_Cnt  varchar(10),  
	@Emerg3_Mem_Cnt  varchar(10),  
	@Emerg_Mem_Cnt  varchar(10),  
	@SpecPhy1_Mem_Cnt  varchar(10),  
	@SpecPhy2a_Mem_Cnt  varchar(10),  
	@SpecPhy2b_Mem_Cnt  varchar(10),  
	@SpecPhy3_Mem_Cnt  varchar(10),  
	@SpecPhy_Mem_Cnt  varchar(10),  
	@PCPPhy1_Mem_Cnt  varchar(10),  
	@PCPPhy2a_Mem_Cnt  varchar(10),  
	@PCPPhy2b_Mem_Cnt  varchar(10),  
	@PCPPhy3_Mem_Cnt  varchar(10),  
	@PCPPhy_Mem_Cnt  varchar(10),  
	@Rad1_Mem_Cnt  varchar(10),  
	@Rad2a_Mem_Cnt  varchar(10),  
	@Rad2b_Mem_Cnt  varchar(10),  
	@Rad3_Mem_Cnt  varchar(10),  
	@Rad_Mem_Cnt  varchar(10),  
	@Lab1_Mem_Cnt  varchar(10),  
	@Lab2a_Mem_Cnt  varchar(10),  
	@Lab2b_Mem_Cnt  varchar(10),  
	@Lab3_Mem_Cnt  varchar(10),  
	@Lab_Mem_Cnt  varchar(10),  
	@HomeHealth1_Mem_Cnt  varchar(10),  
	@HomeHealth2a_Mem_Cnt  varchar(10),  
	@HomeHealth2b_Mem_Cnt  varchar(10),  
	@HomeHealth3_Mem_Cnt  varchar(10),  
	@HomeHealth_Mem_Cnt  varchar(10),  
	@MentHealth1_Mem_Cnt  varchar(10),  
	@MentHealth2a_Mem_Cnt  varchar(10),  
	@MentHealth2b_Mem_Cnt  varchar(10),  
	@MentHealth3_Mem_Cnt  varchar(10),  
	@MentHealth_Mem_Cnt  varchar(10),  
	@MedRx1_Mem_Cnt  varchar(10),  
	@MedRx2a_Mem_Cnt  varchar(10),  
	@MedRx2b_Mem_Cnt  varchar(10),  
	@MedRx3_Mem_Cnt  varchar(10),  
	@MedRx_Mem_Cnt  varchar(10),  
	@Other1_Mem_Cnt  varchar(10),  
	@Other2a_Mem_Cnt  varchar(10),  
	@Other2b_Mem_Cnt  varchar(10),  
	@Other3_Mem_Cnt  varchar(10),  
	@Other_Mem_Cnt  varchar(10),  
	@ALL1_Mem_Cnt  varchar(10),  
	@ALL2a_Mem_Cnt  varchar(10),  
	@ALL2b_Mem_Cnt  varchar(10),  
	@ALL3_Mem_Cnt  varchar(10),  
	@ALL_Mem_Cnt  varchar(10),  
	@Dist_Member_Count varchar(10),  
	@Member_Months  varchar(10),  
	@Avg_Member_Count varchar(10),  
	@Total_Age   varchar(10),  
	@Total_Retro_Risk varchar (50) ,
    @PCPMiddleName [varchar](50),
	@PCPLastName [varchar](50),
	@PCPName [varchar](100) ,
	@PCP_NPI [varchar](20),
	@Chapter [varchar](20) 
   
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- erfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- ADD ACE ETL AUDIT
	--DECLARE @AuditID AS , @ActionStartDateTime AS datetime2, @ActionStopDateTime as datetime2
	
--	SET @ActionStartDateTime = GETDATE(); 
	
	--'2017-12-16 11:15:23.2393473'
    
	--EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 1, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, 'ACECARDW.adi.copUhcPcor', '';
--	--EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR',  @ActionStartDateTime , 'Test', 'ACECARDW.adi.copUhcPcor', '' ;



 --IF (@Physician <>'' AND @FirstName <> '' AND @LastName <> ''  AND @MemberID <> '') 
 IF(@ATTR_TAX_ID !='')
 BEGIN
 INSERT  [adi].[AetCom_ProvCost_Data]
   (
       [OriginalFileName]
      ,[SrcFileName]
	  ,DataDate 
	  ,FileDate 
      ,[LoadDate]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      ,[ATTR_TAX_ID]
      ,[ATTR_TAX_ID_NAME]
      ,[ATTR_PRVDR_ID]
      ,[ATTR_PRINT_NM]
      ,[ATTR_ORG_CD]
      ,[IPFac1_Paid_Amt]
      ,[IPFac2a_Paid_Amt]
      ,[IPFac2b_Paid_Amt]
      ,[IPFac3_Paid_Amt]
      ,[IPFac_Paid_Amt]
      ,[AMBFac1_Paid_Amt]
      ,[AMBFac2a_Paid_Amt]
      ,[AMBFac2b_Paid_Amt]
      ,[AMBFac3_Paid_Amt]
      ,[AMBFac_Paid_Amt]
      ,[Emerg1_Paid_Amt]
      ,[Emerg2a_Paid_Amt]
      ,[Emerg2b_Paid_Amt]
      ,[Emerg3_Paid_Amt]
      ,[Emerg_Paid_Amt]
      ,[SpecPhy1_Paid_Amt]
      ,[SpecPhy2a_Paid_Amt]
      ,[SpecPhy2b_Paid_Amt]
      ,[SpecPhy3_Paid_Amt]
      ,[SpecPhy_Paid_Amt]
      ,[PCPPhy1_Paid_Amt]
      ,[PCPPhy2a_Paid_Amt]
      ,[PCPPhy2b_Paid_Amt]
      ,[PCPPhy3_Paid_Amt]
      ,[PCPPhy_Paid_Amt]
      ,[Rad1_Paid_Amt]
      ,[Rad2a_Paid_Amt]
      ,[Rad2b_Paid_Amt]
      ,[Rad3_Paid_Amt]
      ,[Rad_Paid_Amt]
      ,[Lab1_Paid_Amt]
      ,[Lab2a_Paid_Amt]
      ,[Lab2b_Paid_Amt]
      ,[Lab3_Paid_Amt]
      ,[Lab_Paid_Amt]
      ,[HomeHealth1_Paid_Amt]
      ,[HomeHealth2a_Paid_Amt]
      ,[HomeHealth2b_Paid_Amt]
      ,[HomeHealth3_Paid_Amt]
      ,[HomeHealth_Paid_Amt]
      ,[MentHealth1_Paid_Amt]
      ,[MentHealth2a_Paid_Amt]
      ,[MentHealth2b_Paid_Amt]
      ,[MentHealth3_Paid_Amt]
      ,[MentHealth_Paid_Amt]
      ,[MedRx1_Paid_Amt]
      ,[MedRx2a_Paid_Amt]
      ,[MedRx2b_Paid_Amt]
      ,[MedRx3_Paid_Amt]
      ,[MedRx_Paid_Amt]
      ,[Other1_Paid_Amt]
      ,[Other2a_Paid_Amt]
      ,[Other2b_Paid_Amt]
      ,[Other3_Paid_Amt]
      ,[Other_Paid_Amt]
      ,[ALL1_Paid_Amt]
      ,[ALL2a_Paid_Amt]
      ,[ALL2b_Paid_Amt]
      ,[ALL3_Paid_Amt]
      ,[ALL_Paid_Amt]
      ,[IPFac1_Mem_Cnt]
      ,[IPFac2a_Mem_Cnt]
      ,[IPFac2b_Mem_Cnt]
      ,[IPFac3_Mem_Cnt]
      ,[IPFac_Mem_Cnt]
      ,[AMBFac1_Mem_Cnt]
      ,[AMBFac2a_Mem_Cnt]
      ,[AMBFac2b_Mem_Cnt]
      ,[AMBFac3_Mem_Cnt]
      ,[AMBFac_Mem_Cnt]
      ,[Emerg1_Mem_Cnt]
      ,[Emerg2a_Mem_Cnt]
      ,[Emerg2b_Mem_Cnt]
      ,[Emerg3_Mem_Cnt]
      ,[Emerg_Mem_Cnt]
      ,[SpecPhy1_Mem_Cnt]
      ,[SpecPhy2a_Mem_Cnt]
      ,[SpecPhy2b_Mem_Cnt]
      ,[SpecPhy3_Mem_Cnt]
      ,[SpecPhy_Mem_Cnt]
      ,[PCPPhy1_Mem_Cnt]
      ,[PCPPhy2a_Mem_Cnt]
      ,[PCPPhy2b_Mem_Cnt]
      ,[PCPPhy3_Mem_Cnt]
      ,[PCPPhy_Mem_Cnt]
      ,[Rad1_Mem_Cnt]
      ,[Rad2a_Mem_Cnt]
      ,[Rad2b_Mem_Cnt]
      ,[Rad3_Mem_Cnt]
      ,[Rad_Mem_Cnt]
      ,[Lab1_Mem_Cnt]
      ,[Lab2a_Mem_Cnt]
      ,[Lab2b_Mem_Cnt]
      ,[Lab3_Mem_Cnt]
      ,[Lab_Mem_Cnt]
      ,[HomeHealth1_Mem_Cnt]
      ,[HomeHealth2a_Mem_Cnt]
      ,[HomeHealth2b_Mem_Cnt]
      ,[HomeHealth3_Mem_Cntm]
      ,[HomeHealth_Mem_Cnt]
      ,[MentHealth1_Mem_Cnt]
      ,[MentHealth2a_Mem_Cnt]
      ,[MentHealth2b_Mem_Cnt]
      ,[MentHealth3_Mem_Cnt]
      ,[MentHealth_Mem_Cnt]
      ,[MedRx1_Mem_Cnt]
      ,[MedRx2a_Mem_Cnt]
      ,[MedRx2b_Mem_Cnt]
      ,[MedRx3_Mem_Cnt]
      ,[MedRx_Mem_Cnt]
      ,[Other1_Mem_Cnt]
      ,[Other2a_Mem_Cnt]
      ,[Other2b_Mem_Cnt]
      ,[Other3_Mem_Cnt]
      ,[Other_Mem_Cnt]
      ,[ALL1_Mem_Cnt]
      ,[ALL2a_Mem_Cnt]
      ,[ALL2b_Mem_Cnt]
      ,[ALL3_Mem_Cnt]
      ,[ALL_Mem_Cnt]
      ,[Dist_Member_Count]
      ,[Member_Months]
      ,[Avg_Member_Count]
      ,[Total_Age]
      ,[Total_Retro_Risk]
	  ,[PCPMiddleName]
      ,[PCPLastName]
      ,[PCPName]
      ,[PCP_NPI]
      ,[Chapter]
   
          )
     VALUES
   (
    @OriginalFileName ,
	@SrcFileName ,
	CASE WHEN @DataDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @DataDate)
	END,
	CASE WHEN @FileDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @FileDate)
	END,
	DATEADD(mm, DATEDIFF(mm,0, GETDATE()), 0),
	--@LoadDate date  ,
	GETDATE(),
	--@CreatedDate date   ,
	@CreatedBy  ,
	--@LastUpdatedDate datetime  ,
	GETDATE(),
	@LastUpdatedBy ,
	@ATTR_TAX_ID  ,
	@ATTR_TAX_ID_NAME  ,
	@ATTR_PRVDR_ID  ,
	@ATTR_PRINT_NM  ,
	@ATTR_ORG_CD , 
	CASE WHEN @IPFac1_Paid_Amt = ''
	THEN NULL
	ELSE CONVERT(money, @IPFac1_Paid_Amt)
	END,
	CASE WHEN @IPFac2a_Paid_Amt = ''
	THEN NULL
	ELSE CONVERT(money, @IPFac2a_Paid_Amt)
	END,
	CASE WHEN @IPFac2b_Paid_Amt   = ''
	THEN NULL
	ELSE CONVERT(money, @IPFac2b_Paid_Amt)
	END,
	CASE WHEN @IPFac3_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money, @IPFac3_Paid_Amt)
	END,
	CASE WHEN @IPFac_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money, @IPFac_Paid_Amt  )
	END,
	CASE WHEN @AMBFac1_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money, @AMBFac1_Paid_Amt )
	END,
	CASE WHEN @AMBFac2a_Paid_Amt   = ''
	THEN NULL
	ELSE CONVERT(money, @AMBFac2a_Paid_Amt )
	END,	 
	CASE WHEN @AMBFac2b_Paid_Amt   = ''
	THEN NULL
	ELSE CONVERT(money, @AMBFac2b_Paid_Amt )
	END,
	CASE WHEN @AMBFac3_Paid_Amt = ''
	THEN NULL
	ELSE CONVERT(money, @AMBFac3_Paid_Amt )
	END,	    
	CASE WHEN @AMBFac_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money, @AMBFac_Paid_Amt )
	END,	    
	CASE WHEN @Emerg1_Paid_Amt = ''
	THEN NULL
	ELSE CONVERT(money, @Emerg1_Paid_Amt)
	END,	     	     
	CASE WHEN @Emerg2a_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money, @Emerg2a_Paid_Amt )
	END,
	     
	CASE WHEN @Emerg2b_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money, @Emerg2b_Paid_Amt )
	END,
	   
	CASE WHEN @Emerg3_Paid_Amt = ''
	THEN NULL
	ELSE CONVERT(money, @Emerg3_Paid_Amt )
	END,
	 
	CASE WHEN @Emerg_Paid_Amt   = ''
	THEN NULL
	ELSE CONVERT(money, @Emerg_Paid_Amt )
	END,
	CASE WHEN @SpecPhy1_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money, @SpecPhy1_Paid_Amt )
	END,
	
	CASE WHEN @SpecPhy2a_Paid_Amt = ''
	THEN NULL
	ELSE CONVERT(money, @SpecPhy2a_Paid_Amt )
	END,
	CASE WHEN @SpecPhy2b_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money, @SpecPhy2b_Paid_Amt )
	END,
	    
	CASE WHEN @SpecPhy3_Paid_Amt = ''
	THEN NULL
	ELSE CONVERT(money, @SpecPhy3_Paid_Amt   )
	END,
	CASE WHEN @SpecPhy_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money, @SpecPhy_Paid_Amt )
	END,
   
	CASE WHEN 	@PCPPhy1_Paid_Amt = ''
	THEN NULL
	ELSE CONVERT(money, 	@PCPPhy1_Paid_Amt )
	END,
   
	CASE WHEN 	@PCPPhy2a_Paid_Amt    = ''
	THEN NULL
	ELSE CONVERT(money,	@PCPPhy2a_Paid_Amt  )
	END,
	    
	CASE WHEN @PCPPhy2b_Paid_Amt    = ''
	THEN NULL
	ELSE CONVERT(money,	@PCPPhy2b_Paid_Amt  )
	END,
	     
	CASE WHEN @PCPPhy3_Paid_Amt   = ''
	THEN NULL
	ELSE CONVERT(money,	@PCPPhy3_Paid_Amt )
	END,

	CASE WHEN @PCPPhy_Paid_Amt = ''
	THEN NULL
	ELSE CONVERT(money,	@PCPPhy_Paid_Amt )
	END,
    
	CASE WHEN 	@Rad1_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money,@Rad1_Paid_Amt )
	END,
	    
	CASE WHEN @Rad2a_Paid_Amt   = ''
	THEN NULL
	ELSE CONVERT(money,@Rad2a_Paid_Amt )
	END,
	   
	CASE WHEN @Rad2b_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money,@Rad2b_Paid_Amt   )
	END,
  
	CASE WHEN 	@Rad3_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money,	@Rad3_Paid_Amt  )
	END,
	  
	CASE WHEN @Rad_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money,	@Rad_Paid_Amt   )
	END,
	 
	CASE WHEN @Lab1_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money,	@Lab1_Paid_Amt )
	END,
	    
	CASE WHEN @Lab2a_Paid_Amt   = ''
	THEN NULL
	ELSE CONVERT(money,	@Lab2a_Paid_Amt  )
	END,
	CASE WHEN 	@Lab2b_Paid_Amt    = ''
	THEN NULL
	ELSE CONVERT(money,		@Lab2b_Paid_Amt )
	END,
	CASE WHEN @Lab3_Paid_Amt   = ''
	THEN NULL
	ELSE CONVERT(money,@Lab3_Paid_Amt  )
	END,
	CASE WHEN @Lab_Paid_Amt   = ''
	THEN NULL
	ELSE CONVERT(money,@Lab_Paid_Amt )
	END,
	  
	CASE WHEN @HomeHealth1_Paid_Amt   = ''
	THEN NULL
	ELSE CONVERT(money,@HomeHealth1_Paid_Amt )
	END,
	CASE WHEN @HomeHealth2a_Paid_Amt    = ''
	THEN NULL
	ELSE CONVERT(money,@HomeHealth2a_Paid_Amt  )
	END,
	CASE WHEN @HomeHealth2b_Paid_Amt   = ''
	THEN NULL
	ELSE CONVERT(money,@HomeHealth2b_Paid_Amt )
	END,
	
	CASE WHEN @HomeHealth3_Paid_Amt   = ''
	THEN NULL
	ELSE CONVERT(money,@HomeHealth3_Paid_Amt )
	END,
	  
	CASE WHEN @HomeHealth_Paid_Amt   = ''
	THEN NULL
	ELSE CONVERT(money,@HomeHealth_Paid_Amt  )
	END,
	CASE WHEN @MentHealth1_Paid_Amt    = ''
	THEN NULL
	ELSE CONVERT(money,@MentHealth1_Paid_Amt )
	END,
	  
	CASE WHEN @MentHealth2a_Paid_Amt = ''
	THEN NULL
	ELSE CONVERT(money,@MentHealth2a_Paid_Amt  )
	END,
	
	CASE WHEN @MentHealth2b_Paid_Amt   = ''
	THEN NULL
	ELSE CONVERT(money,@MentHealth2b_Paid_Amt  )
	END,
	     
	CASE WHEN @MentHealth3_Paid_Amt   = ''
	THEN NULL
	ELSE CONVERT(money,@MentHealth3_Paid_Amt )
	END,
	CASE WHEN @MentHealth_Paid_Amt   = ''
	THEN NULL
	ELSE CONVERT(money, @MentHealth_Paid_Amt )
	END,
	  
	CASE WHEN @MedRx1_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money, @MedRx1_Paid_Amt )
	END,
	CASE WHEN @MedRx2a_Paid_Amt    = ''
	THEN NULL
	ELSE CONVERT(money, @MedRx2a_Paid_Amt   )
	END,
	 
	CASE WHEN @MedRx2b_Paid_Amt     = ''
	THEN NULL
	ELSE CONVERT(money, @MedRx2b_Paid_Amt   )
	END,
	  
	CASE WHEN @MedRx3_Paid_Amt   = ''
	THEN NULL
	ELSE CONVERT(money, @MedRx3_Paid_Amt )
	END,

	CASE WHEN @MedRx_Paid_Amt = ''
	THEN NULL
	ELSE CONVERT(money, @MedRx_Paid_Amt )
	END,
	    
	CASE WHEN @Other1_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money, @Other1_Paid_Amt  )
	END,
	CASE WHEN @Other2a_Paid_Amt = ''
	THEN NULL
	ELSE CONVERT(money, @Other2a_Paid_Amt)
	END,
	CASE WHEN @Other2b_Paid_Amt = ''
	THEN NULL
	ELSE CONVERT(money, @Other2b_Paid_Amt )
	END,

	CASE WHEN @Other3_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money, @Other3_Paid_Amt )
	END,
	
	CASE WHEN @Other_Paid_Amt = ''
	THEN NULL
	ELSE CONVERT(money, @Other_Paid_Amt )
	END,
	CASE WHEN @ALL1_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money, @ALL1_Paid_Amt )
	END,
	
	CASE WHEN @ALL2a_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money, @ALL2a_Paid_Amt)
	END,
	CASE WHEN @ALL2b_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money, @ALL2b_Paid_Amt )
	END,
	    
	CASE WHEN @ALL3_Paid_Amt    = ''
	THEN NULL
	ELSE CONVERT(money, @ALL3_Paid_Amt  )
	END,
	CASE WHEN @ALL_Paid_Amt  = ''
	THEN NULL
	ELSE CONVERT(money, @ALL_Paid_Amt )
	END,
	CASE WHEN @IPFac1_Mem_Cnt = ''
	THEN NULL
	ELSE CONVERT(int, @IPFac1_Mem_Cnt)
	END, 
	@IPFac2a_Mem_Cnt  ,  
	@IPFac2b_Mem_Cnt  ,  
	@IPFac3_Mem_Cnt  ,  
	@IPFac_Mem_Cnt  ,  
	@AMBFac1_Mem_Cnt  ,  
	@AMBFac2a_Mem_Cnt  ,  
	@AMBFac2b_Mem_Cnt  ,  
	@AMBFac3_Mem_Cnt  ,  
	@AMBFac_Mem_Cnt  ,  
	@Emerg1_Mem_Cnt  ,  
	@Emerg2a_Mem_Cnt  ,  
	@Emerg2b_Mem_Cnt  ,  
	@Emerg3_Mem_Cnt  ,  
	@Emerg_Mem_Cnt  ,  
	@SpecPhy1_Mem_Cnt  ,  
	@SpecPhy2a_Mem_Cnt  ,  
	@SpecPhy2b_Mem_Cnt  ,  
	@SpecPhy3_Mem_Cnt  ,  
	@SpecPhy_Mem_Cnt  ,  
	@PCPPhy1_Mem_Cnt  ,  
	@PCPPhy2a_Mem_Cnt  ,  
	@PCPPhy2b_Mem_Cnt  ,  
	@PCPPhy3_Mem_Cnt  ,  
	@PCPPhy_Mem_Cnt  ,  
	@Rad1_Mem_Cnt  ,  
	@Rad2a_Mem_Cnt  ,  
	@Rad2b_Mem_Cnt  ,  
	@Rad3_Mem_Cnt  ,  
	@Rad_Mem_Cnt  ,  
	@Lab1_Mem_Cnt  ,  
	@Lab2a_Mem_Cnt  ,  
	@Lab2b_Mem_Cnt  ,  
	@Lab3_Mem_Cnt  ,  
	@Lab_Mem_Cnt  ,  
	@HomeHealth1_Mem_Cnt  ,  
	@HomeHealth2a_Mem_Cnt  ,  
	@HomeHealth2b_Mem_Cnt  ,  
	@HomeHealth3_Mem_Cnt  ,  
	@HomeHealth_Mem_Cnt  ,  
	@MentHealth1_Mem_Cnt  ,  
	@MentHealth2a_Mem_Cnt  ,  
	@MentHealth2b_Mem_Cnt  ,  
	@MentHealth3_Mem_Cnt  ,  
	@MentHealth_Mem_Cnt  ,  
	@MedRx1_Mem_Cnt  ,  
	@MedRx2a_Mem_Cnt  ,  
	@MedRx2b_Mem_Cnt  ,  
	@MedRx3_Mem_Cnt  ,  
	@MedRx_Mem_Cnt  ,  
	@Other1_Mem_Cnt  ,  
	@Other2a_Mem_Cnt  ,  
	@Other2b_Mem_Cnt  ,  
	@Other3_Mem_Cnt  ,  
	CASE WHEN @Other_Mem_Cnt  = ''
	THEN NULL
	ELSE CONVERT(int,@Other_Mem_Cnt)
	END,
	 
	CASE WHEN @ALL1_Mem_Cnt  = ''
	THEN NULL
	ELSE CONVERT(int,@ALL1_Mem_Cnt)
	END,
	CASE WHEN @ALL2a_Mem_Cnt   = ''
	THEN NULL
	ELSE CONVERT(int,@ALL2a_Mem_Cnt)
	END,
	CASE WHEN @ALL2b_Mem_Cnt  = ''
	THEN NULL
	ELSE CONVERT(int, @ALL2b_Mem_Cnt)
	END,	   
	CASE WHEN @ALL3_Mem_Cnt   = ''
	THEN NULL
	ELSE CONVERT(int, @ALL3_Mem_Cnt )
	END,
	CASE WHEN @ALL_Mem_Cnt  = ''
	THEN NULL
	ELSE CONVERT(int, @ALL_Mem_Cnt )
	END,
	CASE WHEN @Dist_Member_Count = ''
	THEN NULL
	ELSE CONVERT(int, @Dist_Member_Count)
	END,	 
	CASE WHEN @Member_Months  = ''
	THEN NULL
	ELSE CONVERT(int,@Member_Months )
	END, 
	CASE WHEN @Avg_Member_Count = ''
	THEN NULL
	ELSE CONVERT(decimal,@Avg_Member_Count)
	END, 
	CASE WHEN 	@Total_Age = ''
	THEN NULL
	ELSE CONVERT(int,	@Total_Age)
	END, 
	@Total_Retro_Risk,
	@PCPMiddleName ,
	@PCPLastName ,
	@PCPName,
	@PCP_NPI,
	@Chapter 
   )
   END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, 'ACECARDW.adi.copUhcPcor', '';

END




