
/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/


USE [master]
GO

/****** Object:  LinkedServer [SSAS_TAB]    Script Date: 11/13/2017 10:52:07 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'SSAS_TAB', @srvproduct=N'MSOLAP.7', @provider=N'MSOLAP', @datasrc=N'ABI1\ABI_TAB', @catalog=N'AdventureWorksTab2014'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'SSAS_TAB',@useself=N'False',@locallogin=NULL,@rmtuser=N'ABI1\PBI_User',@rmtpassword='########'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_TAB', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_TAB', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_TAB', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_TAB', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_TAB', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_TAB', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_TAB', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_TAB', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_TAB', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_TAB', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_TAB', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_TAB', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_TAB', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


