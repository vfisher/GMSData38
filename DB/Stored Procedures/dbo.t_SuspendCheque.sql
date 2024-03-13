SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SuspendCheque](@ChID bigint, @Msg varchar(200) OUTPUT)
/* Откладывает чек */ 
AS
BEGIN
  SET @Msg = 'Чек отложен.'

  UPDATE 
    t_SaleTemp 
  SET 
    DocTime = GetDate(),
    DocState = 10
  WHERE ChID = @ChID

  EXEC t_SaleDeleteMasterRecord @ChID
  IF NOT EXISTS(SELECT TOP 1 1 FROM t_SaleTempD WHERE ChID = @ChID)
    BEGIN
      EXEC t_SaleDeleteCheque @ChID
      SET @Msg = 'Чек не содержал позиций и был удален.'
    END
END
GO
