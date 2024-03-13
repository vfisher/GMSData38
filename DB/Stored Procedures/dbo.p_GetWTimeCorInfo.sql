SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_GetWTimeCorInfo] ( @Vals VARCHAR(3600) )
/* Возвращает информацию об отклонениях от графика работы для сотрудника */
AS
  BEGIN
	DECLARE	@EmpID INT, @OurID INT,	@BDate SMALLDATETIME, @DayPosID INT

	EXEC z_ValsLookup 'EmpID', @Vals, @EmpID OUTPUT
	EXEC z_ValsLookup 'OurID', @Vals, @OurID OUTPUT
	EXEC z_ValsLookup 'BDate', @Vals, @BDate OUTPUT
	EXEC z_ValsLookup 'DayPosID', @Vals, @DayPosID OUTPUT

	SELECT	WTSignID, EveningHours, NightHours, WorkHours, OverTime, OverPayFactor, DayShiftCount, DayPayFactor
	FROM	p_CWTimeCor
	WHERE	OurID = @OurID
			AND EmpID = @EmpID
			AND AppDate = DATEADD(DAY, @DayPosID - 1, @BDate) AND UseInWTime = 1
  END
GO
