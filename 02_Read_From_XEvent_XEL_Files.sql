
/* Copyright (c) 2017 ABI Cube */
/* Shabnam Watson */
/* Sample code for reading XEL files genearted by Extended Events with SQL. */



USE [Performance_Monitoring];

WITH
SSAStabularExtendedEventsXML AS
	(
		SELECT        CAST(event_data AS XML) AS XE
		FROM          sys.fn_xe_file_target_read_file('C:\Extended Events Log Files\TABULAR\*.xel', NULL, NULL, NULL)
	)

SELECT	XE.value('(/event/data[@name="TextData"]/value)[1]', 'varchar(max)') AS QueryText,
		XE.value('(/event/data[@name="CPUTime"]/value)[1]', 'int') AS CPUTime,
		XE.value('(/event/data[@name="CurrentTime"]/value)[1]', 'datetime') AS CurrentTime,
		XE.value('(/event/data[@name="DatabaseName"]/value)[1]', 'varchar(255)') AS DatabaseName,
		XE.value('(/event/data[@name="Duration"]/value)[1]', 'int') AS Duration,
        XE.value('(/event/data[@name="EndTime"]/value)[1]', 'datetime') AS EndTime,
		XE.value('(/event/data[@name="ErrorType"]/value)[1]', 'int') AS ErrorType,
		XE.value('(/event/data[@name="EventClass"]/value)[1]', 'int') AS EventClass,
		XE.value('(/event/data[@name="EventSubclass"]/value)[1]', 'int') AS EventSubclass,
		XE.value('(/event/data[@name="IntegerData"]/value)[1]', 'int') AS IntegerData, 
        XE.value('(/event/data[@name="NTCanonicalUserName"]/value)[1]', 'varchar(255)') AS NTCanonicalUserName,
		XE.value('(/event/data[@name="NTDomainName"]/value)[1]', 'varchar(255)') AS NTDomainName, 
        XE.value('(/event/data[@name="NTUserName"]/value)[1]', 'varchar(255)') AS NTUserName,
		XE.value('(/event/data[@name="ServerName"]/value)[1]', 'varchar(255)') AS ServerName, 
        XE.value('(/event/data[@name="ObjectPath"]/value)[1]', 'varchar(255)') AS ObjectPath,
		XE.value('(/event/data[@name="ApplicationName"]/value)[1]', 'varchar(255)') AS ApplicationName, 
        XE.value('(/event/data[@name="StartTime"]/value)[1]', 'datetimeoffset') AS StartTime,
		XE.value('(/event/data[@name="Success"]/value)[1]', 'int') AS Success,
		XE.value('(/event/data[@name="Severity"]/value)[1]', 'int') AS Severity 

FROM   SSAStabularExtendedEventsXML E



