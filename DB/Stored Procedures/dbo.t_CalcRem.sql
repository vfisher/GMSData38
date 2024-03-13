SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_CalcRem]
AS
  BEGIN TRAN 
  DELETE FROM dbo.t_Rem
  INSERT dbo.t_Rem
  SELECT *  FROM dbo.zf_t_CalcRem()
  IF @@ERROR <> 0 GOTO ErrorHandler
  /* Логирование расчета */
  INSERT z_LogAU (AUGroupCode, UserCode)
  VALUES  (1, dbo.zf_GetUserCode())
  COMMIT TRAN 
  RETURN
  ErrorHandler:
  ROLLBACK TRAN
GO
