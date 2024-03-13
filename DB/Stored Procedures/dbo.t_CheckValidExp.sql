SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_CheckValidExp](@TableName varchar(250), @ChID bigint, @OurID int, @StockID int, @SrcPosID int, @ProdID int,
                                @PPID int, @SecID int, @Qty numeric(21,9), @IgnoreCurPos bit, @Result varchar(255) OUTPUT)
/* Проверяет корректность продажи */
AS
BEGIN
  SELECT @Result = ''
  IF dbo.zf_Var('t_AutoPP') = '1' RETURN 
  DECLARE @v numeric(21, 9), @v1 numeric(21,9)
  SELECT @v = SUM(Qty) FROM t_Rem WITH(NOLOCK) WHERE OurID = @OurID AND StockID = @StockID AND ProdID = @ProdID AND PPID = @PPID AND SecID = @SecID
  SELECT @v = ISNULL(@v, 0)
  DECLARE @SQL varchar(2000)
  SELECT @SQL = 'SELECT @v1 = ISNULL(Qty, 0) FROM ' + @TableName + ' m, ' + @TableName + 'D d WHERE m.ChID = d.ChID AND OurID = @OurID AND StockID = @StockID ' + 
                'AND ProdID = @ProdID AND PPID = @PPID AND SecID = @SecID AND m.ChID = @ChID AND d.SrcPosID = @SrcPosID'  
  IF @IgnoreCurPos = 0 
    EXEC sp_executesql
      @stmt = @SQL, 
      @Params = '@v1 numeric(21,9) OUTPUT, @ChID bigint, @OurID int, @StockID int, @SrcPosID int, @ProdID int, @PPID int, @SecID int',
      @v1 = @v1 OUTPUT,
      @ChID = @ChID,
      @OurID = @OurID,
      @StockID = @StockID,
      @SrcPosID = @SrcPosID,
      @ProdID = @ProdID,
      @PPID = @PPID,
      @SecID = @SecID
  SELECT @v1 = ISNULL(@v1, 0)
  SELECT @v = @v + @v1       

  IF @Qty > @v SELECT @Result = 'ВНИМАНИЕ! Количество товара превышает остаток на данном КЦП (партии).'
END
GO
