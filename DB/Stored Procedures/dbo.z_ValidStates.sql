SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_ValidStates] (@DocCode int, @ChID bigint, @StateCode int)
/* Возвращает доступные статусы */ 
AS
  SELECT * FROM r_States WHERE (@StateCode <> StateCode) AND dbo.zf_CanChangeState(@DocCode, @ChID, @StateCode, StateCode) = 1
GO
