# Performance Indicators Application Functional Specification

version 0.0.0.9003 from 01-Feb-2018 by
[Vladimir Turbayesky](mailto:volodymyr.turbayevsky@wano.org) (partly
based on information presented on the [DES](http://www.wano.org/Dk01Asp/dkw000.asp) and [Reports](http://www.wano.org/xwp10webapp/Confidentiality.aspx) websites)

## Abstract

It's a live document to describe the _minimal_ functionlaity of the
Performance Indicators Application, which is currently work on the
INPO servers as two apps which is DES and [Reports](#reports).

As minimum, _all_ these functions _must_ be included into the new PI
application. Also it is necessary to include all the reporting
functions ehich are described into the
[Prototype](#prototype-functionality) section. It is the vital
condition to extend the existing DES-Reports functionality to justify
developnemt necessity.

Some extra [functionality](#extra-functionality) is also described in here and is divided to _must_ and _should_ sections.

DES was designed to enter source data, provide very basic calculation,
and to provide some security functions. Also it supports the basic
[dataflow](#data-processing) which mean review data then promote or reject them. More
detailed information regarding DES please see
[below](#data-entry-system-basic-functionality).

[Reports](#reports) provides basic reports functionality, including
reports, groups and indexes tuning. Currently the system has the
_precalculated_ results. The calculation of the results might be
started manually or automatically (every weekend).

It seems reasonable _new system to calculate all the resuls on fly_.

## History 

The Performance Indicator Programme (PIP) has started in 1990 and mainly used as a management tool. All WANO regional centres (RC), members and plants can monitor their performance and trends and set challenging goals for improvement and consistently compare their performance with other plants and nuclear industry. Performance indicators can also be used to assess industry performance, to support other WANO programmes and to provide assistance to members if necessary.

Existing PI DB includes two structures: PI Data Entry System (DES) and PI REPORT system. The first one provides data entry and preliminary checking. The second one provides indicator and indexes calculation, and reporting and trending providing.

Currently very limited number of people has enough knowledges and training to use the PI results in their practice. It is probably one of the reasons why PI programme does not use wide enough.

WANO LO IS developed IS Strategy which includes IS Business Data Plan (BDP) (both documents are available at the SharePoint into Information System Area).

Taking into account a serious potential problem to reconnect existing PIP users (especially INPO members) from existing DES the decision was found to retain the existing DES structure but modify PI REPORT System only (see Implementation of the project and Risks sections).

To solve the existing problems and to improve PIP WANO LO management decided to implement this plan into TSE Strategy, IS Strategy and IS Business Data Plan.

This document provides an overview of how WANO LO intends to approach the future development of systems to support the management of PI data and states the high level plan that we will use to inform the related planning and decision making processes. Detailed plans for specific work streams can be documented separately.

All work in this area should be aligned with the principles described in this plan. The plan can be changed at any time if approved by the owner and should be updated regularly to remain current. The plan is owned by the CEO (CEO Deputy) and TSE Programme Directors.

### Project advantages

The main advantage of this project is it needn’t any changes of existing data structure or data flows. The existing PI DB and data flows will continue to work without any changes and independently from this project. The PI data customers will be able to choose which kind of report is more appropriate for their needs.

Additional advantage is the WANO LO will be able to provide any new or updated calculations and reports without any request to INPO. It allows WANO LO to check any new method before realisation into INPO server, if WANO members decide continue to use the existing PI REPORT system.

All the software will be developed are quite supportable by IT experts but not by PI system administrator only. It _might_ be based on popular Microsoft Power Business Intelligence (Power BI) system for online reports, on standard SQL for calculation module and on the SQL Server Reporting Services (SSRS) to provide paper reports.

Finally, the approach is proposed let all the WANO members  to receive all kind of necessary information without any special knowledges and trainings. The Power BI online report examples are presented below.

## Data processing

The following Performance Indicator’s process description flowchart describes the PIs process and its main phases. All these steps are described below.

![](pic/dataflow.PNG)

### Step 1 – Data collection, Members

Each WANO member (nuclear operating organisation) is responsible for
the element data collection. All necessary elements are identified in
the Data Entry System (DES) section of the WANO member website. Most
of the world plants report quarterly. However, the USA plants report
monthly to the Institute of Nuclear Power Operations (INPO) using CDE
(Consolidated Data Entry) system. The INPO transfer monthly all
predefined data from CDE into PI DB through DES.

### Step 2 – Data reporting and submission, Members

Station PI staff is responsible for the first review and submittal of
good quality data elements to Regional Centres (RCs) according to the
PI Reference Manual and for informing RCs about data collection
issues.

These data elements should be collected for each operating nuclear
station/reactor unit, and submitted to the member's RC within 45 days
following the end of each calendar quarter.

All PI data, with exception of the USA plants must be submitted
through the DES of the WANO member website.

Each WANO member can submit only data elements related to its own
unit/station. All data elements which are significantly different from
previous values, or reflected during Quality Report Review (QRR)
system, should be commented into appropriated fields. Before
submitting data should be checked by QRR system, and then using
‘Calculate Indicator’ option into DES menu bar check results for all
available date ranges.

The number of units not reporting in time is measured through the
PI-1, “Number of units not reporting in 45 days after end of quarter”
scorecard (see details in the [Metrics](#metrics) section).

### Step 3 – Data review, correction and acceptance, RC PI Managers

WANO RCs’ PI managers are responsible for reviewing /screening data
elements in their region and challenging inconsistent data. Acceptable
data is promoted. At times, it is possible to place unacceptable data
in production, but with a disqualification code , which will prevent
its use in result calculations. WANO RCs are also responsible for
maintaining knowledge of RC and stations’ personnel using PI in
cooperation with other programmes and for providing regular ‘random’
on-site data inserting check visits to be sure data is correctly
collected and reported.

RCs review and promote to production the submitted data in DES within
60 days following the end of each calendar quarter. They inform the
system administrator(s) when all data has been promoted.

To resolve data inconsistencies or reporting problems, RCs can also reject the data to members. When they reject the data to members, it is a good practice to get in touch with the plant PI manager to clarify why the data elements have been rejected and also insert comments on each data element as appropriate.
All data elements which are significantly different from previous
values, or reflected during Quality Report Review (QRR) system, should
be commented into appropriated fields. Before submitting data should
be checked by [QRR](#qrr) system, and then using ‘Calculate Indicator’ option
into DES menu bar for check results all available date ranges.

London Office (LO) monitors the number of units without a complete set
of data elements. LO works together with the respective RC PI manager
to understand the reasons and resolve issues if necessary.

### Step 4 – Calculation of results, WANO PI Administration staff

The WANO PI SA initiates the calculation of indicator values of data
the RCs placed in production.

The number of units not reporting all data elements indicator is
measured through the PI-2, “Number of units not reporting all data
elements” scorecard (see details in the [Metrics](#metrics) section).

### Step 5 – Posting and releasing of results, WANO PI Administration staff

The WANO PI SA(s) initiates calculations and releases the results for
each quarter. Indicator values are automatically updated on the WANO
member website every weekend or manually by SA (by request).

If necessary LO sends the clarification request to the RC during step
5 and 6 (see Fig. above).

At the end of every year, the SA prepares a PI annual summary with the
trend of a selection of indicators to show the general performance of
the industry.

Periodically, RC and LO staff may consider check quality data using
available information, for example IAEA indicators, reported operating
experience and on-site data checking.

### Step 6 – Usage of results

PIs are mainly used by WANO regional centres, members and stations to
monitor performance and progress, set challenging goals for
improvement and consistently compare performance with other plants or
the wider industry.

Performance indicators are also used to review industry performance,
support other WANO programmes and identify areas of assistance to
members if necessary. Great care should be exercised in the use of
performance indicators to ensure they are not used in a manner that
could encourage plant operating personnel to take non-conservative
actions regarding plant safety in order to improve performance values
or achieve performance goals that are based on the indicators. The
following principles should be applied when using the WANO performance
indicators:

- Performance indicators are most appropriately used by nuclear
  operating organisations for trending performance and, if needed,
  adjusting priorities and resourcing; the relative emphasis to be
  placed on a given indicator, or set of indicators, should be an
  operating line management prerogative.

- Performance indicators should be used in conjunction with other
  review tools. They should not be used as the sole basis for
  decisions. Excessive focus on a narrow set of indicators or one
  indicator can be counter-productive to safety.

- Detailed or process-related indicators requiring a detailed
  knowledge of plant programmes should only be used by the plant
  staff; comparisons of such indicators can provide the plant staff
  with a useful perspective, but should not be used by other
  organisations to compare performance.

- Performance indicators should not be used for solely ranking plants
  because they provide only a partial and historic perspective
  regarding safe and reliable plant operation.

Examples of use of WANO performance indicators are as follows:

- Station: Performance trending, long-term station achievements,
  comparison, areas for improvement, resource alignment, etc.

- WANO RCs: Performance trending in the region, weak and good
  performances, support other programmes (information for peer
  reviews, technical support missions, OE performance), long-term
  regional achievements, periodic regional performance review, etc.

- WANO LO: Periodic industry performance review, strengths and weak
  points, long-term industry achievements, support of other programmes
  etc.

It is important to respect the confidentiality of WANO performance
indicators results for individual plants. Before quoting any
performance indicator values outside of WANO, reference should be made
to the current WANO Confidentiality Policy Document and WPG.

### Metrics

Metrics have been identified to monitor specific attributes of the programme.
General principles

Metrics have been identified to measure the main steps of the process
and ensure outputs are fulfilling user needs.

The set of metrics can evolve over time to fit the needs and evolution
of the process.

The metrics used to assess the PI Programme results are:

- PI-1 - Number of units not submitting data within forty five (45) days after end of quarter
- PI-2 – Number of units not reporting all data elements
- PI-3 - Number of access to the PI reports area on the WANO member website
- PI-4 - Number of trained WANO RCs’ and members’ staff

## Use of DES

The basic use of DES is as follows:

Authorized IDs enter PI data. Data can be entered, saved, viewed, and
calculated prior to submittal to WANO. Data may even be entered in
advance for indicator projection calculations. (However, data cannot
be submitted prior to the end of the period (see
[Data Processing Step 2](#data-processing) section)). Data entered at the unit/utility level has a green background.

Data can and should be reviewed by other utility staff prior to
submittal to WANO.  The data submittal authority is a separate
authorization from data entry.  Furthermore, while data entry
authority may be assigned to IDs by category, the assignment of
submittal authority is for all data categories, although the submitter
may elect to submit data categories at different times.  It is
recommended that initial data submittals for a new reporting period be
done for all categories at the same time. The station level submittals
are separate from unit level submittals - submitters should not forget
that both submittals need to be done each period (see
[Data Processing Step 2](#data-processing) section). Data that is submitted for WANO review has a yellow background.

IDs with data entry privileges may also Recall data that has been
submitted - returning the data from the review (yellow) status to the utility level (green).

After data is submitted (a due date has been established for each
reporting period - please check with your regional coordinator for the due date), the applicable WANO regional centre will review the submittals. The various results from review can be accepted, or returned to the submitter electronically. The reviewer may also elect to phone the submitter to resolve any questions. If the data is accepted, the reviewer will promote the data to production. The data will then be used in WANO calculations when the WANO system administrator calculates results. Data that is promoted (in production) has a white background.

Data can also be disqualified - a UD [code](#data-entry-code-entries) is assigned to a data
element and then has a red background - or the data may be returned to the utility (the data is returned to a utility level (green) from the review status (yellow).

Results are typically calculated by WANO once a calendar quarter after all worldwide data is placed in production.

Authorized IDs may calculate any indicators value in DES for the associated unit using data in the various levels (green, yellow, or white backgrounds.)

Users with data entry, data submittal and view data authority may calculate indicator values for the associated units/stations.

The [QRR](#qrr) (Quality Review Report) may be used to identify potential data
errors. QRRs are intended to help users ensure accurate data is reported. If you receive a QRR message, you are not required to make a comment in the Data Entry field; however, a comment may help explain the data to other data users

All data fields have associated comment fields. The comment fields are
text fields that can contain up to 255 characters. _Only Roman style
characters should be used._ It is recommended that comments be
provided for unusual or significant data or data changes. WANO
reviewers have a separate comment field for WANO comments. Utility and
WANO comments are separate and cannot be modified by each other.

### About Security

In this topic you can learn the following:

- Why is there security?
- How DES security works

#### Why is there security?

The DES needs security because all members access the system at the same place, the WANO Web site.  Unlike software on a desktop computer, where users must have access to a specific computer in order to view or modify station data, many members can access the WANO Web site.  Thus, Web based data is not protected by the physical location of the computer.  Instead, a security system is used to control who can view and update data for each unit.

#### How DES security works

##### Security is assigned by function and location

DES security was designed to permit users to perform many functions or only a few, depending on how a member chooses to manage the data entry process. In order to permit this flexibility, security control is divided into many functions. Users can be assigned from one to all of these functions:

- Generation data entry - enter/update data elements needed to
  calculate planned & unplanned capability loss  and unplanned
  automatic scrams indicators

- Equipment performance (safety systems) data entry - enter/update
  data elements needed to calculate safety system performance
  indicator

- Chemistry data entry - enter/update data elements needed to calculate
the chemistry performance indicator

- Fuel reliability data entry - enter/update data elements needed to
  calculate the fuel reliability indicator

- Radiation protection data entry - enter/update data elements needed
  to calculate cumulative radiation exposure

- Personnel safety data entry - enter/update data elements needed to
  calculate the industrial safety accident rate

- View data only - view data elements for all indicators and run all
  reports

- Submit data to WANO - designate station data as ready for use by
  WANO

- Local administrator - assign rights to perform the functions above
  to other users in the organization

The right to perform any of the above functions is assigned for specific units, stations, or organizations (such as a utility or member).

If a member wishes to assign individuals data entry responsibilities for a specific category of data they may do so by assigning data entry privileges for that category. For example, if a station performance indicator data coordinator wished to assign the chemistry department responsibility for entering chemistry data, the coordinator would configure the User ID of one person in chemistry to permit data entry in the chemistry category. That person would then be permitted to enter data in the chemistry category but not any other category. Any user authorized to enter data in one category also is permitted to view that unit's data in other categories, though they will be unable to enter or change data in other categories.

#### Local administrators assign security

In order to assign security privileges within their organization, users must have their Ids configured as a "local administrator". Local administrators can delegate any function (all or any subset thereof) they possess to any user in their organization. For example, if a local administrator has data entry, submittal, and local administrator functions for all stations in a utility, that local administrator can delegate all or some of those functions to any user in their utility.

#### Security is administered in tiers or levels

Local administration is constructed in a tiered fashion. At the highest level, WANO Regional Center personnel are local administrators of all DES functions for every station in their region. They may delegate these privileges to any user within their region. Regional center personnel may elect to delegate local administrator privileges to one representative at each member, creating a tier of administrators that can delegate DES privileges for any station of that member. The member local administrator may delegate local administrator privileges to a representative of each utility affiliated with that member. Through this process, members can create as many or as few tiers of security administration as they wish. Listed below are some possible tiers of local administrators:

- Regional center administrator - All data entry privileges for all
  stations in their region

- Member administrator - All data entry privileges for all station of
  their organization

- Utility administrator - All data entry privileges for all stations
  of their utility

- Station administrator - All or most data entry privileges for a
  station

- Unit administrator - All or most data entry privileges for a unit

_Note that administrators can only delegate privileges they are assigned. For example, if data submittal to WANO is not assigned to an administrator, they cannot delegate that privilege._

## Data Entry System basic functionality

DES can be accessed [here](http://www.wano.org/Dk01Asp/dkw000.asp)
(for registered users only). Here is the main page screen.
![Home menu](pic/0.bmp)

### Overall Description

The WANO Data Entry System (DES) is a Web-based application developed and implemented for WANO member units to directly enter performance indicator data reportable to the WANO Performance Indicator Programme.

The reported data is used by WANO to calculate performance indicator values.  These results are periodically posted on the WANO Web site. Results are available on spreadsheets and in Web-based PI REPORTS, both available on the WANO Web site.

DES has a Home Page that provides various programme information, reminders, and a [link](http://www.wano.org/DK01/inc/DESIssues.asp) to Current DES Issues. These all should be reviewed periodically.

### Access

The application requires access to the Internet using Internet Explorer version 5.0, service pack B, or better. If access is not currently available, a member may request its regional centres to enter its data for its units; however, it is strongly suggested that each member work towards improving its Internet access to benefit from efficient data reporting and utilization of the system features.

The system is accessed through the Performance Indicator section on the WANO Web site.  An ID and password are required to access the WANO Web site; in addition, specific authorizations must be made for the ID to perform various actions within DES. The units assigned local administrator for the performance indicator program controls those authorizations.  The WANO regional centre data coordinators initially assign the local administrator authorization. The system administrator is located in WANO-Atlanta Center. (Passwords expire every 180 days.)

### Personal Authorization

Local administrators control access to DES once an ID is assigned to the individual seeking access.

### Features

The following features are included in DES:  [Data Entry](#data-entry) (the capability to enter data into data categories); [Data Submittal](#data-submittal) (the capability to submit data after entry to WANO regional centres for review, acceptance, and processing); [Data Review](#data-review) (the capability for regional centres to review and process data submitted by members); [Data View](#data-view) (the capability to view data entered into DES); and the capability to run several types of reports.

The [Reports](#reports) include data quality reports, calculations, timeliness status, and unit pedigree information.

The system also allows local administrators flexibility in assigning authorizations to other IDs of the same organization.  [Security](#administer-security) administration can be accessed under the  [Maintenance](#maintenance) tab on the DES Home Page.

Several other features are included under the [Maintenance](#maintenance) tab that allows certain label customizations and selections. These features are suggested for advanced users.  Contact the regional coordinator regarding these features.

[Help](#help) screens are available under the Help tab but are very basic and limited. Improvements will be made as resources permit. Although print and copy capability is possible, the system is designed for electronic entry, submittal, and viewing of data, and therefore printouts may not be suitable for formal reports.

Users should review all available tabs and menu items to identify all available capabilities.

### Data Entry

Authorized users enter performance data or codes in specific categories and the related comments if appropriate. If the category field has a selectable option for the corresponding unit of measure, that selection MUST be made first, turning the data field color green, before entering the numerical value. Data with a green field is called utility data as it has not been submitted to WANO for review. Calculations can be made in DES using utility data.

### Submittal

 Authorized users submit completed performance categories for specific periods.  Any or all categories may be selected for single or multiple periods at a single time. After submittal, the data field turns yellow. Data with a yellow field is called Review level data and is available to WANO for Review and acceptance. Data at the Review level cannot be changed by the utility. It is also not used by WANO in published calculations.   Authorized users can recall (by category) data in Review to utility data level if the data needs to be changed. Calculations can be made in DES using Review level data.

A separate ID can be used to submit data in order to allow an
independent verification of data quality before data categories are
submittal to WANO.

Data submitters are reminded to submit "station" level data in
addition to the "unit" level data (separate selections are
required). We have noticed that station submittal is sometimes
overlooked. We are also investigating a software change to avoid this
problem. Some units have data revisions remaining at the "utility"
level (green).  Please remember to Submit data revisions, or Refresh
to return display to production values. "Green" data has not been
submitted and is not used by WANO.  "Red" data is not used in
calculations.

Atlanta Center Stations:
- U.S. Stations Only: Data is due per schedule established by INPO (within approximately 20-22 days after end of each calendar quarter).
- Atlanta Center International Stations: Data is due 30 days following
  end of calendar quarter.

Moscow, Paris, and Tokyo Center Stations: Data is due 60 days following end of calendar quarter.

### Review by WANO Regional Staff

 Authorized users (IDs having Submit authority) submit completed performance categories for specific periods.  Any or all categories may be selected for single or multiple periods at a single time. After submittal, the data field turns yellow. Data with a yellow field is called Review level data and is available to WANO regional staff for Review and acceptance.  Data at the Review level cannot be changed by the utility. It is also not used by WANO in published calculations.  Authorized users can recall (by category) data in Review to utility data level if the data needs to be changed. Calculations can be made in DES using Review level data.

### Calculation of Results

Under the Reports tab, a user with at least View Data authority can calculate results and display those values in one of six formats.  Depending on the criteria selected, the user can calculate results based on utility level (green) data only, or production level (white) data only, or production level data with the Review level data (yellow) where it is present, for one or more units, and one or more data periods, covering one or several time periods. Please contact your regional coordinator for more details.

### Other Features

The regional coordinator should be contacted regarding other features
that may be available or other issues not addressed in this
document. The DES Home Page may also be referenced for the latest
information on the status of DES and current DES issues.

DES added a feature in August 2002 that allows authorized users to
view the data elements that contributed to the results, trend
performance, and make comparisons for units worldwide. To use the
feature, obtain a result using the Calculate Indicator feature. When
the result is displayed, select the View Data tab. The WANO PI View
Production Data page is opened. Select the appropriate data category
and the data for the time periods of the calculated result(s) will be
displayed.

U.S. members provide data into WANO DES using Consolidated Data Entry
(CDE). (Direct entry is no longer possible.) Transfer of data from CDE
into DES places data in the green utility level; data will still need
to be submitted to WANO within WANO DES for review. Please contact
INPO CDE help line, (770) 644-8500, or WANO-AC if there are questions.

A default unit of measure has been set for all units for applicable
radiation protection and fuel reliability data.  Initial default
settings are based on 2003Q3 data; however, members may change the
default setting by using the unit label customization feature of DES.
(Authority for label customization is required.)  Contact your
regional data coordinator if you have questions.

Attention U.S. members:  Some computer checks existing in DES are not in effect for U.S. members due to direct transfer into DES from CDE.  Please do not depend on computer checks to ensure data accuracy.

_NOTE: If more than one result was generated, all the applicable data periods will be displayed._

### KPIs

World Wide Key PI Reference Values - WANO has established long-term
2015 reference values for collective radiation exposure, forced loss
rate, industrial safety accident rate, and safety system performance
indicators. These values can be displayed as an option on applicable
summary and trend reports from the WANO PI REPORTS application. See
the Performance Indicators Page and the PI REPORTS application for
more information.

### Reference Manual

The PI reporting guidelines/definitions document is only available
on-line and is now referred to as the WANO PI Reference Manual
(formerly IG 19.1, Annex 1).  SSPI definitions are now provided by
reactor type.  (Chapters may be viewed on-line, or downloaded and
printed.)

### Data Entry (top menu)

The home page provides access to each of the DES modules. The area
beneath the menu bar is used by WANO to provide news and information
to DES users.

#### Home

Home - Two options are available:
- PIP Home -This option returns you to the Performance Indicator home page on the WANO Web site
- Home - This option returns you to the DES home page

#### Data Entry

The very first menu is Data Entry
![data-entry](pic/3.bmp)

The Data Entry page is your platform for entering raw data from the units for which you are responsible. If responsibility for entering data is shared with other personnel, your authority to perform data entry may be restricted to one or more performance indicator categories and/or units. You will need to verify your specific assignment(s) with your performance indicator coordinator.

This tab designed to enter the source data and to check data status
accordingly to the [Data Processing](#data-processing). The main data
entry window lokks like the following
![data-entry-window](pic/1.PNG)

When first opened, the units and time periods selected for data entry are displayed. Additionally, the six data category tabs are displayed for selection. Clicking a data entry tab displays the data form for that category.

After unit selection ([filters](#filters) are applicable) we can see
the data category selector as following
![cat-selection](pic/2.png)

![filter](pic/filter.png)

Then we can see the data for each category ![cat-selection](pic/3.png)

_Please note that all the data in this manual are faked_

##### Data Status

Data resides in one of four virtual views. These views are color coded to help users identify their status:
- Utility - Data entered by a station but not submitted to WANO for use in performance indicator program. WANO does not use or view this data until the station submits it. The cell background will be green.
- Review - Data submitted by a station to WANO but under review by a regional center. The cell background will be yellow.
- Returned - Data submitted to WANO but not accepted to the production database. It was returned to the station for revision. The cell background will be red.
- Production - Data that has been reviewed by WANO and promoted to the production database. This data is used for calculating the performance indicator values displayed on the WANO Web site and published in WANO reports. The cell background will be white.

So, the white backgroung below the data entry fiend means that data has
been promoted (see the [data processing](#data-processing) for
details). Yellow backgroung means data has been received from data
promoter, and green one means data has been sent from data promoter
but didn't submitted yet.

It is _extremly important_ user to add the [comments](#comments) as shown below for
all the data which is reflected into the [QRR](#qrr)
report. ![comments](pic/comms.png)
If the comments exist, the colour of the 'C' button is green.

##### View and Enter Data

If you have authority to enter or update data for given category and
unit, data entry cells will be displayed on the form. If you only have
authority to view data for a category or unit, the form will display
data in a table without data entry cells.

#### Using the Page

The blue tabs under WANO PI Data Entry represent the six performance indicator categories. Click on the Generation tab for an illustration of the steps involved in performing data entry.

##### Entering Data

1. Click the blue category tab in the WANO PI Data Entry window.

_Note: The unit names and the time period you have chosen previously
are already filled in for you. The Reference Unit Power is
automatically filled if the previous period contains this data. If the
Reference Unit Power is filled, Reference Energy Generation will be
calculated based on the hours in the time period times Reference Unit
Power. This auto fill feature is used on a small number of fields that
are likely to remain the same from time period to time period._

2. Definitions for the remaining data to be entered can be found on the
performance indicator definitions page.

3. To enter data, click in the appropriate cell and begin typing. For
instance, September 2000 Planned Energy Loss for Byron 2 would be
placed in the last cell of the third data row.

4. Once you have moved to a new cell for data entry, the previously
completed cell will display green, which means that data has been
entered by the unit and is only viewed by the station prior to being
submitted to WANO.

5. Continue in this fashion until you have entered all the desired data.

_Note: For some data categories, such as Chemistry and Fuel Reliability, it is not appropriate to report data when the unit is shut down. During such time periods, you may enter the letters "DN" into the data entry field to denote that accurate data could not be collected because the unit was shut down. The "DN" will be move from the data entry cell to the code field next to the cell when your cursor leaves that cell._

_In the event that you are unable to collect data for any other
reason, you may enter the letter "X" in a data entry cell to denote
that the data is unavailable. This code should be used sparingly and
should be corrected as soon as the data becomes available._

6. To enter data in another performance indicator category, click on the appropriate blue tab.

##### Comments

1. To enter a comment in a cell, click on the "c" icon and the Enter/Update User Comments dialog window appears. Enter your comments in the Utility Comments box and click OK to return to the data entry form. If a comment has been entered the "c" icon is highlighted in a bright green color when you return to the data entry form.

_Note: There is a response box called "WANO Centre Comments" where
WANO Regional Center personnel may enter comments about the data._

2. To save the data you have entered. Click on the Save button at the
top of the window.

3. After saving your data, you may use any other of the function buttons above, as previously described.

##### Submit tab

Going to the Submit tab data promoter can select the units which data
to be send to the Regional Centres for cheching and promotion. The
data selection menu is the
following. ![submit](pic/submit.png)

_Do NOT_ forget to press _Save_ button wheb operation completed.

##### Indicator Calculator

It is also possible to calculate indicators before data
submitting. The unit selection menu looks like selector in
[DES](#data-entry) above, but then you can choose the indicator report
criteria as shown
below. ![indicator-selector](pic/ind-selector.png)

Then you have to choose the final
criteria. ![final-criteria](pic/final-criteria.png)

Then the calculated indicator will be
shown. ![ind-show](pic/ind-show.png)

By pressing 'View Data' you'll be redirected to the
[source data entry](#data-entry) window as above.

##### Run QRR

QRR is the extremely important and useful instrument to double check
if all the data are correct and have not anomalies. Pressing 'Run QRR'
(Quality Report Review) you'll see the window as
below. ![qrr](pic/qrr.png)

The _Report Option_ are the following:
- All
- Missing data
- Range Checks
- Consistency check

Pressing _Go_ we can see the cheching result as follows ![qrr-check](pic/qrr-rep.png)

### Data Review

#### Review Data

The second one is Data Review ![data-review](pic/4.bmp)

After pressing the _Go_ button data will be submitted to the Regional
Centres for double-checking and
promotion. ![review-sel](pic/review-sel.png)

Then all the source data can be
reviewed.![review-data](pic/review-data.png)

In the menu there are option to promote (see
[Data Processing](#data-processing)) data, to see the production data,
or to [calculate](#indicator-calculator) indicators or to run
[QRR](#qrr).

#### Promote to Production

![](pic/promote.PNG)
![](pic/promote_2.PNG)

#### Reject to Utility

![](pic/reject.PNG)

### Maintenance

Maintenance - Two options are available for members:
- Administer Security
- Unit Label Customization
  - Permits your unit labels to be customized
  - Data value range check values can be updated for each data entry field.

#### Codes Maintenance

##### Measurement Codes

![](pic/measurement_codes.PNG)
![](pic/medit.PNG)

##### Category Codes

![](pic/cat_codes.PNG)
![](pic/cat_add.PNG)

##### Element Codes

![](pic/elCodes.PNG)
![](pic/elAdd.PNG)

##### Label codes

![](pic/labelCodes.PNG)
![](pic/labCodeAdd.PNG)

##### Category Group Codes

![](pic/catGroupLabels.PNG)
![](pic/catAdd.PNG)
![](pic/catUnits.PNG)
![](pic/catGroupScreenLabel.PNG)
![](pic/catGroupLabelAdd.PNG)

#### Data due dates

![](pic/dataDueDates.PNG)
![](pic/setDueDate.PNG)

#### Indicator Eff. Dates

![](pic/effDateSel.PNG)
![](pic/indEffDate.PNG)
![](pic/addEffDate.PNG)

#### Unit Label Customisation

![](pic/selUnitLabel.PNG)
![](pic/maintUnitLabel.PNG)
![](pic/setUnitLabel.PNG)

#### Sync Data Elemnts to the DK

![](pic/sync.PNG)

#### Promote Failure Report

![](pic/failRep.PNG)

#### Administer Security

The basic information about security please see [here](#about-security).

_Please note that security mode is only available in F12 emulation
Document Mode 5 only._ ![](pic/f12.PNG)

_Note: the advanced Security Application is now in the trial operation_

##### Purpose

This is the main menu of the DES security system. From this menu you may administer security by user or by function. More general information on how DES security works is available on the following page.  Reports also are available regarding the assignment of data entry functions in your organization.

##### Using the Page

![](pic/secMenu1.bmp)
![](pic/secMenu2.bmp)
![](pic/secMenu3.bmp)

###### Administer Security by User

From the security menu click on "Administer by User" and then click on
the menu options below, which will be "As 'entity name'".  "Entity
name" will be the name of the organization, station, or unit for which
you are a local administrator.

This page enables local administrators to change the DES privileges of an existing user or to add and assign privileges to a new user.

####### Page Elements

A list of User Ids in your organization that are already configured for the DES are displayed. You have two choices:

- Add a new user
- Update an existing user

This page also displays a dialog box that is used to find users by their name, UserID, or organization.

####### Using this Page

######## Add a new user

Click "Add" in the upper right hand corner of the page. A search form will appear that permits you to search for users by:

- Name
- Organization name
- User Id

Add User Dialog Box Select UserID Dialog Box ![](pic/addUser.gif)

Enter your search criteria and click the search button. If your search is successful, one or more User Ids will be listed below the search form. Select one of the Ids using the checkbox to the left of each Id.


Add User Search ResultsAdd User Search Results ![](pic/searchUser.gif)

The administer function form will be displayed.

######### Administer Functions by User

This page enables local administrators to change the DES privileges of an existing user or to add and assign privileges to a new user.

########## Page Elements

The form below will be displayed for updating the users security privileges. This form lists the privileges you are permitted to assign to other users.

Administer Functions Form ![](pic/admFunc.gif)

########## Using the Page

Clicking on any change button will produce a list of organizations, stations, or units for which you can delegate the selected function.

Organization List ![](pic/orgList.gif)

Select the entities you wish to delegate for that user using the check box to left of each entity. Selecting an organization authorizes that function for any station and unit in that organization. Similarly, selecting a utility authorizes that function for any station and unit in that organization. Selecting a station authorizes that function for all units at that station. Selecting a unit does not authorize that function for other units at the associated station, utility, or member.

After you complete selecting entities, click "OK" to return to the list of privileges for that user. If you are finished, click "Save" in the upper right hand corner of the page. If you wish to continue delegated privileges, you may click "Save" later. NOTE: If the "Save" button appears in black letters, unsaved changes remain to be saved. If the "Save" button is gray, all changes have been saved.

_NOTE:  Certain functions, such as data entry, require the ability to at least view station level data even if the user only is authorized data entry for a single station at a unit.  For this reason, users that are assigned privileges for a single unit should also be assigned "View" data privileges for the associated station._

When you are finished assigning security privileges, you may return to earlier pages using the "Back" button on your browser or on the top right portion of the page.

######## Update an existing user

In the list of User Ids already configured for your organization,
click on the User's ID next to the User name (Each User ID in the list
is a hyperlink). The form ![form](pic/admFunc.gif) for updating the user's security privileges will appear.

To change the scope of data entry privileges for the user, click change and continue as you would for adding a new user. To remove privileges for a User ID, uncheck boxes next to organizations, stations, or units.

###### Administer Security by Function

From the security menu click on "Administer by Function" and then
click on the menu options below, which will be "As 'entity name'".

This function is intended primarily for use by regional centers for monitoring the assignment of key DES functions.  As such, we recommend that you perform most of your DES security administration "by User" instead of "by Function".

###### Reports

Two reports are available for administering security:
- [All Users](#all-users-in-organization-report) in your org - lists all users in the organizations for which your are able to administer security.
- All Users in your org [with security](#users-with-privileges-in-your-organization-report) - lists all the DES capabilities
  of each ID in your organization that has DES privileges


####### All Users in Organization Report

######## Purpose

This report shows all User IDs assigned to personnel in your
organization. You can delegate DES privileges to these User IDs.

######## Page Elements

The list of User IDs is presented at the summary level, which is
signified by plus signs next to organization names. User IDs are
sorted by WANO Regional Center, WANO Member, utility, station, and
unit.

######## Using the Page

Clicking on a plus sign will expand the User ID list to display the
next level of detail. Continue clicking plus signs to get down to the
unit level. User IDs are displayed beneath the organizational level to
which they are assigned. A minus sign indicates all detail is
displayed at that level. Click the minus signs to compress the list.

![](pic/allUsers.gif)

####### Users with Privileges in Your Organization Report

######## Purpose

This report shows all User IDs with DES privileges in your
organization. All data entry privileges for each User ID can be found
in this report.

######## Page Elements

Information is presented at the summary level, which is signified by
plus signs next to organization names. User IDs are sorted by WANO
Regional Center, WANO Member, utility, station, and unit.

######## Using the Page

Clicking on a plus sign will expand the User ID list to display the
next level of detail. Continue clicking plus signs to get down to the
unit level. User IDs are displayed beneath the organizational level to
which they are assigned. A minus sign indicates all detail is
displayed at that level. Click the minus signs to compress the list.

![](pic/userSec.gif)

### Reports

Reports - The following reports are available:
- QRR
- Calculate Indicators
- Reporting Timeliness
- Pedigree Data Review

#### Purpose of the Page

This page is used to select the units to be used in several report modules. The title of each page will identify the report for which the unit selection page is being used.

#### Page Elements

1. Up to six drop-down lists may be used to define the desired quarter and station or unit that will be selected. The core report selections (values that are common to each of the reports) will Be Region, Member, Utility, and Station. The example below depicts the available selections for Pedigree Data Review. This report is a review of pertinent operating and design data.

![](pic/coreRep.gif)

2. Selection will be made through use of the drop-down menus.

_Note: Only the locations for which you are authorized to enter data
will be represented in the drop-down menus._

	- Click on the down arrow to the right of the Region cell and select the appropriate region.
	- Click on the down arrow to the right of the Member cell and select the desired member.
	- Click on the down arrow to the right of the Utility cell and select the utility.
	- Click on the down arrow to the right of the Station cell and select the station.

3. After these four selections have been made, the options will differ according to the type of report you are creating.
For instructions on how to generate a specific report, click on the appropriate link below.

Timeliness Report - This report provides data for users to assess the punctuality of data provided to the regional centers. Data that is submitted to the appropriate WANO regional center in accordance with the associated Due Date (30 days from the end of the report quarter for Atlanta Center and 75 days for other centers) is deemed to be Timely.

Completeness Report - The report offers an additional selection value, Desired Quarter, so that a specific time frame can be chosen. This report helps Users determine the status of reporting of performance indicators by WANO members, and shows the amount of data that has been submitted by the station and reviewed and accepted by WANO.

Quality Review Report (QRR) - The QRR Report checks your work for errors in the areas of completeness, range, and consistency before submitting the data to WANO. You may generate a report for each of six attributes, or specify that all are checked in one report.

Pedigree Data Review - The purpose of the Pedigree Data Report is for users to determine pertinent operating and design basis data about WANO member stations.

#### QRR

There are four Quality Review Reports:

1. Missing Data Report

	- points out all the cells in a given date range that have not been filled in.

2. Range Checks Report

	- captures the instances of entered data falling outside the expected range (too low or too high) for a specific data element. The data reporter can then decide if the questionable value is correct, or if the value should be adjusted.

3. Consistency Checks Report

	- highlights the cells that are not consistent with the rest of the data being submitted, giving the data coordinator the opportunity to explain the discrepancy or make the necessary adjustments to the data in question.

4. All

	- is a combination of the three above reports.

##### Page Elements

You have seen how to make the core report selections of Region, Member, Utility and Station (see Unit Selection-Reports Help) by using the arrows to view the drop-down menus.

_Note: Only the locations for which you are authorized to enter data will be represented in the drop-down menus._

 To complete the Quality Review Report set-up, eight additional values and four report options have been added for selection:

- Time Period ![](pic/timePeriod.gif)

- Category and Quality Check Selection ![](pic/checkSelection.gif)

##### How to Use This Page

1. If you click the Unit arrow, the report will provide detailed data
   for each unit identified for that station.

2. Use the check boxes to choose the data categories for which you
   want to measure completeness or choose All to view all categories.

3. Click on the down arrow to the right of Report Options: and you
   will see that four report types are available:

   - Missing Data
   - Range Checks
   - Consistency
   - All

Follow these steps for each of the four reports listed above.

4. Click Go, and the requested Quality Review Report will be generated.

_Note: The All report option has been selected; thus, the example below depicts a consolidated report._

Quality Review Report ![](pic/QRReport.gif)

5. Beginning with the first month of the selected quarter, the report
   will display, from left to right:

   - the data category
   - the data element
   - the data element value
   - QRR message explaining why the value is in question
   - Click on Data Entry to display the data entry page and change the data value or provide an explanatory comment
   - After you have made the necessary data changes, you may return to Reports/QRR and generate a new report.


#### Calculate Indicators

This is the first of two pages used to calculate WANO performance indicator values for any unit for which you are permitted to enter data or view data. It is preceded by the unit selection page, where you specified the units to be used in the calculations.

##### Page Elements

The forms on this page are used to select the report format.

##### Using This Page

1. In the Select Criteria screen, there are six selections under Report Formats:
   - Indicators by Unit
   - Time Spans by Indicator
   - Time Spans by Unit
   - Indicator Trend by Indicator
   - Indicator Trend by Unit
   - Indicator Trend by Time Span

Select Report Type Form ![](pic/selReactor.gif)

_Note the frame to the right of the report formats._

2. When you select a report format by clicking on the radio button to
   the left of the format name, a preview of the format will appear in
   the frame adjacent to the format selection. In the example below,
   Indicator-Trend by Indicator has been chosen.

3. Under Units of Measure, US Units of Measure has been selected.

4. Under Data Level, Utility Data has been chosen.

Example of Report Format Display ![](pic/repFormat.gif)

5. Click on Go and the Report: Indicators by Unit - Select Final
   Criteria screen will be displayed.

This is the second of two pages used to calculate WANO performance indicator values for any unit for which you are permitted to enter data or view data. The select report format page precedes this page, where you specified the format of the calculation results.

##### Page Elements

The top form on this page is used to select the indicators that will be calculated. Some report formats only permit calculating one indicator value. For those reports you will receive a warning message if you attempt to pick more than one indicator.

The second form selects the period end data or range of period end dates. Period End date is the last period in a range of periods used to calculate an indicator. For example, a one-year indicator value with a period end date of 2000-Q1 is calculated using the indicator values for 1999-Q2, 1999-Q3, 1999-Q4, and 2000-Q1. For trend reports, indicator values are calculated for a series of periods with consecutive end dates. For these reports, two Period Ending dropdown lists are used to select the series of consecutive period to calculate.

The final form on this page specifies how many time periods will be used in a calculation.
- Selected Period - Only data from a single period is used in the
calculation.
- 1 year - One year's data, ending with the period end date are used in the calculation.
- 2 year - Two years' data, ending with the period end date are used in the calculation.
- 3 year - Three years' data, ending with the period end date are used in the calculation.
- Custom - Specify the number of periods used in the calculation.

Final Criteria Form ![](pic/selCriteria.gif)

##### Using this Page

1. In the example above, under Indicators: Chemistry and Cumulative Radiation Exposure have been selected by clicking on the boxes directly to the left of CY and CRE.
2. Under Period (Ending): 2000-06 to 2000-09 (June 1, 2000 through September 30, 2000), and Time Spans: Custom: 3 Months have been selected.
3. Click on Go and the report that you have designed will appear.

#### Reporting Timelines

##### Purpose of the Report

This report provides data for users to assess the promptness and punctuality of data provided to the WANO Regional Centers. Data that is submitted to the appropriate WANO Regional Center in accordance with the associated Due Date (30 days for Atlanta Center and 75 days for other Centers from the end of the Reporting Quarter) is deemed to be Timely.

##### Page Elements

You have seen how to make the core report selections of Region, Member, Utility and Station (see Unit Selection-Reports Help) by using the arrows to view the drop-down menus.

_Note: Only the locations for which you are authorized to enter data will be represented in the drop-down menus._


To complete the Timeliness Report set-up, two additional values have been added for selection:
- Time Period ![](pic/timePeriod.gif)
- Unit Detail ![](pic/unitDetails.gif)

##### How to Use This Page

1. After you have made the core report selections (Region, Member,
   Utility and Station), click on the down arrow to the right of the
   Desired Quarter cell and select the calendar quarter desired for
   review.

2. If you desire detailed data for each unit identified for your
   Station, check the Include Unit Detail box. This will allow you to
   view statistics for individual units.

3. Click Go, and the Timeliness Report you have designed will be
   generated. Untimely units will be listed under the identification
   banner.

_Note: Data submittal dates were not recorded before 2001. As a result, this report will be valid only for reporting periods in the year 2001 or later._

#### Pedigree Data Review

The Pedigree Data Report allows individual users and WANO Regional Centers to determine pertinent operating and design basis data about WANO member stations.

##### Page Elements

1. You have seen how to make the core report selections of Region,
   Member, Utility and Station (see Unit Selection-Reports Help) by
   using the arrows to view the drop-down menus.

_Note: Only the locations for which you are authorized to enter data will be represented in the drop-down menus._

Core Location Selection Elements ![](pic/coreLoc.gif)

2. Click on Go, and the requested Pedigree Data Report will appear. (See example report below.)

Pedigree Report ![](pic/pedigree.gif)

#### Data Readiness

##### Purpose of the Report

This report shows the percentage of fields containing data in the WANO production database for selected time periods and categories. This percentage indicates how well stations have been able to fulfill their performance indicator data reporting commitment.

##### Page Elements

You have seen how to make the core report selections of Region, Member, Utility and Station (see Unit Selection-Reports Help) by using the arrows to view the drop-down menus.

_Note: Only the locations for which you are authorized to enter data will be represented in the drop-down menus._


 To fill out the Completeness Report set-up, eight additional values
 have been added for selection:

- Time Period ![](pic/timePeriod.gif)
- Category Selection ![](pic/catSelection.gif)

##### How to Use This Page

1. After you have made the core report selections (Region, Member,
   Utility and Station), click on the down arrow to the right of the
   Desired Quarter cell and select the calendar quarter desired for
   review.

2. Use the check boxes to choose the data categories for which you
   want to measure completeness or choose All to view all categories.

3. Click Go, and the Completeness Report you have designed will be generated.

### Submittal

Use this module to submit or recall data from your WANO regional
center. Two options are available:

- Submit Data To Regional Center
- Recall Data from Regional Center

#### Submit to Regional Centre

This page is used to select data to be submitted or recalled from your
WANO Regional Center. Data is submitted and recalled in increments of
unit, category, and time period. You may select data for as little as
one unit, one time period, and one performance indicator category or
many units, time periods, and categories.

The page title indicates whether this page was entered from the submit or recall option on the home page menu.

##### Submit Page Elements

Two drop down lists are used to select the range of data to be searched for data available for submittal. Tables contain three columns showing data status: show which categories have sufficient data to be submitted and which categories are missing data (and cannot be submitted). Additionally, data that is in review at the WANO regional center also is shown.

###### Categories Ready

Shows categories that have had utility level data that has been entered and not been submitted to WANO. Additionally, all fields in the category are complete.

###### Incomplete Categories

Shows categories that have utility level data but some fields are blank. Categories cannot be submitted with blank data fields.

###### Categories Submitted

Shows categories successfully submitted to your WANO Regional Center and in Review status.

###### Category Abbreviations

- GD (Generation Data)
- EP (Equipment Performance)
- CY (Chemistry)
- RP (Radiation Protection)
- FR (Fuel Reliability)

#### Recall from Regional Centre

The elements on the Recall page are similar to those on the Submit page, however some meanings are different. The Category Ready column now indicates data in Review status at the regional center that is available to recall. The Categories Recalled column indicates data that has been successfully recalled from the regional center.

Submit/Recall Page Elements ![](pic/selSubmit.gif)

##### Using the Page

###### Date Field

Before selecting the desired units, it is first necessary to select a
date range. Note: The nomenclature for this field is YYYY-MM

- Click on the arrow in the From: menu and highlight the desired year-month. (This field is defined as the first day of the selected month.)
- Next, click on the arrow in the To: menu and highlight the desired year-month. (This field is defined as the last day of the selected month.)

###### Selectable Units

_Note: In the above screen, the user will notice there are no units
 selected._

_Note: All stations for which your ID has authority to submit data will be listed under the Selectable Units list box._

By clicking on the box to the left of the identified unit, that unit will be selected for placement in the Chosen Units table for submittal to the WANO Regional Center.

###### Chosen Units

_Note: Notice that selected units move from the selectable table to the chosen table._

Click "Go" to process your selection.

### Help

Three kinds of help are available

#### PIP Definitions

A link to the performance indicator definitions page.

#### User Priviledges

Display User functions that are authorized.

#### View Help

Instructions for using DES

## Reports

To access to the Report System you've to use
[this](http://www.wano.org/xwp10webapp/Confidentiality.aspx) link.

Be sure that you have access to the WANO member website because the system will asko you log in

![](pic/login.PNG)

Then you will see the Confidentiality Notice

![](pic/notice.PNG)

The PI REPORTS application on the Performance Indicator Web page allows users to obtain results, trend performance, and make comparison for units worldwide. Trend charts and summary tables can be viewed, copied, saved and printed.  WANO PI REPORTS is a time-saving and informative supplement to DES and the Microsoft Excel results spreadsheets.

The Report System is designed to provide all kind of the precalculated
results and reports based on PI Programme needs. Howevew, the list of
indicators and reports is slightly out of dates, therefore you have to
realise all the additional functionality described in
[Prototype](#prototype) section below.

The design of the Report System is similar as
[DES](#data-entry-system) is.

By selecting [Standard Reports](#standard-reports) or [Custom Reports](#custom-reports) from the drop-down menus at the top of the page, a WANO user can review performance of any unit or group of units as measured by the performance indicator programme. Performance charts and tables can be viewed, copied, and saved. Please remember that data confidentiality and limited distribution policies apply.

![](pic/rMenu1.bmp)
![](pic/rMenu2.bmp)

All results are for currently operating units reporting performance
indicator data only

Generating PI REPORTS with WANO Key Performance Indicator Reference Values Displayed - More information [here](http://www.wano.org/PerformanceIndicators/PI_Reports_Documents/Generating_PI_REPORTS_with_Interim_Goals.pdf) and below.

![](pic/rMenu3.bmp)
![](pic/rMenu4.bmp)

From the menu bar, the available types of reports can be viewed by passing the cursor over the Standard Reports and Custom Reports menu items. Select the desired drop-down report by single-clicking on it. Definitions are provided below. The selection will take the user to the appropriate report selection criteria screen.

### Generating PI REPORTS with WANO Key Performance Indicator Targets Displayed on the Report

#### Background and Objective:

Upon the decision by the WANO Governing Board to implement Key Performance Indicator targets, a way was needed to observe performance relative to those values. The existing WANO application, PI REPORTS, was identified as an existing application that could be modified to display those values on the reports if a user so desired.

#### Description:

WANO PI REPORTS, available to WANO membership on the WANO restricted Web site since 2001,provides the capability to generate both summary tables (quarterly results) and trend charts (performance trended over time). The report selection process has been modified by adding steps related to the display of target values (also called reference values) for applicable indicators.

##### Summary Table:

An option was added to display for both individual and industry values on a summary table report. If selected, the “individual” unit (or station) WANO target is displayed on the table in the appropriate location in red font; when applicable, the “worst quartile target” will appear in red font next to the actual worst quartile value. The summary table report also now identifies the specific selected member or utility, or states “Custom” if a selection was modified.

##### Trend Chart:

A new step was added when generating a trend report. Depending on the criteria selected, either the individual or industry target may be selected to appear on a trend report; a link is provided on the Web page identifying the requirements for displaying various target values. Targets will be displayed in red.

In reviewing the modified reports, users should have:

1. a basic understanding of the WANO Performance Indicator Program
2. an understanding of the WANO targets (see separate document available on WANO Web site)

And be aware of the following:

1. Target values can only be displayed for the selected WANO indicators: FLR, CRE, ISA,
and SSPI (three indicators, SP1, SP2, and SP5).
2. There are two types of target values: individual and industry. Individual reference values apply to units (CRE, FLR, SP1, SP2, SP5) and stations (ISA, SP5); industry goals may be a “worst quartile
value” (CRE, FLR, ISA) or relative mean performance (SSPI) of worldwide units.
3. Targets for CRE and SP1 and SP2 are based on reactor type.
4. Displayed numerical values are approved target values.
5. Values will only be displayed if appropriate criteria is selected; that is, for example, results period must be “36 months“.
6. Display of target values on the reports is optional.
7. Trend chart display requirements are described in a link available on the appropriate selection
page in PI REPORTS.


The Custom Reports currently include complete results through the most recent quarter currently available.  *Complete results are defined as being inclusive of all available unit data for the period. Results in Custom Reports are updated automatically every weekend to reflect data changes processed by WANO during the prior week.*

### Standard Reports

Currently, the only standard reports available are standard charts. The standard charts are trend charts showing performance of pre-identified groups, using 1-year (12-month) indicator values, generated for applicable indicators and reactor type. The median value of the group is trended over 20 quarters ending with the most recently released quarter's results. Over 330 chart reports are available. Supporting data tables are also available. Pre-identified groups within standard charts include regional centers, major WANO members, and a worldwide group. Customized charts using other groupings, periods, or results may be obtained by using Custom Reports.

Standard Reports include: Group Index Ranking reports for pre-selected groups, Index Tables for each unit, and Regional Center Target Performance Reports. Standard reports also include five-year trend charts of the median of the 12-month indicator values of each unit/station within pre-identified groups.  Performance charts are updated each quarter.

#### Standard Report Selection

##### Page Description

This page identifies the selection criteria for choosing one of over 330+ standard charts that are available.  These standard charts are typically generated once per quarter (and therefore will not reflect changes to data/results until the next quarter’s charts are generated).  Each category/field must have a selection.  Clicking on View Report will display the trend chart for the selected criteria.

##### Actions

Make a selection from each field.  Some selections are limited based on other selections (i.e., a FRI standard report is not available for ALL reactor types.)   After all selections are complete, select the View Report button below the selection criteria window.  To leave the page without clicking on View Report, click on the Main Menu link in the upper left.  Close a chart by clicking on the x box in the upper right-hand corner.

##### Definitions

The following report types are available:

###### Group

One of several pre-identified groups that comprise a different set of preselected units.  Predefined groups include regional centers, major members, and a worldwide group.  These groups are also available to select in most custom reports.

###### Indicator
Any of the currently active WANO performance indicators.  (To support the application some indicators are specially coded:  ISA1 is the Industrial Safety Accident Rate indicator calculated per 1,000,000 man-hours worked, whereas ISA2 is calculated per 200,000 man-hours worked.)

###### Unit of Measure (UOM)

A unit of measure must be selected for a standard report for two indicators.  Available choices are US or Metric.  For CRE, a US selection will report results in man-rem; selecting Metric will use man-Sieverts.  For FRI, the US unit of measure is microcuries (US) and the Metric unit of measure is Becquerels.  For unitless values, US will be indicated as the default UOM.  The metric selection provides the same value (no conversion is made between the two) and the indicator has the same meaning.

###### Reactor Type

Units worldwide are identified by type of reactor. Stations are not identified by reactor type because a station may have multiple units of differing reactor types. Various indicator charts are available per reactor type.  Some reports may provide a selection of ALL reactor types and others may limit selection to a specific available reactor type. Station level indicators cannot be selected based on reactor type because a station may have more than one reactor type when it has more than one unit.

###### Result Period

The result period is not a selection option for a standard chart but is described below for completeness.  Only 1-year results (12 months Results Period) are in standard charts.

The results period identifies the number of months of data considered in calculating a single result.  Data is reported to WANO via the Data Entry System as either monthly or quarterly data, and for consistency, the selection of how much data to use for a single result is identified by the number of months. Therefore to view the 1-year results, the user selects 12 months, indicating that the indicator result will be based on qualified data from the 12 months (or 4 quarters) ending with the quarter for which the result is desired.  The available results periods are limited to 3 months (a calendar quarter), 12 months (a 1-year value), 18 months (a year-and-a-half value), 24 months (a 2-year value), and 36 months (a 3-year value).

###### Ending Quarter

The ending quarter for a standard chart is not a selection option, but is described below for completeness.  For a standard chart, the ending quarter is always the last released quarter.  See the Trend Chart Selection Help Page for a description of the last released quarter.

The ending quarter for a trend chart is the last quarter for which performance is trended and cannot exceed the last released quarter.  To obtain a trend chart with a different ending quarter than used in a standard chart use a custom trend chart from Custom Reports.


#### Index Table

![](pic/index1.PNG)
![](pic/index2.PNG)
![](pic/index3.PNG)

#### Group Index Ranking

![](pic/grIndex1.PNG)
![](pic/grIndex2.PNG)

### Custom Reports

Custom reports are trend charts and summary tables that are generated based on the selections of users. The user may specify — within limitations of the data and the desired report — the unit or group, the applicable time period or time span, the indicator, reactor type, and the result period (the number of months of data used in calculating a single result, e.g., 3, 12, 18, 24, 36 months) for a desired report. Supporting data tables are also available for the trend charts.

These are performance indicator trend charts or data tables for user-selected time periods, results periods, and units. These charts provide options to include target values for applicable indicators and the option to compare performance between units or groups on a single chart. The charts are generated from the most current available results. Typically, results are updated every weekend to reflect recent data changes.

Within Custom Reports, an "index" value is an available option for a trend chart. "Method 4" is used to calculate an index value for all units, but only a user's unit(s) or group(s) is available to trend. Index tables are provided under Standard Reports.

#### Summary Table

The summary table is a data table showing a list of individual indicator results for the calendar quarter selected. The user selects a single result period, which is the number of months of data used to calculate a single result, e.g., 3, 12, 18, 24, or 36 months). The report also provides the median, mean, and upper and lower quartiles for the grouping of the selected units/stations. The user can select entire groups or select individual units/stations within centres to create a customized grouping.

![](pic/sumTab1.PNG)
![](pic/sumTab1_1.PNG)

##### Page Description
This page contains the selection criteria for a custom summary table.  The Summary Table is generated based on the selections made by the user, using the most recent unit/station results.  Clicking on “View Report” will display the summary table for the selected criteria.

###### Actions

Make a selection from each option.  Three pages are used as indicated by the 3 buttons on the left of the selection windows.  The buttons or the “Next Page” button may be used to move to the next selection screen.  Some selections are limited based on other selections.   After the final selection screen is complete, the summary of the report selection criteria can be reviewed.  When the review is complete, select “View Report” below the summary window.  To leave the page without clicking on “View Report”, click on the “Main Menu” link in the upper left.  The left buttons or the “Back” button below the selection/summary windows may be used to move between selection pages.

![](pic/sel.bmp)

###### Definitions

The following report types are available:

####### Group

One of several pre-identified groups that comprise a different set of pre-selected units.  Pre-identified groups include regional centers, major members, and a worldwide group.  These groups are also available to select in Standard Charts and Custom Trend Charts.

![](pic/sumTab2.PNG)
![](pic/sumTab2_1.PNG)
![](pic/sumTab3.PNG)
![](pic/sumTab3_1.PNG)
![](pic/sumTab4.PNG)
![](pic/sumTab4_1.PNG)

####### Indicator

Any of the currently active WANO performance indicators.  (To support the application some indicators are specially coded:  ISA1 is the Industrial Safety Accident Rate indicator calculated per 1,000,000 man-hours worked, whereas ISA2 is calculated per 200,000 man-hours worked.)


####### Unit of Measure (UOM)

A unit of measure must be selected for a standard report for two indicators.  Available choices are US or Metric.  For CRE, a US selection will report results in man-rem; selecting Metric will use man-Sieverts.  For FRI, the US unit of measure is microcuries (US) and the Metric unit of measure is Becquerels.

####### Reactor Type

Various indicator reports are available per reactor type.  Some reports may provide a selection of ALL reactor types and others may limit selection to a specific available reactor type.

####### Result Period

The number of months of data considered in calculating a single result.  Data is reported to WANO either on a monthly or quarterly basis, but for consistency, the selection within this application used to identify the amount of data to be considered for use in a single calculation is identified by months.  Therefore, to view a 1-year result – a result based on data from the past 4 quarters or 12 months, the user selects 12 months.  The desired indicator result that will be used/displayed in the report will be based on qualified data from the 12 months, or 4 quarters, ending with the quarter specified as the ending quarter.  The available results periods are limited to 3 months (a calendar quarter), 12 months (a 1-year value), 18 months (a year-and-a-half value), 24 months (a 2-year value), and 36 months (a 3-year value).

The ending quarter can be any calendar quarter (back to 1990, inclusive).

For example, a 1-year UCF result for a unit for the fourth quarter of 2001 would be calculated using the qualified data for the 12 months (or 4 quarters) prior to and including the fourth quarter of 2001.

####### Starting Quarter

The quarter which is the start of the indicator trend chart.  The starting quarter can be any calendar quarter (back to 1990 inclusive.)

####### Ending Quarter

The quarter which is the end of the indicator trend chart.  The ending quarter can be any calendar quarter up to the last released quarter.

####### Last Released Quarter

The last (most recent) quarter for which calculated results have been released by the WANO system administration.  Last released quarters may differ among members based on the data due dates  (i.e., members with data due sooner will likely have their data released earlier if all data is received.)

#### Trend Chart

The custom trend chart shows performance of a user-selected unit, pre-identified group, or user customized grouping. The selected performance can be compared to another selection if desired. The user specifies the start and end quarters of the chart, using any available calculated indicator result period (as indicated by the number of months in a single calculated result, e.g., 3, 12, 18, 24 or 36). Supporting data tables are also available.

This page identifies the selection criteria for a custom trend chart.  These custom charts may be generated at any time and will be based on the latest results available.  Each field must have a selection, although some selections do have a default value.  Charting options are available.  Clicking on View Report will display the trend chart for the selected criteria.

##### Actions

Make a selection from each.  Four pages are used as indicated by the four buttons on the left of the selection/summary window.  The buttons or the Next Page button may be used to move to the next selection screen.  Some selections are limited based on other selections.   After the final selection screen is complete, a summary of the report selection criteria may be reviewed.  When the review is complete, select View Report below the summary window.  To leave the page without clicking on View Report, click on the Main Menu link in the upper left.  The left buttons or the Back button below the selection window may be used to move between selection/summary pages.

##### Definitions

The following report types are available:

###### Group

One of several pre-identified groups that comprise a different set of preselected units.  Predefined groups include regional centers, major members, and a worldwide group.  These groups are also available to select in Standard Reports and Custom Summary Tables.

###### Indicator

Any of the currently active WANO performance indicators.  (To support the application some indicators are specially coded:  ISA1 is the Industrial Safety Accident Rate indicator calculated per 1,000,000 man-hours worked, whereas ISA2 is calculated per 200,000 man-hours worked.)

![](pic/trend1.PNG)

###### Unit of Measure (UOM)

A unit of measure must be selected for a standard report for two indicators.  Available choices are US or Metric.  For CRE, a US selection will report results in man-rem; selecting Metric will use man-Sieverts.  For FRI, the US unit of measure is microcuries (US) and the Metric unit of measure is Becquerels.

###### Reactor Type

Various indicator reports are available per reactor type.  Some reports may provide a selection of ALL reactor types and others may limit selection to a specific available reactor type.

###### Result Period

The number of months of data considered in calculating a single result.  Data is reported to WANO either on a monthly or quarterly basis, but for consistency, the selection within this application used to identify the amount of data to be considered for use in a single calculation is identified by months.  Therefore, to view a 1-year result – a result based on data from the past 4 quarters or 12 months, the user selects 12 months.  The desired indicator result that will be used/displayed in the report will be based on qualified data from the 12 months, or 4 quarters, ending with the quarter specified as the ending quarter.  The available results periods are limited to 3 months (a calendar quarter), 12 months (a 1-year value), 18 months (a year-and-a-half value), 24 months (a 2-year value), and 36 months (a 3-year value).

For example, a 1-year UCF result for a unit for the fourth quarter of 2001 would be calculated using the qualified data for the 12 months (or 4 quarters) prior to and including the fourth quarter of 2001.

###### Starting Quarter

The quarter which is the start of the indicator trend chart.  The starting quarter can be any calendar quarter (back to 1990 inclusive.)

###### Ending Quarter

The quarter which is the end of the indicator trend chart.  The ending quarter can be any calendar quarter up to the last released quarter.

###### Last Released Quarter

The last (most recent) quarter for which calculated results have been released by the WANO system administration.  Last released quarters may differ among members based on the data due dates  (i.e., members with data due sooner will likely have their data released earlier if all data is received.)

![](pic/trend2.PNG)

###### Charting Options (within the trend chart selection criteria)

The custom trend charts selection allows the user an option to obtain a trend of only one selection (for instance, a Base)  or two different selections (a Base and a Comparison).

If only a Base is desired, only one selection is available (labeled Selection 1).  The options for the selection are statistic type and chart type.

If both a Base and a Comparison are desired, two selections are made (labeled Selection 1 and Selection 2).  The options for each selection are statistic type and chart type.   If two selections are made, at least one selection must have a line chart type.

###### Statistic Type

A selection may be displayed as an individual trend (only if an individual unit/station is selected) or as a median, quartiles, or mean (average) if a group (more than one unit/station) is selected.

###### Chart Type

The selection’s indicator trend may be displayed as a line or a bar.  If two selections are made, only one may be a bar.  One must be a line.

![](pic/trend3.PNG)
![](pic/trend4.PNG)

Report Selection Requirements to Display CRE, FLR, ISA, SP1, SP2, or SP5 Interim Targets on Trend Charts. (Only one option can be selected.)

Individual: To display CRE, FLR, ISA, SP1, SP2, or SP5 individual targets on a trend chart, the following must be selected:

- Reports Period must be "36 Months"
- Statistic Type must be "Individual"

Worldwide Worst Quartile: To display CRE, FLR, or ISA worst quartile targets on a trend chart, the following must be selected:

- Reports Period must be "36 Months"
- Statistic Type must be "Quartiles"
- For CRE, Reactor must be a specific reactor type (AGR, BWR, LWCGR, PHWR, or PWR)
- For FLR, Reactor must be "All Reactors"
- Data Set must have all available regional centers selected

Mean Performance: To display SP1, SP2, or SP5 mean performance target and result on a trend chart, the following must be selected:

- Reports Period must be "36 Months"
- Statistic Type must be "Mean"
- For SP1 or SP2, Reactor must be a specific reactor type (AGR, BWR, LWCGR, PHWR, or PWR)
- Data Set must have all available regional centers selected

![](pic/trend5.PNG)
![](pic/trend6.PNG)

![](pic/dataOnly.PNG)
![](pic/chartOnly.PNG)
![](pic/chartAndData.PNG)

#### Result Period

The results period identifies the number of months of data considered in calculating a single result. Data is reported to WANO via the Data Entry System as either monthly or quarterly data; and for consistency, the selection of how much data to use for a single result is identified by the number of months. Therefore to view the 1-year results, the user selects 12 months indicating that the indicator result will be based on qualified data from the 12 months (or 4 quarters) ending with the quarter for which the result is desired. The available results periods are limited to 3 months (a calendar quarter), 12 months (a 1-year value), 18 months (a year-and-a-half value), 24 months (a 2-year value), and 36 months (a 3-year value).

For example, a 1-year UCF result for a unit for the 4th quarter of 2001 would be calculated using the qualified data for the 12 months (or 4 quarters) prior to and including the 4th quarter of 2001.

### Maintenance

#### Process Results

![](pic/procRes1.PNG)
![](pic/calcDate.PNG)
![](pic/uSel.PNG)
![](pic/uInfo.PNG)

![](pic/procRes1_1.PNG)
![](pic/procRes1_2.PNG)

#### Release Data

![](pic/relData.PNG)

#### Generate Standard Reports

##### Standard Report Selection

###### Page Description

This page identifies the selection criteria for choosing one of over 330+ standard charts that are available.  These standard charts are typically generated once per quarter (and therefore will not reflect changes to data/results until the next quarter’s charts are generated).  Each category/field must have a selection.  Clicking on View Report will display the trend chart for the selected criteria.

####### Actions

Make a selection from each field.  Some selections are limited based on other selections (i.e., a FRI standard report is not available for ALL reactor types.)   After all selections are complete, select the View Report button below the selection criteria window.  To leave the page without clicking on View Report, click on the Main Menu link in the upper left.  Close a chart by clicking on the x box in the upper right-hand corner.

####### Definitions

The following report types are available:

![](pic/stRep1.PNG)

######## Group

One of several pre-identified groups that comprise a different set of preselected units.  Predefined groups include regional centers, major members, and a worldwide group.  These groups are also available to select in most custom reports.

######## Indicator

Any of the currently active WANO performance indicators.  (To support the application some indicators are specially coded:  ISA1 is the Industrial Safety Accident Rate indicator calculated per 1,000,000 man-hours worked, whereas ISA2 is calculated per 200,000 man-hours worked.)

######## Unit of Measure (UOM)

A unit of measure must be selected for a standard report for two indicators.  Available choices are US or Metric.  For CRE, a US selection will report results in man-rem; selecting Metric will use man-Sieverts.  For FRI, the US unit of measure is microcuries (US) and the Metric unit of measure is Becquerels.  For unitless values, US will be indicated as the default UOM.  The metric selection provides the same value (no conversion is made between the two) and the indicator has the same meaning.

######## Reactor Type

Units worldwide are identified by type of reactor. Stations are not identified by reactor type because a station may have multiple units of differing reactor types. Various indicator charts are available per reactor type.  Some reports may provide a selection of ALL reactor types and others may limit selection to a specific available reactor type. Station level indicators cannot be selected based on reactor type because a station may have more than one reactor type when it has more than one unit.

######## Result Period

The result period is not a selection option for a standard chart but is described below for completeness.  Only 1-year results (12 months Results Period) are in standard charts.

The results period identifies the number of months of data considered in calculating a single result.  Data is reported to WANO via the Data Entry System as either monthly or quarterly data, and for consistency, the selection of how much data to use for a single result is identified by the number of months. Therefore to view the 1-year results, the user selects 12 months, indicating that the indicator result will be based on qualified data from the 12 months (or 4 quarters) ending with the quarter for which the result is desired.  The available results periods are limited to 3 months (a calendar quarter), 12 months (a 1-year value), 18 months (a year-and-a-half value), 24 months (a 2-year value), and 36 months (a 3-year value).

######## Ending Quarter

The ending quarter for a standard chart is not a selection option, but is described below for completeness.  For a standard chart, the ending quarter is always the last released quarter.  See the Trend Chart Selection Help Page for a description of the last released quarter.

The ending quarter for a trend chart is the last quarter for which performance is trended and cannot exceed the last released quarter.  To obtain a trend chart with a different ending quarter than used in a standard chart use a custom trend chart from Custom Reports.

![](pic/stRep2.PNG)

![](pic/promote_3.PNG)
![](pic/promote_31.PNG)

![](pic/view.PNG)
![](pic/view2.PNG)
![](pic/view3.PNG)

#### Targets Report

![](pic/target1.PNG)
![](pic/target2.PNG)

#### ISA Industry Calculation

![](pic/isaCalc.PNG)

#### Maintain Groups

![](pic/group1.PNG)
![](pic/group2.PNG)
![](pic/group3.PNG)
![](pic/group31.PNG)
![](pic/group4.PNG)
![](pic/group5.PNG)
![](pic/group6.PNG)

#### Chart Definitions

![](pic/chartDef1.PNG)
![](pic/chartDef11.PNG)

#### Maintain Index

![](pic/index01.PNG)
![](pic/index02.PNG)
![](pic/index021.PNG)
![](pic/index03.PNG)
![](pic/index031.PNG)
![](pic/index04.PNG)

#### Maintain Indicators

![](pic/ind1.PNG)
![](pic/ind11.PNG)

#### Maintain Support Emails

![](pic/email.PNG)

#### View Error and Info Log

(cuirrently unavailable)

### Help

Additional information is provided on associated Help pages

#### Send us Your Comments/Questions

![](pic/feedback.PNG)

## FAQ

(copied from the PI webgage)

### Data Entry Code Entries

_When should data entry codes DN and X be used instead of numerical values?
The data entry codes DN and X should only be used in the following
specific circumstances. Normally, numerical values are entered and
data fields are never left blank._

The DN code should only be used instead of a numerical value when the
value cannot be determined due to power requirements of the reporting
guidance for the data element. Only the chemistry and fuel reliability
data categories have data elements that have power
requirements. Therefore, if no data element value meeting the data
requirements is available, a DN code should be entered instead of
leaving the field blank.

The X code is used in any data element field where the value is not
available due to circumstances that prevented collection of numerical
data that would normally be available.

The use of DN or X in a data field results in that period's data
elements not being used in indicator calculations.

### Performance Indicator Results Spreadsheets

_Several columns in the unit performance indicator results published
on the WANO Web site contain the words "data code" in the title. What
are these columns for, and what do the single characters in these
columns represent?_

These columns indicate whether valid results could be calculated for
the associated indicator using the raw data provided by the
station. The letters are data disqualification codes. The presence of
a disqualification code usually means that a valid result could not be
calculated, and the letter indicates the reason why. In the WANO
year-end report, indicator values with a disqualification code are
excluded from calculation of industry values.


A)	Commercial Date disqualification. The unit has no assigned commercial date or the indicator period starts before the unit's commercial date and there is:
- More than 2 months qualified data for a quarterly value, or
- More than 6 months qualified data for a 1-year value

B)	Commercial Date disqualification. The unit has no assigned commercial date or the indicator period starts before the unit's commercial date and there is:
- More than 12 months qualified data for a 2-year value, or
- More than 18 months qualified data for a 3-year value.

C)	Commercial Date disqualification. The unit has no assigned commercial date or the indicator period starts before the unit's commercial date and there is
- Less than 2 months qualified data for a quarterly value, or
- Less than 6 months qualified data for a 1-year value, or
- Less than 12 months qualified data for a 2-year value, or
- Less than 18 months qualified data for a 3-year value.

D)	Value not qualified due to errors in the data provided.

H)	Value not qualified due to insufficient critical hours.

L)	Value not qualified because unit is in long-term shutdown.

M)	Value not qualified due to insufficient or invalid data.

P)	Value not qualified because reactor power was below required
level.

_What do the column headings SP1, SP2, and SP5 mean in the performance
indicator results table published on the WANO Web site?_

These headings identify the safety systems monitored by the safety
system performance indicator. SP5 refers to the emergency AC power
system. Other systems monitored vary according to reactor type. The
table below explains what systems are referred to by the designators
SP1 and SP2.

|Reactor Type|	SP1|	SP2|
|------------|-----|-------|
|PWR / VVER|	high pressure safety injection system|	auxiliary feedwater system|
|BWR|	high pressure injection/heat removal systems|	residual heat removal system|
|RBMK| (first generation)| 	emergency heat removal system|
|RBMK| (second generation)| 	first emergency heat removal system	second emergency heat removal system|
|PHWR|	high pressure emergency coolant injection system|	auxiliary boiler feedwater system|
|Magnox Reactors|	emergency feed system|	tertiary feed system|
|Advanced Gas Cooled Reactors|	emergency feed system|	back up cooling system/decay heat loops|
|FPF (fuel processing facility)|	N/A|	N/A|

### Performance Indicator Definition Interpretation Issues

_In the Performance Indicator Reference Manual chapter for "UNPLANNED SCRAMS PER 7000 HOURS CRITICAL", a clarifying note states : "Each scram caused by intentional manual tripping of the turbine should be analysed to determine those which clearly involve a conscious decision by the operator to manually trip the turbine to protect important equipment or to minimize the effects of a transient. Scrams that involve such a decision are considered to be manual scrams." However, is the scram reported as a manual scram or automatic scram when the reactor scram is caused by the operator manually tripping the turbine unintentionally or unconsciously because of human error?_

If an operator had no intention (did not involve a conscious decision)
of tripping the turbine to protect important equipment or to minimize
the effects of a transient (whether by human error or otherwise) and
an automatic scram resulted from the operator actions, the reactor
scram would be reported as an automatic scram. The clarifying note in
the guidance is provided to characterize the intentional turbine trip
that results in a reactor scram as "manual" because the intention of
the operator was to protect important equipment or to minimize the
effects of a transient by tripping the turbine and the reactor (in
other words, it was a conscious decision). When an unintentional trip
of the turbine results in a reactor scram, it is reported as
"automatic" because it reflects the response of the reactor protection
system to the unintentional turbine trip.

_In the Safety System Performance Indicator chapters, a clarifying
note is provided under Support System Unavailability that reads:
"Unavailable hours are also reported for the unavailability of support
systems that maintain required environmental conditions in rooms in
which monitored safety system components are located if the absence of
those conditions is determined to have rendered a monitored function
of a train unavailable for service at a time it was required to be
available." Since it is the unavailability of the function of the
monitored system that is being reported, how does support system
unavailability affect data reporting? If the temperature is normal,
but cooling is unavailable, is unavailability reported?_

Unavailable hours are reported for the monitored system, not the
support system, so the reported unavailable hours are only those for
when the monitored system is unavailable. If the temperature (or other
environmental conditions) in a room are such (e.g., high), due to the
unavailability of the support system, that the monitored train, as
determined by station staff, cannot then perform its monitored
function, unavailable hours are reported. If the temperature (or other
environmental conditions) in a room are such (e.g., normal) that the
conditions do not then affect the monitored function, as determined by
engineering evaluation, no unavailable hours are reportable - even if
the support system is unavailable - as long as the monitored train is
able to perform its monitored function. Once environmental conditions
reach the point the monitored train cannot or did not perform its
function, unavailable hours are reported. An engineering determination
is required to determine if (or when) the monitored function is lost.

_A nuclear power station often does not own the switchyard even though
it is on-site. Distribution company staff often perform work and
various other activities in the switchyard. The station does not own
the equipment and the workers may not even be assigned to the
station. Are generation losses due to causes, actions, or equipment
failures within the switchyard reportable to WANO for use in the UCF,
UCLF, and FLR indicators?_

WANO reporting guidance does not base reportability of generation losses on "who owns" the equipment or "who performed" activities that resulted in generation losses. Rather, reportability is based on whether the causes of the generation loss were "under the control of plant management.
Management control at a nuclear power station and its switchyard is
viewed as very extensive. Because plant management is expected to
"have control" over the switchyard equipment, the status of the
equipment, and the activities in the switchyard that may result in
lost generation, the generation losses would be reportable.

_Multi-unit CANDU nuclear power stations have sometimes experienced
difficulty in determining reportable component unavailability to WANO
in the monitored safety systems due to the design redundancy and
spares. This is partly due to the design and the difficulty in
identifying the trains and the effect on the identified trains. How
can local terminology assist in determining the data to be reported?
How is the indicator calculated for these stations when as little as
one train may serve multiple units?_

The WANO performance indicator program reference manual establishes
guidance for reporting unavailability data for three separate safety
system performance indicators. For comparability worldwide, the
indicators are defined in terms on "unavailability per train". The
indicator is calculated using each system's number of trains,
pre-identified by the station, and "unavailable hours" based on
"component" unavailability that result in the monitored train/system
being unable to perform the monitored function, and the number of
hours these trains are required to be available for service while the
unit is operating. Since CANDU reactors at multi-unit stations often
have (are designed with) component redundancy built-in rather than a
redundancy of trains of components within a system, the provided
guidance may be difficult to apply consistently.

At some stations, only one monitored train may exist with multiple
redundant components within the train. Determining "unavailable hours"
requires knowledge of the components to be monitored (only those
required to be in service while a unit is operating) and the hours a
system/train is required to be in service. The hours those trains are
required to be in service are defined by the guidance depending on the
monitored system, and a default value is used in the indicator
calculations. The unavailable hours are reported by every unit that is
affected by the unavailability.

At many CANDU units, component unavailability affecting system
function is defined in terms of "levels of impairment". Multiple pumps
and other components result in train/system redundancy that allows an
unavailability of some components to have no affect on the ability of
the monitored system to perform the monitored functions. These
redundant components may be considered installed spares if
unavailability does not affect the ability of the trains to perform
its functions. These may be currently identified as "level 3"
impairments, i.e. reduction in redundancy. An unavailability that
results in a "level 1 or 2 impairment" is considered as resulting in
component unavailable hours, and those unavailable hours (planned or
unplanned) are reported to WANO. Identified fault exposure hours must
be considered (unavailable hours of "spares" are not reported, but the
full reference manual guidance should be reviewed for details). As
mentioned, if unavailability affects more than one unit at a
multi-unit station, the unavailability is reported by each unit.

Knowing unavailable hours of the monitored components, the required
hours (default values), and the number of trains, the safety system
indicators can be calculated in terms of "unavailability/train" for
each of the three systems within the WANO PI program.

_At a PWR, letdown flow normally includes flow through
demineralizers. If the demineralizers are out of service the iodine
concentrations in the reactor coolant increase. Does having the
demineralizers out of service satisfy the steady state conditions
needed for valid data collection? In other words, should fuel
reliability indicator (FRI) data be collected and used from periods
when the purification demineralisers are out of service?_

For PWRs, it is assumed that data collection occurs with normal
letdown (purification) system conditions existing; these conditions
include the demineralizers being in service with normal letdown flow
and steady state chemistry conditions. If these conditions are not met
the FRI data collected while the demineralizers were out of service
should not be included with the remaining monthly data used to
determine the FRI data element values for that month. This is the same
as not using the data from when the unit is below 85% power or the
unit was not at steady state power for at least three days as defined
in the guidance.

_Regarding the industrial safety accident rate indicator (ISA), if an
employee who normally performs five different tasks is injured such
that he/she is no longer capable of performing one of those tasks (but
still capable of performing the remaining four tasks), should that
injury be reported as a restricted work accident? (This also applies
to contactor employees for CISA.)_

Yes. Even though the employee is capable of performing most of the
tasks, since he/she is not capable of performing them all, it is a
restricted work accident.

_Regarding the safety system performance indicators (SSPI), I
     understand that some other non-WANO indicators do not use the
     same guidance for fault exposure as WANO, and some organizations
     do not wish to include fault exposure hours in their
     calculations; are fault exposure hours still reportable to WANO
     for the WANO performance indicators?_


Yes. Fault exposure hours are still to be reported to WANO as part of
the safety system performance indicator as specified in the
guidance. There are several (non-WANO) indicators throughout the
worldwide nuclear industry and their definitions may vary from the
WANO definitions. However, the WANO safety system performance
indicators use fault exposure hours as one of three unavailability
terms in its calculation and therefore the fault exposure data for all
reportable systems are to be reported to WANO as part of the WANO
performance indicators.

_We have heard that some non-WANO groups asked that fault exposure
data collection be stopped. Is that true?_

Yes, a non-WANO member did request that the fault exposure data not be
collected for emergency AC power systems. Since fault exposure is
considered an integral part of the determination of all safety system
unavailability, fault exposure was not removed from the indicator
definition and data collection of fault exposure hours was never
stopped. All fault exposure hours are to be reported per the WANO
reporting guidelines for all the reportable safety systems, including
emergency AC power.

_What planned outage end date do I use to determine the amount of
unplanned energy losses that my unit experiences? Our station has an
end date established with and agreed to by the grid dispatcher, but we
also have a work schedule which shows a scheduled outage end
date. Some units have a detailed schedule of activities used for
directing the outage. Which date is the basis for determining if an
outage extends beyond its planned end and therefore requires
"unplanned energy losses (outage extension)" be reported?_

The clarifying notes of the reporting guidance specify that the end
date of planned outages are those negotiated with and agreed to by the
network and/or grid dispatcher. This date may differ from dates shown
on schedules used by the utility to manage the outage on a day-to-day
basis.

_There is a small amount of dose received outside of our generating
stations (waste reduction, laundry facilities, radiography) that
originates from station radioactive or contaminated material. We
currently take this dose and divide by the total number of stations
and add the result to each unit's total whole body dose. Is it
appropriate to include this nonstation dose in the CRE?_

Based on the indicator definition, the indicator is measuring exposure
"at the facility". Even though the material originated on-site, only
(and all) exposure to monitored personnel on-site should be
counted. Nonstation dose should not be counted.

_Regarding Standby Emergency AC generators (2 out of 4 required), is a
station penalized for the unavailability of one or two generators if
only two are required to meet the design criteria?_

The unavailability incurred for any one or two generators when
multiple emergency AC power trains are installed depends upon the
design basis requirements at a station. To not have unavailable hours
of a train count, or be reported, the emergency AC power train must
either be "not required" or must be an installed spare that is not in
service. Whether the plant is operating or shutdown, the train is
considered to be required and any unavailable hours counted (and thus,
are to be reported). An exception for a single- or multi-unit station
with all units shut down, is that one emergency generator at a time
may be electively taken out of service without incurring planned or
unplanned unavailable hours, providing that at least one operable
emergency generator is available to supply emergency loads.

An installed spare train is one that is used as a replacement for
other trains to allow for the removal of equipment from service for
preventive or corrective maintenance without incurring a limiting
condition for operation (where applicable), or violating the single
failure criterion. To be an "installed spare", it must not be required
in the design basis safety analysis for the system to perform its
safety function (and obviously, not acting as a replacement when the
unavailability occurs). Additionally, some stations using the train
failure-based reporting option may be able to take credit for extra
(redundant) trains to avoid needing to count certain unavailable
hours. See the train failure-based safety system performance indicator
definition for further details.

Also regarding a required train, as specified in the reporting
guidelines, "unavailable hours are recorded only when the emergency
generator train is unavailable to deliver emergency AC power. The
failure of one of two redundant emergency generator support
subsystems, for example, would not count toward emergency generator
unavailability as long as the emergency generator train was still
available."

_It is not clear when reporting Industrial Safety Accident Rate
information if the number of hours is payroll hours (including
vacations, sick leave, and other absences), or just hours worked._

The reporting guidance states that the number of hours is to be the
number worked, not payroll hours.

_Why does WANO still require the reporting of fault exposure
unavailable hours as a part of the safety system performance indicator
unavailability data?_

Without the inclusion of a term to account for the effect on system
unavailability of undiscovered faults, the indicator would be nothing
more than a maintenance indicator showing the effects of planned and
unplanned maintenance time. The intent of the indicator is to depict
all sources of unavailability when the system is required to be in
service. Sometimes, an undiscovered failure can render a train or
system unavailable for prolonged periods of time, greatly effecting
the overall system unavailability. The probabilistic approach used to
estimate the unavailable hours due to latent or undiscovered faults is
sound. More frequent testing of systems with weak performance
histories can enable the detection of latent failures sooner which, in
turn, reduces the unavailable hours due to those failures.

_Since the mathematical approach to calculating fault exposure
unavailable hours is essentially probabilistic in nature, shouldn't
the individual unit and industry SSPI goals reflect what PSAs allow
regarding system unavailability?_

The safety system performance indicator was never intended to produce
data directly usable in PSA calculations, nor were the established
SSPI industry goals intended to be directly tied to individual station
PSA assumptions. In setting year 2000 performance goals, many stations
checked their PSA assumptions to ensure they did not establish a goal
outside of what the PSA assumed, but in many cases, performance of
these systems was already better than what PSAs assumed. Therefore,
the goals set by individual stations for 2000 were based on past
performance, modified, perhaps, by predictable effects of increased
online maintenance or other factors.

_The Performance Indicator Programme has been in place for many years
and the original ten indicators included thermal performance and
radioactive waste volumes. Also, the WANO Results Spreadsheets for
1997 and earlier include this data. Where can the earlier performance
indicator definitions be found?_

The definitions for the early performance indicators (those in use before 2001) can be obtained from the Performance Indicator programme manager in the Coordinating Centre. The early performance indicator definitions were modified and replaced in January 2001 with ten indicators. Over time, additional changes have been made and these are shown in the current version of the Performance Indicator Reference Manual.

## Prototype functionality

The aims of the development of the Performance Analysis (PA) prototype
are:  
- to cover all the uncovered report functionality  
- to consolidate all the source data and results together  
- to have a direct access to the Operational Experience DB (OE DB)
  directly from reporting page  
- to provide some kind of on-fly calculations  
- to cover all the uncovered by [Reports](#reports) calculations  
- to modify the [QRR](#qrr) system  
- to provide easy-to-use:  
  - Quarter Report,  
  - Long-Term Target Report,  
  - Outliers Report,  
  - Report for the Peer Review Team,  
  - PI Metrics Report,  
  - Units Status Report,  
  - Data Submittal Report,  
  - Scrams Summary Report  
  - etc.  
  
All the functionality described below is already realised into PA Application prototype, and all the source code are available [here](https://wanolo.visualstudio.com/WANO%20PI/_versionControl?path=%24%2FWANO%20PI%2FWANO%20PI%2FCode%2FR-CRAN%2Fshiny&_a=contents)

The top menu of the PA prototype is the follows ![pa-top](pic/pa-top.PNG)

### PI and OEDB

In the first tab menu you can choose the unit, quarter, indicator _and source data which is included in this indicator calculation_. All the monitored indicators included.

Data window means the date range for date to be analysed. As it was described above, there are ususally 3, 12, 18, 24 and 36 months calculation intervals are using.

The _Show all the source data_ checkbox means that all the source data will be showed instead of summary information.

![](pic/pa-menu.PNG)

The very top result show the utit history. It is extramely important to do any kind of the analysis.

The second one show the calculated index, which is the reflection of the whole unit performance in one number.

The next one show the source data cummulative (based on analysing period) or detailed information.

![](pic/pa01.PNG)

 The next one show all the available comments were provided. _It is vital to lock the source data when they need comments but comments were not provided_
 
 The next table show the calculated indicator with calculation status.
 
 Then we can see the indicator trend.

![](pic/pa02.PNG)

The next one is _one of the most useful function on this page_ - it provides us the direct link to the OE Database to let us analyse the event which might be related to the indicator we analyse.

![](pic/pa03.PNG)

### Outliers

This tab was developed to find the units which need more attention based on their performance analyysis. 

The menu form asks for a quarter, indicator and data window to be showed and has a slider to set the [IQR](https://en.wikipedia.org/wiki/Interquartile_range) to variate the results.

![](pic/pa04.PNG)

As a results we can see the boxplot with outliers (as points) positions.

![](pic/pa05.PNG)

Then the table with outliers positions and values is provided.

![](pic/pa06.PNG)

### Download reports

This tab let us to check (or update) DB status from the DB Stage local storage. 

![](pic/pa07.PNG)

The DB status is reflected as below.

![](pic/pa08.PNG)

_The vital function for all the Regional Centres is generation of the results spreadsheet_.

Pushing the button the process will be started and the following spreasheet will be generated.

![](pic/spreadsheet.PNG)

Spreadsheet specification can be find [here]()

### PI report for Peer Review team

The next _vital function_ for all the Regional Centres is _generation the report to be provided to the Peer Review team members_. It allows them to get the initial information regarding plant performance and to define the areas for further investigation.

The top menu allows to select one or more units to be analysed. The quarter, indicator and data window selector have the same role as above.

There are three kind of _Distribution_ selector:

- worldwide - to compare the selected unit(s) worldwide;
- the same reactor type;
- the same reactor type for the same Regional Centre

The _Full PI Report_ means that the full performance table will be prodused as _saved_ into xls-file if the appropriate checkbox will be checked.

![](pic/pa09.PNG)

The picture to show the unit position at the [quantile](https://en.wikipedia.org/wiki/Quantile) based distribution (_WANO AC style_) will be prodused as below.

![](pic/pa10.PNG)

The table to show the unit rank based on _distribution_ selector will be generated as well.

![](pic/pa11.PNG)

If _Full PI Report_ button is pressed, the whole performance report will be produced.

![](pic/pa12.PNG)

This report may be saved as Excel spreadsheet.

![](pic/PRreport.PNG)

PR Report specification can be find [here]()

### LTT report

Long-Term Target Report is the _most important report_ for top management.

The charts will be showed if the according checkbox checked.

To produce the sharable report the _(Re)create LTT report and update LTT data_ button might be pressed.

Then the sharable report might be downloeded by pressing _Download_ button.

![](pic/pa13.PNG)

When the analysed quarter is selected, the world performance report will be showed.

![](pic/pa14.PNG)

At the same time, the more detailed Regional Centre performance report will be shown as well.

![](pic/pa15.PNG)

If _show chart_ function is active, the following charts will be shown.

![](pic/pa16.PNG)
![](pic/pa17.PNG)

There are few different style to visualise the results.

![](pic/pa18.PNG)
![](pic/pa19.PNG)

The prinable version of the LTT report will be prodused and can be downloaded by pressing the buttons in the top menu.

It is _one of the most important report_ to be shared through top management.

![](pic/lttRep01.PNG)

The pictures as shown below are also uses in the _public version of the performance report_ called _Trifold_. 

![](pic/CRE_Centre.jpg)
![](pic/CRE_ReactorType.jpg)

There are some additional information and _analysis_ are included into report there.

![](pic/lttRep02.PNG)

Report structure and specification can be find [here]()

### PI metrics

PI metrics definition can be find in the [PI Process Description]().

The system allows to generate such kind of reports to see the RCs performance.

In the top menu you can select the analysing period as well as RC to be shown. If you need a chart or detailed information the corresponding checkbox should be checked.

![](pic/pa20.PNG)

If you asked for detailed information, the following report will be produced.

![](pic/pa21.PNG)

If the chart was requested, the following picture will be shown.

![](pic/pa22.PNG)

### Indicator Trend

One of the most _important and easy-to-undertsand_ reports is the report produces  here.

The Indicator and reactor type (if applicable) can be choosen in the top menu.

![](pic/pa23.PNG)

Then the [boxplot](https://en.wikipedia.org/wiki/Box_plot) chart with the _Long-Term Targets_ will be shown. 

The filter allows you to select the country you are interesed in.

![](pic/pa24.PNG)

If the _outlier_ checkbox is checked, the outliers will be shown as points.

![](pic/pa25.PNG)

### Unit Status

It is the axuiliary report to check unit current status and history. It combines all the necessary information on the one page.

_All the units_ (including out of service) are included.

After selection the unit in the top menu

![](pic/pa26.PNG)

you can see this unit history.

![](pic/pa27.PNG)

Also the additional design related information are available there.

![](pic/pa28.PNG)

The unit relationship will be reflected as below.

![](pic/pa29.PNG)

Finally, some important DB statuses are shown.

![](pic/pa30.PNG)

### Submitting process

To follow the PI process the data submitting process should be strictly monitored.

When you select the reporting period and choose whether you need the detailed information 

![](pic/pa31.PNG)

you will see the following chart.

![](pic/pa32.PNG)

If the _detailed information_ requested, you will see the details of non-reporting units as below.

![](pic/pa33.PNG)

### QRR

The implemented QRR currently just try to find any significant deviation looking at the source data were provided.

In the new QRR realisation it should be much more intelledgence system witch have as mimimum the same tests and functionality as described in [QRR](#qrr) section above.

In the top menu you can choose the quarter and indicator to be analysed.

The _QRR sensivity_ means that the system will find the source data parameters which is out of normal distribution.

![](pic/pa34.PNG)

When the _Calcilate_ button be pressed, the system will prodice the following report.

![](pic/pa35.PNG)

_Note: is takes **very** long to prodice this report_.

### Scrams summary

Another example of the auxiluary report is scram distribution one.

In the top menu you can choose the year and kind of scrams you would like to see.

![](pic/pa36.PNG)

Then the following picture will be produced.

![](pic/pa37.PNG)

The detailed table will be shown below.

![](pic/pa38.PNG)

As an experimental function, the [word cloud](https://www.wordclouds.com/) to reflect the most important reasons of scrams will be produced based on _minimum frequency_ and _maximum number of words_ parameter were set in the top menu.

![](pic/pa39.PNG)

### Unit index (online)

Index calculation process is described in the PI Reference Manual in very detailed way. The index reports are shown [above](#Index).

You can see the index for only unit which is selected in the top menu (currently the only Index Method 4 is supported).

![](pic/pa40.PNG)

As a result the following index table will be produced.

![](pic/pa41.PNG)

If you selected two countries or region in the top menu, the boxplot to reflect their relative position will be generated.

![](pic/pa42.PNG)

The detailed information of the indexes for the first selected county (region) will be shown in table way.

![](pic/pa43.PNG)

## Existing DB structure

To ensure that reporting and data analysis is based on a consistent set of data, a new data warehouse database will be developed alongside the core database. This will take data from all the separate system databases, as well as the core database, spreadsheets and other structured documents that are identified during the requirements finding process.

The following picture shows the current location and configuration of WANO’s databases and database servers.

![](pic/curDB.png)

Next picture shows the proposed location and configuration of WANO’s database servers upon completion of phase 1.

![](pic/phase2.png)

The new database that will support this data warehouse will be called WANO_DW and will facilitate an improved reporting and data analysis capability. This database will be populated with data from multiple sources, including the core database, the PI database, the OE database and any other identified key data sources, such as spreadsheets and structured documents.

The design of a data warehouse is very different from design of an online transaction processing (OLTP) system. In contrast to an OLTP system, where the purpose is to capture high rates of data changes and additions, the purpose of a data warehouse is to organise large amounts of stable data for ease of reporting and analysis. Data warehouse data must be organised to meet this need for rapid access to information.

Dimensional modelling is used in the design of data warehouse databases to organise the data for efficiency of queries that are intended to analyse and summarise large volumes of data. The data warehouse schema is almost always very different and much simpler than the schema of an OLTP system designed using entity-relation modelling.

The use of online analytical processing (OLAP) and data mining is potentially in scope for this phase, but will be dependent on the requirement gathering process. 

All of the Extracting, Transforming and Loading (ETL) processes required to transfer data between the various databases will be completed using SQL Server Integration Services (SSIS).

The next picture shows the proposed data flows between WANO’s database servers upon completion of phase 2.

![](pic/phase3.png)

As part of the requirements gathering process, we will need to obtain specifications for the key reports and dashboards. These will be built using SQL Server Reporting Services (SSRS) reports.

Business intelligence and data analytics _might_ be facilitated using Microsoft Power BI. This includes a website element for publishing and sharing dashboards and reports, as well as a suite of BI tools, which include a standalone design application (Power BI Designer) and a number of add-ins for Excel (Power Pivot, Power View and Power Query). Consideration for this approach has been made over other BI products due to:

-	Native integration with our existing technology stack
-	A majority fit with requirements that have already been identified
-	Required skill set already available within IS LO
-	Affordability
-	Ease of use

### PI DB specific information

The following picture shows the current location and configuration of WANO’s PI databases and reflects the existing data flows. PI DB consists of three (the fourth is updated DB) DB. PEOPLEAND PLACE DB (older DBAA DB) means database with all units and persons information, including their moving history. DES is Data Entry System. CDE is Consolidated Data Entry system (for US plants only). IndValues is a table with source data into DBWP database. QRR module is Quality Report Review system which allows finding mistake after the end of data entry. Results table is one table from DBWP DB to save calculated results. The results are calculation every weekend or by SA request. Third-part software means auxiliary software was developed by WANO LO to produce some additional reports. 

![](pic/flow01.jpg)

On the first stage of phase 2 WANO LO will provide daily complete PI DB copy (about 2 GB) into WANO LO Core DB and/or WANO LO Data Warehouse. As a result the following dataflow will be provided.

![](pic/flow02.jpg)

When Calculation and Reporting modules (i.e. SSRS and Power BI) complete, and the necessary table of source data define, the final structure and PI dataflow _might_ be the following.

![](pic/flow03.jpg)

## Calculation details

Most of calculation regading Indicators and Indexes have already
describes into
[PI Reference Manual](https://members.wano.org/getattachment/e13ff432-e4a2-49c4-94b9-c82b0fcfc48c/document). However, there are list of calculations which is not covered by existing references (e.g. AGR FRI, TISA etc.) or has a mistake (e.g. PWR FRI, CPI, SSPI etc.)

The intention of this section is to cover all the necessary calculation.

## Development process

The development will be based on
[Agile](https://en.wikipedia.org/wiki/Agile_software_development)
methodology (detailes are also available [here](http://agilemethodology.org/)

## CheckList

- [x] Have the initial meeting
  - [x] Prototype demonstration
- [ ] Have the first meeting to define/explain development strategy
  and to discuss all the related questions like communication
  protocol, minimal functional requarements etc.
  - [x] Have a chat with Ross and Sandor (beginning of week 4 2018)
  - [x] Have a meeting with datB (30 Jan 18)
  - [ ] Have a meeting with datB (2 Feb 18)
- [ ] Officially start the development (incluging clear definition of roles
  and tasks for all the memebers)
- [ ] to demonstrate the first prototype during Feb 2018 PI Programme Meeting

## Extra functionality

Some extra functionality must be provided. There are some of them:

- The source data archive should be saved and achievable;
- Source data change log;
- The data archive should be created weekly; the track changing mode should be available;
- Data entry field should be locked until commentary entered (if needed, based on QRR recommendation);
- Metrics information should be provided;
- mobile support;
- IAEA-PI descripency report;
- possibility to lock and check source data before submitting;
- easy to change/add elements and indicators;
- automated data validation process;
- Trifold should be produced automatically;

Some extra functionality may be provided. There are some of them:

- language support;
- trend predictive model;
- user adjustable report;
