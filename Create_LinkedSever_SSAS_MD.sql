
/*
Shabnam Watson
© 2017 ABI Cube Corp.
info@abicube.com
Sample Code: Provided as is.
2017-11-03
*/


USE [master]
GO

/****** Object:  LinkedServer [SSAS_MD]    Script Date: 11/13/2017 10:52:57 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'SSAS_MD', @srvproduct=N'MSOALP.7', @provider=N'MSOLAP', @datasrc=N'ABI1', @catalog=N'AdventureWorksMD2014'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'SSAS_MD',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_MD', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_MD', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_MD', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_MD', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_MD', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_MD', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_MD', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_MD', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_MD', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_MD', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_MD', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_MD', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'SSAS_MD', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


