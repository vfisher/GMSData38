SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[tf_DiscsCompatible](@DiscCode1 int, @DiscCode2 int)
/* Возвращает совместимы ли акции */
/* Сгенерирована 25.04.2019 16:26:29; Приложение: SPComm.exe (Версия 3.14.0.900, 25.04.2019 12:58:58); Версия БД: 3.17.0.0 */
RETURNS bit AS
BEGIN
  RETURN (
    CASE @DiscCode1
      WHEN 0 THEN 0

      ELSE 1
    END)
END
GO