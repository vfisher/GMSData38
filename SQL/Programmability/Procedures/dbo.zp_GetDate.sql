SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[zp_GetDate]/* Возвращает дату без времени, как GETDATE */AS  BEGIN     SELECT dbo.zf_GetDate(getdate())END 
GO