# New Chemistry indicator

## Intro 

There are currently two main problems to check the progress in the chemistry related area in power plants. Firstly, the CPI does not clearly reflect any significant parameter deviations because the result is always very close to 1.00; secondly, CPI has 14 limitation value groups for 10 calculations. For the CPI calculation unification and to improve chemistry control at the NPPs the following changes should be implemented.

## Data collection

These data elements collect information on several key primary and secondary chemistry parameters.  The data elements collected are typically based on time outside threshold values, along with the maximum value of the parameter during the month.  CEI-W data elements must be reported at least quarterly for a unit when the unit is operated at power levels above the specified value or when the reactor coolant system temperature is above the specified value for the element any time during the month (even if less than a full day).  Specific unit power levels and reactor coolant system temperatures are identified in the applicable reactor type section.

The manual starts with some general definitions, some generic rules of usage for submitting data, and some common pitfalls in gathering and submitting data.  Then the reactor group parameters are listed separately.  These sections will describe for that specific reactor group the parameters to be collected sorted by when the collect of data is required to be started depending on reactor temperature or power level.  It is key to ensure that the correct section is used to determine compliance with the data elements manual.

### General Definitions

A day is a 24-hour period extending from midnight to midnight (however, portions of a day are included in data reporting when power and temperature requirements for the CEI-W monthly data elements are met and data is generated).  For consistency in comparison and accuracy of data, it is recommended that on-line monitor data be used at normal recording frequency under normal chemistry conditions.  When an on-line parameter is noted to be nearing or exceeding the defined level one threshold (L-1) value, the monitor readings should be closely examined to report the highest value recorded by the on-line monitor as the maximum value.  The reported value for multiple train locations (such as steam generator blowdown or feedwater train) is the measured maximum value for any train.  For the hours above L-1 values, report the total time any train is above the L-1 value for the parameter.  For example, if SG-A was above L-1 for sodium from 01:15 until 05:15 (4 hours) and SG-B was above L-1 for sodium from 02:15 until 06:15 (4 hours), the hours > L-1 for sodium for this time period would be reported as 5 hours (duration of time above L-1 was from 01:15 until 06:15).

#### Reporting of Values Less Than Lowest Measurable Level

Values that are less than the lowest measurable level are reported as equal to the limit of quantification (LOQ).  The limit of quantification is defined as the lowest concentration of a parameter that must be present before the measurement of that concentration is considered a quantitative result.  Not reporting a value for a parameter for the month will result in no CEI-W value being calculated for the unit and a loss of CEI-W points for that condition.  

#### Chemistry Analysis Equipment Problems

Basic rules for reporting data when the parameter analytical equipment is OOS or not available:

- The last data point reported can be used for up to 28 days unless the unit goes below the power level requirement (that is, < 10 % for BWR or < 30 % for PWR).
- If the last data point is above L-1 value, duration hours continue to accumulate until an analysis is provided to show that the parameter is less than L-1 value.
- If the 28-day analysis grace period crosses a month, the same reported value being used at the end of the previous month is used.  The duration time for a value greater than L-1 resets at the first of the month and then continues until analysis shows the parameter is less than L-1 value.
- After the 28th day, the reported value (max value) is reported as one significant digit greater than L-1 value (for example, if FW iron L-1 value is 5.00 ppb, the value reported is 5.01 ppb).  This value is called the _Penalty Value_ (for long-term unavailable key analytical equipment).  Duration hours continue to accumulate until analysis shows the parameter is less than L-1 value.
- If the unit is reduced below mode-1 operation and the analytical problem is not resolved by the time the parameter is required to be reported, the _Penalty Value_ must be reported and the duration hours begin (or resume) for that month until analysis capability is restored to show less than L-1 value exists.  This also applies if the analytical problem did not exist before the outage but was not available after the outage.
- The maximum value reported for the month is the largest value of either the highest measured value for the month or the _Penalty Value_. 
- The duration time is the summation of all hours when analysis values are greater than L-1 plus the hours that the _Penalty Value_ had to be used.
_Note:  For feedwater metals, the reported value and duration time starts when the filters are placed in service and ends when the next set of filters is placed in service._

### CEI-W Calculations

Monthly Chemistry Effectiveness Indicator (CEI-W) data element values will be averaged to obtain a reported rolling cycle Chemistry Effectiveness Indicator result (12, 18, or 24-month cycle).

#### Common errors and misconceptions

1.	Some stations may have reported quarterly values or rolling three-month values as monthly data.  This is incorrect.  By including data over a longer time period, the effects of chemistry excursions are masked to a greater extent.  Because these excursions can have a significant effect on a plant, it is mandatory to identify them monthly (on the day(s) they occur).  (Some of the confusion comes from differences between the INPO and the WANO definitions.  This indicator was initially developed and used in the U.S.  U.S. data has always been collected on a monthly basis.  Later, WANO adopted many of the U.S. indicators.  At that time, WANO allowed less frequent reporting in order to obtain a higher level of participation worldwide.).  Now data will be collected monthly and reported at least quarterly.

2.	At some stations, personnel have erroneously believed that following a startup they should only include samples (especially metal transport data) taken after the plant chemistry values have stabilized.  This is incorrectone of the objectives is to monitor chemistry excursions during startup after the required power levels are reached.  Corrosion product samples should be initiated at the correct power level as indicated in the appropriate reactor type section of this manual.

3.	Some stations assume that if they only operated a portion of a day and had been shut down the rest of the month, that portion of a day did not count for CEI-W data collection.  This is incorrect.  If any time during the month the power or temperature requirements for a monthly CEI-W data element are met, then data must be collected and reported.

### Reactor Type Groups

| Group | Reactors 
|---|---
|Group A	|BWR / LWCGR 
|Group B	|PWR (RSG) / PHWR / VVER / Fast Breeder
|Group C	|PWR (OTSG)
|Group D	|AGR / GCR / Magnox

Each group will report data using set of chemistry parameters that are applicable to their station design.  For these chemistry parameters, the threshold limit is set for all plants reporting the parameter at the most conservative value across the nuclear fleet.  However, quartile values will be established based on plant type for comparison of performance.  For example, the median CEI-W value.

#### Group A

Specific Sampling Requirements
For this reactor group three feedwater parameters and five reactor coolant parameters are required monthly.

At all times the reactor coolant system is greater than 200 degrees Fahrenheit (93 Celsius)

- RCS Cover Gas unavailability

At all times the reactor above 10% power

- Feedwater Iron  ppb
- Feedwater Copper ppb 
- Feedwater Dissolved Oxygen ppb
- RCS Chloride ppb
- RCS Sulfate ppb
- RCS ECP values SHE
- RCS Conductivity uS/cm
- RCS Hydrogen Availability
 
##### At all times that reactor coolant temperature is greater than 200 degrees Fahrenheit (93 Celsius) | Number of Hours RCS > 200F (93C) | This is the total hours that the reactor coolant system was greater than 200F during the month. Hours when reactor coolant system is greater than 200F are reported to the nearest 0.1 hours. If the reactor coolant system does not exceed 200F any time during the month, enter 0.0 and select “Final” for the status.

###### Hours RCS Hydrogen Unavailable When > 200 F (93 C)

This is the total hours that the reactor coolant system was greater than 200F during the month.

Hours when reactor coolant system is greater than 200F are reported to the nearest 0.1 hours.

If the reactor coolant system does not exceed 200F any time during the month, enter 0.0 and select “Final” for the status.

###### Hours RCS Hydrogen Unavailable When > 200 F (93 C)

Hydrogen unavailability is calculated based on both the time at temperatures > 200F where the ECP of stainless steel is < - 230 mV (SHE) and the reactor water conductivity is < L-1 limit, which can be corrected for Fe and Zn.

For conductivity transients exceeding 24 hours, only the time in excess of 24 hours for each transient needs be considered when calculating unavailability.  It is not appropriate to exclude any amount of time of interrupted hydrogen injection when calculating hours unavailable.

For moderate HWC plants if ECP probe measurements are not available, secondary parameters such as molar ratio or dissolved oxygen measurements may be used to verify the limits established by the VIA modeled values for these secondary parameters have been obtained to ensure ECP < -230 mV (SHE).

This is the summation of all hours that hydrogen is not providing the required protection based on ECP or oxygen requirements during the month for the time that the reactor coolant system temperature is > 200F.

Because the stations have not developed a method for getting hydrogen in service at 200 degrees, some unavailability is expected to be reported for each unit shutdown/startup period.

All occurrences are added together for the month for a total number of hours that hydrogen is not providing mitigation.

##### At all times that reactor is at greater than 10% power (RUP)

###### Peak ECP SHE

This is the highest (least negative) value for ECP when reactor power is > 10% power during the month.

Moderate hydrogen water chemistry plants may run the BWRVIA model quarterly for ECP results if an ECP monitor is not available.

If the unit is not operated at or above 10% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Number of Hours ECP > -350 SHE

An effective noble metal electrochemical potential (ECP) monitor is defined as a monitor that has been on line at the proper flow and temperature (if ECP is located in the MMS) when reactor power is greater than 10% and reading a corrosion potential < -350 mV standard hydrogen electrode (SHE) value.

Moderate hydrogen water chemistry plants may run the BWRVIA model quarterly for ECP results if an ECP monitor is not available.

This is the summation of all hours that:

- For noble chemistry plants the ECP monitor is not available when reactor power is > 10% power
- the ECP monitor readings are > -350 mV SHE during the month when reactor power is greater than 10%
- total number of hours that temperature or flow failed to meet vendor-specified limits (if ECP is located in the MMS).

Hours are reported to the nearest 0.1 hours. 

If the reactor power does not exceed 10% any time during the month, enter 0.0 and select “Final” for the status.

###### Feedwater Iron Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.

All occurrences are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours.

Elevated sample values during startups and transients are expected to be included in the computed hours greater than L-1 when power is at or above 10%, except for those hours reported during the seven-day period following an outage going below mode-1 that are reported by Feedwater Iron Duration hours after an outage for the month.

When a plant trips, the corrosion product filters should be changed out as soon as possible and the analysis should be reported in the monthly data.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated at or above 10% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Iron Peak ppb

Feedwater iron concentration is normally obtained based on a seven-day integrated value.

For plants whose feedwater has a high concentration of metal transport, this may not be feasible.  Integrated values obtained on a frequency of less than seven days may be used.

The value reported is the maximum value measured in ppb during the month, reported to the nearest 0.001 ppb (not averaged with other measurements, and not power adjusted).

Elevated sample values during transients are expected to be included in the computed hours greater than L-1 when power is > 10%.  A stabilization time nor a grace before entering AL-1 applies for reporting feedwater metals.  Collection and reporting begin when the power requirements above are met.

The peak value during the seven-day period following a refueling outage that is reported as the Feedwater Iron Peak after an outage going below mode-1 is excluded from the values used to determine the maximum Feedwater Iron value measured in ppb during the month.  Before or after the seven-day outage period, the maximum peak value is reported for the month.  If the only period of operation during the month with power >10 percent the seven-day period following an outage, report a value of 0.000 and select “Final” for Status.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated at or above 10% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Iron Duration hours Power and Time Weighted After a shutdown below mode-1

This is the summation of hours that feedwater iron was above L-1 S/U limit during the first seven days after initially reaching 10% power after startup from an outage going to below mode-1.  Power and Time weight averaging over the seven-day sample integration period following power escalation from less than mode-1 may be used for calculation of peak ppb and duration hours in accordance with the following:

1.	Take power readings every two hours starting at 10% power.
2.	The power/time weighted average ppb for each sample (when the corrosion product filter is changed out) is the average power (percent power, times the time for each power reading, divided by the total time) while the sample filter has been in use, times the analyzed ppb results for the sample.
3.	Multiply the power/time weighted average ppb for the sample by the percent of the week (time the sample was in service divided by 168 hours) to get the corrected value.
4.	Sum all the corrected values for the samples during the week to get the reported ppb value
5.	The duration hours to report is determined by summing all the hours that for the samples during the startup week that exceeded the L-1 S/U limit.

Hours above the L-1 S/U limit are reported to the nearest 0.1 hours.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1 S/U limit, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1 S/U limit, hours >L-1 S/U limit will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

Only report a value for the first seven days of operation at or above 10% power after the completion of an outage.  For all other months, enter 0.0 and select “Final” for the status.

###### Feedwater Copper Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.  
All occurrences are added together for a total number of hours > L-1 limit.  Hours above the L-1 limit are reported to the nearest 0.1 hours.

Elevated sample values during transients are expected to be included in the computed hours greater than L-1 when power is at or above 10%. 

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated at or above 10% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Copper Peak ppb 

Feedwater copper concentration is normally obtained based on a seven-day integrated value.

For plants whose feedwater has a high concentration of metal transport, this may not be feasible.  Integrated values obtained on a frequency of less than seven days may be used.

The value reported is the maximum value measured in ppb for the month, reported to the nearest 0.001 ppb.

Elevated sample values during transients are expected to be included in the computed hours greater than L-1 when power is > 10%.  A stabilization time nor a grace before entering AL-1 applies for reporting feedwater metals.  Collection and reporting begin when the power requirements above are met, even for periods of time less than a full day.

The peak value during the seven-day period following a refueling outage that is reported as the Feedwater Copper Peak after an outage below mode-1 is excluded from the values used to determine the maximum Feedwater Copper value measured in ppb during the month.  After the seven-day outage period, the normal peak value is reported for the month.  If the only period of operation during the month with power > 10 percent is the seven-day period following an outage, report a value of 0.000 and select “Final” for Status.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated at or above 10% power at any time during the month, leave the value blank and select “Final-DN” for the status. 

###### Feedwater Copper Duration hours Power and Time Weighted following a shutdown below mode-1 

This is the summation of all hours that feedwater copper was above L-1 S/U limit during the first seven days after initially reaching 10% power after startup from an outage going below mode-1.  Power and Time weight averaging over the seven-day sample integration period following power escalation from less than mode-1 may be used for calculation of peak ppb and duration hours in accordance with the following:

1.	Take power readings every two hours starting at 10% power.
2.	The power/time weighted average ppb for each sample (when the corrosion product filter is changed out) is the average power (percent power, times the time for each power reading, divided by the total time) while the sample filter has been in use, times the analyzed ppb results for the sample.
3.	Multiply the power/time weighted average ppb for the sample by the percent of the week (time the sample was in service divided by 168 hours) to get the corrected value.
4.	Sum all the corrected values for the samples during the week to get the reported ppb value
5.	The duration hours to report is determined by summing all the hours that for the samples during the startup week that exceeded the L-1 S/U limit.

Hours above the L-1 S/U limit are reported to the nearest 0.1 hours.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1 S/U limit, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 
  
For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1 S/U limit, hours >L-1 S/U limit will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

Only report a value for the first seven days of operation at or above 10% power units after the completion of a refueling outage.  For all other months, enter 0.0 and select “Final” for the status.

###### Feedwater Dissolved Oxygen Duration hours > L-1

This is the summation of all hours that this parameter was above the specified L-1 limit when power is at or greater than 10% units during the month.

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours.

If the unit is not operated at or above 10% power any time during the month, enter 0.0 and select “Final” for the status.

###### Feedwater Dissolved Oxygen Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.001 ppb.

Zero is not an acceptable value.

Note:  For short oxygen spikes above L-1, the peak value reported may be based on the time-weighted average value of oxygen over the first 30 minutes after exceeding L-1 and can be used in calculating duration hours.  This is normally due to an electronic spike or an air bubble going through the monitor and not representative of actual chemistry conditions and should not have an effect on steam generator chemistry. 

If the plant is not operated at or greater than 10% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### RCS Chloride Duration hours > 1 ppb

This is the summation of all hours that this parameter was above the L-1 limit during the month when the plant is operated above 10% power.

A 24-hour grace period is given for reporting the duration hours for chloride peak > L-1 limit after a unit has reached 10% power after a startup and Plant Mode change to Mode-1.

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above L-1 limit are reported to the nearest 0.1 hours.

If the unit is not operated above 10% power at any time during the month, enter 0.0 and select “Final” for the status.

###### RCS Chloride Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.01 ppb.

Zero is not an acceptable value.

If the unit is not taken operated above 10% power units at any time during the month, leave the value blank and select “Final-DN” for the status. 

###### RCS Specific Conductivity Duration hours > L-1

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours.

If the unit is not operated above 10% power at any time during the month, enter 0.0 and select “Final” for the status.

###### RCS Specific Conductivity Peak

This is the maximum value measured for reactor water specific conductivity during the month in uS/cm at 25 +/- 3 degrees C.

The maximum value is reported to the nearest 0.01 uS/cm corrected to 25C.

Reported conductivity values may be adjusted for the presence of iron and zinc concentrations using the following equation:

Reported conductivity = measured conductivity – ((calculated conductivity with Fe & Zn) – (calculated conductivity without Fe & Zn))

If the unit is not operated above 10% power at any time during the month, leave the value blank and select “Final-DN” for the status. 

###### RCS Sulfate Duration hours > L-1

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours.

If the unit is not operated above 10% power at any time during the month, enter 0.0 and select “Final” for the status.

###### RCS Sulfate Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.01 ppb.

Zero is not an acceptable value.

If the unit is not operated above 10% power units at any time during the month, leave the value blank and select “Final-DN” for the status. 

#### Group B

Specific Sampling Requirements

For this reactor type group six feedwater parameters and five reactor coolant parameters are required monthly.

At all times the reactor is critical

- RCS Chloride ppb
- RCS Fluoride ppb
- RCS Sulfate ppb

At all times the reactor is is in Mode 1 Power Operations

- RCS Cover Gas availability
- RCS LiOH/KOH control

At all times the reactor above 30% power

- Feedwater Copper ppb 
- Feedwater Iron ppb

At all times the reactor above the Midpower Value (MPV)

- SG Chloride in ppb
- SG Sodium in ppb
- SG Sulfate in ppb 
- Feedwater Dissolved Oxygen ppb

Mid-Power Value Guidance for PWR RSG

PWR RSG units shall establish and document a midpower value (MPV) at which monitoring of steam generator impurities will commence in the unit Strategic Water Chemistry Plan.  The MPV shall be established as low as possible in the range of 30% to 50% power (if MPV has not been established, use 30% power as the reporting threshold).  Each unit is responsible for documenting the technical justification for the specific MPV chosen in the Strategic Water Chemistry Plan for the unit.  Refer to the EPRI _Secondary Water Chemistry Guidelines_ for further information and guidance on establishing the MPV.

##### At all times that the reactor is critical

###### RCS Chloride Duration hours > L-1

This is the summation of all hours that this parameter was above the specified L-1 limit during the month when the plant is taken critical (Mode-1).

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours.

If the unit is not taken critical at any time during the month, enter 0.0 and select “Final” for the status.

###### RCS Chloride Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.01 ppb.

Zero is not an acceptable value.

If the unit is not taken critical at any time during the month, leave the value blank and select “Final-DN” for the status. 

###### RCS Fluoride Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours.

If the unit is not taken critical at any time during the month, enter 0.0 and select “Final” for the status.

###### RCS Fluoride Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.01 ppb.

Zero is not an acceptable value.

If the unit is not taken critical at any time during the month, leave the value blank and select “Final-DN” for the status. 

###### RCS Sulfate Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours.

If the unit is not taken critical at any time during the month, enter 0.0 and select “Final” for the status.

###### RCS Sulfate Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.01 ppb.

Zero is not an acceptable value.

If the unit is not taken critical at any time during the month, leave the value blank and select “Final-DN” for the status. 

##### At all times that the reactor is in mode one power operations

###### Outside RCS Cover Gas Control Band hours 

This is the summation of all hours that this parameter was outside the station selected specified cover gas control limits during the month when the unit is operated in mode-1.

All occurrences are added together for a total number of hours outside the specified control limits.

Hours outside the specified control limits are reported to the nearest 0.1 hours.
For Hydrogen cover gas stations:
Hydrogen may be reduced to 15 cc/kg within 48 hours before shutdown without reporting these hours as out of limit hours.  (These 48 hours will not be counted as hours outside control limits.)

During unit startup, hours outside the specified control limits start to accumulate after:

- 24 hours of entering Mode-1 for 25 to 50 cc/kg
- 72 hours of entering Mode-1 for 30 to 50 cc/kg

For all stations:

If the unit is not operated in Mode-1 at any time during the month, enter 0.0 and select “Final” for the status.

###### Outside RCS Lithium/Potassium Hydroxide Control Band Duration hours

This is the summation of all hours that this parameter was outside the station selected specified control limits for controlling RCS pH during the month when the unit is operated in mode-1.

All occurrences are added together for a total number of hours outside the specified control limits 

During unit startup, out-of-spec hours outside the specified control limits start to accumulate 72 hours after entering Mode-1 or at xenon equilibrium, whichever occurs first after a unit startup.

Hours outside the specified control limits are reported to the nearest 0.1 hours.

In addition to the normal operating limits, during shutdown hours for out-of-specification will accumulate during the 24 hours prior to shutdown when pH is < 6.5, and at all other times with the unit critical and pH is < 7.0.

If the unit is not operated in Mode-1 at any time during the month, enter 0.0, and select “Final” for the status.

##### At all times that the reactor is above 30% power

###### Feedwater Copper Duration hours > L-1

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.

All occurrences are added together for a total number of hours > L-1 limit.  Hours above the L-1 limit are reported to the nearest 0.1 hours.

Elevated sample values during transients are expected to be included in the computed hours greater than L-1 when power is above 30% power.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Copper Peak ppb 

Feedwater copper concentration is normally obtained based on a seven-day integrated value.

For plants whose feedwater has a high concentration of metal transport, this may not be feasible.  Integrated values obtained on a frequency of less than seven days may be used.

The value reported is the maximum value measured in ppb for the month, reported to the nearest 0.001 ppb.

Elevated sample values during transients are expected to be included in the computed hours greater than L-1 when power above 30% .  A stabilization time nor a grace before entering AL-1 applies for reporting feedwater metals.  Collection and reporting begin when the power requirements above are met, even for periods of time less than a full day.

The peak value during the seven-day period following a refueling outage that is reported as the Feedwater Copper Peak after an outage below mode-1 is excluded from the values used to determine the maximum Feedwater Copper value measured in ppb during the month.  After the seven-day outage period, the normal peak value is reported for the month.  If the only period of operation during the month with power >30 percent is the seven-day period following an outage, report a value of 0.000 and select “Final” for Status. 

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Copper Duration hours Power and Time Weighted following a shutdown below mode-1 

This is the summation of all hours that feedwater copper was above L-1 S/U limit during the first seven days after initially reaching 30% for PWR after startup from an outage going below mode-1.  Power and Time weight averaging over the seven-day sample integration period following power escalation from less than mode-1 may be used for calculation of peak ppb and duration hours in accordance with the following:

1.	Take power readings every two hours starting at 30% power.
2.	The power/time weighted average ppb for each sample (when the corrosion product filter is changed out) is the average power (percent power, times the time for each power reading, divided by the total time) while the sample filter has been in use, times the analyzed ppb results for the sample.
3.	Multiply the power/time weighted average ppb for the sample by the percent of the week (time the sample was in service divided by 168 hours) to get the corrected value.
4.	Sum all the corrected values for the samples during the week to get the reported ppb value
5.	The duration hours to report is determined by summing all the hours that for the samples during the startup week that exceeded the L-1 S/U limit. 

Unit Shutdown Occurrence Records and daily Unit Power levels reported to the NRC with the morning report are used to validate appropriate reporting of these values with reactor taken critical as the point of validation.

Hours above the L-1 S/U limit are reported to the nearest 0.1 hours.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1 S/U limit, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1 S/U limit, hours >L-1 S/U limit will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

Only report a value for the first seven days of operation at or above 30% power after the completion of a refueling outage.  For all other months, enter 0.0 and select “Final” for the status.

###### Feedwater Copper Peak Power and Time Weighted following a shutdown below mode-1ppb 

Feedwater copper concentration is normally obtained based on a seven-day integrated value.

For plants whose feedwater has a high concentration of metal transport, this may not be feasible.  Integrated values obtained on a frequency of less than seven days may be used.

The value reported is the maximum value measured in ppb for first seven days after initially reaching 30% units after startup from an outage going below mode-1.  Power and Time weight averaging over the seven-day sample integration period following power escalation from less than mode-1 may be used for calculation of peak ppb and duration hours in accordance with the following:

1.	Take power readings every two hours starting at 30% power.
2.	The power/time weighted average ppb for each sample (when the corrosion product filter is changed out) is the average power (percent power, times the time for each power reading, divided by the total time) while the sample filter has been in use, times the analyzed ppb results for the sample.
3.	Multiply the power/time weighted average ppb for the sample by the percent of the week (time the sample was in service divided by 168 hours) to get the corrected value.
4.	Sum all the corrected values for the samples during the week to get the reported ppb value
5.	The duration hours to report is determined by summing all the hours that for the samples during the startup week that exceeded the L-1 S/U limit.

Report the feedwater copper concentration to the nearest 0.001 ppb.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1 S/U limit, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 
  
For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1 S/U limit, hours >L-1 S/U limit will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

Only report a value for the first seven days of operations at or above 30% power units after the completion of a refueling outage.  For all other months, enter 0.000 and select “Final” for the status.

###### Steam Generator Copper Removal Efficiency % 

For units that add polyacrylic acid (PAA) dispersant to the steam generators, enter the steam generator blowdown copper removal efficiency time-weighted average in percent (xx.x%), calculated by (mass of SGBD Cu)/(mass of FFWCu).

The parameter value to be entered is based on the weekly or monthly time-weighted average value (VT) as defined by the following:

$$VT=\frac{\sum{V_i\cdot\T_i}}{\sum{T_i}}$$

Use whole days in the calculation.

Integrated sampling must be used to obtain a representative sample.  Grab samples are not appropriate for reporting blowdown removal efficiency.

The maximum allowable value for entry is 100%.

If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Iron Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.
	
All occurrences are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours.

Elevated sample values during startups and transients are expected to be included in the computed hours greater than L-1 when power is at or above 30%, except for those hours reported during the seven-day period following an outage going below mode-1 that are reported by Feedwater Iron Duration hours after an outage for the month.

When a plant trips, the corrosion product filters should be changed out as soon as possible and the analysis should be reported in the monthly data.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Iron Peak ppb

Feedwater iron concentration is normally obtained based on a seven-day integrated value.

For plants whose feedwater has a high concentration of metal transport, this may not be feasible.  Integrated values obtained on a frequency of less than seven days may be used.

The value reported is the maximum value measured in ppb during the month, reported to the nearest 0.001 ppb (not averaged with other measurements, and not power adjusted).

Elevated sample values during transients are expected to be included in the computed hours greater than L-1 when power is > 30%.  A stabilization time nor a grace before entering AL-1 applies for reporting feedwater metals.  Collection and reporting begin when the power requirements above are met.

The peak value during the seven-day period following a refueling outage that is reported as the Feedwater Iron Peak after an outage going below mode-1 is excluded from the values used to determine the maximum Feedwater Iron value measured in ppb during the month.  After the seven-day outage period, the normal peak value is reported for the month.  If the only period of operation during the month with power >30 percent is the seven-day period following an outage, report a value of 0.000 and select “Final” for Status.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis.

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Iron Duration hours Power and Time Weighted After a shutdown below mode-1 

This is the summation of hours that feedwater iron was above L-1 S/U limit during the first seven days after initially reaching 30% power after startup from an outage going to below mode-1.  Power and Time weight averaging over the seven-day sample integration period following power escalation from less than mode-1 may be used for calculation of peak ppb and duration hours in accordance with the following:

1.	Take power readings every two hours starting at 30% power.
2.	The power/time weighted average ppb for each sample (when the corrosion product filter is changed out) is the average power (percent power, times the time for each power reading, divided by the total time) while the sample filter has been in use, times the analyzed ppb results for the sample.
3.	Multiply the power/time weighted average ppb for the sample by the percent of the week (time the sample was in service divided by 168 hours) to get the corrected value.
4.	Sum all the corrected values for the samples during the week to get the reported ppb value
5.	The duration hours to report is determined by summing all the hours that for the samples during the startup week that exceeded the L-1 S/U limit.

Unit Shutdown Occurrence Records and daily Unit Power levels reported to the NRC with the morning report are used to validate appropriate reporting of these values with reactor taken critical as the point of validation.

Hours above the L-1 S/U limit are reported to the nearest 0.1 hours.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1 S/U limit, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 
  
For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1 S/U limit, hours >L-1 S/U limit will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

Only report a value for the first seven days of operation at or above 30% power after the completion of an outage.  For all other months, enter 0.0 and select “Final” for the status.

###### Feedwater Iron Peak ppb Power and Time Weighted After a shutdown below mode-1 

Feedwater iron concentration is normally obtained based on a seven-day integrated value.

For plants whose feedwater has a high concentration of metal transport, this may not be feasible.  Integrated values obtained on a frequency of less than seven days may be used.  The value reported is the maximum value measured in ppb for the first seven days after initially reaching 30% after startup from an outage going below mode-1 Power and Time weight averaging over the seven-day sample integration period following power escalation from less than mode-1 may be used for calculation of peak ppb and duration hours in accordance with the following:

1.	Take power readings every two hours starting at 30% power.
2.	The power/time weighted average ppb for each sample (when the corrosion product filter is changed out) is the average power (percent power, times the time for each power reading, divided by the total time) while the sample filter has been in use, times the analyzed ppb results for the sample.
3.	Multiply the power/time weighted average ppb for the sample by the percent of the week (time the sample was in service divided by 168 hours) to get the corrected value.
4.	Sum all the corrected values for the samples during the week to get the reported ppb value
5.	The duration hours to report is determined by summing all the hours that for the samples during the startup week that exceeded the L-1 S/U limit.

Report the feedwater iron concentration to the nearest 0.001 ppb.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1 S/U limit, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 
  
For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1 S/U limit, hours >L-1 S/U limit will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

Only report a value for the first seven days of operation at or above 30% power after the completion of a outage.  For all other months, enter 0 and select “Final” for the status.

###### Steam Generator Iron Removal Efficiency % 

For stations that add polyacrylic acid (PAA) dispersant to the steam generators, enter the steam generator blowdown iron removal efficiency time-weighted average in percent (xx.x%), calculated by (mass of SGBD Fe)/(mass of FFW Fe).

The parameter value to be entered is based on the weekly or monthly time-weighted average value (VT) as defined by the following:

$$VT=\frac{\sum{V_i\cdot\T_i}}{\sum{T_i}}$$

for the period

Use whole days in the calculation.

To encourage the reduction of iron during refueling and startup periods, a level-2 value of 10 ppb has been established for stations using PAA that will be applied to the maximum value reported before applying the PAA removal credit.

Integrated sampling must be used to obtain a representative sample.  Grab samples are not appropriate for reporting blowdown removal efficiency.

The maximum allowable value for entry is 100%.

If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status.

##### At all times that the reactor is above the MPV

###### SG Chloride Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month after reaching MPV.

All occurrence hours are added together for a total number of hours > L-1 limit (the 24 hours grace before entering AL-1 does not apply).

Hours above the L-1 limit are reported to the nearest 0.1 hours.

If the unit is not operated at or above MPV power at any time during the month, enter 0.0 and select “Final” for the status.

###### SG Chloride Peak ppb

This is the maximum value measured for the parameter in units of parts per billion (ppb) during the month after reaching MPV.

The maximum value is reported to the nearest 0.001 ppb.

Zero is not an acceptable value.

If the unit is not operated at or above MPV power at any time during the month, leave the value blank and select “Final-DN” for the status. 

###### SG Sodium Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month after reaching MPV.

All occurrence hours are added together for a total number of hours > L-1 limit (the 24 hours grace before entering AL-1 does not apply).

Hours above the L-1 limit are reported to the nearest 0.1 hours.

If the unit is not operated at or above MPV power at any time during the month, enter 0.0 and select “Final” for the status.

###### SG Sodium Duration hours  > 0.8 ppb

This is the summation of all hours that this parameter was above 0.8 ppb during the month after reaching MPV.

All occurrence hours are added together for a total number of hours > 0.8 ppb; however, a 24-hour grace period is given for reporting the duration hours for sodium peak > 0.8 ppb after a unit has reached MPV after a startup and a Plant Mode change to Mode-1.

Hours above 0.8 ppb are reported to the nearest 0.1 hours.

If the unit is not operated at or above MPV power at any time during the month, enter 0.0 and select “Final” for the status.

###### SG Sodium Peak

This is the maximum value measured for the parameter in units of parts per billion (ppb) during the month after reaching MPV.

The maximum value is reported to the nearest 0.001 ppb.  (Note:  The peak value is reported without the consideration of any grace allowed for duration hours.)

Zero is not an acceptable value.

If the unit is not operated at or above MPV power at any time during the month, leave the value blank and select “Final-DN” for the status. 

###### SG Sulfate Duration hours > L-1

This is the summation of all hours that this parameter was above the specified L-1 limit during the month after reaching MPV.

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours (the 24 hours grace before entering AL-1 does not apply).

If the unit is not operated at or above MPV power at any time during the month, enter 0.0 and select “Final” for the status.

###### SG Sulfate Peak ppb

This is the maximum value measured for the parameter in units of parts per billion (ppb) during the month after reaching MPV.

The maximum value is reported to the nearest 0.001 ppb.

Zero is not an acceptable value.

If the unit is not operated at or above MPV power at any time during the month, leave the value blank and select “Final-DN” for the status. 

###### Feedwater Dissolved Oxygen Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit when power is greater than MPV during the month.

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours.

If the unit is not operated at  greater than MPV power for PWR RSG units at any time during the month, enter 0.0 and select “Final” for the status.

###### Feedwater Dissolved Oxygen Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.001 ppb.

Zero is not an acceptable value.

Note:  For short oxygen spikes above L-1, the peak value reported may be based on the time-weighted average value of oxygen over the first 30 minutes after exceeding L-1 and can be used in calculating duration hours.  This is normally due to an electronic spike or an air bubble going through the monitor and not representative of actual chemistry conditions and should not have an effect on steam generator chemistry. 

If the plant is not operated at greater than MPV power at any time during the month, leave the value blank and select “Final-DN” for the status.

#### Group C

Specific Sampling Requirements

For this reactor type group six feedwater parameters and five reactor coolant parameters are required monthly.

At all times the reactor is critical

- RCS Chloride ppb
- RCS Fluoride ppb
- RCS Sulfate ppb

At all times the reactor is is in Mode 1 Power Operations

- RCS Cover Gas availability
- RCS LiOH / KOH

At all times the reactor above 30% power

- Feedwater Copper ppb 
- Feedwater Iron ppb
- Feedwater Dissolved Oxygen ppb
- Feedwater Chloride in ppb
- Feedwater Sodium in ppb
- Feedwater Sulfate in ppb

##### At all times that the reactor is critical

###### RCS Chloride Duration hours > L-1

This is the summation of all hours that this parameter was above the specified L-1 limit during the month when the plant is taken critical (Mode-1).

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours.

If the unit is not taken critical at any time during the month, enter 0.0 and select “Final” for the status.

###### RCS Chloride Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.01 ppb.

Zero is not an acceptable value.

If the unit is not taken critical at any time during the month, leave the value blank and select “Final-DN” for the status. 

###### RCS Fluoride Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours.

If the unit is not taken critical at any time during the month, enter 0.0 and select “Final” for the status.

###### RCS Fluoride Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.01 ppb.

Zero is not an acceptable value.

If the unit is not taken critical at any time during the month, leave the value blank and select “Final-DN” for the status. 

###### RCS Sulfate Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours.

If the unit is not taken critical at any time during the month, enter 0.0 and select “Final” for the status.

###### RCS Sulfate Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.01 ppb.

Zero is not an acceptable value.

If the unit is not taken critical at any time during the month, leave the value blank and select “Final-DN” for the status. 

##### At all times that the reactor is in mode one power operations

###### Outside RCS Lithium Control Band Duration hours

This is the summation of all hours that this parameter was outside the specified control limits during the month.

All occurrences are added together for a total number of hours outside the specified control limits 

During unit startup, out-of-spec hours outside the specified control limits start to accumulate 72 hours after entering Mode-1 or at xenon equilibrium, whichever occurs first after a unit startup.

Hours outside the specified control limits are reported to the nearest 0.1 hours.

In addition to the normal operating limits, during shutdown hours for out-of-specification will accumulate during the 24 hours prior to shutdown when pH is < 6.5, and at all other times with the unit critical and pH is < 7.0.

If the unit is not operated in Mode-1 at any time during the month, enter 0.0, and select “Final” for the status.

###### Outside RCS Hydrogen Control Band hours

This is the summation of all hours that this parameter was outside the specified control limits during the month.

All occurrences are added together for a total number of hours outside the specified control limits.

Hours outside the specified control limits are reported to the nearest 0.1 hours.

Hydrogen may be reduced to 15 cc/kg within 48 hours before shutdown without reporting these hours as out of limit hours.  (These 48 hours will not be counted as hours outside control limits.)

During unit startup, hours outside the specified control limits start to accumulate after:

- 24 hours of entering Mode-1 for 25 to 50 cc/kg
- 72 hours of entering Mode-1 for 30 to 50 cc/kg

If the unit is not operated in Mode-1 at any time during the month, enter 0.0 and select “Final” for the status.

##### At all times that the reactor is above 30% power

###### Feedwater Copper Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.

All occurrences are added together for a total number of hours > L-1 limit.  Hours above the L-1 limit are reported to the nearest 0.1 hours.

Elevated sample values during transients are expected to be included in the computed hours greater than L-1 when power is above 30% power.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated above MPV at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Copper Peak ppb 

Feedwater copper concentration is normally obtained based on a seven-day integrated value.

For plants whose feedwater has a high concentration of metal transport, this may not be feasible.  Integrated values obtained on a frequency of less than seven days may be used.

The value reported is the maximum value measured in ppb for the month, reported to the nearest 0.001 ppb.

Elevated sample values during transients are expected to be included in the computed hours greater than L-1 when power above 30% .  A stabilization time nor a grace before entering AL-1 applies for reporting feedwater metals.  Collection and reporting begin when the power requirements above are met, even for periods of time less than a full day.

The peak value during the seven-day period following a refueling outage that is reported as the Feedwater Copper Peak after an outage below mode-1 is excluded from the values used to determine the maximum Feedwater Copper value measured in ppb during the month.  After the seven-day  outage period, the normal peak value is reported for the month.  If the only period of operation during the month with power >30 percent is the seven-day period following an outage, report a value of 0.000 and select “Final” for Status.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated at or above 30% power  at any time during the month, leave the value blank and select “Final-DN” for the status. 

###### Feedwater Copper Duration hours Power and Time Weighted following a shutdown below mode-1

This is the summation of all hours that feedwater copper was above L-1 S/U limit during the first seven days after initially reaching 30% after startup from an outage going below mode-1.  Power and Time weight averaging over the seven-day sample integration period following power escalation from less than mode-1 may be used for calculation of peak ppb and duration hours in accordance with the following:

1.	Take power readings every two hours starting at 30% power.
2.	The power/time weighted average ppb for each sample (when the corrosion product filter is changed out) is the average power (percent power, times the time for each power reading, divided by the total time) while the sample filter has been in use, times the analyzed ppb results for the sample.
3.	Multiply the power/time weighted average ppb for the sample by the percent of the week (time the sample was in service divided by 168 hours) to get the corrected value.
4.	Sum all the corrected values for the samples during the week to get the reported ppb value
5.	The duration hours to report is determined by summing all the hours that for the samples during the startup week that exceeded the L-1 S/U limit.

Unit Shutdown Occurrence Records and daily Unit Power levels reported to the NRC with the morning report are used to validate appropriate reporting of these values with reactor taken critical as the point of validation.

Hours above the 0.2 ppb limit are reported to the nearest 0.1 hours.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1 S/U limit, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1 S/U limit, hours >L-1 S/U limit will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

Only report a value for the first seven days of operation at or above 30% power after the completion of a refueling outage.  For all other months, enter 0.0 and select “Final” for the status.

###### Feedwater Copper Peak Power and Time Weighted following a shutdown below mode-1 ppb

Feedwater copper concentration is normally obtained based on a seven-day integrated value.

For plants whose feedwater has a high concentration of metal transport, this may not be feasible.  Integrated values obtained on a frequency of less than seven days may be used.

The value reported is the maximum value measured in ppb for first seven days after initially reaching 30% units after startup from an outage going below mode-1.  Power and Time weight averaging over the seven-day sample integration period following power escalation from less than mode-1 may be used for calculation of peak ppb and duration hours in accordance with the following:

1.	Take power readings every two hours starting at 30% power.
2.	The power/time weighted average ppb for each sample (when the corrosion product filter is changed out) is the average power (percent power, times the time for each power reading, divided by the total time) while the sample filter has been in use, times the analyzed ppb results for the sample.
3.	Multiply the power/time weighted average ppb for the sample by the percent of the week (time the sample was in service divided by 168 hours) to get the corrected value.
4.	Sum all the corrected values for the samples during the week to get the reported ppb value
5.	The duration hours to report is determined by summing all the hours that for the samples during the startup week that exceeded the L-1 S/U limit.

Report the feedwater copper concentration to the nearest 0.001 ppb.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1 S/U limit, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 
  
For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1 S/U limit, hours >L-1 S/U limit will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

Only report a value for the first seven days of operations at or above 30% power units after the completion of a refueling outage.  For all other months, enter 0.000 and select “Final” for the status.

###### Feedwater Iron Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.
	
All occurrences are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours.

Elevated sample values during startups and transients are expected to be included in the computed hours greater than L-1 when power is at or above 30%, except for those hours reported during the seven-day period following an outage going below mode-1 that are reported by Feedwater Iron Duration hours after an outage for the month.

When a plant trips, the corrosion product filters should be changed out as soon as possible and the analysis should be reported in the monthly data.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Iron Peak ppb 

Feedwater iron concentration is normally obtained based on a seven-day integrated value.

For plants whose feedwater has a high concentration of metal transport, this may not be feasible.  Integrated values obtained on a frequency of less than seven days may be used.

The value reported is the maximum value measured in ppb during the month, reported to the nearest 0.001 ppb (not averaged with other measurements, and not power adjusted).

Elevated sample values during transients are expected to be included in the computed hours greater than L-1 when power is > 30%.  A stabilization time nor a grace before entering AL-1 applies for reporting feedwater metals.  Collection and reporting begin when the power requirements above are met.

The peak value during the seven-day period following a refueling outage that is reported as the Feedwater Iron Peak after an outage going below mode-1 is excluded from the values used to determine the maximum Feedwater Iron value measured in ppb during the month.  After the seven-day outage period, the normal peak value is reported for the month.  If the only period of operation during the month with power >30 percent is the seven-day period following an outage, report a value of 0.000 and select “Final” for Status.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis.

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Iron Duration hours Power and Time Weighted After a shutdown below mode-1

This is the summation of hours that feedwater iron was above L-1 S/U limit during the first seven days after initially reaching 30% power after startup from an outage going to below mode-1.  Power and Time weight averaging over the seven-day sample integration period following power escalation from less than mode-1 may be used for calculation of peak ppb and duration hours in accordance with the following:

1.	Take power readings every two hours starting at 30% power.
2.	The power/time weighted average ppb for each sample (when the corrosion product filter is changed out) is the average power (percent power, times the time for each power reading, divided by the total time) while the sample filter has been in use, times the analyzed ppb results for the sample.
3.	Multiply the power/time weighted average ppb for the sample by the percent of the week (time the sample was in service divided by 168 hours) to get the corrected value.
4.	Sum all the corrected values for the samples during the week to get the reported ppb value
5.	The duration hours to report is determined by summing all the hours that for the samples during the startup week that exceeded the L-1 S/U limit.

Unit Shutdown Occurrence Records and daily Unit Power levels reported to the NRC with the morning report are used to validate appropriate reporting of these values with reactor taken critical as the point of validation.

Hours above the L-1 S/U limit are reported to the nearest 0.1 hours.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1 S/U limit, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 
  
For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1 S/U limit, hours >L-1 S/U limit will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

Only report a value for the first seven days of operation at or above 30% power after the completion of an outage.  For all other months, enter 0.0 and select “Final” for the status.

###### Feedwater Iron Peak ppb Power and Time Weighted After a shutdown below mode-1

Feedwater iron concentration is normally obtained based on a seven-day integrated value.

For plants whose feedwater has a high concentration of metal transport, this may not be feasible.  Integrated values obtained on a frequency of less than seven days may be used.  The value reported is the maximum value measured in ppb for the first seven days after initially reaching 30% after startup from an outage going below mode-1 Power and Time weight averaging over the seven-day sample integration period following power escalation from less than mode-1 may be used for calculation of peak ppb and duration hours in accordance with the following:

1.	Take power readings every two hours starting at 30% power.
2.	The power/time weighted average ppb for each sample (when the corrosion product filter is changed out) is the average power (percent power, times the time for each power reading, divided by the total time) while the sample filter has been in use, times the analyzed ppb results for the sample.
3.	Multiply the power/time weighted average ppb for the sample by the percent of the week (time the sample was in service divided by 168 hours) to get the corrected value.
4.	Sum all the corrected values for the samples during the week to get the reported ppb value
5.	The duration hours to report is determined by summing all the hours that for the samples during the startup week that exceeded the L-1 S/U limit.

Report the feedwater iron concentration to the nearest 0.001 ppb.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1 S/U limit, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 
  
For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1 S/U limit, hours >L-1 S/U limit will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

Only report a value for the first seven days of operation at or above 30% power after the completion of a outage.  For all other months, enter 0 and select “Final” for the status.

###### Feedwater Dissolved Oxygen Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit when power is greater than MPV during the month.

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours.

If the unit is not operated at greater than MPV power for PWR RSG units at any time during the month, enter 0.0 and select “Final” for the status.

###### Feedwater Dissolved Oxygen Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.001 ppb.

Zero is not an acceptable value.

Note:  For short oxygen spikes above L-1, the peak value reported may be based on the time-weighted average value of oxygen over the first 30 minutes after exceeding L-1 and can be used in calculating duration hours.  This is normally due to an electronic spike or an air bubble going through the monitor and not representative of actual chemistry conditions and should not have an effect on steam generator chemistry. 

If the plant is not operated at greater than MPV power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Chloride Duration hours  > L-1

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.

All occurrence hours are added together for a total number of hours > L-1 limit.  Hours above the L-1 limit are reported to the nearest 0.1 hours. 

If the unit is not operated at or above 30% power at any time during the month, enter 0.0 and select “Final” for the status.

###### Feedwater Chloride Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.001 ppb.

Zero is not an acceptable value.

If the unit is not operated at or greater than 30% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Sodium Duration hrs > 0.3ppb

This is the summation of all hours that this parameter was above L-1 limit during the month.

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above L-1 limit are reported to the nearest 0.1 hours when power is at or above 30%.

A 24-hour grace period is given for reporting the duration hours for sodium peak > L-1 limit after a unit has reached 30% power after a startup and a Plant Mode change to Mode-1.

If the unit is not operated at or above 30% power at any time during the month, enter 0.0 and select “Final” for the status.

###### Feedwater Sodium Duration hrs > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours when power is at or above 30%.

If the plant is not operated at or above 30% power at any time during the month, enter 0.0 and select “Final” for the status.

###### Feedwater Sodium Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.001 ppb.

Zero is not an acceptable value.

Note:

For power changes that result in a feedwater sodium spike:

- To avoid a feedwater sodium concentration spike that may not be representative of actual feedwater conditions that exceeds the L-2 value for 30 minutes or less, the on-line sodium monitor data after reaching the L-2 value may be time-weight averaged and reported as the peak value over the 30 minute period.
- If the sodium spike lasts more than 30 minutes, then the actual peak value must be reported (not the time-weighted value).

If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status. 

###### Feedwater Sulfate Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours when power is at or above 30%.

If the unit is not operated at or above 30% power at any time during the month, enter 0.0 and select “Final” for the status.

###### Feedwater Sulfate Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.001 ppb.

Zero is not an acceptable value.

If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status. 

#### Group D

Specific Sampling Requirements

For this reactor type group six feedwater parameters and one reactor coolant parameters are required monthly.

At all times the reactor is is in Mode 1 Power Operations

RCS Cover Gas availability

At all times the reactor above 30% power

- Feedwater Copper ppb 
- Feedwater Iron ppb
- Feedwater Dissolved Oxygen ppb
- Feedwater Chloride in ppb
- Feedwater Sodium in ppb
- Feedwater Sulfate in ppb

##### At all times that the reactor is in mode one power operations

###### Outside RCS Cover Gas Control Band hours 

This is the summation of all hours that this parameter was outside the station selected specified control limits during the month.

All occurrences are added together for a total number of hours outside the specified control limits.

Hours outside the specified control limits are reported to the nearest 0.1 hours.

For Hydrogen cover gas controlled stations:
Hydrogen may be reduced to 15 cc/kg within 48 hours before shutdown without reporting these hours as out of limit hours.  (These 48 hours will not be counted as hours outside control limits.)

During unit startup, hours outside the specified control limits start to accumulate after:

- 24 hours of entering Mode-1 for 25 to 50 cc/kg
- 72 hours of entering Mode-1 for 30 to 50 cc/kg

For all stations:

If the unit is not operated in Mode-1 at any time during the month, enter 0.0 and select “Final” for the status.

##### At all times that the reactor is above 30% power

###### Feedwater Copper Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.

All occurrences are added together for a total number of hours > L-1 limit.  Hours above the L-1 limit are reported to the nearest 0.1 hours.

Elevated sample values during transients are expected to be included in the computed hours greater than L-1 when power is above 30% power.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Copper Peak ppb 

Feedwater copper concentration is normally obtained based on a seven-day integrated value.

For plants whose feedwater has a high concentration of metal transport, this may not be feasible.  Integrated values obtained on a frequency of less than seven days may be used.

The value reported is the maximum value measured in ppb for the month, reported to the nearest 0.001 ppb.

Elevated sample values during transients are expected to be included in the computed hours greater than L-1 when power above 30% .  A stabilization time nor a grace before entering AL-1 applies for reporting feedwater metals.  Collection and reporting begin when the power requirements above are met, even for periods of time less than a full day.

The peak value during the seven-day period following a refueling outage that is reported as the Feedwater Copper Peak after an outage below mode-1 is excluded from the values used to determine the maximum Feedwater Copper value measured in ppb during the month.  After the seven-day outage period, the normal peak value is reported for the month.  If the only period of operation during the month with power >30 percent is the seven-day period following an outage, report a value of 0.000 and select “Final” for Status.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Copper Duration hours Power and Time Weighted following a shutdown below mode-1

This is the summation of all hours that feedwater copper was above L-1 S/U limit during the first seven days after initially reaching 30% for PWR after startup from an outage going below mode-1.  Power and Time weight averaging over the seven-day sample integration period following power escalation from less than mode-1 may be used for calculation of peak ppb and duration hours in accordance with the following:

1.	Take power readings every two hours starting at 30% power.
2.	The power/time weighted average ppb for each sample (when the corrosion product filter is changed out) is the average power (percent power, times the time for each power reading, divided by the total time) while the sample filter has been in use, times the analyzed ppb results for the sample.
3.	Multiply the power/time weighted average ppb for the sample by the percent of the week (time the sample was in service divided by 168 hours) to get the corrected value.
4.	Sum all the corrected values for the samples during the week to get the reported ppb value
5.	The duration hours to report is determined by summing all the hours that for the samples during the startup week that exceeded the L-1 S/U limit. 

Unit Shutdown Occurrence Records and daily Unit Power levels reported to the NRC with the morning report are used to validate appropriate reporting of these values with reactor taken critical as the point of validation.

Hours above the 0.2 ppb limit are reported to the nearest 0.1 hours.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1 S/U limit, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1 S/U limit, hours >L-1 S/U limit will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

Only report a value for the first seven days of operation at or above 30% power after the completion of a refueling outage.  For all other months, enter 0.0 and select “Final” for the status.

###### Feedwater Copper Peak Power and Time Weighted following a shutdown below mode-1ppb

Feedwater copper concentration is normally obtained based on a seven-day integrated value.

For plants whose feedwater has a high concentration of metal transport, this may not be feasible.  Integrated values obtained on a frequency of less than seven days may be used.

The value reported is the maximum value measured in ppb for first seven days after initially reaching 30% units after startup from an outage going below mode-1.  Power and Time weight averaging over the seven-day sample integration period following power escalation from less than mode-1 may be used for calculation of peak ppb and duration hours in accordance with the following:

1.	Take power readings every two hours starting at 30% power.
2.	The power/time weighted average ppb for each sample (when the corrosion product filter is changed out) is the average power (percent power, times the time for each power reading, divided by the total time) while the sample filter has been in use, times the analyzed ppb results for the sample.
3.	Multiply the power/time weighted average ppb for the sample by the percent of the week (time the sample was in service divided by 168 hours) to get the corrected value.
4.	Sum all the corrected values for the samples during the week to get the reported ppb value
5.	The duration hours to report is determined by summing all the hours that for the samples during the startup week that exceeded the L-1 S/U limit.

Report the feedwater copper concentration to the nearest 0.001 ppb.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1 S/U limit, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 
  
For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1 S/U limit, hours >L-1 S/U limit will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

Only report a value for the first seven days of operations at or above 30% power units after the completion of a refueling outage.  For all other months, enter 0.000 and select “Final” for the status

###### Steam Generator Copper Removal Efficiency %

For units that add polyacrylic acid (PAA) dispersant to the steam generators, enter the steam generator blowdown copper removal efficiency time-weighted average in percent (xx.x%), calculated by (mass of SGBD Cu)/(mass of FFWCu).

The parameter value to be entered is based on the weekly or monthly time-weighted average value (VT) as defined by the following:

$$VT=\frac{\sum{V_i\cdot\T_i}}{\sum{T_i}}$$

for the period

Use whole days in the calculation.

Integrated sampling must be used to obtain a representative sample.  Grab samples are not appropriate for reporting blowdown removal efficiency.

The maximum allowable value for entry is 100%.

If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Iron Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.
	
All occurrences are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours.

Elevated sample values during startups and transients are expected to be included in the computed hours greater than L-1 when power is at or above 30%, except for those hours reported during the seven-day period following an outage going below mode-1 that are reported by Feedwater Iron Duration hours after an outage for the month.

When a plant trips, the corrosion product filters should be changed out as soon as possible and the analysis should be reported in the monthly data.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Iron Peak ppb 

Feedwater iron concentration is normally obtained based on a seven-day integrated value.

For plants whose feedwater has a high concentration of metal transport, this may not be feasible.  Integrated values obtained on a frequency of less than seven days may be used.

The value reported is the maximum value measured in ppb during the month, reported to the nearest 0.001 ppb (not averaged with other measurements, and not power adjusted).

Elevated sample values during transients are expected to be included in the computed hours greater than L-1 when power is > 30%.  A stabilization time nor a grace before entering AL-1 applies for reporting feedwater metals.  Collection and reporting begin when the power requirements above are met. 

The peak value during the seven-day period following a refueling outage that is reported as the Feedwater Iron Peak after an outage going below mode-1 is excluded from the values used to determine the maximum Feedwater Iron value measured in ppb during the month.  After the seven-day outage period, the normal peak value is reported for the month.  If the only period of operation during the month with power >30 percent is the seven-day period following an outage, report a value of 0.000 and select “Final” for Status.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis.

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Iron Duration hours Power and Time Weighted After a shutdown below mode-1

This is the summation of hours that feedwater iron was above L-1 S/U limit during the first seven days after initially reaching 30% power after startup from an outage going to below mode-1.  Power and Time weight averaging over the seven-day sample integration period following power escalation from less than mode-1 may be used for calculation of peak ppb and duration hours in accordance with the following:

1.	Take power readings every two hours starting at 30% power.
2.	The power/time weighted average ppb for each sample (when the corrosion product filter is changed out) is the average power (percent power, times the time for each power reading, divided by the total time) while the sample filter has been in use, times the analyzed ppb results for the sample.
3.	Multiply the power/time weighted average ppb for the sample by the percent of the week (time the sample was in service divided by 168 hours) to get the corrected value.
4.	Sum all the corrected values for the samples during the week to get the reported ppb value
5.	The duration hours to report is determined by summing all the hours that for the samples during the startup week that exceeded the L-1 S/U limit.

Unit Shutdown Occurrence Records and daily Unit Power levels reported to the NRC with the morning report are used to validate appropriate reporting of these values with reactor taken critical as the point of validation.

Hours above the L-1 S/U limit are reported to the nearest 0.1 hours.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1 S/U limit, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 
  
For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1 S/U limit, hours >L-1 S/U limit will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

Only report a value for the first seven days of operation at or above 30% power after the completion of an outage.  For all other months, enter 0.0 and select “Final” for the status.

###### Feedwater Iron Peak ppb Power and Time Weighted After a shutdown below mode-1

Feedwater iron concentration is normally obtained based on a seven-day integrated value.

For plants whose feedwater has a high concentration of metal transport, this may not be feasible.  Integrated values obtained on a frequency of less than seven days may be used.  The value reported is the maximum value measured in ppb for the first seven days after initially reaching 30% after startup from an outage going below mode-1 Power and Time weight averaging over the seven-day sample integration period following power escalation from less than mode-1 may be used for calculation of peak ppb and duration hours in accordance with the following:

1.	Take power readings every two hours starting at 30% power.
2.	The power/time weighted average ppb for each sample (when the corrosion product filter is changed out) is the average power (percent power, times the time for each power reading, divided by the total time) while the sample filter has been in use, times the analyzed ppb results for the sample.
3.	Multiply the power/time weighted average ppb for the sample by the percent of the week (time the sample was in service divided by 168 hours) to get the corrected value.
4.	Sum all the corrected values for the samples during the week to get the reported ppb value
5.	The duration hours to report is determined by summing all the hours that for the samples during the startup week that exceeded the L-1 S/U limit.

Report the feedwater iron concentration to the nearest 0.001 ppb.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1 S/U limit, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 
  
For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1 S/U limit, hours >L-1 S/U limit will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

Only report a value for the first seven days of operation at or above 30% power after the completion of a outage.  For all other months, enter 0 and select “Final” for the status.

###### Feedwater Copper Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.

All occurrences are added together for a total number of hours > L-1 limit.  Hours above the L-1 limit are reported to the nearest 0.1 hours.

Elevated sample values during transients are expected to be included in the computed hours greater than L-1 when power is above 30% power.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated above MPV at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Copper Peak ppb 

Feedwater copper concentration is normally obtained based on a seven-day integrated value.

For plants whose feedwater has a high concentration of metal transport, this may not be feasible.  Integrated values obtained on a frequency of less than seven days may be used.

The value reported is the maximum value measured in ppb for the month, reported to the nearest 0.001 ppb. 

Elevated sample values during transients are expected to be included in the computed hours greater than L-1 when power above 30% .  A stabilization time nor a grace before entering AL-1 applies for reporting feedwater metals.  Collection and reporting begin when the power requirements above are met, even for periods of time less than a full day.

The peak value during the seven-day period following a refueling outage that is reported as the Feedwater Copper Peak after an outage below mode-1 is excluded from the values used to determine the maximum Feedwater Copper value measured in ppb during the month.  After the seven-day  outage period, the normal peak value is reported for the month.  If the only period of operation during the month with power >30 percent is the seven-day period following an outage, report a value of 0.000 and select “Final” for Status.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status. 

###### Feedwater Iron Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.
	
All occurrences are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours.

Elevated sample values during startups and transients are expected to be included in the computed hours greater than L-1 when power is at or above 30%, except for those hours reported during the seven-day period following an outage going below mode-1 that are reported by Feedwater Iron Duration hours after an outage for the month.

When a plant trips, the corrosion product filters should be changed out as soon as possible and the analysis should be reported in the monthly data.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis. 

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Iron Peak ppb 

Feedwater iron concentration is normally obtained based on a seven-day integrated value.

For plants whose feedwater has a high concentration of metal transport, this may not be feasible.  Integrated values obtained on a frequency of less than seven days may be used.

The value reported is the maximum value measured in ppb during the month, reported to the nearest 0.001 ppb (not averaged with other measurements, and not power adjusted).

Elevated sample values during transients are expected to be included in the computed hours greater than L-1 when power is > 30%.  Neither the stabilization time nor the 24 hours grace before entering AL-1 applies for reporting feedwater metals.  Collection and reporting begin when the power requirements above are met.

The peak value during the seven-day period following a refueling outage that is reported as the Feedwater Iron Peak after an outage going below mode-1 is excluded from the values used to determine the maximum Feedwater Iron value measured in ppb during the month.  After the seven-day outage period, the normal peak value is reported for the month.  If the only period of operation during the month with power >30 percent is the seven-day period following an outage, report a value of 0.000 and select “Final” for Status.

When a single integrated sampling period starts in one month and ends in a second month, the value obtained from the analysis of this sample is counted for the sampling period from both months.  If the analysis indicates >L-1, then the out-of-spec duration for the first month shall include the time period from the start of the sample until the end of the last day of the first month.  Additionally, the out-of-spec duration for the second month shall include the time period from the start of the first day of the second month until the time the sample is removed for analysis.

For example, if the weekly metals sample is collected on Tuesday the 29th and a new seven day sample is started the same day, the next seven day sample collected on Tuesday the 5th will be used as data for the 30th and 31st of the previous month and the period in the next month up to the 5th.  If Tuesday the 5th sample results were above L-1, hours >L-1 will be reported for the 30th and 31st of the previous month and for the first five days of the current month.

If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Dissolved Oxygen Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit when power is greater than MPV during the month.

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours.

If the unit is not operated at greater than MPV power for PWR RSG units at any time during the month, enter 0.0 and select “Final” for the status.

###### Feedwater Dissolved Oxygen Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.001 ppb.

Zero is not an acceptable value.

Note:  For short oxygen spikes above L-1, the peak value reported may be based on the time-weighted average value of oxygen over the first 30 minutes after exceeding L-1 and can be used in calculating duration hours.  This is normally due to an electronic spike or an air bubble going through the monitor and not representative of actual chemistry conditions and should not have an effect on steam generator chemistry. 

If the plant is not operated at greater than MPV power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Chloride Duration hours > L-1

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.

All occurrence hours are added together for a total number of hours > L-1 limit.  Hours above the L-1 limit are reported to the nearest 0.1 hours. 

If the unit is not operated at or above 30% power at any time during the month, enter 0.0 and select “Final” for the status.

###### Feedwater Chloride Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.001 ppb.

Zero is not an acceptable value.

If the unit is not operated at or greater than 30% power at any time during the month, leave the value blank and select “Final-DN” for the status.

###### Feedwater Sodium Duration hrs > 0.3ppb

This is the summation of all hours that this parameter was above 0.3 ppb during the month.

All occurrence hours are added together for a total number of hours > 0.3 ppb.

Hours above 0.3 ppb are reported to the nearest 0.1 hours when power is at or above 30%.

A 24-hour grace period is given for reporting the duration hours for sodium peak > 0.3 ppb after a unit has reached 30% power after a startup and a Plant Mode change to Mode-1.

If the unit is not operated at or above 30% power at any time during the month, enter 0.0 and select “Final” for the status.

###### Feedwater Sodium Duration hrs > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours when power is at or above 30%.

If the plant is not operated at or above 30% power at any time during the month, enter 0.0 and select “Final” for the status.

###### Feedwater Sodium Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.001 ppb.

Zero is not an acceptable value.

_Note: If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status._

###### Feedwater Sulfate Duration hours > L-1 

This is the summation of all hours that this parameter was above the specified L-1 limit during the month.

All occurrence hours are added together for a total number of hours > L-1 limit.

Hours above the L-1 limit are reported to the nearest 0.1 hours when power is at or above 30%.

If the unit is not operated at or above 30% power at any time during the month, enter 0.0 and select “Final” for the status.

###### Feedwater Sulfate Peak ppb

This is the maximum value measured during the month for the parameter in units of parts per billion (ppb).

The maximum value is reported to the nearest 0.001 ppb.

Zero is not an acceptable value.

If the unit is not operated at or above 30% power at any time during the month, leave the value blank and select “Final-DN” for the status. 


## CY: Feedwater

|Reactor types|Fe[^1]|Cu[^1]|Dis.O~2~[^1]|Na[^1]|Cl[^1]|SO~4~[^1]|pH|Cat.Cond[^2]
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-
|BWR|2.5|0.2|30-50[^3] 									
|RSG PWR, PHWR, FBR|3|0.2[^4]|3		
|OTSG PWR, AGR, Magnox|	3|0.2|3|0.3|0.5|0.75					
|LWCGR|||20|||||0.1
|VVER-440|||5||||≥8.8≤9.2[^5]|0.5
|VVER-1000 with copper alloy|||5||||≥9.0≤9.2[^5]|0.25
|VVER-1000 without copper alloy|||3||||≥9.5≤9.7[^5]|0.3

## CY: Steam Generators

|Reactor Types|Na|Cl|SO~4~|Cat.Cond[^2]
|:-:|:-:|:-:|:-:|:-
|BWR
|RSG PWR, PHWR, FBR|2|2|2
|OTSG PWR, AGR, Magnox
|LWCGR
|VVER-440||50||4
|VVER-1000 (Cu)||50|100|4
|VVER-1000||10|10|1.5


## CY: Primary coolant

|Reactors|F[^6]|Cl[^6]|SO~4~[^6]|pH[^3]|Cov.gas|ECP|Cond.[^2]|Co|Dis.O~2~[^6]|H~2~[^6]
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-
|BWR||1|2||99% avail.[^3]|<-350SHE[^3]|0.25|<1.0E-4 uCi/ml Co^60^
|RSG PWR, PHWR, FBR|15|20|15|>=7.0|(>30<50 cc/kg)[^3]|||< 1.0E-3 uCi/ml Co^58^&Co^60^
|OTSG PWR, AGR, Magnox|15|20|15|>=7.0|(>30<50 cc/kg)[^3]|||< 1.0E-3 uCi/ml Co^58^&Co^60^
|LWCGR||11|20||||0.25
|VVER (all)||70||≥5.8≤10.3|||||5|≥2.2≤4.5[^7]


## CY: calculation

$$CPI=\frac{Max \cdot Hrs}{168 \cdot Lim}$$

where 

- Max - Reported maximaml value for the month
- Hrs - Duration hours more than limit
- Lim - Limit value

_The basis for CPI is zero_

Reporting System changes:

As for the PI Reporting System, the following changes should be provided:

-	Update the reactor type report grouping based on calculations and source data.

After whole the CPI project implementation all WANO members have the accurate CPI for adequate NPPs performance monitor and control – one calculation (in three sub calculations) principle and standard for seven reactor type groups.


## CY: calculation (BWR,LWCGR)

$$CPI = \frac{Max \cdot Hrs}{168 \cdot Lim} + \frac{FWDO + CG + ECP}{24}$$

where

- Lim - limits[^8] as described in the tables
- FWDO -  Total hours outside the band forFeedwater dissolved Oxygen
- CG - the same for Cover Gas

## CY: calculation (all other)

$$CPI = \frac{Max \cdot Hrs}{168 \cdot Lim} + \frac{CG}{24}$$

where

- Lim - limits[^9][^10] as described in the tables

## CY pilot data collection and calculation (DES/external apps)

Any CY (actually, any significant) changes will be provided either:

- We started new PI Apps (doesn’t matter with or without new CY calculation);
- We agree (after PI Programme meeting next month) that LO calculates/reports CY separately (based on existing source data);
- We agree (after PI Programme meeting next month) that LO will create new pilot CY calculation based on updated CY source data.

[^1]: The units for the Iron, Cooper, Dissolved oxygen, Sodium, Chloride and Sulphate is micrograms per cubic decimetre

[^2]: For conductivity the unit is micro Siemens per cm

[^3]: Report hours outside established control band; for RCS pH would be the control band for Li or K or the hours when pH is < 7.0

[^4]: Excludes S/G with I-800 tubes

[^5]: Total hours outside control band

[^6]: The units for the Fluoride, Dissolved oxygen, Chloride, Sulphate and Hydrogen is micrograms per cubic decimetre

[^7]: VVER-1000 with copper alloy only: total hours outside control band; indicator is only taken above 30% reactor power

[^8]: for Fe, Cu, RCS Cl, RCS SO~4~, RCS Cond, and RCS Co

[^9]: RSG PWR,PHWR,VVER,FBR: for Fe, Cu, FW D.O., S/G Na, S/G Cl, S/G SO~4~, RCS F, RCS Cl, RCS SO~4~, and RCS Co

[^10]: OTSG PWR,AGR,Magnox: for Fe, Cu, FW D.O., FW Na, FW Cl, FW SO~4~, RCS F, RCS Cl, RCS SO~4~, and RCS Co
