SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[b_CalcRem]
AS
  BEGIN TRAN 
  DELETE FROM dbo.b_Rem
  INSERT dbo.b_Rem
  SELECT *  FROM dbo.zf_b_CalcRem()
  IF @@ERROR <> 0 GOTO ErrorHandler
  /* Логирование расчета */
  INSERT z_LogAU (AUGroupCode, UserCode)
  VALUES  (3, dbo.zf_GetUserCode())
  COMMIT TRAN 
  RETURN
  ErrorHandler:
  ROLLBACK TRAN
GO
