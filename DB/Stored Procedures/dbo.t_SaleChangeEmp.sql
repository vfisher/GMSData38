SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleChangeEmp](
  @DocCode int,
  @DocChID bigint,
  @SrcPosID int,
  @EmpID int OUTPUT,
  @SaleMode bit,
  @UseEmpIDForCheque int
  )
AS
BEGIN
  /* Изменяет служащего для заголовка(позиции) чека */
  /*
  @UseEmpIDForCheque = 0 - для позиции чека
  @UseEmpIDForCheque = 1 - для заголовка чека
  @UseEmpIDForCheque = 2 - для всего чека
  */

  DECLARE @EmpName varchar(200)

  SELECT @EmpName = EmpName FROM r_Emps WHERE EmpID = @EmpID
  IF @EmpName IS NULL BEGIN
 DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('Пользователь не обнаружен.')
 RAISERROR(@Error_msg1, 16, 1) END


  IF (@UseEmpIDForCheque >= 1)
    BEGIN
      IF @DocCode = 11004
        UPDATE t_CRRet SET EmpID = @EmpID WHERE ChID = @DocChID
      ELSE
        UPDATE t_SaleTemp SET EmpID = @EmpID WHERE ChID = @DocChID
    END

  IF @UseEmpIDForCheque = 2
    BEGIN
      IF @DocCode = 11004
        UPDATE t_CRRetD SET EmpID = @EmpID, ModifyTime = GetDate() WHERE ChID = @DocChID
      ELSE
        UPDATE t_SaleTempD SET EmpID = @EmpID, EmpName = @EmpName, ModifyTime = GetDate() WHERE ChID = @DocChID
    END

  /* Идентификация служащего для текущей позиции чека только для режима продаж */
  IF (@SrcPosID = -1) OR (@SaleMode = 0) OR (@UseEmpIDForCheque <> 0) RETURN

  IF @DocCode = 11004
    UPDATE t_CRRetD SET EmpID = @EmpID
    WHERE ChID = @DocChID AND SrcPosID = @SrcPosID
  ELSE
    UPDATE t_SaleTempD SET EmpID = @EmpID, EmpName = @EmpName
    WHERE ChID = @DocChID AND (SrcPosID = @SrcPosID OR CSrcPosID = @SrcPosID)
END

GO
