SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_TableLookup](@ExprStr varchar(250), @TableCode int, @FilterStr varchar(4000), @out varchar(250) OUT) 
GO