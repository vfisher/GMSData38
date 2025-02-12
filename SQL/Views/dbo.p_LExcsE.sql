SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_LExcsE] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT m.ChID,
  m.DocID,
  IntDocID,
  m.WOrderID,
  m.DocDate,
  m.ExcDate,
  m.KursMC,
  m.OurID,
  m.CodeID1,
  m.CodeID2,
  m.CodeID3,
  m.CodeID4,
  m.CodeID5,
  d.EmpID,
  d.SubID,
  d.DepID,
  d.PostID,
  d.EmpClass,
  d.ShedID,
  d.WorkCond,
  d.SubJob,
  d.SalaryQty,
  d.SalaryType,
  d.SalaryForm,
  d.SalaryMethod,
  d.BSalary,
  d.BSalaryPrc,
  d.TimeNormType,
  d.PensMethod,
  d.PensCatID
FROM p_LExc AS m
  LEFT JOIN p_LExcD AS d ON m.ChID=d.ChID
) GMSView
GO