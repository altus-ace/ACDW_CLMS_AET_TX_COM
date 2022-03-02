

CREATE FUNCTION [adw].[tvf_get_age](@age_start VARCHAR(10), @age_end VARCHAR(10),@measurement_date VARCHAR(20))
RETURNS TABLE
AS RETURN(
SELECT distinct SUBSCRIBER_ID
	from adw.tvf_get_active_members(1) 
	where datediff(year,DOB,convert(date,@measurement_date,101)) between @age_start and @age_end

)
