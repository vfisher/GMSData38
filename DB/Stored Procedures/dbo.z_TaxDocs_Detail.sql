SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_TaxDocs_Detail](@DocCode int, @ChID bigint)
AS
BEGIN
  DECLARE
    @MTableName varchar(50),
    @DTableName varchar(50),
    @MTableCode int,
    @DTableCode int,
    @SQLStr nvarchar(500),
    @KeyField varchar(50),
    @RefTable varchar(50),
    @TaxTypeExp varchar(50),
    @SumCC_nt nvarchar(50),
    @TaxSum nvarchar(50),
    @SumCC_wt nvarchar(50),
    @Sum_nt numeric(21,9),
    @Sum2_nt numeric(21,9),
    @Sum3_nt numeric(21,9),
    @Sum4_nt numeric(21,9),
    @Sum_tx numeric(21,9),
    @Sum_wt numeric(21,9)

IF @DocCode = 14141
BEGIN
  SELECT @Sum_nt = SumCC_nt, @Sum2_nt = SumCC2_nt, @Sum3_nt = SumCC3_nt, @Sum4_nt = SumCC4_nt FROM b_DStack WHERE ChID = @ChID
  IF @Sum_nt <> 0
  BEGIN
    SET @SumCC_nt = 'SumCC_nt'
    SET @TaxSum = 'TaxSum'
    SET @SumCC_wt = 'SumCC_wt'
  END
  ELSE IF @Sum2_nt <> 0
  BEGIN
    SET @SumCC_nt = 'SumCC2_nt'
    SET @TaxSum = 'TaxSum2'
    SET @SumCC_wt = 'SumCC2_wt'
  END
  ELSE IF @Sum3_nt <> 0
  BEGIN
    SET @SumCC_nt = 'SumCC3_nt'
    SET @TaxSum = 'TaxSum3'
    SET @SumCC_wt = 'SumCC3_wt'
  END
  ELSE IF @Sum4_nt <> 0
  BEGIN
    SET @SumCC_nt = 'SumCC4_nt'
    SET @TaxSum = 'TaxSum4'
    SET @SumCC_wt = 'SumCC4_wt'
  END
END

IF @DocCode IN (14011, 14012)
  SELECT @DocCode = ParentDocCode, @ChID = ParentChID FROM z_DocLinks WHERE ChildDocCode = @DocCode AND ChildChID = @ChID AND ParentDocCode IN (11001, 14101)
  SELECT @MTableName = TableName, @MTableCode = TableCode FROM z_Tables WHERE TableCode = @DocCode * 1000 + 1
  SELECT @DTableName = TableName, @DTableCode = TableCode FROM z_Tables WHERE TableCode = @DocCode * 1000 + 2
IF (@DTableName IS NULL)  SELECT @DTableName = @MTableName, @DTableCode = @MTableCode

IF EXISTS(SELECT TOP 1 1 FROM vz_Fields WHERE TableCode = @DTableCode AND FieldName = 'ProdID')
  SELECT @KeyField = 'ProdID', @RefTable = 'r_Prods', @TaxTypeExp = 'r.TaxTypeID'
ELSE IF EXISTS(SELECT TOP 1 1 FROM vz_Fields WHERE TableCode = @DTableCode AND FieldName = 'AssID')
SELECT @KeyField = 'AssID', @RefTable = 'r_Assets', @TaxTypeExp = '0'
ELSE IF (@DocCode IN (14301, 14302))
  SELECT @KeyField = 'ChID', @RefTable = '', @TaxTypeExp = '0'
ELSE IF (@DocCode = 14141)
  SELECT @KeyField = 'ChID', @RefTable = '', @TaxTypeExp = '0'
ELSE
BEGIN
  BEGIN

  DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('Невозможно получить данные документа')

  RAISERROR (@Error_msg1, 18, 1)
  END

  RETURN
END

IF (@RefTable <> '')
  SELECT @RefTable = 'JOIN ' + @RefTable + ' r ON d.' + @KeyField + ' = r.' + @KeyField
IF @DocCode = 14141
  SELECT @SQLStr = N'SELECT d.' + @KeyField + ' KeyField, m.DocDate, ' + @TaxTypeExp + ' TaxTypeID, d.' + @SumCC_nt + ', d.' + @TaxSum + ', d.' + @SumCC_wt + ' 
    FROM ' + @DTableName + ' d JOIN ' + @MTableName + ' m ON d.ChID = m.ChID ' + @RefTable + ' WHERE d.ChID = ' + CAST(@ChID AS varchar(50))
ELSE
  SELECT @SQLStr = N'SELECT d.' + @KeyField + ' KeyField, m.DocDate, ' + @TaxTypeExp + ' TaxTypeID, d.SumCC_nt, d.TaxSum, d.SumCC_wt 
    FROM ' + @DTableName + ' d JOIN ' + @MTableName + ' m ON d.ChID = m.ChID ' + @RefTable + ' WHERE d.ChID = ' + CAST(@ChID AS varchar(50))
EXEC sp_executesql @SQLStr
END

GO
