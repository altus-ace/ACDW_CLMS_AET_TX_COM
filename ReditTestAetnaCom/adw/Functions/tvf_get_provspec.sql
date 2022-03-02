
/****** Object:  UserDefinedFunction adw.[tvf_get_active_members2]    Script Date: 12/20/2018 11:39:29 AM ******/

CREATE FUNCTION [adw].[tvf_get_provspec]
(@clientKey INT,
 @spec1 VARCHAR(50), 
 @spec2 VARCHAR(50), 
 @spec3 VARCHAR(50), 
 @spec4 VARCHAR(50), 
 @spec5 VARCHAR(50), 
 @spec6 VARCHAR(50)
)
RETURNS TABLE
AS
     RETURN
(
    SELECT DISTINCT 
           ch.seq_claim_id, 
           ch.subscriber_id, 
           ch.PRIMARY_SVC_DATE, 
           ch.ADMISSION_DATE, 
           ch.SVC_TO_DATE
    FROM adw.Claims_Headers ch
         JOIN
    (
        SELECT DISTINCT 
               source
        FROM [lst].[ListAceMapping]
        WHERE destination IN(@spec1, @spec1, @spec3, @spec4, @spec5, @spec6)
		  and ClientKey = @clientKey
    ) b ON ch.PROV_SPEC = b.source
);
