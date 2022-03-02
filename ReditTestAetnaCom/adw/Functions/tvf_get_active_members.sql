CREATE FUNCTION [adw].[tvf_get_active_members]
(@isactive INT
)
RETURNS TABLE
AS
     RETURN
(
    SELECT DISTINCT 
           subscriber_id, 
           m_gender AS gender, 
           m_date_of_birth AS DOB
    FROM adw.M_MEMBER_ENR
    WHERE CLIENT_ID = 'OKC'
);
