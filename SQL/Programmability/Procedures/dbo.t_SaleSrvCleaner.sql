SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrvCleaner]/* Удаляет устаревшие записи в журналах регистрации действий Торгового Сервера */ASBEGIN  DECLARE @LogMaxDays int  DECLARE @DocTime datetime  SET @LogMaxDays = 14  SET @DocTime = DATEADD(DAY, 0 - @LogMaxDays, GETDATE())  DELETE FROM z_LogCashReg WHERE DocTime <= @DocTime  DELETE FROM z_LogScale WHERE DocTime <= @DocTimeEND
GO