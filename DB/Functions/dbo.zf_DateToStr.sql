SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*----------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[zf_DateToStr](@date datetime)
RETURNS varchar(50) AS
/* Возвращает дату в формате дд.мм.гггг */
Begin
  declare @i int, @s varchar(50), @r varchar(50)

  select @i = DATEPART(dd, @date)
  select @s = CAST(@i AS varchar(2))
  if @i < 10 select @s = '0' + @s
  select @r = @s

  select @i = DATEPART(mm, @date)
  select @s = CAST(@i AS varchar(2))
  if @i < 10 select @s = '0' + @s
  select @r = @r + '.' + @s + '.' + CAST(DATEPART(yy, @date) AS varchar(4))

  RETURN(@r)
End
GO
