

CREATE  FUNCTION [adw].[tvf_get_gender](@gender VARCHAR(10))
RETURNS TABLE
AS RETURN(
SELECT distinct SUBSCRIBER_ID
	from adw.tvf_get_active_members(1) 
	where gender = @gender



)
