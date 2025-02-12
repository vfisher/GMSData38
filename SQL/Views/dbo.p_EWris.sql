SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_EWris] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT ChID,
 DocID,
 IntDocID,
 DocDate,
 KursMC,
 OurID,
 SubID,
 DepID,
 CodeID1,
 CodeID2,
 CodeID3,
 CodeID4,
 CodeID5,
 EmpID,
 WritDocID,
 WritDate,
 WritDept,
 WritType,
 WritBDate,
 WritEDate,
 WritSumCC,
 WritPrc,
 AddrCompID,
 AddrEmpID,
 TransType,
 BankID,
 AccountCC,
 Notes
FROM p_EWri) GMSView
GO