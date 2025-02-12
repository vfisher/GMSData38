SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[p_LeaveScheds]
AS
SELECT
  m.ChID, m.DocID, m.IntDocID, m.DocDate, m.KursMC, m.OurID, o.OurName, m.EmpID, e.EmpName, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes
FROM
  p_LeaveSched m,
  r_Emps e,
  r_Ours o
WHERE m.EmpID = e.EmpID AND m.OurID = o.OurID
GROUP BY m.ChID, m.DocID, m.IntDocID, m.DocDate, m.KursMC, m.OurID, o.OurName, m.EmpID, e.EmpName, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes
GO