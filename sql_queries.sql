-- STEP 1: Statistical Calculation
SELECT 
    AVG(SedentaryMinutes) / 60 AS avg_sedentary_hours,
    AVG(VeryActiveMinutes + FairlyActiveMinutes) AS avg_high_intensity_minutes
FROM `nifty-yeti-492810-d4.bellabeat_data.dailyActivity_merged`;
