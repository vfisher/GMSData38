SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetEmpLeavCorPeriodDate](@DocCode INT, @ChID BIGINT, @AChID BIGINT, @OurID int, @EmpID int, @BDate datetime, @EDate datetime)
/* Возвращает периоды корректировки отпуска по сотруднику (для расчета документа Табель учета рабочего времени) */
RETURNS @tmpLeavPeriod table (LeavType int, BDate DATETIME, EDate DATETIME, SrcPosID INT)
AS
BEGIN

DECLARE @SubID INT, @DepID INT
IF @DocCode = 15051
SELECT 
  @SubID = d.SubID,
  @DepID = d.DepID
FROM p_CWTime m, p_CWTimeD d
WHERE m.ChID = d.ChID AND m.OurID = @OurID AND d.EmpID = @EmpID AND d.ChID = @ChID AND d.AChID = @AChID

/* Период отпуска из документа Приказ: Отпуск: Корректировка (условие: отпуск дней <> 0) */
INSERT INTO @tmpLeavPeriod
SELECT S1.LeavType, S1.NewBDate, S1.NewEDate, S1.SrcPosID
FROM
  (SELECT d.LeavType, d.BDate, d.EDate, d.SrcPosID
  FROM p_ELeav m, p_ELeavD d
  WHERE m.ChID = d.ChID AND m.OurID = @OurID AND d.EmpID = @EmpID AND d.SubID = @SubID AND d.DepID = @DepID) S
LEFT JOIN
  (SELECT d1.LeavType, d1.BDate, d1.EDate, d1.NewBDate, d1.NewEDate, d1.LeavCorDays, d1.SrcPosID
  FROM p_ELeavCor m1, p_ELeavCorD d1
  WHERE m1.ChID = d1.ChID AND m1.OurID = @OurID AND d1.EmpID = @EmpID) S1 ON S.BDate = S1.BDate AND S.EDate = S1.EDate
WHERE S1.NewBDate <= @EDate AND S1.NewEDate >= @BDate AND S1.LeavCorDays <> 0

/* Период отпуска из документа Приказ: Отпуск (условие: если создан документ Приказ: Отпуск: Корректировка с типом корректировки отпуска: Продление, Перенос) */
UNION ALL
SELECT S.LeavType, S.BDate, S.EDate, S.SrcPosID
FROM
  (SELECT d.LeavType, d.BDate, d.EDate, d.SrcPosID
  FROM p_ELeav m, p_ELeavD d
  WHERE m.ChID = d.ChID AND m.OurID = @OurID AND d.EmpID = @EmpID AND d.SubID = @SubID AND d.DepID = @DepID) S
LEFT JOIN
  (SELECT d1.LeavType, d1.LeavCorType, d1.BDate, d1.EDate, d1.NewBDate, d1.NewEDate, d1.LeavCorDays, d1.SrcPosID
  FROM p_ELeavCor m1, p_ELeavCorD d1
  WHERE m1.ChID = d1.ChID AND m1.OurID = @OurID AND d1.EmpID = @EmpID) S1 ON S.BDate = S1.BDate AND S.EDate = S1.EDate
WHERE S1.BDate <= @EDate AND S1.EDate >= @BDate AND S1.LeavCorType NOT IN (3,4) 

/* Период отпуска из документа Приказ: Отпуск (условие: если не создан документ Приказ: Отпуск: Корректировка) */
INSERT INTO @tmpLeavPeriod
SELECT S.LeavType, S.BDate, S.EDate, S.SrcPosID
FROM
  (SELECT d.LeavType, d.BDate, d.EDate, d.SrcPosID
  FROM p_ELeav m, p_ELeavD d
  WHERE m.ChID = d.ChID AND m.OurID = @OurID AND d.EmpID = @EmpID AND d.SubID = @SubID AND d.DepID = @DepID) S
LEFT JOIN
  (SELECT d1.LeavType, d1.BDate, d1.EDate, d1.NewBDate, d1.NewEDate, d1.LeavCorDays, d1.SrcPosID
  FROM p_ELeavCor m1, p_ELeavCorD d1
  WHERE m1.ChID = d1.ChID AND m1.OurID = @OurID AND d1.EmpID = @EmpID) S1 ON S.BDate = S1.BDate AND S.EDate = S1.EDate
WHERE S.BDate <= @EDate AND S.EDate >= @BDate AND S1.NewBDate IS NULL AND S1.NewEDate IS NULL

RETURN
END
GO
