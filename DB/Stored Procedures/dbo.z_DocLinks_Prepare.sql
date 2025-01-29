SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_DocLinks_Prepare](@ParentDocCode int, @ParentChID bigint, @ChildDocCode int, @ChildChID bigint, @RepToolCode int, @ToolCode int)
AS
/* Связь документов: Подготовка данных */
BEGIN
  DECLARE
    @DocLinkTypeID int,
    @ParentDocName varchar(250),
    @ParentSumCC numeric(21, 9),
    @ParentSumCCClosed numeric (21, 9),
    @ParentSumCCFree numeric (21, 9),
    @ParentLinkSumExp varchar(200),
    @ParentDocID bigint,
    @ParentDocDate smalldatetime,
    @ChildDocName varchar(250),
    @ChildSumCC numeric(21, 9),
    @ChildSumCCClosed numeric (21, 9),
    @ChildSumCCFree numeric (21, 9),
    @ChildLinkSumExp varchar(200),
    @ChildDocID bigint,
    @ChildDocDate smalldatetime,
    @LinkSumCC numeric(21, 9),
    @ShowDialog bit,
    @TableName varchar(200),
    @SQLStr nvarchar(500),
    @Params nvarchar(500),

    @SumCC_wt nvarchar(50),
    @Sum_nt numeric(21,9),
    @Sum_tx numeric(21,9),
    @Sum_wt numeric(21,9)
    IF @ParentDocCode = 14141
    begin

    Select @Sum_wt = SumCC_wt from b_dstack where ChID=@ParentChID
    If @Sum_wt<>0 set @SumCC_wt='SumCC_wt' else
       Select @Sum_wt = SumCC2_wt from b_dstack where ChID=@ParentChID
       If @Sum_wt<>0 set @SumCC_wt='SumCC2_wt' else
          Select @Sum_wt = SumCC3_wt from b_dstack where ChID=@ParentChID
          If @Sum_wt<>0 set @SumCC_wt='SumCC3_wt' else
             Select @Sum_wt = SumCC4_wt from b_dstack where ChID=@ParentChID
             If @Sum_wt<>0 set @SumCC_wt='SumCC4_wt'
    end
  /* Расчет суммы основополагающего документа */
  SELECT @ParentLinkSumExp = LinkEExp FROM z_Docs WHERE DocCode = @ParentDocCode
  If @ParentDocCode=14141 Set @ParentLinkSumExp=@SumCC_wt
  Select @ParentDocName = DocName FROM z_Docs WHERE DocCode = @ParentDocCode
  SELECT @TableName = TableName FROM z_Tables WHERE TableCode = @ParentDocCode * 1000 + 1
  SELECT @SQLStr = N'SELECT @DocIDOUT = DocID, @DocDateOUT = DocDate, @SumCCOUT = ' + @ParentLinkSumExp + ' FROM ' + @TableName + ' WHERE ChID = @ChID'
  SELECT @Params = N'@ChID bigint, @DocIDOUT bigint OUTPUT, @DocDateOUT smalldatetime OUTPUT, @SumCCOUT numeric(21, 9) OUTPUT'
  EXECUTE sp_executesql @SQLStr, @Params, @ChID = @ParentChID, @DocIDOUT = @ParentDocID OUTPUT, @DocDateOUT = @ParentDocDate OUTPUT, @SumCCOUT = @ParentSumCC OUTPUT
  /* Расчет суммы подчиненного документа */
  SELECT @ChildLinkSumExp = LinkEExp FROM z_Docs WHERE DocCode = @ChildDocCode
  Select @ChildDocName = DocName FROM z_Docs WHERE DocCode = @ChildDocCode
  SELECT @TableName = TableName FROM z_Tables WHERE TableCode = @ChildDocCode * 1000 + 1
  SELECT @SQLStr = N'SELECT @DocIDOUT = DocID, @DocDateOUT = DocDate, @SumCCOUT = ' + @ChildLinkSumExp + ' FROM ' + @TableName + ' WHERE ChID = @ChID'
  SELECT @Params = N'@ChID bigint, @DocIDOUT bigint OUTPUT, @DocDateOUT smalldatetime OUTPUT, @SumCCOUT numeric(21, 9) OUTPUT'
  EXECUTE sp_executesql @SQLStr, @Params, @ChID = @ChildChID, @DocIDOUT = @ChildDocID OUTPUT, @DocDateOUT = @ChildDocDate OUTPUT, @SumCCOUT = @ChildSumCC OUTPUT
  SELECT @DocLinkTypeID = CASE
    WHEN @RepToolCode = 11901 THEN 31
    WHEN @ChildDocCode BETWEEN 12000 AND 12999 OR @ChildDocCode BETWEEN 14010 AND 14099 THEN 11
    WHEN @ParentDocCode = 8001 AND @ChildDocCode BETWEEN 14001 AND 14999 THEN 21
    ELSE 0
  END
  SELECT @ParentSumCCClosed = ISNULL(SUM(LinkSumCC), 0) FROM z_DocLinks WHERE ParentDocCode = @ParentDocCode AND ParentChID = @ParentChID
  SELECT @ChildSumCCClosed = ISNULL(SUM(LinkSumCC), 0) FROM z_DocLinks WHERE ChildDocCode = @ChildDocCode AND ChildChID = @ChildChID
  SELECT
    @ParentSumCCFree = @ParentSumCC - @ParentSumCCClosed,
    @ChildSumCCFree = @ChildSumCC - @ChildSumCCClosed
  IF @ParentSumCCFree < @ChildSumCCFree SELECT @LinkSumCC = @ParentSumCCFree ELSE SELECT @LinkSumCC = @ChildSumCCFree
  SELECT @ShowDialog = CASE @RepToolCode WHEN 10602 THEN 1 ELSE 0 END
  /* Мастер Копирования */
  IF @RepToolCode = 10501
    BEGIN
      SELECT
        @DocLinkTypeID = DocLinkTypeID,
        @LinkSumCC = CASE LinkDocsWithSum WHEN 0 THEN 0 ELSE @LinkSumCC END
      FROM
        z_WCopy
      WHERE
        CopyID = @ToolCode
    END
  TRUNCATE TABLE #_DocLinks
  INSERT INTO #_DocLinks(
    ParentDocCode, ParentDocName, ParentChID, ParentDocID, ParentDocDate, ParentSumCC, ParentSumCCClosed, ParentSumCCFree,
    ChildDocCode, ChildDocName, ChildChID, ChildDocID, ChildDocDate, ChildSumCC, ChildSumCCClosed, ChildSumCCFree,
    DocLinkTypeID, LinkSumCC, RepToolCode, ToolCode, ShowDialog,
    Notes)
  VALUES (
    @ParentDocCode, @ParentDocName, @ParentChID, @ParentDocID, @ParentDocDate, @ParentSumCC, @ParentSumCCClosed, @ParentSumCCFree,
    @ChildDocCode, @ChildDocName, @ChildChID, @ChildDocID, @ChildDocDate, @ChildSumCC, @ChildSumCCClosed, @ChildSumCCFree,
    @DocLinkTypeID, @LinkSumCC, @RepToolCode, @ToolCode, @ShowDialog,
    dbo.zf_Translate('Укажите сумму связи и тип. Сумма связи, как правило, влияет на размер дебиторской задолженности. Тип связи определяет логический смысл связи и используется при дальнейшем анализе'))
END

GO
