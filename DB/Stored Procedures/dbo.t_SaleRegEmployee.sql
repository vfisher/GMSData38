SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleRegEmployee](@EmpBarCode VARCHAR(2000), @Msg varchar(2000) OUTPUT, @ShowTime int OUTPUT)
AS
BEGIN
  DECLARE @EmpID int
  SELECT @ShowTime = 1000
  SELECT @EmpID = EmpID FROM r_Emps WHERE BarCode = @EmpBarCode
  IF @EmpID IS NULL
    BEGIN
      BEGIN

      DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('Служащий не обнаружен в справочнике.')

      RAISERROR (@Error_msg1, 16, 1)
      END

      RETURN
    END
END

GO
