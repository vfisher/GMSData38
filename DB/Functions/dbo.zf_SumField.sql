SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_SumField](@TableName varchar(250), @ChID bigint, @SumType int)
/* Возвращает суммовое поле указанного типа */
RETURNS varchar(250)
AS
BEGIN
  /*
    @SumType:
    0 - НДС
    1 - Без НДС
    2 - с НДС
  */
  DECLARE
    @SumCC_nt varchar(50),
    @TaxSum varchar(50),
    @SumCC_wt varchar(50),
    @Sum_nt numeric(21, 3),
    @Sum_tx numeric(21, 3),
    @Sum_wt numeric(21, 3)

  IF @TableName = 'b_DStack'
    BEGIN
      IF (SELECT SumCC_nt FROM b_DStack WHERE ChID = @ChID) <> 0
        BEGIN
          SELECT @Sum_nt = SumCC_nt FROM b_DStack WHERE ChID = @ChID
          SET @SumCC_nt = 'SumCC_nt'
          SET @TaxSum = 'TaxSum'
          SET @SumCC_wt = 'SumCC_wt'
        END
      IF (SELECT SumCC2_nt FROM b_DStack WHERE ChID = @ChID) <> 0
        BEGIN
          SELECT @Sum_nt = SumCC2_nt FROM b_DStack WHERE ChID = @ChID
          SET @SumCC_nt = 'SumCC2_nt'
          SET @TaxSum = 'TaxSum2'
          SET @SumCC_wt = 'SumCC2_wt'
        END
      IF (SELECT SumCC3_nt FROM b_DStack WHERE ChID = @ChID) <> 0
        BEGIN
          SELECT @Sum_nt = SumCC3_nt FROM b_DStack WHERE ChID = @ChID
          SET @SumCC_nt = 'SumCC3_nt'
          SET @TaxSum = 'TaxSum3'
          SET @SumCC_wt = 'SumCC3_wt'
        END
      IF (SELECT SumCC4_nt FROM b_DStack WHERE ChID = @ChID) <> 0
        BEGIN
          SELECT @Sum_nt = SumCC4_nt FROM b_DStack WHERE ChID = @ChID
          SET @SumCC_nt = 'SumCC4_nt'
          SET @TaxSum = 'TaxSum4'
          SET @SumCC_wt = 'SumCC4_wt'
        END
      IF @Sum_nt = 0
        BEGIN
          SET @SumCC_nt = 'SumCC_nt'
          SET @TaxSum = 'TaxSum'
          SET @SumCC_wt = 'SumCC_wt'
        END
    END
  RETURN (CASE @SumType
    WHEN 0 THEN
      CASE
        WHEN @TableName = 'b_DStack' AND EXISTS(SELECT * FROM vz_Fields WHERE TableName = @TableName AND FieldName = @TaxSum) THEN @TaxSum
        WHEN EXISTS(SELECT * FROM vz_Fields WHERE TableName = @TableName AND FieldName = 'TaxSum') THEN 'TaxSum'
        WHEN EXISTS(SELECT * FROM vz_Fields WHERE TableName = @TableName AND FieldName = 'TTaxSum') THEN 'TTaxSum'
      END
    WHEN 1 THEN
      CASE
        WHEN @TableName = 'b_DStack' AND EXISTS(SELECT * FROM vz_Fields WHERE TableName = @TableName AND FieldName = @SumCC_nt) THEN @SumCC_nt
        WHEN EXISTS(SELECT * FROM vz_Fields WHERE TableName = @TableName AND FieldName = 'SumCC_nt') THEN 'SumCC_nt'
        WHEN EXISTS(SELECT * FROM vz_Fields WHERE TableName = @TableName AND FieldName = 'TSumCC_nt') THEN 'TSumCC_nt'
        WHEN EXISTS(SELECT * FROM vz_Fields WHERE TableName = @TableName AND FieldName = 'SumCC_In') AND EXISTS(SELECT * FROM vz_Fields WHERE TableName = @TableName AND FieldName = 'TaxSum') THEN 'SumCC_In - TaxSum'
        WHEN EXISTS(SELECT * FROM vz_Fields WHERE TableName = @TableName AND FieldName = 'TSumCC_In') AND EXISTS(SELECT * FROM vz_Fields WHERE TableName = @TableName AND FieldName = 'TTaxSum') THEN 'TSumCC_In - TTaxSum'
      END
    WHEN 2 THEN
      CASE
        WHEN @TableName = 'b_DStack' AND EXISTS(SELECT * FROM vz_Fields WHERE TableName = @TableName AND FieldName = @SumCC_wt) THEN @SumCC_wt
        WHEN EXISTS(SELECT * FROM vz_Fields WHERE TableName = @TableName AND FieldName = 'SumCC_wt') THEN 'SumCC_wt'
        WHEN EXISTS(SELECT * FROM vz_Fields WHERE TableName = @TableName AND FieldName = 'TSumCC_wt') THEN 'TSumCC_wt'
        WHEN EXISTS(SELECT * FROM vz_Fields WHERE TableName = @TableName AND FieldName = 'SumCC_In') THEN 'SumCC_In'
        WHEN EXISTS(SELECT * FROM vz_Fields WHERE TableName = @TableName AND FieldName = 'TSumCC_In') THEN 'TSumCC_In'
      END
  END)
END
GO
