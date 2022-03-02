-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- change log
-- add Datedate and use the last date from file name  
-- =============================================
CREATE PROCEDURE [adi].[ImportAetnaCommGIC_ActionList](
	@OriginalFileName varchar(100) ,
	@SrcFileName varchar(100) ,
	--@LoadDate date NOT ,
	--@CreatedDate date NOT ,
	@CreatedBy varchar(50)  ,
	--@LastUpdatedDate datetime ,
	@LastUpdatedBy varchar(50) ,
	@OrgCode varchar(20) ,
	@GapCount int ,
	@OnPriorList char(1) ,
	@SourceCUMBID varchar(50) ,
	@AetnaCardID varchar(50) ,
	@SeqNumber varchar(20) ,
	@Funding varchar(50) ,
	@PlanSponsorName varchar(50) ,
	@MemberID varchar(50) ,
	@LastName varchar(50) ,
	@FirstName varchar(50) ,
	@DateBirth varchar(10) ,
	@Gender char(1) ,
	@Phone varchar(20) ,
	@SegmentName varchar(50) ,
	@Carrier varchar(50) ,
	@MemberActive varchar(10) ,
	@AttributedTIN varchar(20) ,
	@AttributedTIName varchar(50) ,
	@AttributedPIN varchar(20) ,
	@AttributedProviderNPI varchar(20) ,
	@AttributedProviderName varchar(50) ,
	@LastSeenPCPName varchar(50) ,
	@LastseenPCPNPI varchar(20) ,
	@LastseenPCPVisitDate varchar(10) ,
	@NumberDaysLastPCPvisit int ,
	@PCPwithinACO varchar(50) ,
	@LastSeenSpecName varchar(50) ,
	@LastSeenSpecSpclty varchar(50) ,
	@LastseenSpecVisitDate varchar(10) ,
	@MedicalConditions varchar(50) ,
	@ContinuousEnrollment varchar(50) ,
	@Measure varchar(50) ,
	@ActionRequired varchar(50) ,
	@LastTest_ExamDate varchar(10) ,
	@ValueType varchar(50) ,
	@Value varchar(50) ,
	@Exam_DrugName varchar(50) ,
	@HBA1C_Value varchar(50) 
   
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
 INSERT INTO [adi].[AetnaCommGIC_ActionList]
   (
       [OriginalFileName]
      ,[SrcFileName]
      ,[LoadDate]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      ,[OrgCode]
      ,[GapCount]
      ,[OnPriorList]
      ,[SourceCUMBID]
      ,[AetnaCardID]
      ,[SeqNumber]
      ,[Funding]
      ,[PlanSponsorName]
      ,[MemberID]
      ,[LastName]
      ,[FirstName]
      ,[DateBirth]
      ,[Gender]
      ,[Phone]
      ,[SegmentName]
      ,[Carrier]
      ,[MemberActive]
      ,[AttributedTIN]
      ,[AttributedTIName]
      ,[AttributedPIN]
      ,[AttributedProviderNPI]
      ,[AttributedProviderName]
      ,[LastSeenPCPName]
      ,[LastseenPCPNPI]
      ,[LastseenPCPVisitDate]
      ,[NumberDaysLastPCPvisit]
      ,[PCPwithinACO]
      ,[LastSeenSpecName]
      ,[LastSeenSpecSpclty]
      ,[LastseenSpecVisitDate]
      ,[MedicalConditions]
      ,[ContinuousEnrollment]
      ,[Measure]
      ,[ActionRequired]
      ,[LastTest_ExamDate]
      ,[ValueType]
      ,[Value]
      ,[Exam_DrugName]
      ,[HBA1C_Value]
   
            )
     VALUES
   (
 @OriginalFileName  ,
	@SrcFileName ,
	GETDATE(),
	--@LoadDate date NOT ,
    GETDATE(),
	--@CreatedDate date NOT ,
	@CreatedBy  ,
	GETDATE(),
	--@LastUpdatedDate datetime ,
	@LastUpdatedBy  ,
	@OrgCode  ,
	@GapCount ,
	@OnPriorList  ,
	@SourceCUMBID  ,
	@AetnaCardID  ,
	@SeqNumber  ,
	@Funding  ,
	@PlanSponsorName  ,
	@MemberID  ,
	@LastName  ,
	@FirstName  ,
	CASE WHEN @DateBirth =''
	THEN NULL
	ELSE CONVERT(DATE, @DateBirth)
	END,
	@Gender  ,
	@Phone  ,
	@SegmentName  ,
	@Carrier  ,
	@MemberActive  ,
	@AttributedTIN  ,
	@AttributedTIName  ,
	@AttributedPIN  ,
	@AttributedProviderNPI  ,
	@AttributedProviderName  ,
	@LastSeenPCPName  ,
	@LastseenPCPNPI  ,
	CASE WHEN @LastseenPCPVisitDate  =''
	THEN NULL
	ELSE CONVERT(DATE, @LastseenPCPVisitDate )
	END,
	@NumberDaysLastPCPvisit ,
	@PCPwithinACO  ,
	@LastSeenSpecName  ,
	@LastSeenSpecSpclty  ,
	CASE WHEN @LastseenSpecVisitDate =''
	THEN NULL
	ELSE CONVERT(DATE, @LastseenSpecVisitDate)
	END,
	@MedicalConditions  ,
	@ContinuousEnrollment  ,
	@Measure  ,
	@ActionRequired  ,
	CASE WHEN @LastTest_ExamDate =''
	THEN NULL
	ELSE CONVERT(DATE, @LastTest_ExamDate)
	END,
	@ValueType  ,
	@Value  ,
	@Exam_DrugName  ,
	@HBA1C_Value   
   )
   END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, 'ACECARDW.adi.copUhcPcor', '';

END




