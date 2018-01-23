# PI Application Term of Reference

## Background

The Performance Indicator Programme (PIP) was started many years ago
and mainly used as a management tool so that each WANO regional
centre, member and plant can monitor its own performance and progress,
set challenging goals for improvement and consistently compare its
performance with that of other plants or the wider
industry. Performance indicators are also should use to assess
industry performance, to support other WANO programmes and to provide
assistance to members if necessary.

WANO LO Technical Support and Exchange Programme Director is (or
should be) a PIP owner, but historically the Performance Indicator
Database and Application (PI DB) was located on the INPO server and
managed by INPO staff. And till last time there was only one qualified
expert from WANO Atlanta centre to PI manage. The PI DB manage does
not include programme code changing but only adjusting and general
management of indicators.

If WANO London office has to make any more or less serious changes
(like Report design changing) in the Performance Indicator Programme
we have to ask INPO for this task and should pay some cost for
realisation. Also WANO has to pay annual or monthly payments for PI DB
support and control.

PI DB interface looks very old to compare to IAIE PRIS system.

The PI DB has not any interfaces to connect to another WANO Programmes data. This moment there is not any technical possibility to automatic data comparison both the WANO Programmes and IAEA PRIS and ISOE (radiation exposure) data.
The PI DB has a much branched structure, and WANO has not access to
manage unit status table at all (it is INPO table).

PI DB does not integrate to WANO Integrated Management System (IMS).
These and a row of other problems let as recommend WANO top management start to develop a new PI DB as a part of WANO IMS with modern interface and wide potential.

## Objectives

This Project should be a part of IMS described above, so it has to
have interfaces to connect other modules.

### Major objectives

The major Project objectives are the next:

1.	Obtaining the full control under PIP. This target includes:
	- DB support, updating, changing and adjustment opportunity
	- Indicators and indexes updating possibility
	- New Indicator and indexes including opportunity
	- Report system managing (adding of new reports by request of other programmes, updating the existing reports, data import and export possibility)
	- Opportunity of Data Entry System and Report System modules upgrading, including new Application developing and connecting
2.	Connecting other WANO Programmes for use PI data more effectively
	- The Project let other WANO Programmes receive more detailed and measured information about end-users need (including AFI etc.)
	- Information sharing and exchange for using IAEA, ISOE and WANO (OE etc.) data for data quality control and area for improving definition
3. Connecting the RCs and end-users for easy nuclear safety and reliability performance control
4.	Decrease the cost spending for DB support and adjustment by INPO
5.	Developing a part of Integrated Management System

### Project Stages

The Project may be separated to next stages (more detailed Project
schedule you can find on the SharePoint):

1.	Start project. Work Group creating. Definition the major target
      etc. (1 month)

2.	Database and application general structure developing. Define the more applicable DB engine and program language [finished]. This activity includes:
	- DB copy receiving and investigation
	- New DB structure defining

3.	Data Entry System (DES) developing (3 months). This activity includes:
	- DB exist data copying [finished]
	- Developing the data entry interface (for administrator and users)
	- Developing data control system (can be realised later). This moment there are lot of misunderstandings in this system using there.
	- DES testing on the local server

4.	Reporting System (RS) developing (6 months). This activity includes:
	- Interfaces to other user and programmes (WANO) definition. It may include the opportunity of automatic data receiving from other DB (like IAEA PRIS, ISOE etc.) for data control. The best would be using the process approach for clearly understanding inputs and outputs for all the programmes before.
	- Developing the indicator module. This includes:
	  - Realisation the existing indicators
	  - Indicator updating. It includes big CPI updating programme, CRE updating activity etc.
	  - Developing the new indicators like Non-Reactor Site Performance Indicator (active programme), Investment (cost) indicator for assess industry contribution to modernisation/ages control and Unit ages indicator (probably use with previous one)
	  - Modules (database), View (interface) realisation
	- Developing indexes module. It includes:
	  - Existing indexes realisation (Method 4 and 7)
	  - New indexes developing (using new indicator described above)
	  - Modules (database), View (interface) realisation
	- Report module developing. This may include:
	  - Existing report realisation (Standard and Custom Reports)
	  - New reports developing (by other user/programmes/end-user request)
	  - Long-Term target reports updating
	  - Annual report module developing
	  - Interactive Report module developing (show the short report when NPP selected on the map)
	  - Modules (database), View (interface) realisation
	- Report modules local testing

5.	DES and RS external testing (3 months). This includes:
	- INPO and new WANO PI DB synchronisation
	- Administrator and end-user access and authorisation system testing
	- Parallel data input by user
	- Report comparison
	- Bug tracking

6.	Developing another IMS modules (out of this project):
	- Quality Management System
	  - Document Management System (TSE DB already exist)
	  - Activity Reporting System
	  - Another IMS modules
	- Integrate the OE database
	- Integrate the WALO LO (based on MS Access) DB

### Resources Required

To realise this project we need the next resources:
1.	Software
	- On the DB and application developing stage:
	  - MS SQL Management Studio 2008 for existing DB investigation – already installed as a part of WANO LO existing software
	  - Install Virtual Machine (Oracle VM) on the developer laptop (freeware)
	  - Install Ubuntu Linux under VM (freeware)
	  - Install Python and all supporting software in the Linux (freeware)
	- On the testing and ‘commercial’ operation phase:
	  - WANO web-server (already exists). There is no any specific
        requirement to server hardware and software.

2.	Cost
	- All software are free or already installed before project beginning
	- There is no extra cost excepting existing developer salary

### Project expectation and target audience

Project let us significantly increase the PI data quality, cooperation
with other WANO programmes (help to more deep understand the needs of
each NPP), RCs and end users.

At the end this project may increase the nuclear industry safety and
reliability using PI because each WANO regional centre, member and
plant can monitor its own performance and progress, set challenging
goals for improvement and consistently compare its performance with
that of other plants or the wider industry.

Renewal Performance Indicators and Indexes are also used to assess
industry performance, to support other WANO programmes and to provide
assistance to members if necessary.

WANO performance indicators will encourage members to emulate the best industry performance and motivate members to improve the operations of their nuclear plant(s) more effectively.
The modern PI DB interface lets end-users receive and use the
necessary data more effectively.

The module of IMS let build the whole system using existing templates
and modules.

### Risk

The Project risks may be divided to technical, images, communication
and rehouses one. The risk matrix you can see below.

The analysis show Project has not any extreme risk and has some High and Moderate risks. The main parts of risks are Low.

Category | Negligible | Marginal | Critical
---|---|---|---
**Certain**	| Project schedule violation
**Likely** | Extra expert involving. The out-of-WANO expert may not be agree to support project | INPO resistance. This question should be settled by WANO top management
**Possible** | Communication problem between WANO PI staff. This question may be settled by WANO top management | Server down. It is risk with low probability and low impact. The server unavailable in couple of hours or even days is not critical. When server will up all the data can be synchronise (from INPO server duration test operation) or restore (if need) from local copy. | WANO LO image lost risk has low probability but high impact so we have to start a ‘commercial’ DB operational only after sufficient test in both internal and external modes
**Unlikely** | Local network and environment problem duration local developing may be exclude using Virtual Machine system. | Low Security risk (unauthorised data access) should be excluding on the access system test. Used software (see Methodology -> Software part below) is well tested and secure. | Data lost risk. It can be excluding by regular DB backup copying. The very easy DB format (SQLite3, all the data is including to one file only) let make a backup copy process very simple as just file copy procedure. Also duration the test operation INPO DB has the same data as our one
**Rare** | Financial risk. The Project need not any extra cost excepting developer standard WANO salary.

## Issues

### Key issues

The key issues to be studied and disputed at every stage of the
project lifecycle are the next:

1.	Start project. Work Group creating. Definition the major target
      etc. The issue is defining the necessary and composition of
      Working Group (WG). WG should include WANO LO TSE Director and
      IS Manager. It may include WANO RCs PI manager, but they are
      already involved in the indicator updating process. Other WANO
      Programmes expert involving seems possible.

2.	Database and application general structure developing. The issue
      is DB copy receiving (solved), instrument for investigation
      defining and installing (solved).

3.	Data Entry System (DES) developing. The issues are:
	- software process procuring
	- clear communication with INPO and WANO AC expert
	- involving the WANO PI and another expert

4.	Reporting System (RS) developing. The issues are the same.

5.	DES and RS external testing. The issues are:
	- DB ownership transfer question
	- RCs and end-user training
	- Technical question for DB transferring

6.	Developing other IMS modules – out of project.

### Criteria

Any case the PI DB and application should demonstrate the Efficiency, Relevance, Effectiveness, Impact, Sustainability no worse than existing one.

## Methodology

### Key phases of the project implementation process

The key phases of the project implementation process are described in
the Project Stages part above.

The Project milestones are:

1.	DES prototype
2.	Active DES in test operational
3.	Report System prototype
4.	Active RS in test operational
5.	Overall system external test operational

### Required level of stakeholder involvement

The next stakeholders should be involved in the process:

1.	WANO IS department: on the Project initiation phase, on the
      software install phase, on the external testing phase

2.	WANO PI expert and end-user expert: on the indicator and indexes
      developing (updating) and testing phases (including overall
      system testing)

### Content and duration of project activities

The Project content and duration are described in the Project Stages part.
Please pay your attention that project duration was based on the
pessimistic prognoses.

### List the information collection tools necessary for monitoring
purposes

For information collecting may be use any freeware version/revision
control system.

### Data analysis rules

There are no any specific data analysis rules.

### Software

#### Database

For easy DB managing including copying recommended to use SQLite DB
engine. SQLite is an in-process library that implements a
self-contained, serverless, zero-configuration, transactional SQL
database engine. The code for SQLite is in the public domain and is
thus free for use for any purpose, commercial or private. SQLite is
currently found in more applications than we can count, including
several high-profile projects.

SQLite is an embedded SQL database engine. Unlike most other SQL
databases, SQLite does not have a separate server process. SQLite
reads and writes directly to ordinary disk files. A complete SQL
database with multiple tables, indices, triggers, and views, is
contained in a single disk file. The database file format is
cross-platform - you can freely copy a database between 32-bit and
64-bit systems or between big-endian and little-endian
architectures. These features make SQLite a popular choice as an
Application File Format. Think of SQLite not as a replacement for
Oracle but as a replacement for fopen().

SQLite is a compact library. With all features enabled, the library
size can be less than 500KiB, depending on the target platform and
compiler optimization settings. (64-bit code is larger. And some
compiler optimizations such as aggressive function inlining and loop
unrolling can cause the object code to be much larger.) If optional
features are omitted, the size of the SQLite library can be reduced
below 300KiB. SQLite can also be made to run in minimal stack space
(4KiB) and very little heap (100KiB), making SQLite a popular database
engine choice on memory constrained gadgets such as cellphones, PDAs,
and MP3 players. There is a tradeoff between memory usage and
speed. SQLite generally runs faster the more memory you give
it. Nevertheless, performance is usually quite good even in low-memory
environments.

SQLite is very carefully tested prior to every release and has a
reputation for being very reliable. Most of the SQLite source code is
devoted purely to testing and verification. An automated test suite
runs millions and millions of test cases involving hundreds of
millions of individual SQL statements and achieves 100% branch test
coverage. SQLite responds gracefully to memory allocation failures and
disk I/O errors. Transactions are ACID even if interrupted by system
crashes or power failures. All of this is verified by the automated
tests using special test harnesses which simulate system failures. Of
course, even with all this testing, there are still bugs. But unlike
some similar projects (especially commercial competitors) SQLite is
open and honest about all bugs and provides bugs lists including lists
of critical bugs and minute-by-minute chronologies of bug reports and
code changes.

The SQLite code base is supported by an international team of
developers who work on SQLite full-time. The developers continue to
expand the capabilities of SQLite and enhance its reliability and
performance while maintaining backwards compatibility with the
published interface spec, SQL syntax, and database file format. The
source code is absolutely free to anybody who wants it, but
professional support is also available.

#### Web framework

We are recommended to use Django for DB environment (DES and RS) developing.
With Django, we can take Web applications from concept to launch in a
matter of hours. Django takes care of much of the hassle of Web
development, so we can focus on writing your app without needing to
reinvent the wheel. It’s free and open source.

Django was designed to help developers take applications from concept
to completion as quickly as possible.

Django includes dozens of extras you can use to handle common Web development tasks. Django takes care of user authentication, content administration, site maps, RSS feeds, user comments and many more tasks — right out of the box.
Django takes security seriously and helps developers avoid many common
security mistakes, such as SQL injection, cross-site scripting,
cross-site request forgery and clickjacking. Its user authentication
system provides a secure way to manage user accounts and passwords.

Some of the busiest sites on the planet use Django’s ability to quickly and flexibly scale to meet the heaviest traffic demands.
Companies, organizations and governments have used Django to build all sorts of things — from content management systems to social networks to scientific computing platforms.

## Expertise

### Type of work involved in the proposed project

This project includes the next types of works:

1.	Expert work for indicators and indexes updating and developing
2.	Programmer work when software developing
3.	IS System Administrator work for server install and support and system testing (including security testing)
4.	End-user and RC staff work for system testing
5.	PI staff work for accuracy data control

### Type of skills and abilities required

All the involved staff should have enough qualification for Project
support. WANO LO PI Manager has enough qualification in programming,
PI and data analysis and project managing. So he should be responsible
for team composition and qualification

### Exact number of individuals involved

Exact number of individuals involved may be inconstant and changing
when Project realisation.

### Point at the period of engagement of each team member

Point at the period of engagement of each team member is describing in
the Project Schedule and can be changing.

### Duties and responsibility per teammate

Duties and responsibility per teammate was described above and can be
clarified during the process.

### Relationships between the team members

The WANO LO PI Manager bears full responsibility provided appropriate from TSE Director and IS Manager.

## Reporting

### Table of Contents for project reports

All the Project milestones should be reported to demonstrate software.

### Rules for composing annexes

It is not necessary to prepare the hard copy of program code. All the
data including revision control data is stored on the safe storage.

### Report templates

There is no need any report template.

### Submission dates

All submission data is describing in the Project Schedule.

### Computer software programmes to be used for report writing

There is no any specific requires to computer software programmes for
report writing.

### People responsible for reporting and approving

The WANO LO PI Manager bears full responsibility for reporting and
approving provided appropriate from TSE Director and IS Manager.

### Other sufficient information

(such as number of copies to be created, responsibilities for report
production and presentation, etc.)

In the Attachment you can see the MS Project based schedule.

## Work plan

### Summary of the anticipated work

The summary of the anticipated work described in the parts Major
objectives and Project expectation and target audience above.

### Activities and necessary resources required for achieving the project’s results and purpose

Activities and necessary resources required for achieving the
project’s results and purpose are described in the Resources Required,
Type of work involved in the proposed project and Relationships
between the team members above.

### Activity schedule template

The detailed Project schedule you can find on the SharePoint.

### The finance resources allocated to the project

There is no any extra financial resources need for this Project. For more detailed information please see part Resources Required -> Cost above.
