-- DATA CLEANING
-- Changing the data and time column to a standard date and time format
UPDATE transactions
SET `date` = STR_TO_DATE(`date`,"%d/%m/%Y"),
	`time` = STR_TO_DATE(`time`,"%h:%i:%s%p");

-- changing the datatype FEROM TEXT to DATE datatype 
ALTER TABLE transactions
MODIFY COLUMN `date` DATE;

ALTER TABLE transactions
MODIFY COLUMN `time` TIME;

-- REMOVING PIN CODE IN THE DATASET
ALTER TABLE transactions
DROP COLUMN PIN_Code;

--   ------------------ANALYSIS
-- total transaction monitoring by customers
-- there was a total of 1000 transactions in the dataset
SELECT COUNT(Transaction_id) AS total_transactions 
FROM transactions
;

-- total money moved 
-- in the dataset there were total of $771165.29 moved 
SELECT CONCAT('$',SUM(Transaction_Amount) )AS total_money_moved
FROM transactions;


-- transaction volume over year, and total transactions over the months in each year
-- in the dataset all transactions took place in 2025 only so the total transactions was 1000
SELECT YEAR(`date`) AS `date`, COUNT(Transaction_ID) AS transaction_count
FROM transactions
GROUP BY YEAR(`date`);


-- AVERAGE TRANSACTION AMOUNT
-- The total amount of transaction performed in the dataset was $771.17
SELECT CONCAT("$",ROUND(AVG(transaction_amount), 2)) Avg_transaction
FROM transactions;

-- TOP SENDERS IDENTIFICATION AND FRAUD FLAG COUNT
-- the top 1 sender in the dataset are have the total transaction amount of $2757.77 but all the transactions were all flagged including the least sender 
-- which indicates that the fraud is not determined by the highest sender 

SELECT *, COUNT(*) AS _fraud_flag_count
FROM 
		(SELECT Sender_ID, CONCAT("$",Transaction_Amount) AS total_transactions, transaction_count,
		RANK() OVER(ORDER BY Transaction_Amount DESC) AS ranking
		FROM 
				(SELECT sender_id, SUM(transaction_amount) AS transaction_amount,COUNT(Transaction_ID) AS transaction_count
				FROM transactions
				GROUP BY Sender_ID) AS sub1 )AS sub
                GROUP BY Sender_ID;
				
-- FLAGGED TRANSACTIONS 
-- trying to bring out the list of flagged transaction showing the sender and receiver of the transaction
SELECT transaction_id,Sender_ID, Receiver_ID, Transaction_Type, Fraud_Flag
FROM transactions
WHERE Fraud_Flag = 'true';

-- TRANSACTIONS PER HOUR
-- there were total of 983 transactions at 10 oclock and 17 transactions at 11 oclock
-- having just 2 hours of total transactons in the dataset
SELECT HOUR(`time`) AS txn_hour, COUNT(Transaction_ID) AS txn_count
FROM transactions
GROUP BY txn_hour
ORDER BY txn_count DESC
;

-- count of fraudulent transaction
-- out of 1000 total transactions there were total of 481 transactions which were flagged as a fraudulent transactions
SELECT Fraud_Flag, count(*) AS count_fraud_transactions
FROM transactions
GROUP BY Fraud_Flag;


-- fraud by device
-- the count of fraud flag for mobile transaction were total of 267 
-- while the fraud flag count for desktop were  a total of 214
SELECT device_used,
COUNT(Fraud_Flag) AS fraud_flag_count
FROM transactions
WHERE Fraud_Flag = 'TRUE'
GROUP BY device_used
ORDER BY 2 DESC;




-- devices used most by each user
SELECT DISTINCT Sender_ID, Device_Used, num_of_txn
FROM(
	SELECT sender_id, Device_Used, COUNT(Transaction_ID) AS num_of_txn,
	dense_rank() OVER(PARTITION BY Sender_ID, Device_Used ORDER BY COUNT(Transaction_ID)) AS ranking
	FROM transactions
	GROUP BY Sender_ID, Device_Used) ranks
    WHERE ranking = 1;

-- transactions by type
-- counting the total transactions by transaction type which are deposit, withdrawal and transfer
SELECT transaction_type, COUNT(*) AS count_of_transactions
FROM transactions
GROUP BY transaction_type;

-- risk perspective
-- checking the total transactions that were flagged as fraud by transaction type 
-- the query shows that there were 167 Deposit and  170 Transfer and 144 Withdrawal which means that fraud does not depend on the transaction type 
-- since the fraud count are distributed in the three transaction type
SELECT transaction_type, COUNT(*) AS fraud_count
FROM transactions
WHERE Fraud_Flag = 'TRUE'
GROUP BY transaction_type;

-- fraud amount vs non fraud amount
-- the fraud amount in the dataset was $378863.9, while the non fraud amount was $392301.39
SELECT fraud_flag, CONCAT('$',ROUND(SUM(transaction_amount),2)) AS fraud_amount
FROM transactions
GROUP BY Fraud_Flag;


-- suspicious locations
-- checking to know the location with high fraud_count and with the query it is known that the highest fraud count was 21 and the location was 51.5074 N -118.2437 W
SELECT latitude, longitude, COUNT(*) AS fraud_count
FROM transactions
WHERE Fraud_Flag = 'true'
GROUP BY latitude, longitude
ORDER BY 3 DESC;


-- successful vs failed transaction
-- there were total of 513 failed transaction and 487 successfull transactions this is also a red flag for a banking system 
-- which needs and investigation to impove the sytem for the user for better performance
SELECT transaction_status, COUNT(*) AS txn_count
FROM transactions
GROUP BY Transaction_Status;


-- successful vs failed Transaction_Amount
-- the total value of successful transaction amount is slightly fewer than the failed transaction 
-- which is a red flag and neeeds to be investigated mostly with the system for better performance 
SELECT transaction_status, CONCAT('$',ROUND(SUM(transaction_amount),2)) AS total_txn_amount
FROM transactions
GROUP BY Transaction_Status
ORDER BY 2 DESC;


-- average latency by networ slice
-- this shows that slice 2 performs faster transactions compared to slice 1 and slice 3 meaning that it is advisable for most transactions to beg
-- directed to slice 2 for faster transactions
SELECT Network_Slice_ID, AVG(`Latency(ms)`)
FROM transactions
GROUP BY Network_Slice_ID;


-- Network slice with highest succcessful transaction values
-- slice 2 outperforms slice 1 and slice 3 in latency and also handled most of the transactions 
-- since it is faster and also processed munch transaction it is advisable to direct 
-- most transactions to slice 2 
SELECT network_slice_id, COUNT(*) AS total_txn
FROM transactions
GROUP BY Network_Slice_ID
ORDER BY 2 DESC;

