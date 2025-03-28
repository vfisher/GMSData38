SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_DocLinks_Validate](@Continue bit OUTPUT, @Msg varchar(200) OUTPUT)
AS 
/* Связь документов: Проверка */
BEGIN  
  IF EXISTS (SELECT TOP 1 1 FROM #_DocLinks WHERE LinkSumCC > ChildSumCCFree OR LinkSumCC > ParentSumCCFree)
    BEGIN
      SELECT
        @Msg = dbo.zf_Translate('Сумма связи не может быть больше доступной суммы каждого документа'),
        @Continue = 0
        RETURN
    END


  IF (EXISTS (SELECT TOP 1 1 FROM #_DocLinks WHERE DocLinkTypeID = 21) AND
     EXISTS (SELECT TOP 1 1 FROM #_DocLinks t, z_DocLinks d WHERE t.ChildDocCode = d.ChildDocCode AND t.ChildChID = d.ChildChID AND (t.LinkID <> d.LinkID OR t.LinkID IS NULL) AND d.DocLinkTypeID = 21))
    BEGIN
      SELECT
        @Msg = dbo.zf_Translate('Допустима только одна связь данного типа с основополагающим документом'),
        @Continue = 0
      RETURN
    END

  IF EXISTS (SELECT TOP 1 1 FROM z_DocLinks d INNER JOIN #_DocLinks t ON d.ChildDocCode = t.ParentDocCode AND d.ChildChID = t.ParentChID WHERE d.DocLinkTypeID = 21 AND t.DocLinkTypeID = 21)
    BEGIN
      SELECT
        @Msg = dbo.zf_Translate('Основополагающий документ не может иметь подчиненную связь данного типа, так как сам является подчиненным с данным типом связи'),
        @Continue = 0
      RETURN
    END

  IF EXISTS (SELECT TOP 1 1 FROM z_DocLinks d INNER JOIN #_DocLinks t ON d.ParentDocCode = t.ChildDocCode AND d.ParentChID = t.ChildChID WHERE d.DocLinkTypeID = 21 AND t.DocLinkTypeID = 21)
    BEGIN
      SELECT
        @Msg = dbo.zf_Translate('Подчиненный документ не может иметь главную связь данного типа, так как сам является основополагающим с данным типом связи'),
        @Continue = 0
      RETURN
    END

  SELECT
    @Msg = '',
    @Continue = 1
END 

GO
