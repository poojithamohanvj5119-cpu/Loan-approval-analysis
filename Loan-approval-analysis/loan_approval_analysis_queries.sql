create database loan_approval_dataset;

select * from loan_approval_dataset

select table_name
from information_schema. tables
where table_schema=
'loan_approval_dataset';

-- preview first 10 rows to confrim data loaded correctly
select * from loan_approval_dataset limit 100;
-- add a new column for loan status(approved / not approved)

alter table loan_approval_dataset add column loan_status VARCHAR(10);
-- POPULATE LOAN STATUS USING APPROVAL CRITERIA
-- APPROVAL LOGIC:
-- CREDIT_SCORE>=700
-- DEBT_TO_INCOME_RATIO ,=0.4
-- INCOME>=3000

UPDATE loan_approval_dataset
set loan_status = case
when credit_score >=650 and Debt_to_Income_Ratio <= 40 and income >= 2500 then 'y' else 'N' end;

-- CHECK APPROVAL VS REJECTION DISTRIBUTION

SELECT LOAN_STATUS, COUNT(*) AS TOTAL_APPLICANTS
FROM LOAN_APPROVAL_DATASET
GROUP BY LOAN_STATUS;

-- HOW MANY HAVE Debt_to_Income_Ratio <= 40;
SELECT COUNT(*) FROM loan_approval_dataset WHERE INCOME >= 2500;

-- APPROVAL PERCENTAGE BY EMPLOYMENT STATUS
SELECT EMPLOYMENT_STATUS, 
count(*) AS TOTAL_APPLICANTS,
SUM(CASE WHEN LOAN_STATUS='Y'
THEN 1 ELSE 0 END) AS APPROVED, 
(SUM(CASE WHEN LOAN_STATUS='Y'
THEN 1 ELSE 0 END) * 100.0 / COUNT(*))
AS APPROVAL_PERCENTAGE 
FROM LOAN_APPROVAL_DATASET
GROUP BY EMPLOYMENT_STATUS
ORDER BY APPROVAL_PERCENTAGE DESC;

-- APPROVAL PERCENTAGE BY PROPERTY OWNERSHIP
SELECT Loan_Purpose, 
COUNT(*) AS TOTAL_APPLICANTS,
SUM(CASE WHEN LOAN_STATUS='Y'
THEN 1 ELSE 0 END) AS APPROVED,
(SUM(CASE WHEN LOAN_STATUS= 'Y'
THEN 1 ELSE 0 END) *100.0/ COUNT(*))
AS APPROVAL_PERCENTAGE
FROM loan_approval_dataset
GROUP BY LOAN_PURPOSE
ORDER BY APPROVAL_PERCENTAGE DESC;

-- AVERAGE LOAN AMOUNT OF APPROVED APPLICANTS

SELECT round(AVG(LOAN_AMOUNT), 2) AS AVG_LOAN_AMOUNT_APPROVED
FROM loan_approval_dataset
WHERE LOAN_STATUS = 'Y';

-- AVERAGE CREDIT STATUS OF APPROVED VS REJECTED APPLICANTS
SELECT LOAN_STATUS,
ROUND(AVG(CREDIT_SCORE), 2) AS 
AVG_CREDIT_SCORE
FROM loan_approval_dataset
GROUP BY loan_status;
