
/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/

--Create an empty database called [Performance_Monitoring]

USE [Performance_Monitoring]
GO
/****** Object:  Table [dbo].[Date]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Date]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Date](
	[ID] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Day] [char](2) NOT NULL,
	[DaySuffix] [varchar](4) NOT NULL,
	[DayOfWeek] [varchar](9) NOT NULL,
	[DOWInMonth] [tinyint] NOT NULL,
	[DayOfYear] [int] NOT NULL,
	[WeekOfYear] [tinyint] NOT NULL,
	[WeekOfMonth] [tinyint] NOT NULL,
	[Month] [char](2) NOT NULL,
	[MonthName] [varchar](9) NOT NULL,
	[Quarter] [tinyint] NOT NULL,
	[QuarterName] [varchar](6) NOT NULL,
	[Year] [char](4) NOT NULL,
	[StandardDate] [varchar](10) NULL,
	[HolidayText] [varchar](50) NULL,
 CONSTRAINT [PK_dimDate] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  View [dbo].[dimDate]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[dimDate]'))
EXEC dbo.sp_executesql @statement = N'


/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/


CREATE VIEW [dbo].[dimDate]
AS
SELECT        ID, Convert(Date,[Date]) as [Date], Day, DaySuffix, DayOfWeek, DOWInMonth, DayOfYear,
              WeekOfYear, WeekOfMonth, Month, MonthName, Quarter,
			  QuarterName, Year, StandardDate, HolidayText,
			  Case When StandardDate =  CONVERT(date, getdate()) Then ''Yes'' Else ''No'' End as CurrentDate
FROM            dbo.Date
WHERE StandardDate <= GetDate() 






' 
GO
/****** Object:  Table [dbo].[Time]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Time]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Time](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Time] [char](8) NOT NULL,
	[Hour] [char](2) NOT NULL,
	[MilitaryHour] [char](2) NOT NULL,
	[Minute] [char](2) NOT NULL,
	[Second] [char](2) NOT NULL,
	[AmPm] [char](2) NOT NULL,
	[StandardTime] [char](11) NULL,
 CONSTRAINT [PK_dimTime] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  View [dbo].[dimTime]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[dimTime]'))
EXEC dbo.sp_executesql @statement = N'

/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/

CREATE vIEW [dbo].[dimTime]
AS

SELECT      [ID]
		   ,[Time]
           ,[Hour]
           ,[MilitaryHour]
           ,[Minute]
           ,[Second]
           ,[AmPm]
           ,[StandardTime]
		   ,CASE WHEN CONVERT(Time,[Time]) Between CONVERT(TIME,DateAdd(Hour,-1,GetDate())) AND CONVERT(TIME,GetDate()) THEN ''Yes'' ELSE ''No'' END As LastHour
		   ,CASE WHEN CONVERT(Time,[Time]) Between CONVERT(TIME,DateAdd(MINUTE,-30,GetDate())) AND CONVERT(TIME,GetDate()) THEN ''Yes'' ELSE ''No'' END As Last30Minutes
		   ,CASE WHEN CONVERT(Time,[Time]) Between CONVERT(TIME,DateAdd(MINUTE,-15,GetDate())) AND CONVERT(TIME,GetDate()) THEN ''Yes'' ELSE ''No'' END As Last15Minutes
		   ,[Hour] + '':'' + [Minute] + '' '' + [AmPM] as [Hour Minute]
		   ,[MilitaryHour]*100+[Minute] AS [Hour Minute Sort Order]   

FROM        dbo.[Time]







' 
GO
/****** Object:  Table [dbo].[CounterData]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CounterData]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CounterData](
	[GUID] [uniqueidentifier] NOT NULL,
	[CounterID] [int] NOT NULL,
	[RecordIndex] [int] NOT NULL,
	[CounterDateTime] [char](24) NOT NULL,
	[CounterValue] [float] NOT NULL,
	[FirstValueA] [int] NULL,
	[FirstValueB] [int] NULL,
	[SecondValueA] [int] NULL,
	[SecondValueB] [int] NULL,
	[MultiCount] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[GUID] ASC,
	[CounterID] ASC,
	[RecordIndex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  View [dbo].[Perfmon Data]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Perfmon Data]'))
EXEC dbo.sp_executesql @statement = N'

/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/


CREATE VIEW [dbo].[Perfmon Data]
AS
SELECT        CounterID AS ''Counter ID'', 
			  RecordIndex AS ''Measurement Index'',
			  CONVERT(Date,LEFT(CounterDateTime,23)) AS ''Measurement Date'',
			  CONVERT(char(8),LEFT(RIGHT(CounterDateTime,13),8))AS ''Measurement Time'',
			  CONVERT(DateTime, LEFT(CounterDateTime,23)) AS ''Measurement Date Time'',
			  CounterValue as ''Counter Value'',
			  GUID,
			  CASE When RecordIndex = (Select max(RecordIndex) from dbo.CounterData) then ''Yes'' else ''No'' end As ''Last Measurement''
			  
FROM          dbo.CounterData
Where         CounterDateTime >= ''2017-10-09''



' 
GO
/****** Object:  Table [dbo].[CounterDetails]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CounterDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CounterDetails](
	[CounterID] [int] IDENTITY(1,1) NOT NULL,
	[MachineName] [varchar](1024) NOT NULL,
	[ObjectName] [varchar](1024) NOT NULL,
	[CounterName] [varchar](1024) NOT NULL,
	[CounterType] [int] NOT NULL,
	[DefaultScale] [int] NOT NULL,
	[InstanceName] [varchar](1024) NULL,
	[InstanceIndex] [int] NULL,
	[ParentName] [varchar](1024) NULL,
	[ParentObjectID] [int] NULL,
	[TimeBaseA] [int] NULL,
	[TimeBaseB] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CounterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  View [dbo].[Perfmon Counters]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Perfmon Counters]'))
EXEC dbo.sp_executesql @statement = N'

/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/


CREATE VIEW [dbo].[Perfmon Counters]
AS
SELECT			CounterID AS ''Counter ID'',
				MachineName AS ''Server Name'',
				ObjectName AS ''Object Name'',
				CounterName AS ''Counter Name'',
				CounterType AS ''Counter Type'',
				InstanceIndex AS ''Instance Index''			
FROM            dbo.CounterDetails 
				WITH (NOLOCK)
' 
GO
/****** Object:  Table [dbo].[DisplayToID]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DisplayToID]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DisplayToID](
	[GUID] [uniqueidentifier] NOT NULL,
	[RunID] [int] NULL,
	[DisplayString] [varchar](1024) NOT NULL,
	[LogStartTime] [char](24) NULL,
	[LogStopTime] [char](24) NULL,
	[NumberOfRecords] [int] NULL,
	[MinutesToUTC] [int] NULL,
	[TimeZoneName] [char](32) NULL,
PRIMARY KEY CLUSTERED 
(
	[GUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[DisplayString] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  View [dbo].[Perfmon Data Collectors]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Perfmon Data Collectors]'))
EXEC dbo.sp_executesql @statement = N'

/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/



CREATE VIEW [dbo].[Perfmon Data Collectors]
AS
SELECT        GUID,
              RunID as ''Run ID'',
			  DisplayString AS ''Data Collector Name'', 
			  CAST(LEFT(LogStartTime,23) AS smalldatetime) AS ''Log Start Time'',
			  CAST(LEFT(LogStopTime,23) AS smalldatetime) ''Log End Time'',
			  NumberOfRecords AS ''Number of Records''

FROM          dbo.DisplayToID
' 
GO
/****** Object:  View [dbo].[Queries Tab]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Queries Tab]'))
EXEC dbo.sp_executesql @statement = N'


/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/

CREATE VIEW [dbo].[Queries Tab]
AS
WITH
XMLExtendedEvents AS
			(SELECT        CAST(event_data AS XML) AS E
             FROM          sys.fn_xe_file_target_read_file(''C:\Extended Events Log Files\TABULAR\*.xel'', NULL, NULL, NULL)
			),

ExtendedEvents AS
			(SELECT E.value(''(/event/data[@name="TextData"]/value)[1]'', ''varchar(max)'') AS QueryText,
					E.value(''(/event/data[@name="CPUTime"]/value)[1]'', ''int'') AS CPUTime,
					E.value(''(/event/data[@name="CurrentTime"]/value)[1]'', ''datetime'') AS CurrentTime,
					E.value(''(/event/data[@name="DatabaseName"]/value)[1]'', ''varchar(255)'') AS DatabaseName,
					E.value(''(/event/data[@name="Duration"]/value)[1]'', ''int'') AS Duration,
                    E.value(''(/event/data[@name="EndTime"]/value)[1]'', ''datetimeoffset'') AS EndTime,
					E.value(''(/event/data[@name="ErrorType"]/value)[1]'', ''int'') AS ErrorType,
					E.value(''(/event/data[@name="EventClass"]/value)[1]'', ''int'') AS EventClass,
					E.value(''(/event/data[@name="EventSubclass"]/value)[1]'', ''int'') AS EventSubclass,
					E.value(''(/event/data[@name="IntegerData"]/value)[1]'', ''int'') AS IntegerData, 
                    E.value(''(/event/data[@name="NTCanonicalUserName"]/value)[1]'', ''varchar(255)'') AS NTCanonicalUserName,
					E.value(''(/event/data[@name="NTDomainName"]/value)[1]'', ''varchar(255)'') AS NTDomainName, 
                    E.value(''(/event/data[@name="NTUserName"]/value)[1]'', ''varchar(255)'') AS NTUserName,
					E.value(''(/event/data[@name="ServerName"]/value)[1]'', ''varchar(255)'') AS ServerName, 
                    E.value(''(/event/data[@name="ObjectPath"]/value)[1]'', ''varchar(255)'') AS ObjectPath,
					E.value(''(/event/data[@name="ApplicationName"]/value)[1]'', ''varchar(255)'') AS ApplicationName, 
                    E.value(''(/event/data[@name="StartTime"]/value)[1]'', ''datetimeoffset'') AS StartTime,
					E.value(''(/event/data[@name="Success"]/value)[1]'', ''int'') AS Success,
				 	E.value(''(/event/data[@name="Severity"]/value)[1]'', ''int'') AS Severity 
			FROM   XMLExtendedEvents)

SELECT	 
        QueryText AS [Query Text],
		''ID_'' + CONVERT(VARCHAR(8),CONVERT(VARBINARY(8),CHECKSUM(QueryText)),2)AS [Query ID],
		CAST(StartTime AS DATE) AS [Query Start Date],
		CAST(EndTime AS DATE) AS [Query End Date],
		CAST(StartTime AS TIME(3)) AS [Query Start Time],
		CAST(EndTime AS TIME(3)) AS [Query End Time],
		Duration,
		CASE WHEN Duration Between 0 and 1000 THEN ''0-1 Seconds'' 
			WHEN Duration Between 1001 and 2000 THEN ''1-2 Seconds''
			WHEN Duration Between 2001 and 4000 THEN ''2-4 Seconds''
			WHEN Duration Between 4001 and 6000 THEN ''4-6 Seconds''
			WHEN Duration Between 6001 and 8000 THEN ''6-8 Seconds''
			WHEN Duration Between 8001 and 1000 THEN ''8-10 Seconds''
			ELSE ''>10 Seconds''
		END AS Duration_Group,
		CASE WHEN Duration < 1000 THEN 1 
			WHEN Duration Between 1001 and 2000 THEN 2
			WHEN Duration Between 2001 and 4000 THEN 3
			WHEN Duration Between 4001 and 6000 THEN 4
			WHEN Duration Between 6001 and 8000 THEN 5
			WHEN Duration Between 8001 and 1000 THEN 6
			ELSE 7
		END AS Duration_Group_SortOrder,
		CPUTime AS [CPU Time],
		DatabaseName AS [Database],
		ObjectPath AS [Object Name],
		ApplicationName,
		--IntegerData AS Rows,
		--CAST(EventClass AS VARCHAR(10)) + ''.'' + CAST(EventSubclass AS VARCHAR(10)) AS EventKey,
		EventClass AS [Event Class],
		EventSubclass AS [Event SubClass],
		NTDomainName AS [NT Domain Name],
		NTUserName AS [NT User Name],
		ServerName AS [Server Name],
		Success
		--Severity

FROM	ExtendedEvents
WHERE   EventClass = 10 --Limit to Query End. This is redundant here since the XEvent trace is only capturing Query End events. 
AND		EventSubclass IN (0,3) --0 for MDX queries, 3 for DAX queries. This is done to exclude other kinds of queries such as DMV queries that have a subclass of 1.

' 
GO
/****** Object:  View [dbo].[Queries Tab Today]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Queries Tab Today]'))
EXEC dbo.sp_executesql @statement = N'

/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/

CREATE VIEW [dbo].[Queries Tab Today]
AS
SELECT        [Query ID], [Query Start Date], [Query End Date], [Query Start Time], [Query End Time], Duration, Duration_Group, Duration_Group_SortOrder, [CPU Time], [Database], [Object Name], ApplicationName, [Event Class], 
                         [Event SubClass], [NT Domain Name], [NT User Name], [Server Name], Success
FROM            dbo.[Queries Tab]
WHERE        ([Query End Date] = CONVERT(DATE, GETDATE()))
' 
GO
/****** Object:  View [dbo].[Queries Tab History]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Queries Tab History]'))
EXEC dbo.sp_executesql @statement = N'

/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/


CREATE VIEW [dbo].[Queries Tab History]
AS
SELECT        [Query ID], [Query Start Date], [Query End Date], [Query Start Time], [Query End Time], Duration, Duration_Group, Duration_Group_SortOrder, [CPU Time], [Database], [Object Name], ApplicationName, [Event Class], 
                         [Event SubClass], [NT Domain Name], [NT User Name], [Server Name], Success
FROM            dbo.[Queries Tab]
WHERE        ([Query End Date] < CONVERT(DATE, GETDATE()))
' 
GO
/****** Object:  View [dbo].[Activity MD]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Activity MD]'))
EXEC dbo.sp_executesql @statement = N'

/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/

CREATE VIEW [dbo].[Activity MD]
AS
SELECT      OBJECT_PARENT_PATH AS [OBJECT PARENT],
			OBJECT_ID AS [OBJECT ID],
			OBJECT_CPU_TIME_MS AS [OBJECT CPU TIME MS],
			OBJECT_READS AS [OBJECT READS],
			OBJECT_READ_KB AS [OBJECT READ KB],
			OBJECT_WRITES AS [OBJECT WRITES],
			OBJECT_WRITE_KB AS [OBJECT WRITE KB],
			OBJECT_AGGREGATION_HIT AS [OBJECT AGGREGATION HIT],
			OBJECT_AGGREGATION_MISS AS [OBJECT AGGREGATION MISS],
			OBJECT_HIT AS [OBJECT HIT],
			OBJECT_MISS AS [OBJECT MISS],
			OBJECT_VERSION AS [OBJECT VERSION],
			OBJECT_DATA_VERSION AS [OBJECT DATA VERSION],
			OBJECT_ROWS_SCANNED AS [OBJECT ROWS SCANNED],
			OBJECT_ROWS_RETURNED AS [OBJECT ROWS RETURNED]
FROM	OPENQUERY(SSAS_MD, ''SELECT * FROM $SYSTEM.DISCOVER_OBJECT_ACTIVITY'') AS Disc_Activity
' 
GO
/****** Object:  View [dbo].[Activity Tab]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Activity Tab]'))
EXEC dbo.sp_executesql @statement = N'

/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/

CREATE VIEW [dbo].[Activity Tab]
AS
SELECT      OBJECT_PARENT_PATH AS [OBJECT PARENT],
			OBJECT_ID AS [OBJECT ID],
			OBJECT_CPU_TIME_MS AS [OBJECT CPU TIME MS],
			OBJECT_READS AS [OBJECT READS],
			OBJECT_READ_KB AS [OBJECT READ KB],
			OBJECT_WRITES AS [OBJECT WRITES],
			OBJECT_WRITE_KB AS [OBJECT WRITE KB],
			OBJECT_AGGREGATION_HIT AS [OBJECT AGGREGATION HIT],
			OBJECT_AGGREGATION_MISS AS [OBJECT AGGREGATION MISS],
			OBJECT_HIT AS [OBJECT HIT],
			OBJECT_MISS AS [OBJECT MISS],
			OBJECT_VERSION AS [OBJECT VERSION],
			OBJECT_DATA_VERSION AS [OBJECT DATA VERSION],
			OBJECT_ROWS_SCANNED AS [OBJECT ROWS SCANNED],
			OBJECT_ROWS_RETURNED AS [OBJECT ROWS RETURNED]
FROM	OPENQUERY(SSAS_TAB, ''SELECT * FROM $SYSTEM.DISCOVER_OBJECT_ACTIVITY'') AS Disc_Activity
' 
GO
/****** Object:  View [dbo].[Memory Usage MD]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Memory Usage MD]'))
EXEC dbo.sp_executesql @statement = N'

/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/


CREATE VIEW [dbo].[Memory Usage MD]
AS
SELECT       CAST(OBJECT_PARENT_PATH AS NVARCHAR(500)) AS [OBJECT PARENT PATH],
			 CAST(OBJECT_ID AS NVARCHAR(255)) AS [OBJECT ID],
			 OBJECT_MEMORY_SHRINKABLE AS [OBJECT MEMORY SHRINKABLE],
			 OBJECT_MEMORY_NONSHRINKABLE AS [OBJECT MEMORY NONSHRINKABLE],
			 OBJECT_VERSION AS [OBJECT VERSION],
			 OBJECT_DATA_VERSION AS [OBJECT DATA VERSION],
			 OBJECT_TYPE_ID AS [OBJECT TYPE ID],
			 OBJECT_TIME_CREATED AS [OBJECT TIME CREATED], 
             OBJECT_MEMORY_CHILD_SHRINKABLE AS [OBJECT MEMORY CHILD SHRINKABLE],
			 OBJECT_MEMORY_CHILD_NONSHRINKABLE AS [OBJECT MEMORY CHILD NONSHRINKABLE],
			 CAST(OBJECT_GROUP AS NVARCHAR(255)) AS [OBJECT GROUP]
FROM            OPENQUERY(SSAS_MD,''SELECT * FROM $SYSTEM.DISCOVER_OBJECT_MEMORY_USAGE
								 '') AS Disc_Sessions
' 
GO
/****** Object:  View [dbo].[Memory Usage Tab]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Memory Usage Tab]'))
EXEC dbo.sp_executesql @statement = N'

/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/


CREATE VIEW [dbo].[Memory Usage Tab]
AS
SELECT       CAST(OBJECT_PARENT_PATH AS NVARCHAR(500)) AS [OBJECT PARENT PATH],
			 CAST(OBJECT_ID AS NVARCHAR(255)) AS [OBJECT ID],
			 OBJECT_MEMORY_SHRINKABLE AS [OBJECT MEMORY SHRINKABLE],
			 OBJECT_MEMORY_NONSHRINKABLE AS [OBJECT MEMORY NONSHRINKABLE],
			 OBJECT_VERSION AS [OBJECT VERSION],
			 OBJECT_DATA_VERSION AS [OBJECT DATA VERSION],
			 OBJECT_TYPE_ID AS [OBJECT TYPE ID],
			 OBJECT_TIME_CREATED AS [OBJECT TIME CREATED], 
             OBJECT_MEMORY_CHILD_SHRINKABLE AS [OBJECT MEMORY CHILD SHRINKABLE],
			 OBJECT_MEMORY_CHILD_NONSHRINKABLE AS [OBJECT MEMORY CHILD NONSHRINKABLE],
			 CAST(OBJECT_GROUP AS NVARCHAR(255)) AS [OBJECT GROUP]
FROM            OPENQUERY(SSAS_TAB,''SELECT * FROM $SYSTEM.DISCOVER_OBJECT_MEMORY_USAGE
								 '') AS Disc_Sessions
WHERE OBJECT_TYPE_ID IN (703003,703002)
' 
GO
/****** Object:  View [dbo].[Queries MD]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Queries MD]'))
EXEC dbo.sp_executesql @statement = N'



/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/



CREATE VIEW [dbo].[Queries MD]
AS
WITH
XMLExtendedEvents AS
			(SELECT        CAST(event_data AS XML) AS E
             FROM          sys.fn_xe_file_target_read_file(''C:\Extended Events Log Files\MD\*.xel'', NULL, NULL, NULL)
			),

ExtendedEvents AS
			(SELECT E.value(''(/event/data[@name="TextData"]/value)[1]'', ''varchar(max)'') AS QueryText,
					E.value(''(/event/data[@name="CPUTime"]/value)[1]'', ''int'') AS CPUTime,
					E.value(''(/event/data[@name="CurrentTime"]/value)[1]'', ''datetime'') AS CurrentTime,
					E.value(''(/event/data[@name="DatabaseName"]/value)[1]'', ''varchar(255)'') AS DatabaseName,
					E.value(''(/event/data[@name="Duration"]/value)[1]'', ''int'') AS Duration,
                    E.value(''(/event/data[@name="EndTime"]/value)[1]'', ''datetimeoffset'') AS EndTime,
					E.value(''(/event/data[@name="ErrorType"]/value)[1]'', ''int'') AS ErrorType,
					E.value(''(/event/data[@name="EventClass"]/value)[1]'', ''int'') AS EventClass,
					E.value(''(/event/data[@name="EventSubclass"]/value)[1]'', ''int'') AS EventSubclass,
					E.value(''(/event/data[@name="IntegerData"]/value)[1]'', ''int'') AS IntegerData, 
                    E.value(''(/event/data[@name="NTCanonicalUserName"]/value)[1]'', ''varchar(255)'') AS NTCanonicalUserName,
					E.value(''(/event/data[@name="NTDomainName"]/value)[1]'', ''varchar(255)'') AS NTDomainName, 
                    E.value(''(/event/data[@name="NTUserName"]/value)[1]'', ''varchar(255)'') AS NTUserName,
					E.value(''(/event/data[@name="ServerName"]/value)[1]'', ''varchar(255)'') AS ServerName, 
                    E.value(''(/event/data[@name="ObjectPath"]/value)[1]'', ''varchar(255)'') AS ObjectPath,
					E.value(''(/event/data[@name="ApplicationName"]/value)[1]'', ''varchar(255)'') AS ApplicationName, 
                    E.value(''(/event/data[@name="StartTime"]/value)[1]'', ''datetimeoffset'') AS StartTime,
					E.value(''(/event/data[@name="Success"]/value)[1]'', ''int'') AS Success,
				 	E.value(''(/event/data[@name="Severity"]/value)[1]'', ''int'') AS Severity 
			FROM   XMLExtendedEvents)



SELECT	QueryText AS [Query Text],
		''ID_'' + CONVERT(VARCHAR(8),CONVERT(VARBINARY(8),CHECKSUM(QueryText)),2)AS [Query ID],
		CAST(StartTime AS DATE) AS [Query Start Date],
		CAST(EndTime AS DATE) AS [Query End Date],
		CAST(StartTime AS TIME(3)) AS [Query Start Time],
		CAST(EndTime AS TIME(3)) AS [Query End Time],
		Duration,
		CASE WHEN Duration Between 0 and 1000 THEN ''0-1 Seconds'' 
			WHEN Duration Between 1001 and 2000 THEN ''1-2 Seconds''
			WHEN Duration Between 2001 and 4000 THEN ''2-4 Seconds''
			WHEN Duration Between 4001 and 6000 THEN ''4-6 Seconds''
			WHEN Duration Between 6001 and 8000 THEN ''6-8 Seconds''
			WHEN Duration Between 8001 and 1000 THEN ''8-10 Seconds''
			ELSE ''>10 Seconds''
		END AS Duration_Group,
		CASE WHEN Duration < 1000 THEN 1 
			WHEN Duration Between 1001 and 2000 THEN 2
			WHEN Duration Between 2001 and 4000 THEN 3
			WHEN Duration Between 4001 and 6000 THEN 4
			WHEN Duration Between 6001 and 8000 THEN 5
			WHEN Duration Between 8001 and 1000 THEN 6
			ELSE 7
		END AS Duration_Group_SortOrder,
		CPUTime AS [CPU Time],
		DatabaseName AS [Database],
		ObjectPath AS [Object Name],
		ApplicationName,
		--IntegerData AS Rows,
		--CAST(EventClass AS VARCHAR(10)) + ''.'' + CAST(EventSubclass AS VARCHAR(10)) AS EventKey,
		EventClass AS [Event Class],
		EventSubclass AS [Event SubClass],
		NTDomainName AS [NT Domain Name],
		NTUserName AS [NT User Name],
		ServerName AS [Server Name],
		Success
		--Severity

FROM	ExtendedEvents
WHERE   EventClass = 10 --Limit to Query End. This is redundant here since the XEvent trace is only capturing Query End events. 
AND		EventSubclass =0 --0 for MDX queries.

' 
GO
/****** Object:  View [dbo].[Sessions MD]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Sessions MD]'))
EXEC dbo.sp_executesql @statement = N'

/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/


CREATE VIEW [dbo].[Sessions MD]
AS

SELECT       SESSION_SPID,
			 SESSION_CONNECTION_ID,
			 CAST(SESSION_USER_NAME AS NVARCHAR(255)) AS SESSION_USER_NAME,
			 CAST(SESSION_CURRENT_DATABASE AS NVARCHAR(255)) AS SESSION_CURRENT_DATABASE,
			 SESSION_USED_MEMORY AS [USED MEMORY],
			 SESSION_START_TIME, 
             SESSION_ELAPSED_TIME_MS,
			 SESSION_LAST_COMMAND_START_TIME,
			 SESSION_LAST_COMMAND_END_TIME,
			 SESSION_LAST_COMMAND_ELAPSED_TIME_MS,
			 SESSION_IDLE_TIME_MS,
			 SESSION_CPU_TIME_MS, 
             CAST(SESSION_LAST_COMMAND AS NVARCHAR(4000)) AS SESSION_LAST_COMMAND,
			 SESSION_LAST_COMMAND_CPU_TIME_MS,
			 CASE	SESSION_STATUS
				WHEN 0 THEN ''Idle''
				WHEN 1 THEN ''Active''
				WHEN 2 THEN ''Blocked''
				WHEN 3 THEN ''Cancelled'' 
			 END	AS SESSION_STATUS,
			 SESSION_READS,
			 SESSION_WRITES,
			 SESSION_READ_KB,
			 SESSION_WRITE_KB,
			 SESSION_COMMAND_COUNT,             
			 CAST(THREAD_POOL_USED AS NVARCHAR(255)) AS THREAD_POOL_USED
			 
FROM         OPENQUERY(SSAS_MD, ''SELECT * FROM $SYSTEM.DISCOVER_SESSIONS 
								  WHERE SESSION_USER_NAME <>''''ABI1\PBI_User'''''') AS Disc_Sessions 



' 
GO
/****** Object:  View [dbo].[Sessions Tab]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Sessions Tab]'))
EXEC dbo.sp_executesql @statement = N'

/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/


CREATE VIEW [dbo].[Sessions Tab]
AS

SELECT       SESSION_SPID,
			 SESSION_CONNECTION_ID,
			 CAST(SESSION_USER_NAME AS NVARCHAR(255)) AS SESSION_USER_NAME,
			 CAST(SESSION_CURRENT_DATABASE AS NVARCHAR(255)) AS SESSION_CURRENT_DATABASE,
			 SESSION_USED_MEMORY AS [USED MEMORY],
			 SESSION_START_TIME, 
             SESSION_ELAPSED_TIME_MS,
			 SESSION_LAST_COMMAND_START_TIME,
			 SESSION_LAST_COMMAND_END_TIME,
			 SESSION_LAST_COMMAND_ELAPSED_TIME_MS,
			 SESSION_IDLE_TIME_MS,
			 SESSION_CPU_TIME_MS, 
             CAST(SESSION_LAST_COMMAND AS NVARCHAR(4000)) AS SESSION_LAST_COMMAND,
			 SESSION_LAST_COMMAND_CPU_TIME_MS,
			 CASE	SESSION_STATUS
				WHEN 0 THEN ''Idle''
				WHEN 1 THEN ''Active''
				WHEN 2 THEN ''Blocked''
				WHEN 3 THEN ''Cancelled'' 
			 END	AS SESSION_STATUS,
			 SESSION_READS,
			 SESSION_WRITES,
			 SESSION_READ_KB,
			 SESSION_WRITE_KB,
			 SESSION_COMMAND_COUNT,             
			 CAST(THREAD_POOL_USED AS NVARCHAR(255)) AS THREAD_POOL_USED
			 
FROM         OPENQUERY(SSAS_TAB, ''SELECT * FROM $SYSTEM.DISCOVER_SESSIONS 
								  WHERE SESSION_USER_NAME <>''''ABI1\PBI_User'''''') AS Disc_Sessions 



' 
GO
/****** Object:  View [dbo].[Todays Queries Tab]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Todays Queries Tab]'))
EXEC dbo.sp_executesql @statement = N'

/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/


CREATE VIEW [dbo].[Todays Queries Tab]
AS
WITH
XMLExtendedEvents AS
			(SELECT        CAST(event_data AS XML) AS E
             FROM          sys.fn_xe_file_target_read_file(''C:\Extended Events Log Files\TABULAR\*.xel'', NULL, NULL, NULL)
			),

ExtendedEvents AS
			(SELECT E.value(''(/event/data[@name="TextData"]/value)[1]'', ''varchar(max)'') AS QueryText,
					E.value(''(/event/data[@name="CPUTime"]/value)[1]'', ''int'') AS CPUTime,
					E.value(''(/event/data[@name="CurrentTime"]/value)[1]'', ''datetime'') AS CurrentTime,
					E.value(''(/event/data[@name="DatabaseName"]/value)[1]'', ''varchar(255)'') AS DatabaseName,
					E.value(''(/event/data[@name="Duration"]/value)[1]'', ''int'') AS Duration,
                    E.value(''(/event/data[@name="EndTime"]/value)[1]'', ''datetimeoffset'') AS EndTime,
					E.value(''(/event/data[@name="ErrorType"]/value)[1]'', ''int'') AS ErrorType,
					E.value(''(/event/data[@name="EventClass"]/value)[1]'', ''int'') AS EventClass,
					E.value(''(/event/data[@name="EventSubclass"]/value)[1]'', ''int'') AS EventSubclass,
					E.value(''(/event/data[@name="IntegerData"]/value)[1]'', ''int'') AS IntegerData, 
                    E.value(''(/event/data[@name="NTCanonicalUserName"]/value)[1]'', ''varchar(255)'') AS NTCanonicalUserName,
					E.value(''(/event/data[@name="NTDomainName"]/value)[1]'', ''varchar(255)'') AS NTDomainName, 
                    E.value(''(/event/data[@name="NTUserName"]/value)[1]'', ''varchar(255)'') AS NTUserName,
					E.value(''(/event/data[@name="ServerName"]/value)[1]'', ''varchar(255)'') AS ServerName, 
                    E.value(''(/event/data[@name="ObjectPath"]/value)[1]'', ''varchar(255)'') AS ObjectPath,
					E.value(''(/event/data[@name="ApplicationName"]/value)[1]'', ''varchar(255)'') AS ApplicationName, 
                    E.value(''(/event/data[@name="StartTime"]/value)[1]'', ''datetimeoffset'') AS StartTime,
					E.value(''(/event/data[@name="Success"]/value)[1]'', ''int'') AS Success,
				 	E.value(''(/event/data[@name="Severity"]/value)[1]'', ''int'') AS Severity 
			FROM   XMLExtendedEvents)

SELECT	 
        QueryText AS [Query Text],
		CONVERT(VARCHAR(8),CONVERT(VARBINARY(8),CHECKSUM(QueryText)),2)AS [Query ID],
		CAST(StartTime AS DATE) AS [Query Start Date],
		CAST(EndTime AS DATE) AS [Query End Date],
		CAST(StartTime AS TIME(3)) AS [Query Start Time],
		CAST(EndTime AS TIME(3)) AS [Query End Time],
		Duration,
		CASE WHEN Duration Between 0 and 1000 THEN ''0-1000 Milliseconds'' 
			WHEN Duration Between 1001 and 2000 THEN ''1001-2000 Milliseconds''
			WHEN Duration Between 2001 and 4000 THEN ''2001-4000 Milliseconds''
			WHEN Duration Between 4001 and 6000 THEN ''4001-6000 Milliseconds''
			WHEN Duration Between 6001 and 8000 THEN ''6000-8000 Milliseconds''
			WHEN Duration Between 8001 and 1000 THEN ''8000-10000 Milliseconds''
			ELSE ''>10001 Milliseconds''
		END AS Duration_Group,
		CASE WHEN Duration < 1000 THEN 1 
			WHEN Duration Between 1001 and 2000 THEN 2
			WHEN Duration Between 2001 and 4000 THEN 3
			WHEN Duration Between 4001 and 6000 THEN 4
			WHEN Duration Between 6001 and 8000 THEN 5
			WHEN Duration Between 8001 and 1000 THEN 6
			ELSE 7
		END AS Duration_Group_SortOrder,
		CPUTime AS [CPU Time],
		DatabaseName AS [Database],
		ObjectPath AS [Object Name],
		ApplicationName,
		--IntegerData AS Rows,
		--CAST(EventClass AS VARCHAR(10)) + ''.'' + CAST(EventSubclass AS VARCHAR(10)) AS EventKey,
		EventClass AS [Event Class],
		EventSubclass AS [Event SubClass],
		NTDomainName AS [NT Domain Name],
		NTUserName AS [NT User Name],
		ServerName AS [Server Name],
		Success
		--Severity

FROM	ExtendedEvents
WHERE   EventClass = 10 --Limit to Query End. This is redundant here since the XEvent trace is only capturing Query End events. 
AND		EventSubclass IN (0,3) --0 for MDX queries, 3 for DAX queries. This is done to exclude other kinds of queries such as DMV queries that have a subclass of 1.



' 
GO
/****** Object:  View [dbo].[Traces MD]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Traces MD]'))
EXEC dbo.sp_executesql @statement = N'

/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/

CREATE VIEW [dbo].[Traces MD]
AS
SELECT        TraceID, TraceName, LogFileName, LogFileSize, LogFileRollover, AutoRestart, CreationTime, StopTime, Type
FROM            OPENQUERY(SSAS_MD, ''SELECT * FROM $SYSTEM.DISCOVER_TRACES'') AS derivedtbl_1
' 
GO
/****** Object:  View [dbo].[Traces Tab]    Script Date: 11/13/2017 10:39:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Traces Tab]'))
EXEC dbo.sp_executesql @statement = N'
/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/

CREATE VIEW [dbo].[Traces Tab]
AS
SELECT       CAST(TraceID AS NVARCHAR(255)) AS [Trace ID],
			 CAST(TraceName AS NVARCHAR(255)) AS [Trace Name],
			 CAST(LogFileName AS NVARCHAR(255)) AS [Log File Name],
			 LogFileSize AS [Log File Size],
			 LogFileRollover AS [Log File Rollover],
			 AutoRestart AS [Auto Restart],
			 CreationTime AS [Creation Time],
			 StopTime AS [Stop Time],
			 CAST([Type] AS NVARCHAR(255)) AS [Trace Type]

FROM         OPENQUERY(SSAS_TAB, ''SELECT * FROM $SYSTEM.DISCOVER_TRACES'') AS Disc_Traces
' 
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'Activity MD', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Disc_Sessions"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 285
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Activity MD'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'Activity MD', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Activity MD'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'dimDate', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[13] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Date"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 249
               Right = 298
            End
            DisplayFlags = 280
            TopColumn = 6
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 16
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'dimDate'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'dimDate', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'dimDate'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'Memory Usage Tab', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[28] 4[33] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Disc_Sessions"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 363
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Memory Usage Tab'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'Memory Usage Tab', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Memory Usage Tab'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'Perfmon Counters', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CounterDetails"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Perfmon Counters'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'Perfmon Counters', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Perfmon Counters'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'Perfmon Data', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CounterData"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 186
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 3
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Perfmon Data'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'Perfmon Data', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Perfmon Data'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'Perfmon Data Collectors', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "DisplayToID"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 191
               Right = 226
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Perfmon Data Collectors'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'Perfmon Data Collectors', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Perfmon Data Collectors'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'Queries Tab', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[20] 4[10] 2[53] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TabularTimeEvents_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 251
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Queries Tab'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'Queries Tab', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Queries Tab'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'Queries Tab Today', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Queries Tab"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 248
               Right = 267
            End
            DisplayFlags = 280
            TopColumn = 9
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Queries Tab Today'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'Queries Tab Today', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Queries Tab Today'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'Sessions MD', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[26] 4[28] 2[18] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "derivedtbl_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 379
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3630
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Sessions MD'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'Sessions MD', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Sessions MD'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'Sessions Tab', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[26] 4[28] 2[18] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "derivedtbl_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 379
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3630
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Sessions Tab'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'Sessions Tab', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Sessions Tab'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'Traces MD', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "derivedtbl_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 261
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Traces MD'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'Traces MD', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Traces MD'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'Traces Tab', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "derivedtbl_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 261
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Traces Tab'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'Traces Tab', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Traces Tab'
GO
