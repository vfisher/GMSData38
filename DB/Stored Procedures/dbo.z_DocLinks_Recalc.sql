SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_DocLinks_Recalc](@ChangedField varchar(250), @Continue bit OUTPUT, @Msg varchar(200) OUTPUT)
GO