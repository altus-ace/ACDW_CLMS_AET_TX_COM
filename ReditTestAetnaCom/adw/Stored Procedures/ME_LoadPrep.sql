CREATE PROCEDURE [adw].[ME_LoadPrep]
AS
    /* validate load counts */
    select 'Count adi table to validate data counts '
    /*
    SELECT convert(date, CreatedDate), count(*) clmCnt
    FROM adi.OKC_Claims
    GROUP BY convert(date, CreatedDate)
    ORDER BY convert(date, CreatedDate) desc
    */
        
    
    
    
    /* UPdate Stats */
    /*
    EXEC sys.sp_updatestats;
    */
    
    /* Backup CCACO prior to process */
    DECLARE @nvDate NVARCHAR(10) = REPLACE(CONVERT(NVARCHAR(10), GETDATE(), 102), '.', '');
    DECLARE @BkName NVARCHAR(100) = N'H:\ACECAREDW\ACDW_CLMS_WLC_'+ @nvDate + '.bak' ;
    SELECT @BkName
    
    BACKUP DATABASE ACDW_CLMS_WLC
        TO  DISK = @bkName
        WITH COPY_ONLY
        , NOFORMAT
        , NOINIT
        ,  NAME = N'ACDW_CLMS_WLC-Full Database Backup'
        , SKIP
        , NOREWIND
        , NOUNLOAD
        , COMPRESSION
        ,  STATS = 10
