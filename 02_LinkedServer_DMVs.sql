--Linked Servers

/* Copyright (c) 2017 ABI Cube */
/* Shabnam Watson */


USE [Performance_Monitoring]

Select * from openquery(SSAS_TAB, 'EVALUATE ''Geography''')

Select * from openquery(SSAS_TAB, 'SELECT * FROM $SYSTEM.DISCOVER_TRACES')

SELECT * from [dbo].[Traces Tab]
SELECT * from [dbo].[Traces MD]

