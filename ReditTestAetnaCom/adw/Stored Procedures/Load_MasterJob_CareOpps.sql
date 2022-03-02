﻿

CREATE PROCEDURE [adw].[Load_MasterJob_CareOpps] 
					(@QMDate DATE,@ClientKey INT,@DataDate DATE)

AS



BEGIN
		/*Pre Validate CareOpps*/
	EXECUTE [adi].[ValidateCareopps]


END

 BEGIN
	

	/**New Version - Process for all Measures*/
	EXECUTE [ast].[plsCareopps_Quality_Action_List] @QMDate, @ClientKey, @DataDate
	

 END


 BEGIN
	/*Validate Records for processing*/
	EXECUTE [ast].[pstCopValidateStaging]@QMDate, @ClientKey

 END

 BEGIN 

	/*Process records into Data Warehouse*/
	EXECUTE [ast].[pdw_CareOppsStagingToAdw] @QMDate,@ClientKey

 END

 BEGIN
	/*Log invalid Records*/
	EXEC [ast].[pdw_Load_FailedCareOpps] @QMDate,@ClientKey
 END
