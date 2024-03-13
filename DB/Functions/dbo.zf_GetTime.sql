SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetTime](@Date datetime)/* Возвращает время без даты */RETURNS datetimeBEGIN  RETURN CONVERT(varchar(8), @Date, 108)END
GO
