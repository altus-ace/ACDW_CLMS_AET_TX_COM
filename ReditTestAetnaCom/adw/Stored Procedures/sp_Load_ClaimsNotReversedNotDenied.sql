
CREATE PROCEDURE [adw].[sp_Load_ClaimsNotReversedNotDenied]
AS
     TRUNCATE TABLE adw.tmp_Claims_NotReversedNotDenied;
     INSERT INTO adw.tmp_Claims_NotReversedNotDenied(SEQ_CLAIM_ID)
            SELECT DISTINCT 
                   seq_claim_id
            FROM
            (
                SELECT seq_claim_id, 
                       line_number
                FROM adw.claims_details
                EXCEPT
                SELECT seq_claim_id, 
                       line_number
                FROM adw.claims_details
                WHERE sub_line_code = 'R'
            ) a
            EXCEPT
            SELECT DISTINCT 
                   seq_claim_id
            FROM adw.CLAIMS_HEADERS
            WHERE CLAIM_STATUS <> 'D';
