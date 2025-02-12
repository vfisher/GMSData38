SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_GetGOperID] (@DocCode int, @DSCode int, @Vals varchar(3600))/* Формирует список групповых операций для документа */AS DECLARE @SQL nvarchar(4000) SET @SQL = N'SELECT d.GOperID, g.GOperName, d.GTAccID, d.GTAdvAccID, d.GTaxAccID              FROM b_GOperDocs d, r_GOpers g              WHERE d.GOperID = g.GOperID AND DSCode = ' + CAST(@DSCode AS varchar(20)) EXEC sp_executesql @SQL
GO