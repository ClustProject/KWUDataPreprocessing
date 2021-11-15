# KWUDataPreprocessing

# **1. Data** #
## **1-1. AFDB** ##
- Atrial Fibrillation Patients ECG data
## **1-2. CHF** ##
- Chronic Heart Failure Patients ECG data
## **1-3. Healthy** ##
- Healthy group contianing Young and elderly ECG data

---

# **2. preproc.m** #
> It includes load dataset, Preprocessing and Extract RR intervals from ECG data

## **2-1. section** ##
- Set Data location path and Initialize Sampling Freq.

## **2-2. section** ##
- Load CHF, AF, HEALTHY ECG data

## **2-3. section** ##
> Preprocessing
1. Find R-peaks using Pan and Tompkins Algorithms and Extract RR intervals
2. Remove abnormal RRI
3. Remove outliers
