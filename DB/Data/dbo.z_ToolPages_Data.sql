INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1, 1, N'Общие данные', 1, 1, N'SELECT CompName, City, CompID
FROM r_Comps
WHERE (CompID <> 0) AND @ValidComps@(CompID) AND @ValidPLs@(PLID)
ORDER BY CompName', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1, 2, N'Подробно', 2, 1, N'SELECT *FROM r_CompsWHERE CompID=:CompID', 3, NULL)
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1, 3, N'По городам', 1, 1, N'SELECT City, CompName, CompID
FROM r_Comps
WHERE (CompID <> 0) AND @ValidComps@(CompID) AND @ValidPLs@(PLID)
ORDER BY City, CompName', 3, NULL)
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (2, 1, N'Общие данные', 1, 1, N'SELECT m.CompName, m.City, m.CompID
FROM r_Comps m, @Table@ d
WHERE d.CompID = m.CompID and m.CompID <> 0 AND d.@Field@ LIKE ''%@Value@%''
ORDER BY d.@Field@ 
', 3, N'tab_Main')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (2, 2, N'Подробно', 2, 1, N'SELECT *FROM r_CompsWHERE CompID=:CompID', 3, NULL)
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (2, 3, N'По городам', 1, 1, N'SELECT CompName, City, CompID 
FROM r_Comps 
WHERE CompID <> 0 AND @Field@ LIKE ''%@Value@%'' 
ORDER BY CompName', 3, NULL)
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (3, 1, N'Партии', 1, 1, N'SELECT PPID, r.CurrName, PriceAC_In * CAST(u.s_PPAcc AS int) AS PriceAC_In, PriceMC_In * CAST(u.s_PPAcc AS int) PriceMC_In, PriceCC_In * CAST(u.s_PPAcc AS int) PriceCC_In, CostCC, CompName, PPDelay, ProdDate, Article
FROM t_PInP m, r_Comps c, r_Users u, r_Currs r 
WHERE c.CompID = m.CompID AND ProdID = @Value@ AND u.UserID = dbo.zf_GetUserCode() AND m.CurrID = r.CurrID
ORDER BY PPID DESC', 3, N'tab_PP')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (3, 2, N'Цены продажи', 1, 1, N'SELECT m.PLID, p.PLName, m.PriceMC*KursCC PriceCC, m.PriceMC/KursMC PriceMC, m.PriceMC PriceAC, CurrName
FROM r_ProdMP m, r_PLs p, r_Currs c
WHERE p.PLID = m.PLID AND c.CurrID = m.CurrID AND ProdID = @Value@ AND @ValidPLs@(p.PLID)
ORDER BY m.PLID', 3, N'tab_PL')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (3, 3, N'Остатки', 1, 1, N'SELECT OurID, StockID, SUM(Qty) WOAccQty, SUM(AccQty) AccQty, SUM(Qty - AccQty) RemQty, SecID 
FROM t_Rem 
WHERE ProdID = @Value@ AND @ValidOurs@(OurID) AND @ValidStocks@(StockID)
GROUP BY OurID, StockID, SecID 
ORDER BY OurID, StockID, SecID', 3, N'tab_Rem')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (3, 4, N'Остатки партий', 1, 1, N'SELECT  m.OurID, m.StockID, m.PPID, Qty - 0 RemQty,  SecID, PriceCC_In * CAST(u.s_PPAcc AS int) PriceCC_In, CompName, PPDelay, ProdDate, ArticleFROM t_Rem m, t_PInP p, r_Comps c, r_Users uWHERE p.ProdID = m.ProdID AND p.PPID = m.PPID AND c.CompID = p.CompID AND m.ProdID = @Value@ AND @ValidOurs@(m.OurID) AND @ValidStocks@(m.StockID) AND Qty <> 0 AND u.UserID = dbo.zf_GetUserCode()ORDER BY m.OurID, m.StockID, m.PPID DESC, SecID', 3, N'tab_RemPP')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (3, 5, N'Виды упаковок', 1, 1, N'SELECT m.UM, m.Qty, m.BarCode, m.ProdBarCode, m.PLID, d.PLName, m.WeightFROM r_ProdMQ m, r_PLs dWHERE d.PLID = m.PLID AND ProdID = @Value@ORDER BY UM', 3, N'tab_UM')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (3, 6, N'Альтернативы', 1, 1, N'SELECT m.AProdID, p.ProdName, m.NotesFROM r_ProdMA m, r_Prods pWHERE p.ProdID=m.AProdID AND m.ProdID = @Value@ORDER BY m.AProdID', 3, N'tab_Alts')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (4, 0, N'Общие', 2, 1, N'SELECT OrdQty, RecQty, OrdQty - RecQty AS RemQty FROM
(SELECT ISNULL(SUM(NewQty), 0) AS OrdQty FROM t_EOExp m, t_EOExpD d WHERE d.ChID=m.ChID AND   DocID=@DocID@ AND ProdID=@ProdID@) e,
(SELECT ISNULL(SUM(Qty), 0)    AS RecQty FROM t_EORec m, t_EORecD d WHERE d.ChID=m.ChID AND InDocID=@DocID@ AND ProdID=@ProdID@) r
', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (6, 0, N'Общие', 2, 1, N'SELECT OrdQty, RecQty, OrdQty - RecQty AS RemQty FROM
(SELECT ISNULL(SUM(NewQty), 0) AS OrdQty FROM t_IORec m, t_IORecD d WHERE d.ChID=m.ChID AND   DocID=@DocID@ AND ProdID=@ProdID@) e,
(SELECT ISNULL(SUM(Qty), 0)    AS RecQty FROM t_IOExp m, t_IOExpD d WHERE d.ChID=m.ChID AND InDocID=@DocID@ AND ProdID=@ProdID@) r
', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (8, 0, N'Подчиненные документы', 1, 1, N'SELECT ChildChID ChID, DocName, LinkSumCC, ChildDocDate, ChildDocID, ChildDocCode AChIDFROM z_DocLinks m, z_Docs dWHERE  m.DocLinkTypeID <> 31 and d.DocCode = m.ChildDocCode AND ParentDocCode = @DocCode@  AND ParentChID = @ChID@', 3, N'tab_ChildDocs')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (8, 1, N'Основополагающие документы', 1, 1, N'SELECT ParentChID ChID, DocName, LinkSumCC, ParentDocDate, ParentDocID, ParentDocCode AChIDFROM z_DocLinks m, z_Docs dWHERE  ((m.ChildDocCode IN (14341, 14342)) OR ((m.DocLinkTypeID <> 31) AND (m.ChildDocCode NOT IN (14341, 14342)))) AND  d.DocCode = m.ParentDocCode AND ChildDocCode = @DocCode@  AND ChildChID = @ChID@', 3, N'tab_ParentDocs')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (8, 2, N'Процессы', 1, 1, N'z_DocShed', 1, N'tab_ProcsPlan')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (8, 3, N'История статусов', 1, 1, N'SELECT    l.LogDate,    s1.StateName AS StateNameFrom,    s2.StateName AS StateNameTo,    u.UserName  FROM    z_LogState l    LEFT JOIN r_States s1 ON (l.OldStateCode = s1.StateCode)    LEFT JOIN r_States s2 ON (l.NewStateCode = s2.StateCode)    LEFT JOIN r_Users u ON (l.UserCode = u.UserID)  WHERE    l.DocCode = @DocCode@ AND    l.ChID = @ChID@  ORDER BY  LogDate', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (8, 4, N'Налоговые: Входящие', 1, 1, N'SELECT d.DocID, d.DocDate, d.SrcDocID, d.SrcDocDate, d.SumCC_nt, d.TaxSum, d.SumCC_wtFROM z_DocLinks m, b_TRec dWHERE  m.ChildDocCode = 14341 and DocLinkTypeID = 31  AND m.ChildChID = d.ChID AND m.ParentDocCode = @DocCode@ AND m.ParentChID = @ChID@', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (8, 5, N'Налоговые: Исходящие', 1, 1, N'SELECT d.DocID, d.DocDate, d.IntDocID, d.SumCC_nt, d.TaxSum, d.SumCC_wtFROM z_DocLinks m, b_TExp dWHERE  m.ChildDocCode = 14342 and DocLinkTypeID = 31  AND m.ChildChID = d.ChID AND m.ParentDocCode = @DocCode@ AND m.ParentChID = @ChID@', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (9, 0, N'Подчиненные документы', 1, 1, N'SELECT ChildChID ChID, DocName, LinkSumCC, ChildDocDate, ChildDocID, ChildDocCode AChIDFROM z_DocLinks m, z_Docs dWHERE  m.DocLinkTypeID <> 31 and d.DocCode = m.ChildDocCode AND ParentDocCode = @DocCode@  AND ParentChID = @ChID@', 3, N'tab_ChildDocs')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (9, 1, N'Основополагающие документы', 1, 1, N'SELECT ParentChID ChID, DocName, LinkSumCC, ParentDocDate, ParentDocID, ParentDocCode AChIDFROM z_DocLinks m, z_Docs dWHERE  ((m.ChildDocCode IN (14341, 14342)) OR ((m.DocLinkTypeID <> 31) AND (m.ChildDocCode NOT IN (14341, 14342)))) AND  d.DocCode = m.ParentDocCode AND ChildDocCode = @DocCode@  AND ChildChID = @ChID@', 3, N'tab_ParentDocs')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (9, 2, N'Процессы', 1, 1, N'z_DocShed', 1, N'tab_ProcsPlan')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (9, 3, N'История статусов', 1, 1, N'SELECT    l.LogDate,    s1.StateName AS StateNameFrom,    s2.StateName AS StateNameTo,    u.UserName  FROM    z_LogState l    LEFT JOIN r_States s1 ON (l.OldStateCode = s1.StateCode)    LEFT JOIN r_States s2 ON (l.NewStateCode = s2.StateCode)    LEFT JOIN r_Users u ON (l.UserCode = u.UserID)  WHERE    l.DocCode = @DocCode@ AND    l.ChID = @ChID@  ORDER BY  LogDate', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (9, 4, N'Начисление бонусов', 1, 1, N'SELECT d.DiscName, r.SumBonus, dc.DCardID, p.PersonName
FROM z_LogDiscRec r
  JOIN r_DCards dc ON r.DCardChID = dc.ChID
  LEFT JOIN r_Discs d ON r.DiscCode = d.DiscCode
  LEFT JOIN r_PersonDC pdc ON r.DCardChID = pdc.DCardChID
  LEFT JOIN r_Persons p ON pdc.PersonID = p.PersonID
WHERE r.DocCode = @DocCode@ AND r.ChID = @ChID@', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (9, 5, N'Предоставление скидок', 1, 1, N'SELECT d.DiscName, e.SumBonus, e.Discount, dc.DCardID, p.PersonName
FROM z_LogDiscExp e
  JOIN r_DCards dc ON e.DCardChID = dc.ChID
  LEFT JOIN r_Discs d ON e.DiscCode = d.DiscCode
  LEFT JOIN r_PersonDC pdc ON e.DCardChID = pdc.DCardChID
  LEFT JOIN r_Persons p ON pdc.PersonID = p.PersonID
WHERE e.DocCode = @DocCode@ AND e.ChID = @ChID@
', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (9, 6, N'Налоговые: Входящие', 1, 1, N'SELECT d.DocID, d.DocDate, d.SrcDocID, d.SrcDocDate, d.SumCC_nt, d.TaxSum, d.SumCC_wtFROM z_DocLinks m, b_TRec dWHERE  m.ChildDocCode = 14341 and DocLinkTypeID = 31  AND m.ChildChID = d.ChID AND m.ParentDocCode = @DocCode@ AND m.ParentChID = @ChID@', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (9, 7, N'Налоговые: Исходящие', 1, 1, N'SELECT d.DocID, d.DocDate, d.IntDocID, d.SumCC_nt, d.TaxSum, d.SumCC_wtFROM z_DocLinks m, b_TExp dWHERE  m.ChildDocCode = 14342 and DocLinkTypeID = 31  AND m.ChildChID = d.ChID AND m.ParentDocCode = @DocCode@ AND m.ParentChID = @ChID@', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (10, 0, N'Общие', 1, 1, N'SELECT ''t_PInP'' AS TableName, ProdID, PPID, Article, File1, File2, File3, PPDesc
FROM t_PInP
WHERE ProdID=@ProdID@
ORDER BY PPID', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (12, 0, N'tab_Comm', 1, 1, N'SELECT m.ProdID,
       m.ProdName,
       pp.PPID,
       pp.ProdDate,
       pp.Article,
       UM,
       ((pl.PriceMC / c.KursMC) * @KursMC@) AS PriceCC,
       SUM(r.Qty) AS TQty
FROM ((r_Currs c WITH (NOLOCK)
     INNER JOIN (r_Prods m WITH (NOLOCK)
     INNER JOIN r_ProdMP pl WITH (NOLOCK) ON m.ProdID=pl.ProdID) ON c.CurrID=pl.CurrID)
     INNER JOIN t_PInP pp WITH (NOLOCK) ON m.ProdID=pp.ProdID)
     LEFT JOIN t_Rem r WITH (NOLOCK) ON ((pp.PPID=r.PPID) AND (pp.ProdID=r.ProdID) AND (r.OurID=@OurID@) AND (r.StockID=@StockID@))
WHERE pl.PLID=@PLID@  AND m.ProdID > 0 AND
     (m.@FieldName@ LIKE @Value@) AND
     (r.Qty > 0  OR @ShowZeroRem@ = 1)
GROUP BY m.ProdID,
     m.ProdName,
     pp.PPID,
     pp.ProdDate,
     pp.Article,
     UM,
     ((pl.PriceMC / c.KursMC) * @KursMC@)', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (14, 0, N'Общие данные', 1, 1, N'SELECT m.ProdID, m.ProdName, m.UMFROM r_Prods m WITH ( NOLOCK ), @Table@ d WITH ( NOLOCK )WHERE d.ProdID=m.ProdID AND d.@Field@ LIKE @Value@ ORDER BY d.@Field@', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (15, 1, N'Баланс', 1, 1, N'SELECT ''Приход товара'' DocName, SUM(@SumCCField@) TSumCC, SUM(Qty) TQty FROM t_Rec m, t_RecD d WHERE m.ChID=d.ChID AND m.OurID=@OurID@  AND m.StockID=@StockID@ AND m.CompID=@CompID@ AND d.ProdID=@ProdID@UNIONSELECT ''Приход товара по ГТД'' DocName, SUM(SumCC_In) TSumCC, SUM(Qty) TQty FROM t_Cst m, t_CstD d WHERE m.ChID=d.ChID AND m.OurID=@OurID@  AND m.StockID=@StockID@ AND m.CompID=@CompID@ AND d.ProdID=@ProdID@UNIONSELECT ''Возврат товара поставщику'' DocName, -SUM(@SumCCField@) TSumCC, -SUM(Qty) TQty FROM t_CRet m, t_CRetD d WHERE m.ChID=d.ChID AND m.OurID=@OurID@  AND m.StockID=@StockID@ AND m.CompID=@CompID@ AND d.ProdID=@ProdID@AND d.ProdID=@ProdID@', 3, N'tab_Balance')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (15, 2, N'Приход товара', 1, 1, N'SELECT m.ChID, m.DocID, m.DocDate, d.PPID, c.CurrName, p.PriceAC, @PriceCCField@ AS PriceCC, p.PriceCC AS PriceCC_In, Sum(@SumCCField@) AS T@SumCCField@, Sum(Qty) AS TQty 
FROM t_Rec m, t_RecD d, t_PInPs p, r_Currs c 
WHERE m.ChID=d.ChID AND d.ProdID=p.ProdID AND d.PPID=p.PPID AND m.OurID=@OurID@ AND m.CompID=@CompID@ AND m.StockID=@StockID@ AND d.ProdID=@ProdID@ AND  p.CurrID = c.CurrID
GROUP BY m.ChID, m.DocID, m.DocDate, d.PPID, @PriceCCField@, p.PriceCC, c.CurrName, p.PriceAC
ORDER BY m.DocDate, m.DocID
', 3, N'tab_Rec')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (15, 3, N'Приход товара по ГТД', 1, 1, N'SELECT m.ChID, m.DocID, m.DocDate, d.PPID, d.PriceCC_In AS PriceCC, p.PriceCC AS PriceCC_In, Sum(SumCC_In) AS SumCC, Sum(Qty) AS TQty FROM t_Cst m, t_CstD d, t_PInPs p WHERE m.ChID=d.ChID AND d.ProdID=p.ProdID AND d.PPID=p.PPID AND m.OurID=@OurID@ AND m.CompID=@CompID@ AND m.StockID=@StockID@ AND d.ProdID=@ProdID@GROUP BY m.ChID, m.DocID, m.DocDate, d.PPID, d.PriceCC_In, p.PriceCC ORDER BY m.DocDate, m.DocID', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (15, 4, N'Возврат товара поставщику', 1, 1, N'SELECT m.ChID, m.DocID, m.DocDate, d.PPID, @PriceCCField@ AS PriceCC, p.PriceCC PriceCC_In, Sum(@SumCCField@) AS T@SumCCField@, Sum(Qty) AS TQty FROM t_CRet m, t_CRetD d, t_PInPs p WHERE m.ChID=d.ChID AND d.ProdID=p.ProdID AND d.PPID=p.PPID AND m.OurID=@OurID@ AND m.CompID=@CompID@ AND m.StockID=@StockID@ AND d.ProdID=@ProdID@GROUP BY m.ChID, m.DocID, m.DocDate, d.PPID, @PriceCCField@, p.PriceCC ORDER BY m.DocDate, m.DocID', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (16, 1, N'Баланс', 1, 1, N'SELECT ''Расходная накладная'' DocName, SUM(@SumCCField@) TSumCC, SUM(Qty) TQty FROM t_Inv m, t_InvD d WHERE m.ChID=d.ChID AND m.OurID=@OurID@  AND m.StockID=@StockID@ AND m.CompID=@CompID@ AND d.ProdID=@ProdID@UNIONSELECT ''Расходный документ'' DocName, SUM(@SumCCField@) TSumCC, SUM(Qty) TQty FROM t_Exp m, t_ExpD d WHERE m.ChID=d.ChID AND m.OurID=@OurID@  AND m.StockID=@StockID@ AND m.CompID=@CompID@ AND d.ProdID=@ProdID@UNIONSELECT ''Расходный документ в ценах прихода'' DocName, SUM(@SumCCField@) TSumCC, SUM(Qty) TQty FROM t_Epp m, t_EppD d WHERE m.ChID=d.ChID AND m.OurID=@OurID@  AND m.StockID=@StockID@ AND m.CompID=@CompID@ AND d.ProdID=@ProdID@UNIONSELECT ''Возврат товара от получателя'' DocName, -SUM(@SumCCField@) TSumCC, -SUM(Qty) TQty FROM t_Ret m, t_RetD d WHERE m.ChID=d.ChID AND m.OurID=@OurID@  AND m.StockID=@StockID@ AND m.CompID=@CompID@ AND d.ProdID=@ProdID@', 3, N'tab_Balance')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (16, 2, N'Расходная накладная', 1, 1, N'SELECT m.ChID, m.DocID, m.DocDate, d.PPID, c.CurrName, @PriceCCField@ AS PriceCC, p.PriceCC AS PriceCC_In, Sum(@SumCCField@) AS T@SumCCField@, Sum(Qty) AS TQty 
FROM t_Inv m, t_InvD d, t_PInPs p, r_Currs c 
WHERE m.ChID=d.ChID AND d.ProdID=p.ProdID AND d.PPID=p.PPID AND m.OurID=@OurID@ AND m.CompID=@CompID@ AND m.StockID=@StockID@ AND d.ProdID=@ProdID@ AND m.CurrID = c.CurrID
GROUP BY m.ChID, m.DocID, m.DocDate, d.PPID, @PriceCCField@, p.PriceCC, c.CurrName
ORDER BY m.DocDate, m.DocID', 3, N'tab_Inv')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (16, 3, N'Расходный документ', 1, 1, N'SELECT m.ChID, m.DocID, m.DocDate, d.PPID, @PriceCCField@ AS PriceCC, p.PriceCC AS PriceCC_In, Sum(@SumCCField@) AS T@SumCCField@, Sum(Qty) AS TQty FROM t_Exp m, t_ExpD d, t_PInPs p WHERE m.ChID=d.ChID AND d.ProdID=p.ProdID AND d.PPID=p.PPID AND m.OurID=@OurID@ AND m.CompID=@CompID@ AND m.StockID=@StockID@ AND d.ProdID=@ProdID@GROUP BY m.ChID, m.DocID, m.DocDate, d.PPID, @PriceCCField@, p.PriceCC ORDER BY m.DocDate, m.DocID', 3, N'tab_Exp')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (16, 4, N'Расходный документ в ЦП', 1, 1, N'SELECT m.ChID, m.DocID, m.DocDate, d.PPID, c.CurrName, @PriceCCField@ AS PriceCC, p.PriceCC AS PriceCC_In, Sum(@SumCCField@) AS T@SumCCField@, Sum(Qty) AS TQty 
FROM t_Epp m, t_EppD d, t_PInPs p, r_Currs c 
WHERE m.ChID=d.ChID AND d.ProdID=p.ProdID AND d.PPID=p.PPID AND m.OurID=@OurID@ AND m.CompID=@CompID@ AND m.StockID=@StockID@ AND d.ProdID=@ProdID@ AND m.CurrID = c.CurrID
GROUP BY m.ChID, m.DocID, m.DocDate, d.PPID, @PriceCCField@, p.PriceCC, c.CurrName
ORDER BY m.DocDate, m.DocID
', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (16, 5, N'Возврат товара от получателя', 1, 1, N'SELECT m.ChID, m.DocID, m.DocDate, d.PPID, @PriceCCField@ AS PriceCC, p.PriceCC AS PriceCC_In, Sum(@SumCCField@) AS T@SumCCField@, Sum(Qty) AS TQty FROM t_Ret m, t_RetD d, t_PInPs p WHERE m.ChID=d.ChID AND d.ProdID=p.ProdID AND d.PPID=p.PPID AND m.OurID=@OurID@ AND m.CompID=@CompID@ AND m.StockID=@StockID@ AND d.ProdID=@ProdID@GROUP BY m.ChID, m.DocID, m.DocDate, d.PPID, @PriceCCField@, p.PriceCC ORDER BY m.DocDate, m.DocID', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (17, 1, N'История цен', 1, 1, N'SELECT m.ProdID, m.ChTime, m.PLID, m.OldCurrID, m.OldPriceMC, m.CurrID, m.PriceMC, d.PLName
FROM r_ProdMPCh m, r_Pls d
WHERE  m.PLID=d.PLID AND m.ProdID=@ProdID@ AND m.PLID>=@PLIDMIN@ AND m.PLID<=@PLIDMAX@
ORDER BY d.PLName ASC, ChTime DESC', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (18, 1, N'История цен продажи', 1, 1, N'SELECT m.ChID, m.ProdID, m.ChDate, m.ChTime, m.PLID, m.OldCurrID, m.OldPriceMC, m.CurrID, m.PriceMC, m.UserID, d.PLName 
FROM r_ProdMPCh m, r_Pls d 
WHERE m.PLID=d.PLID AND m.ProdID= @ProdID@ AND m.PLID= @PLID@ AND @ValidPLsExp@ AND @PLIDExp@
ORDER BY d.PLName ASC, ChDate DESC , ChTime DESC', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (19, 0, N'Баланс', 1, 1, N'SELECT ''Расходная накладная'' DocName, SUM(CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN SumCC_wt ELSE SumCC_nt END) TSumCC, SUM(Qty) TQty FROM b_Inv m, b_InvD d WHERE m.ChID=d.ChID AND m.OurID=@OurID@  AND m.StockID=@StockID@ AND m.CompID=@CompID@ AND d.ProdID=@ProdID@
UNION
SELECT ''Расходный документ'' DocName, SUM(CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN SumCC_wt ELSE SumCC_nt END) TSumCC, SUM(Qty) TQty FROM b_Exp m, b_ExpD d WHERE m.ChID=d.ChID AND m.OurID=@OurID@  AND m.StockID=@StockID@ AND m.CompID=@CompID@ AND d.ProdID=@ProdID@
UNION
SELECT ''Приход товара'' DocName, SUM(CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN SumCC_wt ELSE SumCC_nt END) TSumCC, SUM(Qty) TQty FROM b_Rec m, b_RecD d WHERE m.ChID=d.ChID AND m.OurID=@OurID@  AND m.StockID=@StockID@ AND m.CompID=@CompID@ AND d.ProdID=@ProdID@
UNION
SELECT ''Возврат товара'' DocName, SUM(CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN SumCC_wt ELSE SumCC_nt END) TSumCC, SUM(Qty) TQty FROM b_Ret m, b_RetD d WHERE m.ChID=d.ChID AND m.OurID=@OurID@  AND m.StockID=@StockID@ AND m.CompID=@CompID@ AND d.ProdID=@ProdID@
', 3, N'tab_Balance')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (19, 1, N'Расходная накладная', 1, 1, N'SELECT m.ChID, m.DocID, m.DocDate, d.PPID, CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN PriceCC_wt ELSE PriceCC_nt END AS SumCC, p.PriceCC, Sum(SumCC_wt) AS TSumCC_wt, Sum(SumCC_nt) AS TSumCC_nt, Sum(TaxSum) AS TTaxSum, Sum(Qty) AS TQty 
FROM b_Inv m, b_InvD d, b_PInPs p 
WHERE m.ChID=d.ChID AND d.ProdID=p.ProdID AND d.PPID=p.PPID AND m.OurID=@OurID@ AND m.CompID=@CompID@ AND m.StockID=@StockID@ AND d.ProdID=@ProdID@
GROUP BY m.ChID, m.DocID, m.DocDate, d.PPID, CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN PriceCC_wt ELSE PriceCC_nt END, p.PriceCC 
ORDER BY m.DocDate, m.DocID
', 3, N'tab_Inv')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (19, 2, N'Расходный документ', 1, 1, N'SELECT m.ChID, m.DocID, m.DocDate, d.PPID, CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN PriceCC_wt ELSE PriceCC_nt END AS SumCC, p.PriceCC, Sum(SumCC_wt) AS TSumCC_wt, Sum(SumCC_nt) AS TSumCC_nt, Sum(TaxSum) AS TTaxSum, Sum(Qty) AS TQty 
FROM b_Exp m, b_ExpD d, b_PInPs p 
WHERE m.ChID=d.ChID AND d.ProdID=p.ProdID AND d.PPID=p.PPID AND m.OurID=@OurID@ AND m.CompID=@CompID@ AND m.StockID=@StockID@ AND d.ProdID=@ProdID@
GROUP BY m.ChID, m.DocID, m.DocDate, d.PPID, CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN PriceCC_wt ELSE PriceCC_nt END, p.PriceCC 
ORDER BY m.DocDate, m.DocID
', 3, N'tab_Exp')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (19, 3, N'Приход товара', 1, 1, N'SELECT m.ChID, m.DocID, m.DocDate, d.PPID, CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN PriceCC_wt ELSE PriceCC_nt END AS SumCC, p.PriceCC, Sum(SumCC_wt) AS TSumCC_wt, Sum(SumCC_nt) AS TSumCC_nt, Sum(TaxSum) AS TTaxSum, Sum(Qty) AS TQty 
FROM b_Rec m, b_RecD d, b_PInPs p 
WHERE m.ChID=d.ChID AND d.ProdID=p.ProdID AND d.PPID=p.PPID AND m.OurID=@OurID@ AND m.CompID=@CompID@ AND m.StockID=@StockID@ AND d.ProdID=@ProdID@
GROUP BY m.ChID, m.DocID, m.DocDate, d.PPID, CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN PriceCC_wt ELSE PriceCC_nt END, p.PriceCC 
ORDER BY m.DocDate, m.DocID
', 3, N'tab_Rec')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (19, 4, N'Возврат товара', 1, 1, N'SELECT m.ChID, m.DocID, m.DocDate, d.PPID, CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN PriceCC_wt ELSE PriceCC_nt END AS SumCC, p.PriceCC, Sum(SumCC_wt) AS TSumCC_wt, Sum(SumCC_nt) AS TSumCC_nt, Sum(TaxSum) AS TTaxSum, Sum(Qty) AS TQty 
FROM b_Ret m, b_RetD d, b_PInPs p 
WHERE m.ChID=d.ChID AND d.ProdID=p.ProdID AND d.PPID=p.PPID AND m.OurID=@OurID@ AND m.CompID=@CompID@ AND m.StockID=@StockID@ AND d.ProdID=@ProdID@
GROUP BY m.ChID, m.DocID, m.DocDate, d.PPID, CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN PriceCC_wt ELSE PriceCC_nt END, p.PriceCC 
ORDER BY m.DocDate, m.DocID
', 3, N'tab_Ret')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (20, 0, N'Баланс', 1, 1, N'SELECT ''Расходная накладная'' DocName, SUM(CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN SumCC_wt ELSE SumCC_nt END) TSumCC, SUM(Qty) TQty FROM b_Inv m, b_InvD d WHERE m.ChID=d.ChID AND m.OurID=@OurID@  AND m.StockID=@StockID@ AND m.CompID=@CompID@ AND d.ProdID=@ProdID@
UNION
SELECT ''Расходный документ'' DocName, SUM(CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN SumCC_wt ELSE SumCC_nt END) TSumCC, SUM(Qty) TQty FROM b_Exp m, b_ExpD d WHERE m.ChID=d.ChID AND m.OurID=@OurID@  AND m.StockID=@StockID@ AND m.CompID=@CompID@ AND d.ProdID=@ProdID@
UNION
SELECT ''Приход товара'' DocName, SUM(CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN SumCC_wt ELSE SumCC_nt END) TSumCC, SUM(Qty) TQty FROM b_Rec m, b_RecD d WHERE m.ChID=d.ChID AND m.OurID=@OurID@  AND m.StockID=@StockID@ AND m.CompID=@CompID@ AND d.ProdID=@ProdID@
UNION
SELECT ''Возврат товара'' DocName, SUM(CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN SumCC_wt ELSE SumCC_nt END) TSumCC, SUM(Qty) TQty FROM b_Ret m, b_RetD d WHERE m.ChID=d.ChID AND m.OurID=@OurID@  AND m.StockID=@StockID@ AND m.CompID=@CompID@ AND d.ProdID=@ProdID@
', 3, N'tab_Balance')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (20, 1, N'Расходная накладная', 1, 1, N'SELECT m.ChID, m.DocID, m.DocDate, d.PPID, CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN PriceCC_wt ELSE PriceCC_nt END AS SumCC, p.PriceCC, Sum(SumCC_wt) AS TSumCC_wt, Sum(SumCC_nt) AS TSumCC_nt, Sum(TaxSum) AS TTaxSum, Sum(Qty) AS TQty 
FROM b_Inv m, b_InvD d, b_PInPs p 
WHERE m.ChID=d.ChID AND d.ProdID=p.ProdID AND d.PPID=p.PPID AND m.OurID=@OurID@ AND m.CompID=@CompID@ AND m.StockID=@StockID@ AND d.ProdID=@ProdID@
GROUP BY m.ChID, m.DocID, m.DocDate, d.PPID, CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN PriceCC_wt ELSE PriceCC_nt END, p.PriceCC 
ORDER BY m.DocDate, m.DocID
', 3, N'tab_Inv')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (20, 2, N'Расходный документ', 1, 1, N'SELECT m.ChID, m.DocID, m.DocDate, d.PPID, CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN PriceCC_wt ELSE PriceCC_nt END AS SumCC, p.PriceCC, Sum(SumCC_wt) AS TSumCC_wt, Sum(SumCC_nt) AS TSumCC_nt, Sum(TaxSum) AS TTaxSum, Sum(Qty) AS TQty 
FROM b_Exp m, b_ExpD d, b_PInPs p 
WHERE m.ChID=d.ChID AND d.ProdID=p.ProdID AND d.PPID=p.PPID AND m.OurID=@OurID@ AND m.CompID=@CompID@ AND m.StockID=@StockID@ AND d.ProdID=@ProdID@
GROUP BY m.ChID, m.DocID, m.DocDate, d.PPID, CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN PriceCC_wt ELSE PriceCC_nt END, p.PriceCC 
ORDER BY m.DocDate, m.DocID
', 3, N'tab_Exp')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (20, 3, N'Приход товара', 1, 1, N'SELECT m.ChID, m.DocID, m.DocDate, d.PPID, CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN PriceCC_wt ELSE PriceCC_nt END AS SumCC, p.PriceCC, Sum(SumCC_wt) AS TSumCC_wt, Sum(SumCC_nt) AS TSumCC_nt, Sum(TaxSum) AS TTaxSum, Sum(Qty) AS TQty 
FROM b_Rec m, b_RecD d, b_PInPs p 
WHERE m.ChID=d.ChID AND d.ProdID=p.ProdID AND d.PPID=p.PPID AND m.OurID=@OurID@ AND m.CompID=@CompID@ AND m.StockID=@StockID@ AND d.ProdID=@ProdID@
GROUP BY m.ChID, m.DocID, m.DocDate, d.PPID, CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN PriceCC_wt ELSE PriceCC_nt END, p.PriceCC 
ORDER BY m.DocDate, m.DocID
', 3, N'tab_Rec')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (20, 4, N'Возврат товара', 1, 1, N'SELECT m.ChID, m.DocID, m.DocDate, d.PPID, CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN PriceCC_wt ELSE PriceCC_nt END AS SumCC, p.PriceCC, Sum(SumCC_wt) AS TSumCC_wt, Sum(SumCC_nt) AS TSumCC_nt, Sum(TaxSum) AS TTaxSum, Sum(Qty) AS TQty 
FROM b_Ret m, b_RetD d, b_PInPs p 
WHERE m.ChID=d.ChID AND d.ProdID=p.ProdID AND d.PPID=p.PPID AND m.OurID=@OurID@ AND m.CompID=@CompID@ AND m.StockID=@StockID@ AND d.ProdID=@ProdID@
GROUP BY m.ChID, m.DocID, m.DocDate, d.PPID, CASE dbo.zf_Var(''b_WithTax'') WHEN 1 THEN PriceCC_wt ELSE PriceCC_nt END, p.PriceCC 
ORDER BY m.DocDate, m.DocID
', 3, N'tab_Ret')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (21, 1, N'Партии', 1, 1, N'IF dbo.zf_UserPPAcc() = 1
    SELECT PPID, PriceCC_In, CompName, PPDelay, ProdDate, Article
    FROM b_PInP m, r_Comps c
    WHERE c.CompID = m.CompID AND ProdID = @Value@
    ORDER BY PPID DESC
  ELSE
    SELECT PPID, ''#Нет доступа#'' Notes, CompName, PPDelay, ProdDate, Article
    FROM b_PInP m, r_Comps c
    WHERE c.CompID = m.CompID AND ProdID = @Value@
    ORDER BY PPID DESC', 3, N'tab_PP')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (21, 2, N'Цены продажи', 1, 1, N'SELECT m.PLID, p.PLName, m.PriceMC*KursCC PriceCC, m.PriceMC/KursMC PriceMC, CurrNameFROM r_ProdMP m, r_PLs p, r_Currs cWHERE p.PLID = m.PLID AND c.CurrID = m.CurrID AND ProdID = @Value@ AND @ValidPLs@(p.PLID)ORDER BY m.PLID', 3, N'tab_PL')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (21, 3, N'Остатки', 1, 1, N'SELECT OurID, StockID, SUM(Qty) RemQty 
FROM b_Rem 
WHERE ProdID = @Value@ AND @ValidOurs@(OurID) AND @ValidStocks@(StockID)
GROUP BY OurID, StockID 
ORDER BY OurID, StockID
', 3, N'tab_Rem')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (21, 4, N'Остатки партий', 1, 1, N'SELECT  OurID, StockID, m.PPID, Qty - 0 RemQty,  PriceCC_In, CompName, PPDelay, ProdDate, ArticleFROM b_Rem m, b_PInP p, r_Comps cWHERE p.ProdID = m.ProdID AND p.PPID = m.PPID AND c.CompID = p.CompID AND m.ProdID = @Value@ AND @ValidOurs@(OurID) AND @ValidStocks@(StockID) AND Qty <> 0ORDER BY OurID, StockID, m.PPID DESC', 3, N'tab_RemPP')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (22, 1, N'Истекшие резервы по счетам', 1, 1, N'SELECT m.OurID, m.DocID, m.DocDate, c.CompName, m.StockID 
FROM t_Acc m, r_Comps c
WHERE 
  c.CompID = m.CompID 
  AND m.ReserveProds <> 0 AND ((m.DocDate + m.ReserveDayCount) <= dbo.zf_GetDate(GetDate())) 
  AND @ValidOurs@(m.OurID) AND @ValidStocks@(m.StockID)', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (23, 1, N'Уведомления внешних заказов', 1, 1, N'SELECT m.OurID, m.DocID, m.DocDate, c.CompName, m.StockID 
FROM t_EOExp m, r_Comps c
WHERE 
  c.CompID = m.CompID 
  AND ((m.ExpSN <> 0 AND m.ExpDate <= dbo.zf_GetDate(GetDate())) 
      OR (m.NotSN <> 0 AND m.NotDate = dbo.zf_GetDate(GetDate()))) 
  AND @ValidOurs@(m.OurID) AND @ValidStocks@(m.StockID)', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (24, 1, N'Уведомления внутренних заказов', 1, 1, N'SELECT m.OurID, m.DocID, m.DocDate, c.CompName, m.StockID 
FROM t_IORec m, r_Comps c
WHERE 
  c.CompID = m.CompID 
  AND ((m.ExpSN<>0 AND m.ExpDate <= dbo.zf_GetDate(GetDate())) 
      OR (m.NotSN<>0 AND m.NotDate = dbo.zf_GetDate(GetDate()))) 
  AND @ValidOurs@(m.OurID) AND @ValidStocks@(m.StockID)', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (25, 1, N'Общие данные', 1, 1, N'SELECT OurName, OurID
FROM r_Ours
WHERE @ValidOurs@(OurID)', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (26, 1, N'Общие данные', 1, 1, N'SELECT StockName, StockGName, StockID
FROM r_Stocks s, r_StockGs g
WHERE s.StockGID = g.StockGID AND @ValidStocks@(s.StockID) AND @ValidPLs@(s.PLID)
', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (27, 1, N'Общие данные', 1, 1, N'SELECT m.OurName, m.OurID
FROM r_Ours m, @Table@ d
WHERE d.OurID = m.OurID AND d.@Field@ LIKE ''%@Value@%'' AND @ValidOurs@(m.OurID)
ORDER BY d.@Field@ 
', 3, N'tab_Main')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (28, 1, N'Общие данные', 1, 1, N'SELECT m.StockName, m.StockID
FROM r_Stocks m, @Table@ d
WHERE d.StockID = m.StockID AND d.@Field@ LIKE ''%@Value@%'' AND @ValidStocks@(m.StockID)
ORDER BY d.@Field@ 
', 3, N'tab_Main')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (29, 1, N'Список', 1, 1, N'SELECT
  m.ChID, m.DocDate , m.DocID, @IdentifierID@, @IdentifierName@, @LinkSumExp@ AS SumCC,
  ISNULL(ROUND((SELECT Sum(LinkSumCC) FROM z_DocLinks d WHERE m.ChID = d.@LinkChIDField@ AND d.@LinkDocCodeField@ = @LinkDocCode@),2), 0) AS LinkSumCC 
FROM @TableName@ m, @IdentifierTableName@
WHERE m.OurID = @OurID@ AND m.@IdentifierIDNoAlias@ = @IdentifierID@
', 3, N'tab_List')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (42, 1, N'Проводник по товарам', 5, 1, N'-- CreateTree(PCatName, PGrName, PGrName1, PGrName2, PGrName3)  
-- CreateGridLevel(0, ProdName, UM, PriceCC, RemQty, ProdID, Barcode, Notes, PCatID, PGrID, PGrID1, PGrID2, PGrID3, PGrName, PGrName1, PGrName2, PGrName3) 
-- CreateGridLevel(1, ProdName, UM, PriceCC, RemQty, ProdID, Barcode, Notes, PCatID, PGrID, PGrID1, PGrID2, PGrID3, PGrName1, PGrName2, PGrName3) 
-- CreateGridLevel(2, ProdName, UM, PriceCC, RemQty, ProdID, Barcode, Notes, PCatID, PGrID, PGrID1, PGrID2, PGrID3, PGrName2, PGrName3) 
-- CreateGridLevel(3, ProdName, UM, PriceCC, RemQty, ProdID, Barcode, Notes, PCatID, PGrID, PGrID1, PGrID2, PGrID3, PGrName3) 
-- CreateGridLevel(4, ProdName, UM, PriceCC, RemQty, ProdID, Barcode, Notes, PCatID, PGrID, PGrID1, PGrID2, PGrID3) 
SELECT r.ProdName, r.UM, m.PriceCC, r.ProdID, r.Notes, c.PCatID, c.PCatName, g.PGrID, g.PGrName, g1.PGrID1, g1.PGrName1, g2.PGrID2, g2.PGrName2, g3.PGrID3, g3.PGrName3 
FROM r_Prods r LEFT JOIN r_ProdMPs m ON m.ProdID = r.ProdID AND m.PLID = @PLID@, r_ProdC c, r_ProdG g, r_ProdG1 g1, r_ProdG2 g2, r_ProdG3 g3  
WHERE c.PCatID = r.PCatID AND g.PGrID = r.PGrID AND g1.PGrID1 = r.PGrID1 AND g2.PGrID2 = r.PGrID2 AND g3.PGrID3 = r.PGrID3 
ORDER BY c.PCatName, g.PGrName, g1.PGrName1, g2.PGrName2, g3.PGrName3, r.ProdName ', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1045, 1, N'Общие данные', 1, 1, N'SELECT m.ChID, m.DCardID, p.PersonName
FROM r_DCards m 
  LEFT JOIN r_PersonDC pd ON m.ChID = pd.DCardChID
  LEFT JOIN r_Persons p ON pd.PersonID = p.PersonID
', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1046, 1, N'Общие данные', 1, 1, N'SELECT m.ChID, m.DCardID, p.PersonName
FROM r_DCards m
  JOIN @Table@ d ON m.DCardID = d.DCardID    
  LEFT JOIN r_PersonDC pd ON pd.DCardChID = m.ChID  
  LEFT JOIN r_Persons p ON pd.PersonID = p.PersonID
WHERE d.@Field@ LIKE ''%@Value@%''
ORDER BY d.@Field@
', 3, N'tab_Main')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1068, 1, N'Расформирование временных должностей', 1, 1, N'SELECT * FROM p_PostStrucEDate ORDER BY EDate, OurID', 3, N'')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1081, 1, N'Cправочник признаков 1', 1, 1, N'SELECT CodeName1, CodeID1
FROM r_Codes1
WHERE @ValidCodeIDs1@(CodeID1)
ORDER BY CodeID1', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1082, 1, N'Cправочник признаков 2', 1, 1, N'SELECT CodeName2, CodeID2
FROM r_Codes2
WHERE @ValidCodeIDs2@(CodeID2)
ORDER BY CodeID2', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1083, 1, N'Cправочник признаков 3', 1, 1, N'SELECT CodeName3, CodeID3
FROM r_Codes3
WHERE @ValidCodeIDs3@(CodeID3)
ORDER BY CodeID3', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1084, 1, N'Cправочник признаков 4', 1, 1, N'SELECT CodeName4, CodeID4
FROM r_Codes4
WHERE @ValidCodeIDs4@(CodeID4)
ORDER BY CodeID4', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1085, 1, N'Cправочник признаков 5', 1, 1, N'SELECT CodeName5, CodeID5
FROM r_Codes5
WHERE @ValidCodeIDs5@(CodeID5)
ORDER BY CodeID5', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1086, 1, N'Справочник прайс-листов', 1, 1, N'SELECT PLName, PLID
FROM r_Pls
WHERE @ValidPLs@(PLID)
ORDER BY PLID', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1087, 1, N'Справочник складов: группы', 1, 1, N'SELECT StockGName, StockGID
FROM r_StockGs
WHERE @ValidStockGs@(StockGID)
ORDER BY StockGID', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1088, 1, N'Справочник предприятий: группы', 1, 1, N'SELECT CGrName, CGrID
FROM r_CompG
WHERE @ValidCGrIDs@(CGrID)
ORDER BY CGrID', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1089, 1, N'Справочник товаров: категории', 1, 1, N'SELECT PCatName, PCatID
FROM r_ProdC
WHERE @ValidPCats@(PCatID)
ORDER BY PCatName', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1090, 1, N'Справочник товаров: группы', 1, 1, N'SELECT PGrName, PGrID
FROM r_ProdG
WHERE @ValidPGrs@(PGrID)
ORDER BY PGrName', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1091, 1, N'Справочник товаров: 1 группа', 1, 1, N'SELECT PGrName1, PGrID1
FROM r_ProdG1
WHERE @ValidPGrs1@(PGrID1)
ORDER BY PGrName1', 3, N'tab_Comm')
INSERT INTO [dbo].[z_ToolPages] ([ToolCode], [PageIndex], [PageName], [PageStyle], [PageVisible], [SQLStr], [SQLType], [IntName]) VALUES (1092, 1, N'Справочник товаров', 1, 1, N'SELECT ProdName, ProdID
FROM r_Prods
WHERE (ProdID <> 0) AND @ValidProds@(ProdID)
ORDER BY ProdName', 3, N'tab_Comm')
