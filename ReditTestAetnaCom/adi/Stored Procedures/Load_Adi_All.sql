CREATE PROCEDURE [adi].[Load_Adi_All](
    @LoadDate Date
)
AS 
 -- Move data from ast to ADI. 
   -- 1. insert all data values
   -- 2. replace stg Seq_ID with new permanant SKey
   -- 3. Add Load data to indentify load batch.
   -- 4. Need: add logging stuff.
   
   --EXEC  [ast].[OkcCleanStaging]
