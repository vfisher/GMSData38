SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleSrv_xPos_CreateOper](@CRID int, @EmpID int, @OperID int OUTPUT)
/* xPOS: Создает оператора, если такого нет */
AS
BEGIN   
  DECLARE @ChID bigint, @ErrorMessage varchar(200), @CROperID int

  IF NOT EXISTS (SELECT TOP 1 1 FROM r_Emps WITH(NOLOCK) WHERE EmpID = @EmpID) 
    BEGIN
      SET @ErrorMessage = dbo.zf_Translate('Служащий с кодом ') + CAST(@EmpID AS varchar(10)) + dbo.zf_Translate(' не существует')
      GOTO Error
    END

  SELECT @OperID = OperID FROM r_Opers WITH(NOLOCK) WHERE EmpID = @EmpID
  IF @OperID IS NULL
    BEGIN
      BEGIN TRANSACTION
      EXEC z_NewChID 'r_Opers', @ChID OUTPUT
      IF @@ERROR <> 0 GOTO Error
      SELECT @OperID = ISNULL(MAX(OperID), 0) + 1 FROM r_Opers WITH(XLOCK, HOLDLOCK)
      INSERT INTO r_Opers(ChID, OperID, OperName, EmpID, OperLockPwd) VALUES (@ChID, @OperID, 'oper' + CAST(@OperID AS Varchar(10)), @EmpID, '')
      COMMIT TRANSACTION
    END

  SELECT @CROperID = CROperID FROM r_OperCRs WITH(NOLOCK) WHERE OperID = @OperID AND CRID = @CRID
  IF @CROperID IS NULL
    INSERT INTO r_OperCRs(CRID, OperID, CROperID) VALUES (@CRID, @OperID, 1)

  RETURN 0
Error:
  IF @@TranCount > 0 ROLLBACK TRANSACTION
  IF @ErrorMessage IS NOT NULL RAISERROR (@ErrorMessage, 18, 1)
END
GO