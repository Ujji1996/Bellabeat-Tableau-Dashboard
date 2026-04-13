-- STEP 1: Statistical Calculation
SELECT 
    AVG(SedentaryMinutes) / 60 AS avg_sedentary_hours,
    AVG(VeryActiveMinutes + FairlyActiveMinutes) AS avg_high_intensity_minutes
FROM `nifty-yeti-492810-d4.bellabeat_data.dailyActivity_merged`;


-- STEP 2: User Categorization
SELECT 
    Id,
    COUNT(ActivityDate) AS days_tracked,
    CASE 
        WHEN COUNT(ActivityDate) >= 25 THEN 'Active User'
        WHEN COUNT(ActivityDate) BETWEEN 15 AND 24 THEN 'Moderate User'
        ELSE 'Light User'
    END AS user_type
FROM `nifty-yeti-492810-d4.bellabeat_data.dailyActivity_merged`
GROUP BY Id
ORDER BY days_tracked DESC;

-- STEP 3: Data Preparation & Multi-Table Join

WITH daily_sleep AS (
    SELECT 
        Id,
        PARSE_DATE('%m/%d/%Y', SPLIT(date, ' ')[OFFSET(0)]) AS sleep_date,
        COUNT(value) AS total_minutes_asleep
    FROM `nifty-yeti-492810-d4.bellabeat_data.minuteSleep_merged`
    WHERE value = 1
    GROUP BY Id, sleep_date
),

daily_weight AS (
    SELECT 
        Id,
        PARSE_DATE('%m/%d/%Y', SPLIT(Date, ' ')[OFFSET(0)]) AS weight_date,
        WeightKg,
        BMI
    FROM `nifty-yeti-492810-d4.bellabeat_data.weightLogInfo_merged`
)

SELECT 
    A.Id,
    A.ActivityDate,
    A.TotalSteps,

    (A.VeryActiveMinutes + A.FairlyActiveMinutes + A.LightlyActiveMinutes) 
        AS total_active_minutes,

    S.total_minutes_asleep,
    W.WeightKg,
    W.BMI

FROM `nifty-yeti-492810-d4.bellabeat_data.dailyActivity_merged` AS A

LEFT JOIN daily_sleep AS S
    ON A.Id = S.Id 
    AND A.ActivityDate = S.sleep_date

LEFT JOIN daily_weight AS W
    ON A.Id = W.Id 
    AND A.ActivityDate = W.weight_date;
