# Database 
CREATE DATABASE Portfolio_project;
USE Portfolio_project;

# Table 
CREATE TABLE transactions (
step INT,
type VARCHAR(20),
amount DOUBLE,
nameOrig VARCHAR(50),
oldbalanceOrg DOUBLE,
newbalanceOrig DOUBLE,
nameDest VARCHAR(50),
oldbalanceDest DOUBLE,
newbalanceDest DOUBLE,
isFraud INT,
isFlaggedFraud INT
);

# Data Load
LOAD DATA LOCAL INFILE '/Users/satyashreet/Downloads/fraud-detection-portfolio/PS_20174392719_1491204439457_log.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select count(*) from transactions;
SELECT * FROM transactions LIMIT 10;

-------------------------------------------------------------------------------------------

# Explaratory Data Anlysis:

# 1️⃣ Total transactions, total frauds, total flagged:
-- Total transactions
SELECT COUNT(*) AS total_transactions FROM transactions;

-- Total fraud transactions
SELECT COUNT(*) AS total_fraud FROM transactions
WHERE isFraud = 1;

-- Total flagged by system
SELECT COUNT(*) AS total_flagged FROM transactions
WHERE isFlaggedFraud = 1;

# 2️⃣ Fraud and Flagged Fraud by Transaction Type:
SELECT 
    type,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_count,
    SUM(isFlaggedFraud) AS flagged_count,
    ROUND(SUM(isFraud)/COUNT(*)*100,2) AS fraud_percent,
    ROUND(SUM(isFlaggedFraud)/COUNT(*)*100,2) AS flagged_percent
FROM transactions
GROUP BY type
ORDER BY fraud_count DESC;

# 3️⃣ Top Origin Accounts Causing Fraud:
SELECT 
    nameOrig,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_count
FROM transactions
GROUP BY nameOrig
HAVING fraud_count > 0
ORDER BY fraud_count DESC
LIMIT 10;

# 4️⃣ Top Destination Accounts Receiving Fraud:
SELECT 
    nameDest,
    COUNT(*) AS total_received,
    SUM(isFraud) AS fraud_received
FROM transactions
GROUP BY nameDest
HAVING fraud_received > 0
ORDER BY fraud_received DESC
LIMIT 10;

# 5️⃣ Transaction Amounts — Fraud vs Non-Fraud:
SELECT 
    isFraud,
    COUNT(*) AS count_transactions,
    ROUND(AVG(amount),2) AS avg_amount,
    ROUND(MAX(amount),2) AS max_amount,
    ROUND(MIN(amount),2) AS min_amount
FROM transactions
GROUP BY isFraud;

# 6️⃣ Step-wise Fraud Frequency:
SELECT 
    step,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_count,
    SUM(isFlaggedFraud) AS flagged_count
FROM transactions
GROUP BY step
ORDER BY step;

# 7️⃣ High-Risk Transactions — Amount > Old Balance:
SELECT 
    COUNT(*) AS suspicious_transactions
FROM transactions
WHERE amount > oldbalanceOrg AND isFraud = 1;




















