SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_EExcs] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT ChID,
  DocID,
  IntDocID,
  WOrderID,
  DocDate,
  ExcDate,
  KursMC,
  OurID,
  CodeID1,
  CodeID2,
  CodeID3,
  CodeID4,
  CodeID5,
  EmpID,
  SubID,
  DepID,
  PostID,
  EmpClass,
  ShedID,
  WorkCond,
  SubJob,
  SalaryQty,
  SalaryType,
  SalaryForm,
  SalaryMethod,
  BSalary,
  BSalaryPrc,
  TimeNormType,
  PensMethod,
  PensCatID
FROM p_EExc
) GMSView
GO