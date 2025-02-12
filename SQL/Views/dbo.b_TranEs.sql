SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[b_TranEs] WITH VIEW_METADATA AS
SELECT * FROM ( 
SELECT 
  b_TranE.ChID, b_TranE.OurID, b_TranE.DocDate, b_TranE.CodeID1, b_TranE.CodeID2, b_TranE.CodeID3, 
  b_TranE.CodeID4, b_TranE.CodeID5, SumAC*KursCC AS TSumCC, SumAC/KursMC AS TSumMC, b_TranE.EmpID,
  r_Emps.EmpName, SumAC1*KursCC AS TSumCC1, SumAC1/KursMC AS TSumMC1
FROM r_Emps INNER JOIN b_TranE ON r_Emps.EmpID = b_TranE.EmpID
) GMSView
GO