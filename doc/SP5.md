# Unit-based EDG (SP5) indicator

## Intro

(based on Mr Schollhorn doc dated July 2006)

## CURRENT WANO INDICATOR DEFINITION(S)

The current SP5 indicator that reflects the performance of the Emergency Power Supply is a “station-based” indicator because in some stations with more then one unit the Emergency Diesel Generators EDGs are interconnectable.


Example for station-based:

![](../pic/sp5_01.PNG)

All EDG trains required on site are identified

Based on reporting guidance, all unavailability of required EDG trains are reported and the calculated SP5 unavailability applies to each unit of the station.


## REVIEW OF THE CURRENT DEFINITIONS

Meanwhile there are a lot of stations having more then 1 unit where the Emergency Diesel Generators EDG’s are not interconnectable.

Example for unit-based:

![](../pic/sp5_02.PNG)

The number of EDG trains that supply individual units on site are identified.

The current SP5 indicator as a station-based indicator should not more being applied to these stations because the unavailability of a unit 1-associated EDG for instance would diminish the performance of the non-affected unit 2 and the same in reverse order.

(Even worse: In the case of a 4-unit-station for instance, the unavailability of one unit-required EDG diminishes the performance of 3 non-affected units).

A unit specific performance assessment is not possible in this case.


## Proposal

Unavailability of the EDG trains required for the associated unit is reported for this unit that requires its availability.

### Suggestions: 

Either

Make survey and split the stations with more than one unit in the following 2 categories:

- Stations with interconnectable EDG’s where the unavailability of the required EDG affects all units
- Stations with non-interconnectable EDG’s where the unavailability of the required EDG affects only the associated unit

Modify the input mask of the DES (Data Entry System)

Or

Modify the input mask of the DES (Data Entry System) in such a way that the stations are able to report unavailability appropriate to their individual situation.

Examples:

Station-based

![](../pic/sp5_03.PNG)

If two out of three EDG’s are required to be available to supply both units in case of emergency, the unavailability of more than one EDG has to be reported against both units

Unit-based

![](../pic/sp5_04.PNG)

If three out of four EDG’s are required to be available to supply the associated unit in case of emergency, the unavailability of more than one EDG has to be reported against the associated unit.

