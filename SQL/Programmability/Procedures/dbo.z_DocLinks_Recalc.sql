SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_DocLinks_Recalc](@ChangedField varchar(250), @Continue bit OUTPUT, @Msg varchar(200) OUTPUT)/* Связь документов: Обновление */AS BEGIN    SELECT    @Msg = '',    @Continue = 1END 
GO