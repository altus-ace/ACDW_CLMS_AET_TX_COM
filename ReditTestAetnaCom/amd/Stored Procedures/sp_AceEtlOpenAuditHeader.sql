
CREATE PROCEDURE [amd].[sp_AceEtlOpenAuditHeader](
    @AuditID INT output
	, @EtlJobName VARCHAR(200) = 'No Job Name Provided'
	, @ActionStartTime DATETIME2 
	, @InputSourceName VARCHAR(200) = 'No Input Source Name Provided'	
	, @DestinationName VARCHAR(200) = 'No Destination Name Provided'	
	, @ErrorName VARCHAR(200) = 'No Error Name Provided'	
	)
AS 
    DECLARE @AuditStatus tinyInt = 1; -- Open value

    INSERT INTO [amd].AceEtlAuditHeader
           ([EtlAuditStatus]
           ,[EtlJobName]
           ,[ActionStartTime]           
           ,[InputSourceName]           
           ,[DestinationName]           
           ,[ErrorDestinationName]           
           )
     VALUES
           (@AuditStatus
           ,@EtlJobName
           ,@ActionStartTime           
           ,@InputSourceName
           ,@DestinationName           
           ,@ErrorName           
           );
    
    SELECT @AuditID = @@IDENTITY;
  
    IF @AuditID IS NULL
    BEGIN
	   RAISERROR ('Audit log entry open audit failed.',16, 1); 
    END
