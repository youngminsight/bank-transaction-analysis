# Transaction Analysis Project

## Objective
Analyze transaction data to understand customer behavior, transaction patterns, system performance, and potential risks like fraud or transaction failures.

## Dataset
- Source: Kaggle (synthetic dataset)  
- Records: 1,000 unique transactions  
- Columns: `Transaction_id`, `Sender_id`, `Receiver_id`, `Transaction_amount`, `Transaction_type`, `Date`, `Time`, `Transaction_status`, `Fraud_flag`, `Latitude`, `Longitude`, `Device_used`, `Network_slice_id`, `Latency(ms)`, `Slice_bandwidth(mbps)`

## Data Cleaning
- Standardized date column  
- Removed unnecessary `pin code` column  
- Fixed incorrect data types  
- Verified dataset has no missing values  

## Tools & Methodology
- **SQL**: querying and aggregation  
- **Power BI**: visualization and dashboards  
- Focused analysis on transaction trends, customer activity, fraud patterns, and system performance

## Key Findings
- Total money moved: **$771,165.29**  
- ~**49% transactions flagged** (extremely high for real banking scenarios)  
- Fraud flag distribution by device: 55.5% mobile, 44.4% desktop  
- Fraud flag distribution by transaction type: Deposit (167), Transfer (170), Withdrawal (144)  
- Failed transactions exceeded successful ones → potential system issues  
- Network latency had minor impact; Slice2 processed the highest transactions despite lowest latency  

## Business Impact
- High failed transaction volume → poor customer experience & revenue loss  
- Distributed fraud risk → need for system-wide monitoring  
- Misidentifying latency as root cause → inefficient resource allocation  

## Recommendations
- Review fraud detection rules to avoid over-flagging legal transactions  
- Investigate locations with high fraud flags to reduce risk  
- Monitor systems to detect causes of high failed transactions  

## Limitations
- Synthetic dataset → values may be extreme; interpret findings as indicative, not definitive  

## Conclusion
The project highlights transaction patterns, system performance issues, and risk exposure. Latency is not the main cause of failures; operational factors play a bigger role. Insights provide a foundation for improving efficiency and risk management.

## Dashboards

### Transaction Dashboard 1
![Transaction Dashboard 1](images/transaction-dashboard1.png)

### Transaction Dashboard 2
![Transaction Dashboard 2](images/transaction-dashboard2.png)

### Transaction Dashboard 3
![Transaction Dashboard 3](images/transaction-dashboard3.png)
