SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_CanCloseRestShift](
  @OurID int,
  @StockID int,
  @Result int OUTPUT,
  @Msg varchar(200) OUTPUT)
/* Проверяет, может ли быть закрыта смена в приложении Ресторан */
AS
BEGIN
  DECLARE @CRID int
  DECLARE @ParamsIn varchar(max) 
  DECLARE @ParamsOut varchar(max)
  DECLARE @SaleSumCash numeric(19, 9)
  DECLARE @SaleSumCCard numeric(19, 9)
  DECLARE @SaleSumCredit numeric(19, 9)
  DECLARE @SaleSumCheque numeric(19, 9)
  DECLARE @SaleSumOther numeric(19, 9)
  DECLARE @MRec numeric(19, 9)
  DECLARE @MExp numeric(19, 9)
  DECLARE @SumCash numeric(19, 9)
  DECLARE @SumRetCash numeric(19, 9)
  DECLARE @SumRetCCard numeric(19, 9)
  DECLARE @SumRetCredit numeric(19, 9)
  DECLARE @SumRetCheque numeric(19, 9)
  DECLARE @SumRetOther numeric(19, 9)

  SET @Result = 1
  SET @Msg = ''

  DECLARE CRCursor CURSOR FAST_FORWARD FOR
    SELECT c.CRID FROM r_CRs c WITH(NOLOCK), r_CRSrvs s WITH(NOLOCK)
    WHERE c.SrvID = s.SrvID AND c.StockID = @StockID AND s.OurID = @OurID

  OPEN CRCursor

  FETCH NEXT FROM CRCursor
  INTO @CRID

  WHILE @@FETCH_STATUS = 0
    BEGIN
	     SET @ParamsIn = (SELECT @CRID AS CRID FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)

	     EXEC t_GetCRBalance @ParamsIn, @ParamsOut OUTPUT

      SET @SaleSumCash = JSON_VALUE(@ParamsOut, '$.SaleSumCash')
      SET @SaleSumCCard = JSON_VALUE(@ParamsOut, '$.SaleSumCCard')
	     SET @SaleSumCredit = JSON_VALUE(@ParamsOut, '$.SaleSumCredit')
	     SET @SaleSumCheque = JSON_VALUE(@ParamsOut, '$.SaleSumCheque')
	     SET @SaleSumOther = JSON_VALUE(@ParamsOut, '$.SaleSumOther')
      SET @MRec = JSON_VALUE(@ParamsOut, '$.MRec')
      SET @MExp = JSON_VALUE(@ParamsOut, '$.MExp')
      SET @SumCash = JSON_VALUE(@ParamsOut, '$.SumCash')
	     SET @SumRetCash = JSON_VALUE(@ParamsOut, '$.SumRetCash')
	     SET @SumRetCCard = JSON_VALUE(@ParamsOut, '$.SumRetCCard')
	     SET @SumRetCredit = JSON_VALUE(@ParamsOut, '$.SumRetCredit')
	     SET @SumRetCheque = JSON_VALUE(@ParamsOut, '$.SumRetCheque')
	     SET @SumRetOther = JSON_VALUE(@ParamsOut, '$.SumRetOther')

      IF (@SaleSumCash <> 0) Or (@SaleSumCCard <> 0) Or (@SaleSumCredit <> 0) Or (@SaleSumCheque <> 0) Or (@SaleSumOther <> 0) Or
        (@MRec <> 0) Or (@MExp <> 0) Or (@SumCash <> 0) Or (@SumRetCash <> 0) Or (@SumRetCCard <> 0) Or (@SumRetCredit <> 0) Or (@SumRetCheque <> 0) Or (@SumRetOther <> 0)
        BEGIN
          SET @Result = 0
          SET @Msg = 'Смена не может быть закрыта: не выполнен Z-отчет на одном из фискальных регистраторов'
          BREAK
        END
      FETCH NEXT FROM CRCursor
      INTO @CRID
    END

  CLOSE CRCursor
  DEALLOCATE CRCursor
END
GO