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
      RAISERROR ('Служащий не обнаружен в справочнике.', 16, 1)
      RETURN
    END
END
GO
