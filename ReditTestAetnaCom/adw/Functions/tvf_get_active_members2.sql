
CREATE FUNCTION [adw].[tvf_get_active_members2]
(@date DATE
)
RETURNS TABLE
AS
     RETURN
( 
    SELECT DISTINCT 
           HICN AS SUBSCRIBER_ID,
           CASE
               WHEN Sex = 'M'  --- this is needs to be addressed by changing the domain of the sex/gender field
               THEN 'M'
               ELSE 'F'
           END AS GENDER, 
           DOB, 
           DATEDIFF(year, DOB, CONVERT(DATE, @date, 101)) AS AGE
    FROM (select * from  adw.tmp_Active_Members where exclusion = 'N' and [plan] <> '')a
)
