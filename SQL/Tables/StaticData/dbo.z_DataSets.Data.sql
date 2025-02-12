INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (1001001, 'Файлы', 1001, 1001181, 1, 'Общие данные', 1, 1, 'z_Files', 1, '', 'FileID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (1011001, 'Служебные данные: Бизнес: Заголовок', 1011, 1011001, 1, 'Заголовок', 0, 1, '', 1, '', 'ChID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (1011002, 'Служебные данные: Бизнес: Товар', 1011, 1011002, 2, 'Товар', 1, 1, 'SELECT * FROM (
SELECT d.*, p.ProdName, p.IsDecQty, p.PriceWithTax, 1 AS PosCount  FROM t_SaleTempD d, r_Prods p WITH(NOLOCK) WHERE p.ProdID = d.ProdID ) GMSView
ORDER BY  SrcPosID', 3, '', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID;', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (1257001, 'Реестр прихода на валютный счет', 1257, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 d.CodeID1,
 d.CodeID2,
 d.CodeID3,
 d.CodeID4,
 d.CodeID5,
 d.DocID,
 d.CompID,
  d.CompAccountAC,
 d.PChID,
 d.EmpID,
 c.CompName,
 c.City,
 d.Subject,
 m.AccountAC,
 m.CurrID,
 d.SumAC AS TSumAC,
 d.SumCC AS TSumCC,
 SumAC/KursMC AS TSumMC,
 d.CSumCC AS TCSumCC
FROM b_BARec AS m INNER JOIN (r_Comps AS c INNER JOIN b_BARecD AS d ON c.CompID = d.CompID) ON m.ChID = d.ChID) GMSView', 3, NULL, '', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (1258001, 'Реестр расхода с валютного счета', 1258, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 d.CodeID1,
 d.CodeID2,
 d.CodeID3,
 d.CodeID4,
 d.CodeID5,
 d.DocID,
 d.CompID,
  d.CompAccountAC,
 d.PChID,
 d.EmpID,
 c.CompName,
 c.City,
 d.Subject,
 m.AccountAC,
 m.CurrID,
 d.SumAC AS TSumAC,
 d.SumCC AS TSumCC,
 SumAC/KursMC AS TSumMC,
 d.CSumCC AS TCSumCC
FROM b_BAExp AS m INNER JOIN (r_Comps AS c INNER JOIN b_BAExpD AS d ON c.CompID = d.CompID) ON m.ChID = d.ChID) GMSView', 3, NULL, '', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (8001001, 'Договор: Общие данные', 8001, 8001001, 1, 'Общие данные', 0, 1, 'z_Contracts', 1, 'tab_Comm', 'DocID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 500, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (8001002, 'Договор: Список', 8001, 8001001, 2, 'Список', 1, 1, 'Договор: Общие данные', 5, '', 'DocID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (8010001, 'Изменение цен продажи', 8010, 8010002, 1, 'Общие данные', 1, 1, 'r_ProdMPChs', 2, 'tab_Comm', 'ChDate;ChTime;ProdID;PLID', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (8020001, 'Шаблоны процессов: Заголовок', 8020, 8020001, 1, 'Заголовок', 0, 1, 'r_DocShed', 1, '', 'DocShedCode', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (8020002, 'Шаблоны процессов: Детали', 8020, 8020002, 2, 'Детали', 1, 1, 'r_DocShedD', 1, '', 'DocShedCode;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'DocShedCode', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (8030001, 'Входящий счет на оплату', 8030, 8030001, 1, 'Общие данные', 1, 1, 'z_InAcc', 1, 'tab_Comm', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10010001, 'Справочник универсальный: типы', 10010, 10010001, 1, 'Типы', 1, 1, 'r_UniTypes', 1, '', 'RefTypeID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10010002, 'Справочник универсальный', 10010, 10010002, 2, 'Справочник', 1, 1, 'r_Uni', 1, '', 'RefTypeID;RefID', '', '', 0, 0, '< Главный Источник Документа >', 'RefTypeID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10089001, 'Справочник выплат/удержаний: категории', 10089, 10089001, 1, 'Общие данные', 1, 1, 'r_PayTypeCats', 1, 'tab_Comm', 'PayTypeCatID', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10090001, 'Справочник выплат/удержаний', 10090, 10090001, 1, 'Общие данные', 1, 1, 'r_PayTypes', 1, '', 'PayTypeID', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10091001, 'Справочник льгот', 10091, 10091001, 1, 'Общие данные', 1, 1, 'r_Prevs', 1, 'tab_Comm', 'PrevID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10092001, 'Справочник должностей: категории: Список', 10092, 10092001, 1, 'Список', 1, 1, 'r_PostC', 1, 'tab_Comm', 'PostCID', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10093001, 'Справочник должностей: Заголовок', 10093, 10092001, 1, 'Заголовок', 0, 1, 'r_PostC', 1, '', 'PostCID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10093002, 'Справочник должностей: Должности', 10093, 10093001, 2, 'Должности', 0, 1, 'r_Posts', 1, '', 'PostID;PostCID;', '', '', 0, 0, '< Главный Источник Документа >', 'PostCID;', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10093003, 'Справочник должностей: Разряды', 10093, 10093002, 3, 'Разряды', 0, 1, 'r_PostMC', 1, '', 'PostID;EmpClass;', '', '', 0, 0, 'Справочник должностей: Должности', 'PostID;', 0, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10094001, 'Справочник работ: типы недели', 10094, 10094001, 1, 'Список', 1, 1, 'r_WWeeks', 1, 'tab_Comm', 'WWeekTypeID', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10095001, 'Справочник работ: графики: Заголовок', 10095, 10095001, 1, 'Заголовок', 0, 1, 'r_Sheds', 1, '', 'ShedID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10095002, 'Справочник работ: графики: Дни графика', 10095, 10095002, 2, 'Дни графика', 0, 1, 'r_ShedMD', 1, '', 'ShedID;DayPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ShedID;', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10095003, 'Справочник работ: графики: Смены графика', 10095, 10095003, 3, 'Смены графика', 0, 1, 'r_ShedMS', 1, '', 'ShedID;DayPosID;ShiftID;', '', '', 0, 0, 'Справочник работ: графики: Дни графика', 'DayPosID;ShedID;', 0, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10096001, 'Справочник работ: подразделения', 10096, 10096001, 1, 'Список', 1, 1, 'r_Subs', 1, 'tab_Comm', 'SubID', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10101001, 'Справочник банков', 10101, 10101001, 1, 'Общие данные', 1, 1, 'r_Banks', 1, 'tab_Comm', 'BankID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10102001, 'Справочник банков: группы', 10102, 10102001, 1, 'Общие данные', 1, 1, 'r_BankGrs', 1, 'tab_Comm', 'BankGrID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10103001, 'Справочник банковских услуг', 10103, 10103001, 1, 'Общие данные', 3, 1, 'r_BServs', 1, '', 'BServID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 450, 190, 3, 30, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10103002, 'Справочник банковских услуг: параметры', 10103, 10103002, 2, 'Параметры', 1, 1, 'r_BServParams', 1, '', 'BServID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'BServID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10103003, 'Справочник банковских услуг: товары', 10103, 10103003, 3, 'Товары', 1, 1, 'r_BServProds', 2, '', 'BServID;SrcPosID', '', '', 0, 0, 'Справочник банковских услуг: параметры', 'BServID;SrcPosID', 1, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10105001, 'Справочник валют: Общие данные', 10105, 10105001, 1, 'Общие данные', 0, 1, 'r_Currs', 1, '', 'CurrID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10105002, 'Справочник валют: История', 10105, 10105102, 2, 'История курса валют', 1, 1, 'r_CurrH', 1, '', 'CurrID;DocDate', '', '', 0, 0, '< Главный Источник Документа >', 'CurrID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10105003, 'Справочник валют: купюры', 10105, 10105002, 3, 'Купюры', 1, 1, 'r_CurrD', 1, '', 'CurrID', '', '', 0, 0, '< Главный Источник Документа >', 'CurrID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10110001, 'Справочник внутренних фирм: Общие данные', 10110, 10110001, 1, 'Общие данные', 0, 1, 'r_Ours', 1, '', 'OurID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10115001, 'Справочник отделов', 10115, 10115001, 1, 'Общие данные', 1, 1, 'r_Deps', 1, 'tab_Comm', 'DepID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10120001, 'Справочник служащих: Заголовок', 10120, 10120001, 1, 'Заголовок', 3, 1, 'r_Emps', 1, '', 'EmpID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 500, 155, 2, 40, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10120002, 'Справочник служащих: Список', 10120, 10120001, 2, 'Список', 1, 1, 'Справочник служащих: Заголовок', 5, 'tab_List', 'EmpID', '', '', 0, 0, '< Нет Master-Источника >', NULL, 0, 0, 0, 1, 500, 155, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10120003, 'Справочник служащих: Общие данные', 10120, 10120001, 3, 'Общие данные', 0, 1, 'Справочник служащих: Заголовок', 5, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', NULL, 0, 0, 0, 1, 500, 155, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10120004, 'Справочник служащих: Дополнительно', 10120, 10120001, 4, 'Дополнительно', 0, 1, 'Справочник служащих: Заголовок', 5, 'tab_More', '', '', '', 0, 0, '< Нет Master-Источника >', NULL, 0, 0, 0, 1, 500, 155, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10120005, 'Справочник служащих: Дополнительно2', 10120, 10120001, 5, 'Дополнительно2', 3, 1, 'Справочник служащих: Заголовок', 5, '', '', '', '', 0, 0, '< Нет Master-Источника >', NULL, 0, 0, 0, 1, 500, 155, 0, 40, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10120006, 'Справочник служащих: Контакты', 10120, 10120005, 6, 'Контакты', 1, 1, 'r_EmpAdd', 1, 'tab_Contact', 'EmpID;', '', '', 0, 0, '< Главный Источник Документа >', 'EmpID', 0, 0, 0, 1, 500, 155, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10120007, 'Справочник служащих: Семейное положение', 10120, 10120006, 7, 'Семейное положение', 1, 1, 'r_EmpKin', 1, 'tab_Kin', 'EmpID;', '', '', 0, 0, '< Главный Источник Документа >', 'EmpID', 0, 0, 0, 1, 500, 155, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10120008, 'Справочник служащих: Трудовая деятельность', 10120, 10120004, 8, 'Трудовая деятельность', 1, 1, 'r_EmpAct', 1, 'tab_Act', 'EmpID;', '', '', 0, 0, '< Главный Источник Документа >', 'EmpID', 0, 0, 0, 1, 500, 155, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10120009, 'Справочник служащих: Фирмы', 10120, 10120002, 9, 'Фирмы', 1, 1, 'r_EmpMO', 1, 'tab_Ours', 'EmpID;', '', '', 0, 0, '< Главный Источник Документа >', 'EmpID', 0, 0, 0, 1, 500, 155, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10120010, 'Справочник служащих: Льготы', 10120, 10120003, 10, 'Льготы', 1, 1, 'r_EmpMP', 1, 'tab_Priv', 'EmpID;', '', '', 0, 0, '< Главный Источник Документа >', 'EmpID', 0, 0, 0, 1, 500, 155, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10120011, 'Справочник служащих: Воинский учет', 10120, 10120001, 11, 'Воинский учет', 0, 1, 'Справочник служащих: Заголовок', 5, 'tab_Mil', '', '', '', 0, 0, '< Нет Master-Источника >', NULL, 0, 0, 0, 1, 500, 155, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10120012, 'Справочник служащих: Изменение ФИО', 10120, 10120010, 12, 'Изменение ФИО', 1, 1, 'r_EmpNames', 1, 'tab_EmpNames', 'EmpID;OurID;ChDate', '', '', 0, 0, '< Главный Источник Документа >', 'EmpID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10120013, 'Справочник служащих: Кадровое состояние', 10120, 0, 13, 'Кадровое состояние', 1, 1, 'SELECT * FROM(
SELECT  m.OurID, m.EmpID, m.BDate, SubID, DepID, PostID, EmpClass, WorkCond, ShedID, SalaryType, SalaryForm, SalaryMethod, BSalary, BSalaryPrc, AdvSum, PensMethod, SalaryQty, GEmpType, Joint, TimeNormType, IndexBaseMonth, LeavDays, LeavDaysExtra
FROM    r_EmpMPst m,
        (SELECT OurID, EmpID, MAX(BDate) BDate FROM r_EmpMPst WHERE EmpID = :EmpID AND IsDisDoc = 0 AND BDate <= dbo.zf_GetDate(GETDATE()) GROUP BY OurID, EmpID) t1
WHERE   m.OurID = t1.OurID AND m.EmpID = t1.EmpID AND m.BDate = t1.BDate
        AND dbo.zf_GetDate(GETDATE()) BETWEEN m.BDate AND m.EDate) GMSView', 3, 'tab_EmpMPst', 'OurID;EmpID', '', '', 0, 0, '< Главный Источник Документа >', 'EmpID', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10120014, 'Справочник служащих: Документы', 10120, 10120011, 14, 'Документы', 1, 1, 'r_EmpFiles', 1, 'tab_EmpFiles', 'EmpID', '', '', 0, 0, '< Главный Источник Документа >', 'EmpID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10125001, 'Справочник пользователей: Общие данные', 10125, 10125001, 1, 'Общие данные', 0, 1, 'r_Users', 1, '', 'UserID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10130001, 'Справочник компьютеров', 10130, 10130001, 1, 'Общие данные', 1, 1, 'r_PCs', 1, 'tab_Comm', 'PCCode', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10151001, 'Справочник признаков 1', 10151, 10151001, 1, 'Общие данные', 1, 1, 'r_Codes1', 1, 'tab_Comm', 'CodeID1', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10152001, 'Справочник признаков 2', 10152, 10152001, 1, 'Общие данные', 1, 1, 'r_Codes2', 1, 'tab_Comm', 'CodeID2', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10153001, 'Справочник признаков 3', 10153, 10153001, 1, 'Общие данные', 1, 1, 'r_Codes3', 1, 'tab_Comm', 'CodeID3', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10154001, 'Справочник признаков 4', 10154, 10154001, 1, 'Общие данные', 1, 1, 'r_Codes4', 1, 'tab_Comm', 'CodeID4', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10155001, 'Справочник признаков 5', 10155, 10155001, 1, 'Общие данные', 1, 1, 'r_Codes5', 1, 'tab_Comm', 'CodeID5', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10170001, 'Справочник прайс-листов: Общие данные', 10170, 10170001, 1, 'Общие данные', 0, 1, 'r_PLs', 1, '', 'PLID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10170002, 'Справочник прайс-листов: Товары', 10170, 10350005, 2, 'Список товаров', 1, 1, 'r_ProdMP', 1, '', 'PLID;ProdID', '', '', 0, 0, '< Главный Источник Документа >', 'PLID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10180001, 'Справочник затрат', 10180, 10180001, 1, 'Общие данные', 1, 1, 'r_Spends', 1, 'tab_Comm', 'SpendCode', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10190001, 'Справочник статусов: Заголовок', 10190, 10190001, 1, 'Заголовок', 1, 1, 'r_States', 1, '', 'StateCode', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 500, 160, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10190002, 'Справочник статусов: Со статуса', 10190, 10190002, 2, 'Со статуса', 1, 1, 'r_StateRules', 1, '', 'StateCodeFrom', '', '', 0, 0, '< Главный Источник Документа >', 'StateCode', 0, 0, 0, 1, 500, 160, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10190003, 'Справочник статусов: Со статуса(Пользователи)', 10190, 10190003, 3, 'Со статуса(Пользователи)', 1, 1, 'r_StateRuleUsers', 1, '', 'StateRuleCode', '', '', 0, 0, 'Справочник статусов: Со статуса', 'StateRuleCode', 0, 0, 0, 2, 500, 160, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10190004, 'Справочник статусов: На статус', 10190, 10190002, 4, 'На статус', 1, 1, 'r_StateRules', 1, '', '', '', '', 0, 0, '< Главный Источник Документа >', 'StateCode', 0, 0, 0, 1, 500, 160, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10190005, 'Справочник статусов: На статус (Пользователи)', 10190, 10190003, 5, 'На статус (Пользователи)', 1, 1, 'r_StateRuleUsers', 1, '', 'StateRuleCode', '', '', 0, 0, 'Справочник статусов: На статус', 'StateRuleCode', 0, 0, 0, 2, 500, 160, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10190006, 'Справочник статусов: Документы', 10190, 10190004, 6, 'Документы', 1, 1, 'r_StateDocs', 1, '', '', '', '', 0, 0, '< Главный Источник Документа >', 'StateCode', 0, 0, 0, 1, 500, 160, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10190007, 'Справочник статусов: Пользователи', 10190, 10190005, 7, 'Пользователи', 1, 1, 'r_StateDocsChange', 1, '', '', '', '', 0, 0, '< Главный Источник Документа >', 'StateCode', 0, 0, 0, 1, 500, 160, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10195001, 'Справочник предприятий: 1 группа', 10195, 10195001, 1, 'Общие данные', 1, 1, 'r_CompGrs1', 1, 'tab_Comm', 'CompGrID1', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10196001, 'Справочник предприятий: 2 группа', 10196, 10196001, 1, 'Общие данные', 1, 1, 'r_CompGrs2', 1, 'tab_Comm', 'CompGrID2', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10197001, 'Справочник предприятий: 3 группа', 10197, 10197001, 1, 'Общие данные', 1, 1, 'r_CompGrs3', 1, 'tab_Comm', 'CompGrID3', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10198001, 'Справочник предприятий: 4 группа', 10198, 10198001, 1, 'Общие данные', 1, 1, 'r_CompGrs4', 1, 'tab_Comm', 'CompGrID4', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10199001, 'Справочник предприятий: 5 группа', 10199, 10199001, 1, 'Общие данные', 1, 1, 'r_CompGrs5', 1, 'tab_Comm', 'CompGrID5', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10200001, 'Справочник предприятий: группы', 10200, 10200001, 1, 'Общие данные', 1, 1, 'r_CompG', 1, 'tab_Comm', 'CGrID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10250001, 'Справочник предприятий: Общие данные', 10250, 10250001, 3, 'Общие данные', 0, 1, '< Главный Источник Документа >', 5, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 500, 160, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10250002, 'Справочник предприятий: Список', 10250, 10250001, 2, 'Список', 1, 1, '< Главный Источник Документа >', 5, 'tab_List', 'CompID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 500, 160, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10250003, 'Справочник предприятий: Контакты', 10250, 10350001, 4, 'Контакты', 0, 1, '< Главный Источник Документа >', 5, 'tab_Contacts', '', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 500, 160, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10250004, 'Справочник предприятий: Группы предприятий', 10250, 10250002, 6, 'Группы', 1, 1, 'r_CompMG', 1, '', 'CompID;CGrID', '', '', 0, 0, '< Главный Источник Документа >', 'CompID', 0, 0, 0, 1, 500, 160, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10250005, 'Справочник предприятий: Классификация', 10250, 10250001, 5, 'Классификация', 3, 1, '< Главный Источник Документа >', 5, '', '', '', '', 0, 0, '< Нет Master-Источника >', NULL, 0, 0, 0, 1, 500, 160, 0, 40, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10250006, 'Справочник предприятий: Расчетные счета', 10250, 10250004, 7, 'Расчетные счета', 1, 1, 'r_CompsCC', 1, 'tab_BankCC', 'CompID;', '', '', 0, 0, '< Главный Источник Документа >', 'CompID', 0, 0, 0, 1, 500, 160, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10250007, 'Справочник предприятий: Валютные счета', 10250, 10250003, 8, 'Валютные счета', 1, 1, 'r_CompsAC', 1, 'tab_BankMC', 'CompID;', '', '', 0, 0, '< Главный Источник Документа >', 'CompID', 0, 0, 0, 1, 500, 160, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10250009, 'Справочник предприятий: Дополнительно', 10250, 10250001, 10, 'Дополнительно', 0, 1, '< Главный Источник Документа >', 5, 'tab_Templates', '', '', '', 0, 0, '< Нет Master-Источника >', NULL, 0, 0, 0, 1, 500, 160, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10250010, 'Справочник предприятий: Документы', 10250, 10250001, 11, 'Документы', 0, 1, '< Главный Источник Документа >', 5, 'tab_Docs', '', '', '', 0, 0, '< Нет Master-Источника >', NULL, 0, 0, 0, 1, 500, 160, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10250011, 'Справочник предприятий: Адреса доставки', 10250, 10250005, 12, 'Адреса доставки', 1, 1, 'r_CompsAdd', 1, 'tab_Addresses', 'CompID', '', '', 0, 0, '< Главный Источник Документа >', 'CompID', 0, 0, 0, 1, 500, 160, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10250013, 'Справочник предприятий: Значения', 10250, 10250006, 14, 'Значения', 1, 1, 'r_CompValues', 1, 'tab_CompValues', 'CompID;', '', '', 0, 0, '< Главный Источник Документа >', 'CompID', 0, 0, 0, 1, 500, 160, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10250014, 'Справочник предприятий: Заголовок', 10250, 10250001, 1, 'Заголовок', 3, 1, 'r_Comps', 1, '', 'CompID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 500, 160, 2, 40, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10300001, 'Справочник складов: группы', 10300, 10300001, 1, 'Общие данные', 1, 1, 'r_StockGs', 1, 'tab_Comm', 'StockGID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10310001, 'Справочник складов: Список', 10310, 10310001, 2, 'Список', 1, 1, '< Главный Источник Документа >', 5, '', 'StockID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10310002, 'Справочник складов: Заголовок', 10310, 10310001, 1, 'Заголовок', 3, 1, 'r_Stocks', 1, '', 'StockID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 600, 120, 2, 40, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10310003, 'Справочник складов: Общие данные', 10310, 10310001, 3, 'Общие данные', 3, 1, '< Главный Источник Документа >', 5, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 600, 120, 2, 40, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10310004, 'Справочник складов: Товары для ЭККА', 10310, 10310002, 4, 'Товары для ЭККА', 1, 1, 'r_StockCRProds', 1, '', 'StockID;CRProdID', '', '', 0, 0, '< Главный Источник Документа >', 'StockID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10310005, 'Справочник складов: Отделы', 10310, 10310003, 5, 'Отделы', 1, 1, 'r_StockSubs', 1, '', 'StockID;DepID', '', '', 0, 0, '< Главный Источник Документа >', 'StockID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10320001, 'Справочник секций', 10320, 10320001, 1, 'Общие данные', 1, 1, 'r_Secs', 1, 'tab_Comm', 'SecID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10331001, 'Справочник товаров: категории', 10331, 10331001, 1, 'Общие данные', 1, 1, 'r_ProdC', 1, 'tab_Comm', 'PCatID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10332001, 'Справочник товаров: группы', 10332, 10332001, 1, 'Общие данные', 1, 1, 'r_ProdG', 1, 'tab_Comm', 'PGrID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10333001, 'Справочник товаров: 1 группа', 10333, 10333001, 1, 'Общие данные', 1, 1, 'r_ProdG1', 1, 'tab_Comm', 'PGrID1', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10334001, 'Справочник товаров: 2 группа', 10334, 10334001, 1, 'Общие данные', 1, 1, 'r_ProdG2', 1, 'tab_Comm', 'PGrID2', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10335001, 'Справочник товаров: 3 группа', 10335, 10335001, 1, 'Общие данные', 1, 1, 'r_ProdG3', 1, 'tab_Comm', 'PGrID3', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10340001, 'Справочник товаров: группа альтернатив', 10340, 10340001, 1, 'Общие данные', 1, 1, 'r_ProdA', 1, 'tab_Comm', 'PGrAID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10345001, 'Справочник товаров: группа бухгалтерии', 10345, 10345001, 1, 'Общие данные', 1, 1, 'r_ProdBG', 1, 'tab_Comm', 'PBGrID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10347001, 'Справочник товаров: весовые префиксы', 10347, 10347001, 1, 'Общие данные', 1, 1, 'r_WPrefs', 1, 'tab_Comm', 'WPref', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350001, 'Справочник товаров: Общие данные', 10350, 10350001, 3, 'Общие данные', 0, 1, '< Главный Источник Документа >', 5, 'tab_Comm', 'ProdID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350002, 'Справочник товаров: Список', 10350, 10350001, 2, 'Список', 1, 1, '< Главный Источник Документа >', 5, 'tab_List', 'ProdID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350003, 'Справочник товаров: Классификация', 10350, 10350001, 4, 'Классификация', 0, 1, '< Главный Источник Документа >', 5, 'tab_PClass', 'ProdID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350004, 'Справочник товаров: Виды упаковок', 10350, 10350004, 5, 'Виды упаковок', 1, 1, 'r_ProdMQ', 1, 'tab_MQ', 'ProdID;Qty;BarCode;UM;', '', '', 0, 0, '< Главный Источник Документа >', 'ProdID', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350005, 'Справочник товаров: Партии', 10350, 10350003, 6, 'Партии', 1, 1, 't_PInP', 1, 'tab_M_PP', 'ProdID;PPID;', '', '', 0, 0, '< Главный Источник Документа >', 'ProdID', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350006, 'Справочник товаров: Цены продажи', 10350, 10350005, 7, 'Цены продажи', 1, 1, 'r_ProdMP', 1, 'tab_M_PL', 'ProdID;PLID;', '', '', 0, 0, '< Главный Источник Документа >', 'ProdID', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350007, 'Справочник товаров: Автоизменение цен', 10350, 10350009, 8, 'Автоизменение цен', 1, 1, 'r_ProdAC', 1, 'tab_AutoCh', 'ProdID;PLID;ChPLID;', '', '', 0, 0, '< Главный Источник Документа >', 'ProdID', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350008, 'Справочник товаров: Цены', 10350, 10350001, 9, 'Цены', 0, 1, '< Главный Источник Документа >', 5, 'tab_Prices', 'ProdID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350009, 'Справочник товаров: Нормы', 10350, 10350001, 10, 'Нормы', 0, 1, '< Главный Источник Документа >', 5, 'tab_Norms', 'ProdID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350010, 'Справочник товаров: Дополнительно', 10350, 10350001, 11, 'Дополнительно', 0, 1, '< Главный Источник Документа >', 5, 'tab_More1', 'ProdID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350011, 'Справочник товаров: Альтернативы', 10350, 10350006, 12, 'Альтернативы', 1, 1, 'r_ProdMA', 1, 'tab_Alts', 'ProdID;AProdID', '', '', 0, 0, '< Главный Источник Документа >', 'ProdID', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350012, 'Справочник товаров: Внешние коды', 10350, 10350010, 13, 'Внешние коды', 1, 1, 'r_ProdEC', 1, 'tab_ProdEC', 'ProdID;CompID;ExtProdID;', '', '', 0, 0, '< Главный Источник Документа >', 'ProdID', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350013, 'Справочник товаров: Значения периодов', 10350, 10350011, 14, 'Значения периодов', 1, 1, 'r_ProdCV', 1, 'tab_Values', 'ProdID;CompID;BDate;', '', '', 0, 0, '< Главный Источник Документа >', 'ProdID', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350014, 'Справочник товаров: Сертификаты', 10350, 10350001, 15, 'Сертификаты', 0, 1, '< Главный Источник Документа >', 5, 'tab_Crts', 'ProdID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350015, 'Справочник товаров: Комплекты', 10350, 10350001, 16, 'Комплекты', 0, 1, '< Главный Источник Документа >', 5, 'tab_Sets', 'ProdID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350016, 'Справочник товаров: Значения', 10350, 10350017, 17, 'Значения', 1, 1, 'r_ProdValues', 1, 'tab_ProdValues', 'ProdID;VarName;', '', '', 0, 0, '< Главный Источник Документа >', 'ProdID', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350017, 'Справочник товаров: Заголовок', 10350, 10350001, 1, 'Заголовок', 3, 1, 'r_Prods', 1, '', 'ProdID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 700, 200, 2, 40, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350018, 'Справочник товаров: изображения', 10350, 10350018, 18, 'Изображения', 1, 1, 'r_ProdImages', 1, 'tab_Images', 'ProdID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ProdID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350019, 'Справочник товаров: Cборы', 10350, 10350019, 19, 'Cборы', 1, 1, 'r_ProdLV', 1, '', 'ProdID;LevyID', '', '', 0, 0, '< Главный Источник Документа >', 'ProdID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350020, 'Справочник товаров: банковские услуги', 10350, 10350020, 20, 'Банковские услуги', 1, 1, 'r_ProdBServs', 2, '', 'ProdID;BServID', '', '', 0, 0, '< Главный Источник Документа >', 'ProdID', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10350021, 'Справочник товаров: Виды операций и потери', 10350, 10350021, 21, 'Виды операций', 1, 1, 'r_ProdOpers', 1, '', 'ProdID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ProdID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10355001, 'Справочник товаров: маркировки', 10355, 10355001, 1, 'Общие данные', 1, 1, 'r_ProdMarks', 1, 'tab_Comm', 'MarkCode;ProdID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10391001, 'Справочник дисконтных карт: группы типов', 10391, 10391001, 1, 'Общие данные', 1, 1, 'r_DCTypeG', 1, 'tab_Comm', 'DCTypeGCode', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10392001, 'Справочник дисконтных карт: Типы: Общие данные', 10392, 10392001, 1, 'Общие данные', 1, 1, 'r_DCTypes', 1, 'Список', 'DCTypeCode', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10392002, 'Справочник дисконтных карт: Типы: Товары', 10392, 10392002, 2, 'Товары', 1, 1, 'r_DCTypeP', 1, '', 'DCTypeCode;ProdID', '', '', 0, 0, '< Главный Источник Документа >', 'DCTypeCode', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10400001, 'Справочник дисконтных карт: Заголовок', 10400, 10400001, 1, 'Заголовок', 3, 1, 'r_DCards', 1, '', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 300, 100, 2, 40, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10400002, 'Справочник дисконтных карт: Общие данные', 10400, 0, 3, 'Общие данные', 3, 1, '< Главный Источник Документа >', 5, 'tab_Comm', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 300, 100, 0, 40, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10400003, 'Справочник дисконтных карт: Начисления', 10400, 1001045, 4, 'Начисления', 1, 1, 'z_LogDiscRec', 1, '', 'DCardChID;LogID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10400004, 'Справочник дисконтных карт: Списания', 10400, 1001046, 5, 'Списания', 1, 1, 'z_LogDiscExp', 1, '', 'DCardChID;LogID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10400009, 'Справочник дисконтных карт: Список', 10400, 10400001, 2, 'Список', 1, 1, '< Главный Источник Документа >', 5, '', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10420001, 'Справочник весов: группы: Список', 10420, 10420001, 1, 'Список', 1, 1, 'r_ScaleGrs', 1, '', 'ScaleGrID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10420002, 'Справочник весов: группы: Префиксы', 10420, 10420002, 2, 'Префиксы', 1, 1, 'r_ScaleGrMW', 1, '', 'ScaleGrID;WPref', '', '', 0, 0, '< Главный Источник Документа >', 'ScaleGrID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10420003, 'Справочник весов: группы: Весы', 10420, 10421001, 3, 'Весы', 1, 1, 'r_Scales', 1, '', 'ScaleGrID;ScaleID', '', '', 0, 0, '< Главный Источник Документа >', 'ScaleGrID', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10421001, 'Справочник весов: Заголовок', 10421, 10421001, 1, 'Заголовок', 3, 1, 'r_Scales', 1, '', 'ScaleID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 600, 160, 2, 40, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10421002, 'Справочник весов: Список', 10421, 10421001, 2, 'Список', 1, 1, '< Главный Источник Документа >', 5, '', 'ScaleID', '', '', 0, 0, '< Главный Источник Документа >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10421003, 'Справочник весов: Общие данные', 10421, 10421001, 3, 'Общие данные', 3, 1, '< Главный Источник Документа >', 5, 'tab_Comm', 'ScaleID', '', '', 0, 0, '< Главный Источник Документа >', '', 0, 0, 0, 1, 600, 160, 2, 40, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10422001, 'Справочник весов: конфигурации: Заголовок', 10422, 10422001, 1, 'Заголовок', 3, 1, 'r_ScaleDefs', 1, '', 'ScaleDefID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 400, 160, 2, 160, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10422002, 'Справочник весов: конфигурации: Список', 10422, 10422001, 2, 'Список', 1, 1, '< Главный Источник Документа >', 5, '', 'ScaleDefID', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10422003, 'Справочник весов: конфигурации: Общие данные', 10422, 10422001, 3, 'Общие данные', 3, 1, '< Главный Источник Документа >', 5, 'tab_Comm', 'ScaleDefID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 400, 160, 0, 160, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10422004, 'Справочник весов: конфигурации: Раскладки', 10422, 10422002, 4, 'Раскладки', 1, 1, 'r_ScaleDefKeys', 1, '', 'ScaleDefID;ScaleKey', '', '', 0, 0, '< Главный Источник Документа >', 'ScaleDefID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10440001, 'Справочник форм оплаты', 10440, 10440001, 1, 'Общие данные', 1, 1, 'r_PayForms', 1, '', 'PayFormCode', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10440002, 'Справочник форм оплаты - Параметры РРО', 10440, 10440002, 2, 'Параметры РРО', 1, 1, 'r_PayFormCR', 1, '', 'PayFormCode;CashType;CRPayFormCode', '', '', 0, 0, '< Главный Источник Документа >', 'PayFormCode', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10451001, 'Справочник торговых серверов', 10451, 10451001, 1, 'серверы', 0, 1, 'r_CRSrvs', 1, '', 'SrvID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10451002, 'Справочник торговых серверов: Общие данные', 10451, 10452001, 2, 'Справочник ЭККА', 1, 1, 'r_Crs', 1, '', 'SrvID;CRID', '', '', 0, 0, '< Главный Источник Документа >', 'SrvID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10451003, 'Справочник торговых серверов: Весы', 10451, 10421001, 3, 'Весы', 1, 1, 'r_Scales', 1, '', 'SrvID;ScaleID', '', '', 0, 0, '< Главный Источник Документа >', 'SrvID', 0, 0, 0, 1, 0, 0, 0, 40, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10452001, 'Справочник ЭККА: Общие данные', 10452, 10452001, 1, 'Общие данные', 0, 1, 'r_Crs', 1, '', 'CRID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10452002, 'Справочник ЭККА - Операторы', 10452, 10454002, 2, 'Справочник ЭККА - Операторы', 1, 1, 'r_OperCRs', 1, '', 'CRID;OperID', '', '', 0, 0, '< Главный Источник Документа >', 'CRID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10452003, 'Справочник ЭККА - Товары', 10452, 10452002, 3, 'Справочник ЭККА - Товары', 1, 1, 'r_CRMP', 1, '', 'CRID;CRProdID', '', '', 0, 0, '< Главный Источник Документа >', 'CRID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10454001, 'Справочник ЭККА: операторы', 10454, 10454001, 1, 'операторы', 0, 1, 'r_Opers', 1, '', 'OperID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10456001, 'Справочник ЭККА: единый ввод', 10456, 10456001, 1, 'Общие данные', 1, 1, 'r_CRUniInput', 1, 'tab_Comm', 'UniInputCode', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10457001, 'Справочник платежных терминалов', 10457, 10457001, 1, 'Общие данные', 1, 1, 'r_POSPays', 1, 'tab_Comm', 'POSPayID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10459001, 'Справочник процессинговых центров', 10459, 10459001, 1, 'Список', 1, 1, 'r_Processings', 1, 'tab_Comm', 'ProcessingID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10550001, 'Справочник рабочих мест', 10550, 10550001, 1, 'Список', 1, 1, 'r_WPs', 1, 'Список', 'WPID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10550002, 'Рабочие места: внешние дисплеи', 10550, 10550002, 2, 'Внешние дисплеи', 1, 1, 'r_Displays', 1, '', 'DisplayID;WPID', '', '', 0, 0, '< Главный Источник Документа >', 'WPID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10550003, 'Справочник рабочих мест: Платежные терминалы', 10550, 10550003, 3, 'Платежные терминалы', 1, 1, 'r_CRPOSPays', 1, '', 'POSPayID', '', '', 0, 0, '< Главный Источник Документа >', 'WPID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10551001, 'Справочник рабочих мест: роли', 10551, 10551001, 1, 'Список', 1, 1, 'r_WPRoles', 1, 'Список', 'WPRoleID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10600001, 'Справочник ресторана: столики: группы', 10600, 10600001, 1, 'Общие данные', 1, 1, 'r_DeskG', 1, 'tab_Comm', 'DeskGCode', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10601001, 'Справочник ресторана: столики', 10601, 10601001, 1, 'Общие данные', 1, 1, 'r_Desks', 1, 'tab_Comm', 'DeskCode', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10605001, 'Справочник ресторана: модификаторы блюд', 10605, 10605001, 1, 'Общие данные', 1, 1, 'r_Mods', 1, 'tab_Comm', 'ModCode', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10606001, 'Справочник ресторана: мониторы заказов', 10606, 10606001, 1, 'Список', 1, 1, 'r_OrderMonitors', 1, 'tab_Comm', 'OrderMonitorID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10610001, 'Справочник меню', 10610, 10610001, 1, 'Список', 1, 1, 'r_Menu', 1, 'Список', 'MenuID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10610002, 'Справочник меню - товары', 10610, 10610002, 2, 'Товары', 1, 1, 'r_MenuP', 1, '', 'MenuID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'MenuID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10610003, 'Справочник меню - подменю', 10610, 10610003, 3, 'Подменю', 1, 1, 'r_MenuM', 1, '', 'MenuID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'MenuID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10701001, 'Справочник основных средств: группы', 10701, 10701001, 1, 'Общие данные', 1, 1, 'r_AssetG1', 1, 'tab_Comm', 'AGrID1', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10702001, 'Справочник основных средств: категории', 10702, 10702001, 1, 'Общие данные', 1, 1, 'r_AssetC', 1, 'tab_Comm', 'ACatID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10703001, 'Справочник основных средств: подгруппы', 10703, 10703001, 1, 'Общие данные', 1, 1, 'r_AssetG', 1, '', 'AGrID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10703002, 'Справочник основных средств: подгруппы: Ставки амортизации', 10703, 10703002, 2, 'Ставки', 1, 1, 'r_AssetGDeps', 1, '', 'AGrID;DocDate', '', '', 0, 0, '< Главный Источник Документа >', 'AGrID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10704001, 'Справочник основных средств: Список', 10704, 10704001, 2, 'Список', 1, 1, '< Главный Источник Документа >', 5, 'TabSheet1', 'AssID;', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10704002, 'Справочник основных средств: Общие данные', 10704, 10704001, 3, 'Общие данные', 0, 1, '< Главный Источник Документа >', 5, 'tab_Main', 'AssID;', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10704003, 'Справочник основных средств: Дополнительно', 10704, 10704001, 4, 'Дополнительно', 0, 1, '< Главный Источник Документа >', 5, 'tab_More', 'AssID;', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10704004, 'Справочник основных средств: Заголовок', 10704, 10704001, 1, 'Заголовок', 3, 1, 'r_Assets', 1, '', 'AssID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 560, 130, 2, 40, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10704005, 'Справочник основных средств: История', 10704, 10704002, 5, 'История', 1, 0, 'r_AssetH', 1, '', 'AssID;BDate', '', '', 0, 0, '< Главный Источник Документа >', 'AssID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10705001, 'Справочник проводок: категории', 10705, 10705001, 1, 'Общие данные', 1, 1, 'r_GOperC', 1, 'tab_Comm', 'GOperCID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10706001, 'Справочник проводок: виды аналитики', 10706, 10706001, 1, 'Общие данные', 1, 1, 'r_GVols', 1, 'tab_Comm', 'GVolID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10708001, 'Справочник проводок: Заголовок', 10708, 10708001, 1, 'Заголовок', 0, 1, 'r_GOpers', 1, '', 'GOperID;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10708002, 'Справочник проводок: Проводки', 10708, 10708002, 2, 'Проводки', 0, 1, 'r_GOperD', 1, '', 'GOperID;SrcPosID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10714001, 'Справочник транспорта: категории', 10714, 10714001, 1, 'Общие данные', 1, 1, 'r_CarrsC', 1, 'tab_Comm', 'CarrCID', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10715001, 'Справочник транспорта: Список', 10715, 10715001, 2, 'Список', 1, 1, '< Главный Источник Документа >', 5, 'TabSheet1', 'CarrID;', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10715002, 'Справочник транспорта: Общие данные', 10715, 10715001, 3, 'Общие данные', 0, 1, '< Главный Источник Документа >', 5, 'tab_Carrs', 'CarrID;', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10715003, 'Справочник транспорта: Дополнительно', 10715, 10715001, 4, 'Дополнительно', 0, 1, '< Главный Источник Документа >', 5, 'tab_More', 'CarrID;', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10715004, 'Справочник транспорта: Заголовок', 10715, 10715001, 1, 'Заголовок', 3, 1, 'r_Carrs', 1, '', 'CarrID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 585, 220, 2, 40, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10716001, 'Справочник работ: виды', 10716, 10716001, 1, 'Список', 1, 1, 'r_WrkTypes', 1, 'tab_Comm', 'WrkID', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10717001, 'Справочник работ: обозначения времени', 10717, 10717001, 1, 'Общие данные', 1, 1, 'r_WTSigns', 1, 'tab_Comm', 'WTSignID', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10719001, 'Справочник работ: нормы времени: Заголовок', 10719, 10719001, 1, 'Заголовок', 0, 1, 'r_Norms', 1, '', 'YearID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10719002, 'Справочник работ: нормы времени: Количество рабочих часов', 10719, 10719002, 2, 'Количество рабочих часов', 1, 1, 'r_NormMH', 1, 'Количество рабочих часов', 'YearID;WWeekTypeID', '', '', 0, 0, '< Главный Источник Документа >', 'YearID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10719003, 'Справочник работ: нормы времени: Типы недели', 10719, 10094001, 3, 'Типы недели', 0, 1, 'r_WWeeks', 1, '', 'WWeekTypeID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10722001, 'Справочник нерабочих дней', 10722, 10722001, 1, 'Общие данные', 1, 1, 'r_Holidays', 1, 'tab_Comm', 'HolidayDate', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10723001, 'Справочник специализаций: категории', 10723, 10723001, 1, 'Список', 1, 1, 'r_TagC', 1, 'tab_Comm', 'TagCID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10724001, 'Справочник специализаций: Заголовок', 10724, 10724001, 1, 'Заголовок', 0, 1, 'r_Tags', 1, 'Заголовок', 'TagCID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10724002, 'Справочник специализаций: Специализации', 10724, 10724001, 2, 'Специализации', 1, 1, 'r_Tags', 1, 'Специализации', 'TagID;TagCID', '', '', 0, 0, '< Главный Источник Документа >', 'TagCID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10725001, 'Справочник кандидатов: Заголовок', 10725, 10725001, 1, 'Заголовок', 3, 1, 'r_Candidates', 1, 'Заголовок', 'CandidateID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 500, 155, 2, 40, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10725002, 'Справочник кандидатов: Список', 10725, 10725001, 2, 'Список', 1, 1, 'Справочник кандидатов: Заголовок', 5, 'tab_List', 'CandidateID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10725003, 'Справочник кандидатов: Общие данные', 10725, 10725001, 3, 'Общие данные', 0, 1, 'Справочник кандидатов: Заголовок', 5, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10725004, 'Справочник кандидатов: Документы', 10725, 10725002, 4, 'Документы', 1, 1, 'r_CandidateFiles', 1, 'tab_CandidateFiles', 'CandidateID', '', '', 0, 0, '< Главный Источник Документа >', 'CandidateID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10750001, 'Справочник ТМЦ: Заголовок', 10750, 10350001, 1, 'Заголовок', 3, 1, 'r_Prods', 1, '', 'ProdID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 700, 200, 2, 40, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10750002, 'Справочник ТМЦ: Список', 10750, 10350001, 2, 'Список', 1, 1, '< Главный Источник Документа >', 5, 'tab_List', 'ProdID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10750003, 'Справочник ТМЦ: Общие данные', 10750, 10350001, 3, 'Общие данные', 0, 1, '< Главный Источник Документа >', 5, 'tab_Comm', 'ProdID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10750004, 'Справочник ТМЦ: Классификация', 10750, 10350001, 4, 'Классификация', 0, 1, '< Главный Источник Документа >', 5, 'tab_PClass', 'ProdID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10750006, 'Справочник ТМЦ: Партии', 10750, 10350002, 6, 'Партии', 1, 1, 'b_PInP', 1, 'tab_M_PP', 'ProdID;PPID;', '', '', 0, 0, '< Главный Источник Документа >', 'ProdID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10750007, 'Справочник ТМЦ: Цены продажи', 10750, 10350005, 7, 'Цены продажи', 1, 1, 'r_ProdMP', 1, 'tab_M_PL', 'ProdID;PLID;', '', '', 0, 0, '< Главный Источник Документа >', 'ProdID', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10750009, 'Справочник ТМЦ: Цены', 10750, 10350001, 9, 'Цены', 0, 1, '< Главный Источник Документа >', 5, 'tab_Prices', 'ProdID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10750010, 'Справочник ТМЦ: Нормы', 10750, 10350001, 10, 'Нормы', 0, 1, '< Главный Источник Документа >', 5, 'tab_Norms', 'ProdID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10750011, 'Справочник ТМЦ: Дополнительно', 10750, 10350001, 11, 'Дополнительно', 0, 1, '< Главный Источник Документа >', 5, 'tab_More1', 'ProdID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10750015, 'Справочник ТМЦ: Сертификаты', 10750, 10350001, 15, 'Сертификаты', 0, 1, '< Главный Источник Документа >', 5, 'tab_Crts', 'ProdID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10750016, 'Справочник ТМЦ: Комплекты', 10750, 10350001, 16, 'Комплекты', 0, 0, '< Главный Источник Документа >', 5, 'tab_Sets', 'ProdID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 700, 200, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10750017, 'Справочник ТМЦ: Cборы', 10750, 10350019, 17, 'Cборы', 1, 1, 'r_ProdLV', 1, '', 'ProdID;LevyID', '', '', 0, 0, '< Главный Источник Документа >', 'ProdID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10800001, 'Справочник местных налогов', 10800, 10800001, 1, 'Список', 1, 1, 'r_TaxRegions', 1, '', 'TaxRegionID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10800002, 'Справочник местных налогов: Ставки', 10800, 10800002, 2, 'Ставки', 1, 1, 'r_TaxRegionRates', 1, '', 'TaxRegionID;SrcDate', '', '', 0, 0, '< Главный Источник Документа >', 'TaxRegionID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10810001, 'Справочник НДС', 10810, 10810001, 1, 'Список', 1, 1, 'r_Taxes', 1, 'Список', 'TaxTypeID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10810002, 'Справочник НДС: значения', 10810, 10810002, 2, 'Значения', 1, 1, 'r_TaxRates', 1, '', 'TaxTypeID;ChDate', '', '', 0, 0, '< Главный Источник Документа >', 'TaxTypeID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10820001, 'Справочник сборов', 10820, 10820001, 1, 'Список', 1, 1, 'r_Levies', 1, 'Список', 'LevyID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10820002, 'Справочник сборов - Ставки', 10820, 10820002, 2, 'Ставки', 1, 1, 'r_LevyRates', 1, '', 'LevyID;ChDate', '', '', 0, 0, '< Главный Источник Документа >', 'LevyID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10820003, 'Справочник сборов - параметры РРО', 10820, 10820003, 3, 'Параметры РРО', 1, 1, 'r_LevyCR', 1, '', 'LevyID;CashType', '', '', 0, 0, '< Главный Источник Документа >', 'LevyID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10900001, 'Справочник стран', 10900, 10900001, 1, 'Общие данные', 1, 1, 'r_Countries', 1, 'tab_Comm', 'CounID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (10910001, 'Справочник расширений файлов', 10910, 10910001, 1, 'Общие данные', 1, 1, 'r_ExtFiles', 1, 'tab_Comm', 'ExtFileID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11001001, 'Счет на оплату товара: Заголовок', 11001, 11001001, 1, 'Заголовок', 0, 1, 't_Acc', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11001002, 'Счет на оплату товара: Товар', 11001, 11001002, 2, 'Товар', 1, 1, 't_AccD', 1, 'TabSheet1', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11001003, 'Счет на оплату товара: Затраты', 11001, 11001003, 3, 'Затраты', 1, 1, 't_AccSpends', 1, '', 'ChID;SpendCode', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11001004, 'Счет на оплату товара: Маршрут', 11001, 11001004, 4, 'Маршрут', 1, 1, 't_AccRoutes', 1, '', 'ChID;RouteID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11002001, 'Приход товара: Заголовок', 11002, 11002001, 1, 'Заголовок', 0, 1, 't_Rec', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11002002, 'Приход товара: Товар', 11002, 11002002, 2, 'Товар', 1, 1, 't_RecD', 1, 'TabSheet1', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11002003, 'Приход товара: Затраты', 11002, 11002003, 3, 'Затраты', 1, 1, 't_RecSpends', 1, '', 'ChID;SpendCode', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11002004, 'Приход товара: Маршрут', 11002, 11002004, 4, 'Маршрут', 1, 1, 't_RecRoutes', 1, '', 'ChID;RouteID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11003001, 'Возврат товара от получателя: Заголовок', 11003, 11003001, 1, 'Заголовок', 0, 1, 't_Ret', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11003002, 'Возврат товара от получателя: Товар', 11003, 11003002, 2, 'Товар', 1, 1, 't_RetD', 1, 'TabSheet1', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11003003, 'Возврат товара от получателя: Затраты', 11003, 11003003, 3, 'Затраты', 1, 1, 't_RetSpends', 1, '', 'ChID;SpendCode', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11003004, 'Возврат товара от получателя: Маршрут', 11003, 11003004, 4, 'Маршрут', 1, 1, 't_RetRoutes', 1, '', 'ChID;RouteID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11004001, 'Возврат товара по чеку: Заголовок', 11004, 11004001, 1, 'Заголовок', 0, 1, 't_CRRet', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11004002, 'Возврат товара по чеку: Товар', 11004, 11004002, 2, 'Товар', 1, 1, 't_CRRetD', 1, 'TabSheet1', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11004003, 'Возврат товара по чеку: Оплата', 11004, 11004003, 3, 'Оплата', 1, 1, 't_CRRetPays', 1, '', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11004004, 'Возврат товара по чеку: Сборы по товару', 11004, 11004004, 4, 'Сборы по товару', 1, 1, 't_CRRetDLV', 1, '', 'ChID;SrcPosID;LevyID', '', '', 0, 0, 'Возврат товара по чеку: Товар', 'ChID;SrcPosID', 1, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11011001, 'Возврат товара поставщику: Заголовок', 11011, 11011001, 1, 'Заголовок', 0, 1, 't_CRet', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11011002, 'Возврат товара поставщику: Товары', 11011, 11011002, 2, 'Товары', 1, 1, 't_CRetD', 1, 'TabSheet1', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11011003, 'Возврат товара поставщику: Затраты', 11011, 11011003, 3, 'Затраты', 1, 1, 't_CRetSpends', 1, '', 'ChID;SpendCode', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11011004, 'Возврат товара поставщику: Маршрут', 11011, 11011004, 4, 'Маршрут', 1, 1, 't_CRetRoutes', 1, '', 'ChID;RouteID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11012001, 'Расходная накладная: Заголовок', 11012, 11012001, 1, 'Заголовок', 0, 1, 't_Inv', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11012002, 'Расходная накладная: Товар', 11012, 11012002, 2, 'Товар', 1, 1, 't_InvD', 1, 'TabSheet1', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11012003, 'Расходная накладная: Затраты', 11012, 11012003, 3, 'Затраты', 1, 1, 't_InvSpends', 1, '', 'ChID;SpendCode', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11012004, 'Расходная накладная: Маршрут', 11012, 11012004, 4, 'Маршрут', 1, 1, 't_InvRoutes', 1, '', 'ChID;RouteID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11015001, 'Расходный документ: Заголовок', 11015, 11015001, 1, 'Заголовок', 0, 1, 't_Exp', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11015002, 'Расходный документ: Товар', 11015, 11015002, 2, 'Товар', 1, 1, 't_ExpD', 1, 'TabSheet1', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11015003, 'Расходный документ: Затраты', 11015, 11015003, 3, 'Затраты', 1, 1, 't_ExpSpends', 1, '', 'ChID;SpendCode', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11015004, 'Расходный документ: Маршрут', 11015, 11015004, 4, 'Маршрут', 1, 1, 't_ExpRoutes', 1, '', 'ChID;RouteID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11016001, 'Расходный документ в ценах прихода: Заголовок', 11016, 11016001, 1, 'Заголовок', 0, 1, 't_Epp', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11016002, 'Расходный документ в ценах прихода: Товары', 11016, 11016002, 2, 'Товары', 1, 1, 't_EppD', 1, 'TabSheet1', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11016003, 'Расходный документ в ценах прихода: Затраты', 11016, 11016003, 3, 'Затраты', 1, 1, 't_EppSpends', 1, '', 'ChID;SpendCode', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11016004, 'Расходный документ в ценах прихода: Маршрут', 11016, 11016004, 4, 'Маршрут', 1, 1, 't_EppRoutes', 1, '', 'ChID;RouteID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11018001, 'Прием наличных денег на склад', 11018, 11018001, 1, 'Общие данные', 1, 1, 't_MonRec', 1, 'tab_Comm', 'OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11021001, 'Перемещение товара: Заголовок', 11021, 11021001, 1, 'Заголовок', 0, 1, 't_Exc', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11021002, 'Перемещение товара: Товар', 11021, 11021002, 2, 'Товар', 1, 1, 't_ExcD', 1, 'TabSheet1', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11021003, 'Перемещение товара: Затраты', 11021, 11021003, 3, 'Затраты', 1, 1, 't_ExcSpends', 1, '', 'ChID;SpendCode', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11021004, 'Перемещение товара: Маршрут', 11021, 11021004, 4, 'Маршрут', 1, 1, 't_ExcRoutes', 1, '', 'ChID;RouteID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11022001, 'Инвентаризация товара: Заголовок', 11022, 11022001, 1, 'Заголовок', 0, 1, 't_Ven', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11022002, 'Инвентаризация товара: Товар', 11022, 11022002, 2, 'Товар', 1, 1, 't_VenA', 1, 'TabSheet1', 'ChID;TSrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11022003, 'Инвентаризация товара: Партии', 11022, 11022003, 3, 'Партии', 0, 0, 't_VenD', 1, '', 'ChID;DetProdID;SrcPosID', '', '', 0, 0, 'Инвентаризация товара: Товар', 'ChID;ProdID', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11022006, 'Инвентаризация товара: Виды упаковок', 11022, 11022006, 6, 'Виды упаковок', 0, 1, 't_VenD_UM', 0, '', 'ChID;DetProdID;DetUM', '', '', 0, 0, 'Инвентаризация товара: Товар', 'ChID;ProdID', 0, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11022007, 'Инвентаризация товара: Первичные данные', 11022, 11022004, 7, 'Первичные данные', 1, 1, 't_VenI', 1, 'TabSheet2', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11022008, 'Инвентаризация товара: Инвентаризация в фронт-офисе: Заголовок', 11022, 11022001, 100, 'Инвентаризация в фронт-офисе (Заголовок)', 0, 0, 't_Ven', 1, '', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11022009, 'Инвентаризация товара: Инвентаризация в фронт-офисе: Исходные данные', 11022, 11022004, 101, 'Инвентаризация в фронт-офисе (Исходные данные)', 0, 0, 't_VenI', 1, '', 'ChID;SrcPosID', '', '', 0, 0, 'Инвентаризация товара: Инвентаризация в фронт-офисе: Заголовок', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11031001, 'Переоценка цен прихода: Заголовок', 11031, 11031001, 1, 'Заголовок', 0, 1, 't_Est', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11031002, 'Переоценка цен прихода: Товар', 11031, 11031002, 2, 'Товар', 1, 1, 't_EstD', 1, 'TabSheet1', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11032001, 'Переоценка цен продажи: Заголовок', 11032, 11032001, 1, 'Заголовок', 0, 1, 't_SEst', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11032002, 'Переоценка цен продажи: Товар', 11032, 11032002, 2, 'Товар', 1, 1, 't_SEstD', 1, 'TabSheet1', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11035001, 'Продажа товара оператором: Заголовок', 11035, 11035001, 1, 'Заголовок', 0, 1, 't_Sale', 1, '', 'ChID;OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11035002, 'Продажа товара оператором: Продажи товара', 11035, 11035002, 2, 'Продажи товара', 1, 1, 't_SaleD', 1, 'TabSheet1', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11035003, 'Продажа товара оператором: Отмены продаж', 11035, 11035003, 3, 'Отмены продаж', 1, 1, 't_SaleC', 1, '', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11035004, 'Продажа товара оператором: Оплата', 11035, 11035004, 4, 'Оплата', 1, 1, 't_SalePays', 1, '', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11035005, 'Продажа товара оператором: Сборы по товару', 11035, 11035005, 5, 'Сборы по товару', 1, 1, 't_SaleDLV', 1, '', 'ChID;SrcPosID;LevyID', '', '', 0, 0, 'Продажа товара оператором: Продажи товара', 'ChID;SrcPosID', 1, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11035006, 'Продажа товара оператором: Модификаторы', 11035, 11035006, 6, 'Модификаторы', 1, 1, 't_SaleM', 1, '', 'ChID;SrcPosID;ModCode', '', '', 0, 0, 'Продажа товара оператором: Продажи товара', 'ChID;SrcPosID', 1, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11036001, 'Выдача наличных держателям ЭПС', 11036, 11036001, 1, 'Общие данные', 1, 1, 't_CashBack', 1, 'tab_Comm', 'DocID;DocTime', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11040001, 'Формирование себестоимости: Заголовок', 11040, 11040001, 1, 'Заголовок', 0, 1, 't_Cos', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11040002, 'Формирование себестоимости: Товар', 11040, 11040002, 2, 'Товар', 1, 1, 't_CosD', 1, 'TabSheet1', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11040003, 'Формирование себестоимости: Затраты', 11040, 11040003, 3, 'Затраты', 1, 1, 't_CosSpends', 1, '', 'ChID;SpendCode', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11045001, 'Приход товара по ГТД: Заголовок', 11045, 11045001, 1, 'Заголовок', 0, 1, 't_Cst', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11045002, 'Приход товара по ГТД: Товар', 11045, 11045002, 2, 'Товар', 1, 1, 't_CstD', 1, 'tab_Comm', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11045003, 'Приход товара по ГТД: Затраты', 11045, 11045003, 3, 'Затраты', 1, 1, 't_CstSpends', 1, '', 'ChID;SpendCode', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11045004, 'Приход товара по ГТД: Маршрут', 11045, 11045004, 4, 'Маршрут', 1, 1, 't_CstRoutes', 1, '', 'ChID;RouteID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11046001, 'Приход товара по ГТД (новый): Заголовок', 11046, 11046001, 1, 'Заголовок', 1, 0, 't_Cst2', 1, '', 'OurID;DocID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11046002, 'Приход товара по ГТД (новый): Товар', 11046, 11046002, 2, 'Товар', 1, 1, 't_Cst2D', 1, 'TabSheet1', 'ChID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11051001, 'Служебный приход денег', 11051, 11051001, 1, 'Общие данные', 1, 1, 't_MonIntRec', 1, 'tab_Comm', 'OurID;DocDate;CRID', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11052001, 'Служебный расход денег', 11052, 11052001, 1, 'Общие данные', 1, 1, 't_MonIntExp', 1, 'tab_Comm', 'OurID;DocDate;CRID', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11060001, 'Ресторан: Смена: Заголовок', 11060, 11060001, 1, 'Заголовок', 3, 1, 't_RestShift', 1, '', 'OurID;DocID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 250, 90, 5, 40, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11060002, 'Ресторан: Смена: Персонал', 11060, 11060002, 2, 'Персонал', 1, 1, 't_RestShiftD', 1, '', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11060003, 'Ресторан: Смена: Свойства', 11060, 11060001, 3, 'Свойства', 3, 1, '< Главный Источник Документа >', 5, '', '', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 3, 300, 90, 0, 40, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11101001, 'Ресторан: Резервирование столиков', 11101, 11101001, 1, 'Заголовок', 3, 1, 't_DeskRes', 1, '', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 250, 90, 5, 40, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11101002, 'Ресторан: Резервирование столиков: Товар', 11101, 11101002, 2, 'Товар', 1, 1, 't_DeskResD', 1, '', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11101003, 'Ресторан: Резервирование столиков: Свойства', 11101, 11101001, 3, 'Свойства', 3, 1, '< Главный Источник Документа >', 5, '', '', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 1, 3, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11111001, 'Служебные данные: Услуги', 11111, 0, 1, 'Список', 3, 1, 'SELECT 
 b.ChID, b.SrvcID, b.ResourceID, b.BTime, b.ETime,
 ex.ExecutorID, ex.ExecutorName,
 d.SrcPosID, d.UM, d.Qty, d.PriceCC_wt, d.SumCC_wt, d.PurPriceCC_wt, d.BarCode, d.ProdID, d.EmpID, d.EmpName,
 s.TimeNorm,
 p.PCatID, p.ProdName FROM t_Booking md
JOIN t_SaleTempD d WITH (NOLOCK)ON md.DocCode = 1011 AND d.ChID = md.DocChID
JOIN r_Prods p WITH (NOLOCK) ON d.ProdID = p.ProdID
LEFT OUTER JOIN t_BookingD b WITH (NOLOCK) ON md.ChID = b.ChID AND b.DetSrcPosID = d.SrcPosID
LEFT OUTER JOIN r_Services s WITH (NOLOCK) ON b.SrvcID = s.SrvcID
LEFT OUTER JOIN r_Executors ex WITH (NOLOCK) ON d.EmpID = ex.EmpID
ORDER BY 
  d.SrcPosID
', 3, '', 'SrcPosID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11113001, 'Справочник ресурсов: типы', 11113, 11113001, 1, 'Список', 1, 1, 'r_ResourceTypes', 1, 'tab_Comm', 'ResourceTypeID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11114001, 'Справочник ресурсов', 11114, 11114001, 1, 'Список', 1, 1, 'r_Resources', 1, 'Список', 'ResourceID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11114002, 'Справочник ресурсов - график работ', 11114, 11114002, 2, 'График', 1, 1, 'r_ResourceSched', 1, '', 'ResourceID', '', '', 0, 0, '< Главный Источник Документа >', 'ResourceID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11115001, 'Справочник услуг', 11115, 11115001, 1, 'Список', 1, 1, 'r_Services', 1, 'Список', 'SrvcID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11115002, 'Справочник услуг - ресурсы', 11115, 11115003, 2, 'Ресурсы', 1, 1, 'r_ServiceResources', 1, '', 'SrvcID;ResourceTypeID', '', '', 0, 0, '< Главный Источник Документа >', 'SrvcID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11115003, 'Справочник услуг - совместимость', 11115, 11115002, 3, 'Совместимость', 1, 1, 'r_ServiceCompatibility', 1, '', 'SrvcID;CompatibleServiceID', '', '', 0, 0, '< Главный Источник Документа >', 'SrvcID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11117001, 'Справочник исполнителей', 11117, 11117001, 1, 'Список', 1, 1, 'r_Executors', 1, 'Список', 'ExecutorID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11117002, 'Справочник исполнителей - услуги', 11117, 11117002, 2, 'Услуги', 1, 1, 'r_ExecutorServices', 1, '', 'ExecutorID;SrvcID', '', '', 0, 0, '< Главный Источник Документа >', 'ExecutorID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11117003, 'Справочник исполнителей - смены', 11117, 11117003, 3, 'Смены', 1, 1, 'r_ExecutorShifts', 1, '', 'ExecutorID;StockID;BTime;ETime', '', '', 0, 0, '< Главный Источник Документа >', 'ExecutorID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11118001, 'Справочник персон', 11118, 11118001, 1, 'Список', 1, 1, 'r_Persons', 1, 'Список', 'PersonID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11118002, 'Справочник персон - предпочтения', 11118, 11118002, 2, 'Предпочтения', 1, 1, 'r_PersonPreferences', 1, '', 'PersonID;ExecutorID;SrvcID;ResourceID', '', '', 0, 0, '< Главный Источник Документа >', 'PersonID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11118003, 'Справочник персон - черный список ресурсов', 11118, 11118003, 3, 'ЧC ресурсов', 1, 1, 'r_PersonResourcesBL', 1, '', 'PersonID;ResourceID', '', '', 0, 0, '< Главный Источник Документа >', 'PersonID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11118004, 'Справочник персон - черный список исполнителей', 11118, 11118004, 4, 'ЧC исполнителей', 1, 1, 'r_PersonExecutorsBL', 1, '', 'PersonID;ExecutorID', '', '', 0, 0, '< Главный Источник Документа >', 'PersonID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11118005, 'Справочник персон - дисконтные карты', 11118, 11118005, 5, 'Дисконтные карты', 1, 1, 'r_PersonDC', 1, '', 'PersonID;DCardChID', '', '', 0, 0, '< Главный Источник Документа >', 'PersonID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11118006, 'Справочник персон - члены семьи', 11118, 11118006, 6, 'Члены семьи', 1, 1, 'r_PersonKin', 1, '', 'PersonID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'PersonID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11211001, 'Заказ внешний: Формирование: Заголовок', 11211, 11211001, 1, 'Заголовок', 0, 1, 't_EOExp', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11211002, 'Заказ внешний: Формирование: Товар', 11211, 11211002, 2, 'Товар', 1, 1, 't_EOExpD', 1, 'tab_Main', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11211003, 'Заказ внешний: Формирование: Подробно', 11211, 11211003, 3, 'Подробно', 0, 0, 't_EOExpDD', 1, '', 'AChID;DetSrcPosID', '', '', 0, 0, 'Заказ внешний: Формирование: Товар', 'AChID', 0, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11211004, 'Заказ внешний: Формирование: Затраты', 11211, 11211004, 4, 'Затраты', 1, 1, 't_EOExpSpends', 1, '', 'ChID;SpendCode', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11211005, 'Заказ внешний: Формирование: Маршрут', 11211, 11211005, 5, 'Маршрут', 1, 1, 't_EOExpRoutes', 1, '', 'ChID;RouteID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11212001, 'Заказ внешний: Обработка: Заголовок', 11212, 11212001, 1, 'Заголовок', 0, 1, 't_EORec', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11212002, 'Заказ внешний: Обработка: Товар', 11212, 11212002, 2, 'Товар', 1, 1, 't_EORecD', 1, 'tab_Main', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11212003, 'Заказ внешний: Обработка: Затраты', 11212, 11212003, 3, 'Затраты', 1, 1, 't_EORecSpends', 1, '', 'ChID;SpendCode', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11212004, 'Заказ внешний: Обработка: Маршрут', 11212, 11212004, 4, 'Маршрут', 1, 1, 't_EORecRoutes', 1, '', 'ChID;RouteID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11221001, 'Заказ внутренний: Формирование: Заголовок', 11221, 11221001, 1, 'Заголовок', 0, 1, 't_IORec', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11221002, 'Заказ внутренний: Формирование: Товар', 11221, 11221002, 2, 'Товар', 1, 1, 't_IORecD', 1, 'tab_Main', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11221003, 'Заказ внутренний: Формирование: Затраты', 11221, 11221003, 3, 'Затраты', 1, 1, 't_IORecSpends', 1, '', 'ChID;SpendCode', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11221004, 'Заказ внутренний: Формирование: Маршрут', 11221, 11221004, 4, 'Маршрут', 1, 1, 't_IORecRoutes', 1, '', 'ChID;RouteID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11222001, 'Заказ внутренний: Обработка: Заголовок', 11222, 11222001, 1, 'Заголовок', 0, 1, 't_IOExp', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11222002, 'Заказ внутренний: Обработка: Товар', 11222, 11222002, 2, 'Товар', 1, 1, 't_IOExpD', 1, 'TabSheet1', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11222003, 'Заказ внутренний: Обработка: Затраты', 11222, 11222003, 3, 'Затраты', 1, 1, 't_IOExpSpends', 1, '', 'ChID;SpendCode', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11222004, 'Заказ внутренний: Обработка: Маршрут', 11222, 11222004, 4, 'Маршрут', 1, 1, 't_IOExpRoutes', 1, '', 'ChID;RouteID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11231001, 'Распределение товара: Заголовок', 11231, 11231001, 1, 'Заголовок', 0, 1, 't_Dis', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11231002, 'Распределение товара: Данные', 11231, 11231002, 2, 'Данные', 1, 1, 't_DisD', 1, 'tab_Main', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11231003, 'Распределение товара: Подробно', 11231, 11231003, 3, 'Подробно', 0, 0, 't_DisDD', 1, 'tab_Main2', 'AChID;DetSrcPosID', '', '', 0, 0, 'Распределение товара: Данные', 'AChID', 0, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11231004, 'Распределение товара: Затраты', 11231, 11231004, 4, 'Затраты', 1, 1, 't_DisSpends', 1, '', 'ChID;SpendCode', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11231005, 'Распределение товара: Маршрут', 11231, 11231005, 5, 'Маршрут', 1, 1, 't_DisRoutes', 1, '', 'ChID;RouteID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11311001, 'Планирование: Комплектация: Заголовок', 11311, 11311001, 1, 'Заголовок', 0, 1, 't_SPRec', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11311002, 'Планирование: Комплектация: Комплекты', 11311, 11311003, 2, 'Комплекты', 1, 1, 't_SPRecA', 1, 'tab_Sets', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11311003, 'Планирование: Комплектация: Составляющие', 11311, 11311004, 3, 'Составляющие', 1, 1, 't_SPRecD', 1, 'tab_SubSets', 'AChID;SubSrcPosID', '', '', 0, 0, 'Планирование: Комплектация: Комплекты', 'AChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11312001, 'Планирование: Разукомплектация: Заголовок', 11312, 11312001, 1, 'Заголовок', 0, 1, 't_SPExp', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11312002, 'Планирование: Разукомплектация: Комплекты', 11312, 11312003, 2, 'Комплекты', 1, 1, 't_SPExpA', 1, 'tab_Sets', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11312003, 'Планирование: Разукомплектация: Составляющие', 11312, 11312004, 3, 'Составляющие', 1, 1, 't_SPExpD', 1, 'tab_SubSets', 'AChID;SubSrcPosID', '', '', 0, 0, 'Планирование: Разукомплектация: Комплекты', 'AChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11321001, 'Комплектация товара: Заголовок', 11321, 11321001, 1, 'Заголовок', 0, 1, 't_SRec', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11321002, 'Комплектация товара: Комплекты', 11321, 11321003, 2, 'Комплекты', 1, 1, 't_SRecA', 1, 'tab_Sets', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11321003, 'Комплектация товара: Составляющие', 11321, 11321004, 3, 'Составляющие', 1, 1, 't_SRecD', 1, 'tab_SubSets', 'AChID;SubSrcPosID', '', '', 0, 0, 'Комплектация товара: Комплекты', 'AChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11321004, 'Комплектация товара: Общие затраты', 11321, 11321002, 4, 'Общие затраты', 1, 1, 't_SRecM', 1, 'tab_Cost', 'ChID;CostCodeID1;CostCodeID2;CostCodeID3;CostCodeID4;CostCodeID5', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11321005, 'Комплектация товара: Затраты на 1 комплект', 11321, 11321005, 5, 'Затраты на 1 комплект', 1, 1, 't_SExpE', 1, 'tab_SubSet1Costs', 'AChID', '', '', 0, 0, 't_SRecA', 'AChID', 0, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11322001, 'Разукомплектация товара: Заголовок', 11322, 11322001, 1, 'Заголовок', 0, 1, 't_SExp', 1, '', 'OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11322002, 'Разукомплектация товара: Комплекты', 11322, 11322003, 2, 'Комплекты', 1, 1, 't_SExpA', 1, 'tab_Sets', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11322003, 'Разукомплектация товара: Составляющие', 11322, 11322004, 3, 'Составляющие', 1, 1, 't_SExpD', 1, 'tab_SubSets', 'AChID;SubSrcPosID', '', '', 0, 0, 'Разукомплектация товара: Комплекты', 'AChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11322004, 'Разукомплектация товара: Общие затраты', 11322, 11322002, 4, 'Общие затраты', 1, 1, 't_SExpM', 1, 'tab_Cost', 'ChID;CostCodeID1;CostCodeID2;CostCodeID3;CostCodeID4;CostCodeID5', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11322005, 'Разукомплектация товара: Затраты на 1 комплект', 11322, 11322005, 5, 'Затраты на 1 комплект', 1, 1, 't_SExpE', 1, 'tab_SubSet1Costs', 'AChID', '', '', 0, 0, 't_SExpA', 'AChID', 0, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11330001, 'Калькуляционная карта: Заголовок', 11330, 11330001, 1, 'Заголовок', 3, 1, 't_Spec', 1, '', 'OurID;DocID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 360, 120, 4, 40, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11330002, 'Калькуляционная карта: Состав', 11330, 11330002, 2, 'Состав', 1, 1, 't_SpecDs', 2, '', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11330003, 'Калькуляционная карта: Свойства', 11330, 0, 3, 'Свойства', 3, 1, '< Главный Источник Документа >', 5, '', '', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 3, 380, 120, 0, 40, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11330004, 'Калькуляционная карта: Настройки', 11330, 11330005, 4, 'Настройки', 3, 1, 't_SpecParams', 1, 'ctl_Params', 'ChID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 3, 380, 120, 0, 40, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11330005, 'Калькуляционная карта: Цены', 11330, 11330007, 5, 'Цены', 3, 1, 't_SpecPrices', 2, '', 'ChID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 3, 380, 120, 0, 40, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11330006, 'Калькуляционная карта: Состав: Итого', 11330, 0, 6, 'Состав: Итого', 1, 1, 'SELECT * FROM dbo.tf_GetSpecListSubs(:ChID)', 3, '', '', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11330007, 'Калькуляционная карта: Технология', 11330, 11330004, 7, 'Технология', 1, 1, 't_SpecT', 1, '', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11330008, 'Калькуляционная карта: Характеристика', 11330, 11330003, 8, 'Характеристика', 1, 1, 't_SpecDesc', 1, '', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11501001, 'Реестр: Счет на оплату товара', 11501, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.TSumCC_wt AS TSumCC, (m.TSumCC_wt / KursMC) AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate, 
  ReserveProds, ReserveDayCount, m.StateCode
FROM r_Comps c INNER JOIN t_Acc m ON c.CompID = m.CompID 

WHERE @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11502001, 'Реестр: Приход товара', 11502, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.TSumCC_wt AS TSumCC,
  CASE WHEN dbo.zf_Var(''t_UseMultiCurrencies'') = ''1'' THEN 
	   CASE WHEN ((SELECT dbo.zf_GetRateCC(m.CurrID)) <> 0) AND (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC / (SELECT dbo.zf_GetRateCC(m.CurrID)) ELSE 0 END
  ELSE CASE WHEN (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC ELSE 0 END
	 END AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate,
  m.SrcDocID, m.SrcDocDate,
  ISNULL((SELECT TOP 1 ChildDocID FROM z_DocLinks l
    WHERE ParentDocCode = 11002 AND l.ParentChID = m.ChID), '''') ChildDocID
FROM r_Comps c INNER JOIN t_Rec m ON c.CompID = m.CompID
WHERE @WorkAge@(m.DocDate)

) GMSView
ORDER BY OurID, DocID
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11503001, 'Реестр: Возврат товара от получателя', 11503, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT 
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.TSumCC_wt AS TSumCC, (m.TSumCC_wt/KursMC) AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate, m.StateCode
FROM r_Comps AS c INNER JOIN t_Ret AS m ON c.CompID = m.CompID

WHERE @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11504001, 'Реестр: Возврат товара по чеку', 11504, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT 
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, 
  m.TSumCC_wt AS TSumCC, (m.TSumCC_wt / KursMC) AS TSumMC, TRealSum, TLevySum, 
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode,
  m.CRID, r_CRs.CRName
FROM r_CRs INNER JOIN t_CRRet m ON r_Crs.CrID=m.CrID

WHERE @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11511001, 'Реестр: Возврат товара поставщику', 11511, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.TSumCC_wt AS TSumCC, 
  CASE WHEN ((SELECT dbo.zf_GetRateCC(m.CurrID) AS RateCC) <> 0) AND (KursMC <> 0) THEN  
    m.TSumCC_wt / KursMC / (SELECT dbo.zf_GetRateCC(m.CurrID) AS RateCC) ELSE 0 
  END AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate
  FROM (r_Comps c INNER JOIN t_CRet m ON c.CompID = m.CompID)

WHERE @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11512001, 'Реестр: Расходная накладная', 11512, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.TSumCC_wt AS TSumCC, (m.TSumCC_wt / KursMC) AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate,
  m.SrcDocID, m.SrcDocDate
FROM r_Comps c INNER JOIN t_Inv m ON c.CompID = m.CompID

WHERE @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11515001, 'Реестр: Расходный документ', 11515, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.TSumCC_wt AS TSumCC, (m.TSumCC_wt / KursMC) AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate, 
  m.SrcDocID, m.SrcDocDate
FROM r_Comps AS c INNER JOIN t_Exp AS m ON c.CompID = m.CompID

WHERE @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11516001, 'Реестр: Расходный документ в ценах прихода', 11516, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT 
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.TSumCC_wt AS TSumCC, (m.TSumCC_wt / KursMC) AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate, 
  m.SrcDocID, m.SrcDocDate
FROM (r_Comps AS c INNER JOIN t_Epp AS m ON c.CompID = m.CompID)

WHERE @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11518001, 'Реестр: Прием наличных денег на склад', 11518, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.DocID, m.StockID, StockName,  m.CompID, CompName,
  m.CurrID, c1.CurrName, m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, m.Subject,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5,
  m.EmpID, e1.EmpName
FROM 
  t_MonRec m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Currs c1,
  r_Comps,
  r_Emps e1
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND c1.CurrID = m.CurrID
  AND r_Comps.CompID = m.CompID
  AND e1.EmpID = m.EmpID
  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID', 3, 'tab_Comm', '', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11521001, 'Реестр: Перемещение товара', 11521, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT 
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.NewStockID,
  m.TSumCC_wt AS TSumCC, (m.TSumCC_wt / KursMC) AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode,
  m.SrcDocID, m.SrcDocDate, s1.StockName AS StockName , s2.StockName AS NewStockName
FROM t_Exc m, r_Stocks s1, r_Stocks s2
WHERE s1.StockID = m.StockID AND s2.StockID = m.NewStockID

  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11522001, 'Реестр: Инвентаризация товара', 11522, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT DISTINCT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, c.StocKName,
  m.TSumCC_wt AS TSumCC, (m.TSumCC_wt / KursMC) AS TSumMC,
  m.TNewSumCC_wt AS TNewSumCC, (m.TNewSumCC_wt / KursMC) AS TNewSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode
FROM t_Ven m LEFT JOIN t_VenA a ON m.ChID = a.ChID, r_Stocks c
WHERE m.StockID= c.StockID 

  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY  OurID, DocID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11522002, 'Реестр: Инвентаризация товара: Инвентаризация в фронт-офисе', 11522, 0, 2, 'Инвентаризация в фронт-офисе', 0, 0, 'SELECT * FROM (

SELECT DISTINCT
  m.ChID, m.DocID, m.DocDate, 
  m.TSumCC_wt AS TSumCC, (m.TSumCC_wt / KursMC) AS TSumMC,
  m.TNewSumCC_wt AS TNewSumCC, (m.TNewSumCC_wt / KursMC) AS TNewSumMC,
  e.EmpName, m.StateCode
FROM t_Ven m LEFT JOIN t_VenA a ON m.ChID = a.ChID
  LEFT JOIN r_Emps e ON m.EmpID = e.EmpID
WHERE m.ChID IN (SELECT DISTINCT ChID FROM t_VenI) 
  AND @WorkAge@(m.DocDate)  
) GMSView
ORDER BY DocID
', 3, '', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 0, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11531001, 'Реестр: Переоценка цен прихода', 11531, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT 
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID,
  m.TSumCC_wt AS TSumCC,
  CASE WHEN dbo.zf_Var(''t_UseMultiCurrencies'') = ''1'' THEN 
	   CASE WHEN ((SELECT dbo.zf_GetRateCC(m.CurrID)) <> 0) AND (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC / (SELECT dbo.zf_GetRateCC(m.CurrID)) ELSE 0 END
  ELSE CASE WHEN (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC ELSE 0 END
	 END AS TSumMC,
  m.TNewSumCC_wt AS TNewSumCC,
  CASE WHEN dbo.zf_Var(''t_UseMultiCurrencies'') = ''1'' THEN 
	   CASE WHEN ((SELECT dbo.zf_GetRateCC(m.CurrID)) <> 0) AND (m.KursMC <> 0) THEN m.TNewSumCC_wt / m.KursMC / (SELECT dbo.zf_GetRateCC(m.CurrID)) ELSE 0 END
  ELSE CASE WHEN (m.KursMC <> 0) THEN m.TNewSumCC_wt / m.KursMC ELSE 0 END
	 END AS TNewSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, c.StockName, m.StateCode
FROM t_Est m, r_Stocks c
WHERE m.StockID = c.StockID

  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11532001, 'Реестр: Переоценка цен продажи', 11532, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT m.ChID,
 m.DocID,
 IntDocID,
 m.OurID,
 m.DocDate,
 m.KursMC, 
 m.CodeID1,
 m.CodeID2, 
 m.CodeID3,   
 m.CodeID4,
 m.CodeID5 
FROM t_SEst AS m 
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.DocID,
 IntDocID,
 m.OurID,
 m.DocDate,
 m.KursMC,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3, 
 m.CodeID4,
 m.CodeID5
) GMSView
ORDER BY OurID, DocID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11535001, 'Реестр: Продажа товара оператором', 11535, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID,
  m.TSumCC_wt AS TSumCC, (m.TSumCC_wt / KursMC) AS TSumMC, TRealSum, TLevySum,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.StateCode,
  m.CRID, r_CRs.CRName
FROM r_CRs INNER JOIN t_Sale m ON r_CRs.CRID = m.CRID

WHERE @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11540001, 'Реестр: Формирование себестоимости', 11540, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.TSumCC_wt AS TSumCC, (m.TSumCC_wt / KursMC) AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate, 
  m.SrcDocID, m.SrcDocDate, m.StateCode
FROM r_Comps c INNER JOIN t_Cos m ON c.CompID = m.CompID

WHERE @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11545001, 'Реестр: Приход товара по ГТД', 11545, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT
  m.ChID, m.OurID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.TSumAC_In AS TSumAC, (m.TSumAC_In / KursMC) AS TSumMC, (m.TSumAC_In * KursCC) AS TSumCC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate, 
  m.CurrID, m.KursCC, m.TSumAC_In
FROM r_Comps c INNER JOIN t_Cst m ON c.CompID = m.CompID

WHERE @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11546001, 'Реестр: Приход товара по ГТД (новый)', 11546, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT    m.ChID, m.OurID, m.DocDate, m.StockID, m.CompID, c.CompName, m.CurrID, c.City,    SUM(d.SumAC_In) AS TSumAC, SUM(d.SumCC_In) AS TSumCC, SUM(d.TaxSum) AS TTaxSum, SUM(d.SumCC_In/m.KursMC/m.KursCC)  AS TSumMC,    m.TTrtAC, m.TTrtCC, m.DocID, IntDocID, m.PayDelay, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.KursCC, m.TSumAC_In  
FROM r_Comps AS c INNER JOIN    t_Cst2 AS m ON c.CompID = m.CompID LEFT JOIN  t_Cst2D AS d ON m.ChID = d.ChID  
WHERE 
  m.DocDate BETWEEN dbo.zf_GetUserWorkAgeBegin(''t'') AND dbo.zf_GetUserWorkAgeEnd(''t'')  
GROUP BY    
  m.ChID, m.OurID, m.DocDate, m.StockID, m.CompID, c.CompName, m.CurrID, c.City,    
  m.TTrtAC, m.TTrtCC, m.DocID, IntDocID, m.PayDelay, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.KursCC, m.TSumAC_In ) GMSView  ORDER BY OurID, DocID
', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11551001, 'Реестр: Служебный приход денег', 11551, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID, m.OurID, m.CRID, cr.CRName, m.DocDate, m.DocID, m.SumCC, m.Notes, m.OperID,
  m.DocTime, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.StateCode, m.IntDocID
FROM t_MonIntRec m, r_CRs cr
WHERE cr.CRID = m.CRID AND @WorkAge@(m.DocDate)
) GMSView
ORDER BY OurID, ChID', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11552001, 'Реестр: Служебный расход денег', 11552, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID, m.OurID, m.CRID, cr.CRName, m.DocDate, m.DocID, m.SumCC, m.Notes, m.OperID,
  m.DocTime, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.StateCode, m.IntDocID
FROM t_MonIntExp m, r_CRs cr
WHERE cr.CRID = m.CRID AND @WorkAge@(m.DocDate)
) GMSView
ORDER BY OurID, ChID', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11560001, 'Реестр: Ресторан: Смена', 11560, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  ChID, OurID, DocID, DocDate, StockID,
  CodeID1, CodeID2, CodeID3, CodeID4, CodeID5,
  StateCode, ShiftOpenTime, ShiftCloseTime
FROM t_RestShift
WHERE @WorkAge@(DocDate)
) GMSView
ORDER BY OurID, DocID', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11601001, 'Реестр: Ресторан: Резервирование столиков', 11601, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT 
  m.ChID, m.OurID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, m.EmpID, e.EmpName, m.DeskCode,
  m.ResTime, p.PersonName, m.Visitors, m.SumPrePay,
  m.TSumCC_wt AS TSumCC, (CASE WHEN KursMC <> 0 THEN m.TSumCC_wt / KursMC ELSE 0 END) AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5 
FROM t_DeskRes m
  JOIN r_Emps e ON m.EmpID = e.EmpID
  JOIN r_Persons p ON m.PersonID = p.PersonID
WHERE 1 = 1
) GMSView
ORDER BY OurID, DocID
', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11711001, 'Реестр: Заказ внешний: Формирование', 11711, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  CASE WHEN m.KursMC <> 0 THEN (m.TSumAC / m.KursMC) ELSE 0 END TSumMC, 
  (m.TSumAC * m.KursCC) TSumCC,
  (m.TNewSumAC * m.KursCC) TNewSumCC,
  CASE WHEN m.KursMC <> 0 THEN (m.TNewSumAC / m.KursMC) ELSE 0 END TNewSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate, 
  m.OrdBDate, m.OrdEDate, m.OrdDayCount, m.StateCode
FROM (r_Comps c INNER JOIN t_EOExp m ON c.CompID = m.CompID)

WHERE @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11712001, 'Реестр: Заказ внешний: Обработка', 11712, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  (m.TSumAC/KursMC) AS TSumMC, (m.TSumAC*KursCC) AS TSumCC,
  m.EmpID, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate, 
  m.InDocID, m.StateCode
  FROM (r_Comps c INNER JOIN t_EORec m ON c.CompID = m.CompID)

WHERE @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11721001, 'Реестр: Заказ внутренний: Формирование', 11721, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.TSumCC_wt AS TSumCC,
  CASE WHEN dbo.zf_Var(''t_UseMultiCurrencies'') = ''1'' THEN 
	   CASE WHEN ((SELECT dbo.zf_GetRateCC(m.CurrID)) <> 0) AND (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC / (SELECT dbo.zf_GetRateCC(m.CurrID)) ELSE 0 END
  ELSE CASE WHEN (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC ELSE 0 END
	 END AS TSumMC,
  m.TNewSumCC_wt,
  CASE WHEN dbo.zf_Var(''t_UseMultiCurrencies'') = ''1'' THEN 
	   CASE WHEN ((SELECT dbo.zf_GetRateCC(m.CurrID)) <> 0) AND (m.KursMC <> 0) THEN m.TNewSumCC_wt / m.KursMC / (SELECT dbo.zf_GetRateCC(m.CurrID)) ELSE 0 END
  ELSE CASE WHEN (m.KursMC <> 0) THEN m.TNewSumCC_wt / m.KursMC ELSE 0 END
	 END AS TNewSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3,  m.CodeID4, m.CodeID5,
  m.EmpID, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate, m.StateCode
FROM r_Comps c INNER JOIN t_IORec m ON c.CompID = m.CompID

WHERE @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11722001, 'Реестр: Заказ внутренний: Обработка', 11722, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.CompID, c.CompName,
  m.TSumCC_wt, (m.TSumCC_wt / KursMC) AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.PayDelay, (m.DocDate + m.PayDelay) AS PayDocDate, 
  m.InDocID, m.StateCode
FROM (r_Comps c INNER JOIN t_IOExp m ON c.CompID = m.CompID)

WHERE @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11731001, 'Реестр: Распределение товара', 11731, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.CurrID,
  m.DocDate,
  m.DocID,
  m.StockID,
  m.CompID,
  c.CompName, m.StateCode
FROM t_Dis m INNER JOIN r_Comps c ON m.CompID = c.CompID 
WHERE @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11811001, 'Реестр: Планирование: Комплектация', 11811, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.SubStockID,
  m.TNewSumCC_wt AS TSumCC,
  CASE WHEN dbo.zf_Var(''t_UseMultiCurrencies'') = ''1'' THEN 
	   CASE WHEN ((SELECT dbo.zf_GetRateCC(m.CurrID)) <> 0) AND (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC / (SELECT dbo.zf_GetRateCC(m.CurrID)) ELSE 0 END
  ELSE CASE WHEN (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC ELSE 0 END
	 END AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode, s1.StockName, s2.StockName AS SubStockName
FROM t_SPRec m, r_Stocks s1, r_Stocks s2 
WHERE s1.StockID = m.StockID AND s2.StockID = m.SubStockID

  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11812001, 'Реестр: Планирование: Разукомплектация', 11812, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.SubStockID,
  m.TNewSumCC_wt AS TSumCC,
  CASE WHEN dbo.zf_Var(''t_UseMultiCurrencies'') = ''1'' THEN 
	   CASE WHEN ((SELECT dbo.zf_GetRateCC(m.CurrID)) <> 0) AND (m.KursMC <> 0) THEN m.TNewSumCC_wt / m.KursMC / (SELECT dbo.zf_GetRateCC(m.CurrID)) ELSE 0 END
  ELSE CASE WHEN (m.KursMC <> 0) THEN m.TNewSumCC_wt / m.KursMC ELSE 0 END
	 END AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode, s1.StockName, s2.StockName AS SubStockName
FROM t_SPExp m, r_Stocks s1, r_Stocks s2
WHERE s1.StockID = m.StockID AND s2.StockID = m.SubStockID

  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11821001, 'Реестр: Комплектация товара', 11821, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.SubStockID,
  m.TNewSumCC_wt AS TSumCC,
  CASE WHEN dbo.zf_Var(''t_UseMultiCurrencies'') = ''1'' THEN 
	   CASE WHEN ((SELECT dbo.zf_GetRateCC(m.CurrID)) <> 0) AND (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC / (SELECT dbo.zf_GetRateCC(m.CurrID)) ELSE 0 END
  ELSE CASE WHEN (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC ELSE 0 END
	 END AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode, s1.StockName AS StockName , s2.StockName AS SubStockName
FROM t_SRec m, r_Stocks s1, r_Stocks s2
WHERE s1.StockID = m.StockID AND s2.StockID = m.SubStockID

  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11822001, 'Реестр: Разукомплектация товара', 11822, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT
  m.ChID, m.OurID, m.CurrID, m.DocID, m.IntDocID, m.DocDate, m.StockID, m.SubStockID,
  m.TNewSumCC_wt AS TSumCC,
  CASE WHEN dbo.zf_Var(''t_UseMultiCurrencies'') = ''1'' THEN 
	   CASE WHEN ((SELECT dbo.zf_GetRateCC(m.CurrID)) <> 0) AND (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC / (SELECT dbo.zf_GetRateCC(m.CurrID)) ELSE 0 END
  ELSE CASE WHEN (m.KursMC <> 0) THEN m.TSumCC_wt / m.KursMC ELSE 0 END
	 END AS TSumMC,
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5,
  m.EmpID, m.StateCode, s1.StockName, s2.StockName AS SubStockName
FROM t_SExp m, r_Stocks s1, r_Stocks s2
WHERE  m.StockID = s1.StockID AND m.SubStockID = s2.StockID

  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocID
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11830001, 'Реестр: Калькуляционная карта', 11830, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT 
  m.ChID, m.DocID, m.IntDocID, m.DocDate, 
  m.OurID, o.OurName, m.EmpID, r_Emps.EmpName, m.Notes, 
  m.StateCode, r_States.StateName,   
  r_Prods.PCatID, r_ProdC.PCatName, 
  r_Prods.PGrID, r_ProdG.PGrName, 
  m.ProdID, 
  r_Prods.ProdName,   
  CAST (ISNULL((
      SELECT TOP 1 0
      FROM t_Spec n WITH (NOLOCK)
      WHERE (n.OurID = m.OurID AND n.ProdID = m.ProdID
                AND n.DocDate > m.DocDate
                AND n.DocDate <= dbo.zf_GetDate(GetDate())) OR m.DocDate > dbo.zf_GetDate(GetDate())), 1) AS bit) InUse
FROM t_Spec m WITH (NOLOCK)
INNER JOIN r_Ours o WITH (NOLOCK) ON m.OurID = o.OurID
INNER JOIN r_Emps WITH (NOLOCK) ON m.EmpID = r_Emps.EmpID 
INNER JOIN r_States WITH (NOLOCK) ON m.StateCode = r_States.StateCode
INNER JOIN r_Prods WITH (NOLOCK) ON m.ProdID = r_Prods.ProdID 
INNER JOIN r_ProdC WITH (NOLOCK) ON r_Prods.PCatID = r_ProdC.PCatID 
INNER JOIN r_ProdG WITH (NOLOCK) ON r_Prods.PGrID = r_ProdG.PGrID 
WHERE @WorkAge@(m.DocDate)) GMSView
', 3, 'tab_Comm', 'OurID;DocID', '', '', 0, 0, '', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11901001, 'Входящие остатки товара', 11901, 11901001, 1, 'Общие данные', 1, 1, 't_zInP', 1, 'tab_Comm', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11905001, 'Изменение цен прихода: Бизнес', 11905, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT m.ChID, ChDate, ChTime, m.ProdID, p.ProdName, OldCurrID, OldPriceMC, OldPriceMC_In, CurrID, PriceMC, PriceMC_In, m.OldPriceCC_In, m.PriceCC_In, m.OldPriceAC_In, m.PriceAC_In, m.UserID, u.UserName
FROM t_pInPCh m, r_Prods p, r_Users u 
WHERE p.ProdID = m.ProdID AND u.UserID = m.UserID
) GMSView
ORDER BY ChDate, ChTime
', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11911001, 'Остатки товара по количеству', 11911, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  Sum(Qty-AccQty) RemQty,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_Rem r WITH(NOLOCK) INNER JOIN r_Prods p WITH(NOLOCK) ON r.ProdID = p.ProdID
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
) GMSView
ORDER BY OurID, StockID, SecID, ProdID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11912001, 'Остатки товара по количеству с резервами', 11912, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  Sum(r.Qty) WOAccQty,
  Sum(r.AccQty) AccQty,
  Sum(Qty-AccQty) RemQty,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_Rem r WITH(NOLOCK) INNER JOIN r_Prods p WITH(NOLOCK) ON r.ProdID = p.ProdID
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
) GMSView
ORDER BY OurID, StockID, SecID, ProdID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11913001, 'Остатки товара в ценах прихода', 11913, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  Sum(Qty - AccQty) RemQty,
  pp.PriceMC, Sum((Qty - AccQty) * PriceMC) RemSumMC,
  pp.PriceCC_In PriceCC, Sum((Qty - AccQty) * PriceCC_In) RemSumCC,
  r.PPID, pp.CompID,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_Rem r, t_PInPs pp, r_Prods p
WHERE r.ProdID = pp.ProdID AND r.PPID = pp.PPID AND p.ProdID = r.ProdID
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID,
  pp.PriceMC, pp.PriceCC_In,
  r.PPID, pp.CompID
) GMSView
ORDER BY OurID, StockID, SecID, ProdID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11914001, 'Остатки товара в ценах прихода с резервами', 11914, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  pp.PriceMC, pp.PriceCC_In PriceCC,
  Sum(r.Qty) WOAccQty,
  Sum(Qty * PriceMC) WOAccSumMC,
  Sum(Qty * PriceCC_In) WOAccSumCC,
  Sum(r.AccQty) AccQty,
  Sum(AccQty * PriceMC) AccSumMC,
  Sum(AccQty * PriceCC_In) AccSumCC,
  Sum(Qty - AccQty) RemQty,
  Sum((Qty - AccQty) * PriceMC) RemSumMC,
  Sum((Qty - AccQty) * PriceCC_In) RemSumCC,
  r.PPID, pp.CompID,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_Rem r, r_Prods p, t_PInPs pp
WHERE r.ProdID = pp.ProdID AND r.PPID = pp.PPID AND p.ProdID = r.ProdID
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID,
  pp.PriceMC, pp.PriceCC_In,
  r.PPID, pp.CompID
) GMSView
ORDER BY OurID, StockID, SecID, ProdID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11915001, 'Остатки товара в ценах продажи', 11915, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  Sum(Qty - AccQty) RemQty,
  pp.PriceMC, Sum((Qty - AccQty) * PriceMC) RemSumMC,
  pp.PriceCC, Sum((Qty - AccQty) * PriceCC) RemSumCC,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_Rem r, r_Prods p, r_ProdMPs pp
WHERE p.ProdID = r.ProdID AND pp.ProdID = r.ProdID AND pp.PLID = @PLID@
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID,
  pp.PriceMC, pp.PriceCC, pp.PLID
) GMSView
ORDER BY OurID, StockID, SecID, ProdID
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11916001, 'Остатки товара в ценах продажи с резервами', 11916, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  pp.PriceMC, pp.PriceCC,
  Sum(r.Qty) WOAccQty,
  Sum(Qty * PriceMC) WOAccSumMC,
  Sum(Qty * PriceCC) WOAccSumCC,
  Sum(r.AccQty) AccQty,
  Sum(AccQty * PriceMC) AccSumMC,
  Sum(AccQty * PriceCC) AccSumCC,
  Sum(Qty - AccQty) RemQty,
  Sum((Qty - AccQty) * PriceMC) RemSumMC,
  Sum((Qty - AccQty) * PriceCC) RemSumCC,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_Rem r, r_Prods p, r_ProdMPs pp
WHERE p.ProdID = r.ProdID AND pp.ProdID = r.ProdID AND pp.PLID = @PLID@
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID,
  pp.PriceMC, pp.PriceCC, pp.PLID
) GMSView
ORDER BY OurID, StockID, SecID, ProdID
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11917001, 'Резервы товара по счетам в ценах прихода', 11917, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  Sum(AccQty) AccQty,
  pp.PriceMC, Sum(AccQty * PriceMC) AccSumMC,
  pp.PriceCC_In PriceCC, Sum(AccQty * PriceCC_In) AccSumCC,
  r.PPID, pp.CompID,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_Rem r, t_PInPs pp, r_Prods p
WHERE r.ProdID = pp.ProdID AND r.PPID = pp.PPID AND p.ProdID = r.ProdID
  AND AccQty <> 0
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID,
  pp.PriceMC, pp.PriceCC_In,
  r.PPID, pp.CompID
) GMSView
ORDER BY OurID, StockID, SecID, ProdID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11918001, 'Резервы товара по счетам в ценах продажи', 11918, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  Sum(AccQty) AccQty,
  pp.PriceMC, Sum(AccQty * PriceMC) AccSumMC,
  pp.PriceCC, Sum(AccQty * PriceCC) AccSumCC,
  pp.PLID,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_Rem r, r_Prods p, r_ProdMPs pp
WHERE p.ProdID = r.ProdID AND pp.ProdID = r.ProdID
  AND AccQty <> 0 AND pp.PLID = @PLID@
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID,
  pp.PriceMC, pp.PriceCC, pp.PLID
) GMSView
ORDER BY OurID, StockID, SecID, ProdID
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11921001, 'Остатки товара на дату по количеству', 11921, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  Sum(Qty - AccQty) RemQty,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_RemD r WITH(NOLOCK) INNER JOIN r_Prods p WITH(NOLOCK) ON r.ProdID = p.ProdID
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
) GMSView
ORDER BY OurID, StockID, SecID, ProdID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11921002, 'Остатки товара на дату по количеству: Информация', 11921, 0, 2, 'Информация', 2, 1, 'SELECT * FROM (SELECT TOP 1 EDate RemDate, DocDate CalcDate FROM z_LogAU WHERE AUGroupCode = 1 AND UserCode = dbo.zf_GetUserCode() ORDER BY DocDate DESC, LogID DESC) GMSView', 3, '', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11922001, 'Остатки товара на дату по количеству с резервами', 11922, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  Sum(r.Qty) WOAccQty,
  Sum(r.AccQty) AccQty,
  Sum(Qty-AccQty) RemQty,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_RemD r WITH(NOLOCK) INNER JOIN r_Prods p WITH(NOLOCK) ON r.ProdID = p.ProdID
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
) GMSView
ORDER BY OurID, StockID, SecID, ProdID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11922002, 'Остатки товара на дату по количеству с резервами: Информация', 11922, 0, 2, 'Информация', 2, 1, 'SELECT * FROM (SELECT TOP 1 EDate RemDate, DocDate CalcDate FROM z_LogAU WHERE AUGroupCode = 1 AND UserCode = dbo.zf_GetUserCode() ORDER BY DocDate DESC, LogID DESC) GMSView', 3, '', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11923001, 'Остатки товара на дату в ценах прихода', 11923, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  Sum(Qty - AccQty) RemQty,
  pp.PriceMC, Sum((Qty - AccQty) * PriceMC) RemSumMC,
  pp.PriceCC_In PriceCC, Sum((Qty - AccQty) * PriceCC_In) RemSumCC,
  r.PPID, pp.CompID,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_RemD r, t_PInPs pp, r_Prods p
WHERE r.ProdID = pp.ProdID AND r.PPID = pp.PPID AND p.ProdID = r.ProdID
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID,
  pp.PriceMC, pp.PriceCC_In,
  r.PPID, pp.CompID
) GMSView
ORDER BY OurID, StockID, SecID, ProdID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11923002, 'Остатки товара на дату в ценах прихода: Информация', 11923, 0, 2, 'Информация', 2, 1, 'SELECT * FROM (SELECT TOP 1 EDate RemDate, DocDate CalcDate FROM z_LogAU WHERE AUGroupCode = 1 AND UserCode = dbo.zf_GetUserCode() ORDER BY DocDate DESC, LogID DESC) GMSView', 3, '', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11924001, 'Остатки товара на дату в ценах прихода с резервами', 11924, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  pp.PriceMC, pp.PriceCC_In PriceCC,
  Sum(r.Qty) WOAccQty,
  Sum(Qty * PriceMC) WOAccSumMC,
  Sum(Qty * PriceCC_In) WOAccSumCC,
  Sum(r.AccQty) AccQty,
  Sum(AccQty * PriceMC) AccSumMC,
  Sum(AccQty * PriceCC_In) AccSumCC,
  Sum(Qty - AccQty) RemQty,
  Sum((Qty - AccQty) * PriceMC) RemSumMC,
  Sum((Qty - AccQty) * PriceCC_In) RemSumCC,
  r.PPID, pp.CompID,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_RemD r, r_Prods p, t_PInPs pp
WHERE r.ProdID = pp.ProdID AND r.PPID = pp.PPID AND p.ProdID = r.ProdID
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID,
  pp.PriceMC, pp.PriceCC_In,
  r.PPID, pp.CompID
) GMSView
ORDER BY OurID, StockID, SecID, ProdID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11924002, 'Остатки товара на дату в ценах прихода с резервами: Информация', 11924, 0, 2, 'Информация', 2, 1, 'SELECT * FROM (SELECT TOP 1 EDate RemDate, DocDate CalcDate FROM z_LogAU WHERE AUGroupCode = 1 AND UserCode = dbo.zf_GetUserCode() ORDER BY DocDate DESC, LogID DESC) GMSView', 3, '', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11925001, 'Остатки товара на дату в ценах продажи', 11925, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  Sum(Qty - AccQty) RemQty,
  pp.PriceMC, Sum((Qty - AccQty) * PriceMC) RemSumMC,
  pp.PriceCC, Sum((Qty - AccQty) * PriceCC) RemSumCC,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_RemD r, r_Prods p, r_ProdMPs pp
WHERE p.ProdID = r.ProdID AND pp.ProdID = r.ProdID AND pp.PLID = @PLID@
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID,
  pp.PriceMC, pp.PriceCC, pp.PLID
) GMSView
ORDER BY OurID, StockID, SecID, ProdID
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11925002, 'Остатки товара на дату в ценах продажи: Информация', 11925, 0, 2, 'Информация', 2, 1, 'SELECT * FROM (SELECT TOP 1 EDate RemDate, DocDate CalcDate FROM z_LogAU WHERE AUGroupCode = 1 AND UserCode = dbo.zf_GetUserCode() ORDER BY DocDate DESC, LogID DESC) GMSView', 3, '', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11926001, 'Остатки товара на дату в ценах продажи с резервами', 11926, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  pp.PriceMC, pp.PriceCC,
  Sum(r.Qty) WOAccQty,
  Sum(Qty * PriceMC) WOAccSumMC,
  Sum(Qty * PriceCC) WOAccSumCC,
  Sum(r.AccQty) AccQty,
  Sum(AccQty * PriceMC) AccSumMC,
  Sum(AccQty * PriceCC) AccSumCC,
  Sum(Qty - AccQty) RemQty,
  Sum((Qty - AccQty) * PriceMC) RemSumMC,
  Sum((Qty - AccQty) * PriceCC) RemSumCC,
  pp.PLID,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_RemD r, r_Prods p, r_ProdMPs pp
WHERE p.ProdID = r.ProdID AND pp.ProdID = r.ProdID AND pp.PLID = @PLID@
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID,
  pp.PriceMC, pp.PriceCC, pp.PLID
) GMSView
ORDER BY OurID, StockID, SecID, ProdID
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11926002, 'Остатки товара на дату в ценах продажи с резервами: Информация', 11926, 0, 2, 'Информация', 2, 1, 'SELECT * FROM (SELECT TOP 1 EDate RemDate, DocDate CalcDate FROM z_LogAU WHERE AUGroupCode = 1 AND UserCode = dbo.zf_GetUserCode() ORDER BY DocDate DESC, LogID DESC) GMSView', 3, '', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11927001, 'Остатки товара с истекающим сроком хранения', 11927, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  pp.PriceMC, pp.PriceCC_In PriceCC,
  Sum(r.Qty) WOAccQty,
  Sum(Qty * PriceMC) WOAccSumMC,
  Sum(Qty * PriceCC_In) WOAccSumCC,
  Sum(r.AccQty) AccQty,
  Sum(AccQty * PriceMC) AccSumMC,
  Sum(AccQty * PriceCC_In) AccSumCC,
  Sum(Qty - AccQty) RemQty,
  Sum((Qty - AccQty) * PriceMC) RemSumMC,
  Sum((Qty - AccQty) * PriceCC_In) RemSumCC,
  r.PPID, pp.CompID,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID
FROM t_Rem r, r_Prods p, t_PInPs pp
WHERE r.ProdID = pp.ProdID AND r.PPID = pp.PPID AND p.ProdID = r.ProdID
  AND pp.ProdDate >= GETDATE() AND DATEDIFF(dd, GETDATE(), pp.ProdDate ) <= 10
GROUP BY
  r.OurID, r.StockID, r.SecID, r.ProdID, p.ProdName, p.UM,
  p.PCatID, p.PGrID, p.PGrID1, p.PGrID2, p.PGrID3, p.PGrAID, p.PBGrID,
  pp.PriceMC, pp.PriceCC_In,
  r.PPID, pp.CompID
) GMSView
ORDER BY OurID, StockID, SecID, ProdID
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11951001, 'Z-отчеты', 11951, 11951001, 1, 'Общие данные', 1, 1, 't_zRep', 1, 'tab_Comm', 'CRID;DocTime', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (11952001, 'Z-отчеты плат. терминалов', 11952, 11952001, 1, 'Общие данные', 1, 1, 't_ZRepT', 1, 'tab_Comm', 'POSPayID;DocTime', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12001001, 'Приход денег по предприятиям', 12001, 12001001, 1, 'Общие данные', 1, 1, 'c_CompRec', 1, 'tab_Comm', 'ChID;OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12002001, 'Расход денег по предприятиям', 12002, 12002001, 1, 'Общие данные', 1, 1, 'c_CompExp', 1, 'tab_Comm', 'ChID;OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12003001, 'Обмен валюты по предприятиям', 12003, 12003001, 1, 'Общие данные', 1, 1, 'c_CompCurr', 1, 'tab_Comm', 'ChID;OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12004001, 'Корректировка баланса предприятия', 12004, 12004001, 1, 'Общие данные', 1, 1, 'c_CompCor', 1, 'tab_Comm', 'ChID;OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12011001, 'Приход денег по служащим', 12011, 12011001, 1, 'Общие данные', 1, 1, 'c_EmpRec', 1, 'tab_Comm', 'ChID;OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12012001, 'Расход денег по служащим', 12012, 12012001, 1, 'Общие данные', 1, 1, 'c_EmpExp', 1, 'tab_Comm', 'ChID;OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12013001, 'Обмен валюты по служащим', 12013, 12013001, 1, 'Общие данные', 1, 1, 'c_EmpCurr', 1, 'tab_Comm', 'ChID;OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12014001, 'Корректировка баланса служащего', 12014, 12014001, 1, 'Общие данные', 1, 1, 'c_EmpCor', 1, 'tab_Comm', 'ChID;OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12015001, 'Перемещение денег между служащими', 12015, 12015001, 1, 'Общие данные', 1, 1, 'c_EmpExc', 1, 'tab_Comm', 'ChID;OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12016001, 'Начисление денег служащим: Заголовок', 12016, 12016001, 1, 'Заголовок', 0, 0, 'c_Sal', 1, '', 'ChID;OurID;DocID', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12016002, 'Начисление денег служащим: Данные', 12016, 12016002, 2, 'Данные', 1, 1, 'c_SalD', 1, 'TabSheet1', 'ChID;EmpID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12017001, 'Отчет служащего', 12017, 12017001, 1, 'Общие данные', 1, 1, 'c_EmpRep', 1, 'tab_Comm', 'ChID;OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12021001, 'Корректировка баланса денег', 12021, 12021001, 1, 'Общие данные', 1, 1, 'c_OurCor', 1, 'tab_Comm', 'ChID;OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12022001, 'Планирование: Доходы', 12022, 12022001, 1, 'Общие данные', 1, 1, 'c_PlanRec', 1, 'tab_Comm', 'ChID;OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12023001, 'Планирование: Расходы', 12023, 12023001, 1, 'Общие данные', 1, 1, 'c_PlanExp', 1, 'tab_Comm', 'ChID;OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12501001, 'Реестр: Приход денег по предприятиям', 12501, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.AccountAC, m.DocID, m.StockID, StockName, m.CompID, CompName,
  m.CurrID, c1.CurrName, m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, m.Subject,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5,
  m.EmpID, e1.EmpName
FROM 
  c_CompRec m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Currs c1,
  r_Comps,
  r_Emps e1
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND c1.CurrID = m.CurrID
  AND r_Comps.CompID = m.CompID
  AND e1.EmpID = m.EmpID
  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocDate, DocID
', 3, 'tab_Comm', 'ChID', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12502001, 'Реестр: Расход денег по предприятиям', 12502, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.AccountAC, m.DocID, m.StockID, StockName,  m.CompID, CompName,
  m.CurrID, c1.CurrName, m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, m.Subject,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5,
  m.EmpID, e1.EmpName
FROM 
  c_CompExp m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Currs c1,
  r_Comps,
  r_Emps e1
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND c1.CurrID = m.CurrID
  AND r_Comps.CompID = m.CompID
  AND e1.EmpID = m.EmpID
  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocDate, DocID
', 3, 'tab_Comm', 'ChID', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12503001, 'Реестр: Обмен валюты по предприятиям', 12503, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.AccountAC, m.NewAccountAC, m.DocID, m.StockID, StockName,  m.CompID, CompName,
  m.CurrID, c1.CurrName, m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, m.Subject,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5,
  NewCurrID, c2.CurrName NewCurrName, NewSumAC, NewKursMC, m.NewSumAC / m.NewKursMC NewSumMC, NewKursCC, m.NewSumAC * m.NewKursCC NewSumCC
FROM 
  c_CompCurr m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Currs c1, r_Currs c2,
  r_Comps
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND c1.CurrID = m.CurrID
  AND r_Comps.CompID = m.CompID
  AND c2.CurrID = m.NewCurrID
  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocDate, DocID
', 3, 'tab_Comm', 'ChID', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12504001, 'Реестр: Корректировка баланса предприятия', 12504, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.DocID, m.StockID, StockName,  m.CompID, CompName,
  m.CurrID, c1.CurrName, m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, m.Subject,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5
FROM 
  c_CompCor m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Currs c1,
  r_Comps
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND c1.CurrID = m.CurrID
  AND r_Comps.CompID = m.CompID
  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocDate, DocID', 3, 'tab_Comm', 'ChID', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12511001, 'Реестр: Приход денег по служащим', 12511, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.AccountAC, m.DocID, m.StockID, StockName,
  m.CurrID, c1.CurrName, m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, m.Subject,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5,
  m.EmpID, e1.EmpName
FROM 
  c_EmpRec m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Currs c1,
  r_Emps e1
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND c1.CurrID = m.CurrID
  AND e1.EmpID = m.EmpID
  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocDate, DocID
', 3, 'tab_Comm', 'ChID', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12512001, 'Реестр: Расход денег по служащим', 12512, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.AccountAC, m.DocID, m.StockID, StockName,
  m.CurrID, c1.CurrName, m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, m.Subject,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5,
  m.EmpID, e1.EmpName
FROM 
  c_EmpExp m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Currs c1,
  r_Emps e1
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND c1.CurrID = m.CurrID
  AND e1.EmpID = m.EmpID
  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocDate, DocID
', 3, 'tab_Comm', 'ChID', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12513001, 'Реестр: Обмен валюты по служащим', 12513, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.AccountAC, m.NewAccountAC, m.DocID, m.StockID, StockName,
  m.CurrID, c1.CurrName, m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, m.Subject,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5,
  m.EmpID, e1.EmpName,
  NewCurrID, c2.CurrName NewCurrName, NewSumAC, NewKursMC, m.NewSumAC / m.NewKursMC NewSumMC, NewKursCC, m.NewSumAC * m.NewKursCC NewSumCC
FROM 
  c_EmpCurr m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Currs c1, r_Currs c2,
  r_Emps e1
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND c1.CurrID = m.CurrID
  AND e1.EmpID = m.EmpID
  AND c2.CurrID = m.NewCurrID
  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocDate, DocID
', 3, 'tab_Comm', 'ChID', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12514001, 'Реестр: Корректировка баланса служащего', 12514, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.DocID, m.StockID, StockName,
  m.CurrID, c1.CurrName, m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, m.Subject,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5,
  m.EmpID, e1.EmpName
FROM 
  c_EmpCor m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Currs c1,
  r_Emps e1
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND c1.CurrID = m.CurrID
  AND e1.EmpID = m.EmpID
  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocDate, DocID', 3, 'tab_Comm', 'ChID', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12515001, 'Реестр: Перемещение денег между служащими', 12515, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.DocID, m.StockID, StockName,
  m.CurrID, c1.CurrName, m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, m.Subject,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5,
  m.EmpID, e1.EmpName,
  m.NewEmpID, e2.EmpName NewEmpName
FROM 
  c_EmpExc m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Currs c1,
  r_Emps e1,
  r_Emps e2
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND c1.CurrID = m.CurrID
  AND e1.EmpID = m.EmpID
  AND e2.EmpID = m.NewEmpID
  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocDate, DocID', 3, 'tab_Comm', 'ChID', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12516001, 'Реестр: Начисление денег служащим', 12516, 0, 1, 'Общие данные', 1, 1, 'SELECT *
FROM (
  SELECT m.ChID
   ,m.DocID
   ,m.OurID
   ,o.OurName
   ,m.StockID
   ,s.StockName
   ,m.DocDate
   ,m.CodeID1
   ,m.CodeID2
   ,m.CodeID3
   ,m.CodeID4
   ,m.CodeID5
   ,m.StateCode
   ,st.StateName
   ,SUM(ISNULL(d.OutAC / d.KursMC, 0)) AS TSumMC
   ,SUM(ISNULL(d.OutAC * d.KursCC, 0)) AS TSumCC
   ,SUM(OutAC) AS TSumAC
   ,COUNT(*) AS EmpCount
 FROM c_Sal m WITH (NOLOCK)
 INNER JOIN c_SalD d WITH (NOLOCK) ON d.ChID = m.ChID
 INNER JOIN r_Ours o WITH (NOLOCK) ON o.OurID = m.OurID
 INNER JOIN r_Stocks s WITH (NOLOCK) ON s.StockID = m.StockID
 INNER JOIN r_States st WITH (NOLOCK) ON st.StateCode = m.StateCode
 WHERE @WorkAge@(m.DocDate)
 GROUP BY m.ChID
   ,m.DocID
   ,m.OurID
   ,o.OurName
   ,m.StockID
   ,s.StockName
   ,m.DocDate
   ,m.CodeID1
   ,m.CodeID2
   ,m.CodeID3
   ,m.CodeID4
   ,m.CodeID5
   ,m.StateCode
   ,st.StateName
 ) GMSView
ORDER BY OurID, DocID
', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12517001, 'Реестр: Отчет служащего', 12517, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.DocID, m.StockID, StockName,  m.CompID, CompName,
  m.CurrID, c1.CurrName, m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, m.Subject,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5,
  m.EmpID, e1.EmpName
FROM 
  c_EmpRep m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Currs c1,
  r_Comps,
  r_Emps e1
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND c1.CurrID = m.CurrID
  AND r_Comps.CompID = m.CompID
  AND e1.EmpID = m.EmpID
  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocDate, DocID', 3, 'tab_Comm', 'ChID', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12521001, 'Реестр: Корректировка баланса денег', 12521, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.AccountAC, m.DocID, m.StockID, StockName,
  m.CurrID, c1.CurrName, m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, m.Subject,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5
FROM 
  c_OurCor m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Currs c1
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND c1.CurrID = m.CurrID
  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocDate, DocID
', 3, 'tab_Comm', 'ChID', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12522001, 'Реестр: Планирование: Доходы', 12522, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.DocID, m.StockID, StockName,  m.CompID, CompName,
  m.CurrID, c1.CurrName, m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, m.Subject,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5,
  m.EmpID, e1.EmpName
FROM 
  c_PlanRec m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Currs c1,
  r_Comps,
  r_Emps e1
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND c1.CurrID = m.CurrID
  AND r_Comps.CompID = m.CompID
  AND e1.EmpID = m.EmpID
  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocDate, DocID', 3, 'tab_Comm', 'ChID', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12523001, 'Реестр: Планирование: Расходы', 12523, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.DocID, m.StockID, StockName,  m.CompID, CompName,
  m.CurrID, c1.CurrName, m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, m.Subject,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5,
  m.EmpID, e1.EmpName
FROM 
  c_PlanExp m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Currs c1,
  r_Comps,
  r_Emps e1
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND c1.CurrID = m.CurrID
  AND r_Comps.CompID = m.CompID
  AND e1.EmpID = m.EmpID
  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocDate, DocID', 3, 'tab_Comm', 'ChID', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12901001, 'Входящий баланс: Касса (Финансы)', 12901, 12901001, 1, 'Общие данные', 1, 1, 'c_OurIn', 1, 'tab_Comm', 'ChID;OurID;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12902001, 'Входящий баланс: Предприятия (Финансы)', 12902, 12902001, 1, 'Общие данные', 1, 1, 'c_CompIn', 1, 'tab_Comm', 'ChID;OurID;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (12903001, 'Входящий баланс: Служащие (Финансы)', 12903, 12903001, 1, 'Общие данные', 1, 1, 'c_EmpIn', 1, 'tab_Comm', 'ChID;OurID;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14001001, 'Счет на оплату: Заголовок', 14001, 14001001, 1, 'Заголовок', 0, 1, 'b_Acc', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14001002, 'Счет на оплату: ТМЦ', 14001, 14001002, 2, 'ТМЦ', 1, 1, 'b_AccD', 1, 'tab_Comm', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14010001, 'Платежное поручение: Заголовок', 14010, 14010001, 1, 'Заголовок', 0, 1, 'b_BankPayCC', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14011001, 'Расчетный счет: Приход', 14011, 14011001, 1, 'Общие данные', 1, 1, 'b_BankRecCC', 1, 'tab_Comm', 'ChID;OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14012001, 'Расчетный счет: Расход', 14012, 14012001, 1, 'Общие данные', 1, 1, 'b_BankExpCC', 1, 'tab_Comm', 'ChID;OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14020001, 'Валютное платежное поручение: Заголовок', 14020, 14020001, 1, 'Заголовок', 0, 1, 'b_BankPayAC', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14021001, 'Валютный счет: Приход', 14021, 14021001, 1, 'Общие данные', 1, 1, 'b_BankRecAC', 1, 'tab_Comm', 'ChID;OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14022001, 'Валютный счет: Расход', 14022, 14022001, 1, 'Общие данные', 1, 1, 'b_BankExpAC', 1, 'tab_Comm', 'ChID;OurID;DocDate;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14031001, 'Кассовый ордер: Приход: Заголовок', 14031, 14031001, 1, 'Заголовок', 0, 1, 'b_CRec', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14032001, 'Кассовый ордер: Расход: Заголовок', 14032, 14032001, 1, 'Заголовок', 0, 1, 'b_CExp', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14101001, 'ТМЦ: Счет на оплату: Заголовок', 14101, 14101001, 1, 'Заголовок', 0, 1, 'b_PAcc', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14101002, 'ТМЦ: Счет на оплату: ТМЦ', 14101, 14101002, 2, 'ТМЦ', 1, 1, 'b_PAccD', 1, 'tab_Comm', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14102001, 'ТМЦ: Приход по накладной: Заголовок', 14102, 14102001, 1, 'Заголовок', 0, 1, 'b_Rec', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14102002, 'ТМЦ: Приход по накладной: ТМЦ', 14102, 14102002, 2, 'ТМЦ', 1, 1, 'b_RecD', 1, 'TabSheet1', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14103001, 'ТМЦ: Возврат от получателя: Заголовок', 14103, 14103001, 1, 'Заголовок', 0, 1, 'b_Ret', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14103002, 'ТМЦ: Возврат от получателя: ТМЦ', 14103, 14103002, 2, 'ТМЦ', 1, 1, 'b_RetD', 1, 'TabSheet1', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14103003, 'ТМЦ: Возврат от получателя: Сборы по товару', 14103, 14103003, 3, 'Сборы по товару', 1, 1, 'b_RetDLV', 1, '', 'ChID;SrcPosID;LevyID', '', '', 0, 0, 'ТМЦ: Возврат от получателя: ТМЦ', 'ChID;SrcPosID', 1, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14111001, 'ТМЦ: Расходная накладная: Заголовок', 14111, 14111001, 1, 'Заголовок', 0, 1, 'b_Inv', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14111002, 'ТМЦ: Расходная накладная: ТМЦ', 14111, 14111002, 2, 'ТМЦ', 1, 1, 'b_InvD', 1, 'TabSheet1', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14111003, 'ТМЦ: Расходная накладная: Сборы по товару', 14111, 14111003, 3, 'Сборы по товару', 1, 1, 'b_InvDLV', 1, '', 'ChID;SrcPosID;LevyID', '', '', 0, 0, 'ТМЦ: Расходная накладная: ТМЦ', 'ChID;SrcPosID', 1, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14112001, 'ТМЦ: Внутренний расход: ТМЦ', 14112, 14112002, 2, 'ТМЦ', 1, 1, 'b_ExpD', 1, 'TabSheet1', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14112004, 'ТМЦ: Внутренний расход: Заголовок', 14112, 14112001, 1, 'Заголовок', 0, 1, 'b_Exp', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14112005, 'ТМЦ: Внутренний расход: Сборы по товару', 14112, 14112003, 3, 'Сборы по товару', 1, 1, 'b_ExpDLV', 1, '', 'ChID;SrcPosID;LevyID', '', '', 0, 0, 'ТМЦ: Внутренний расход: ТМЦ', 'ChID;SrcPosID', 1, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14113001, 'ТМЦ: Возврат поставщику: Заголовок', 14113, 14113001, 1, 'Заголовок', 0, 1, 'b_CRet', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14113002, 'ТМЦ: Возврат поставщику: ТМЦ', 14113, 14113002, 2, 'ТМЦ', 1, 1, 'b_CRetD', 1, 'TabSheet1', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14121001, 'ТМЦ: Перемещение: Заголовок', 14121, 14121001, 1, 'Заголовок', 0, 1, 'b_PExc', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14121002, 'ТМЦ: Перемещение: ТМЦ', 14121, 14121002, 2, 'ТМЦ', 1, 1, 'b_PExcD', 1, 'TabSheet1', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14122001, 'ТМЦ: Инвентаризация: Заголовок', 14122, 14122001, 1, 'Заголовок', 0, 1, 'b_PVen', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14122002, 'ТМЦ: Инвентаризация: Итоги', 14122, 14122002, 2, 'Итоги', 1, 1, 'b_PVenA', 1, 'TabSheet1', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14122003, 'ТМЦ: Инвентаризация: ТМЦ', 14122, 14122003, 3, 'ТМЦ', 0, 1, 'b_PVenD', 1, 'TabSheet1', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14123001, 'ТМЦ: Переоценка партий: Заголовок', 14123, 14123001, 1, 'Заголовок', 0, 1, 'b_PEst', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14123002, 'ТМЦ: Переоценка партий: ТМЦ', 14123, 14123002, 2, 'ТМЦ', 1, 1, 'b_PEstD', 1, 'TabSheet1', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14125001, 'ТМЦ: Формирование себестоимости: Заголовок', 14125, 14125001, 1, 'Заголовок', 1, 1, 'b_PCost', 1, '', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14125002, 'ТМЦ: Формирование себестоимости: ТМЦ', 14125, 14125002, 2, 'ТМЦ', 1, 1, 'b_PCostD', 1, 'TabSheet1', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14125003, 'ТМЦ: Формирование себестоимости: Прочие расходы', 14125, 14125003, 3, 'Прочие расходы', 1, 1, 'b_PCostDExp', 1, 'TabSheet5', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14125004, 'ТМЦ: Формирование себестоимости: Списание ТМЦ по позиции', 14125, 14125004, 4, 'Списание ТМЦ по позиции', 1, 1, 'b_PCostDDExpProds', 1, 'Списание ТМЦ по позиции', 'AChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'AChID', 0, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14125005, 'ТМЦ: Формирование себестоимости: Прочие расходы по позиции', 14125, 14125005, 5, 'Прочие расходы по позиции', 1, 1, 'b_PCostDDExp', 1, 'Прочие расходы по позиции', 'AChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'AChID', 0, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14131001, 'ТМЦ: Приход по ГТД: Заголовок', 14131, 14131001, 1, 'Заголовок', 0, 1, 'b_Cst', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14131002, 'ТМЦ: Приход по ГТД: ТМЦ', 14131, 14131002, 2, 'ТМЦ', 1, 1, 'b_CstD', 1, 'TabSheet1', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14132001, 'ТМЦ: Расход по ГТД: Заголовок', 14132, 14132001, 1, 'Заголовок', 0, 1, 'b_CInv', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14132002, 'ТМЦ: Расход по ГТД: ТМЦ', 14132, 14132002, 2, 'ТМЦ', 1, 1, 'b_CInvD', 1, 'TabSheet1', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14141001, 'ТМЦ: Суммовой учет', 14141, 14141001, 1, 'Общие данные', 1, 1, 'b_DStack', 1, 'tab_Comm', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14142001, 'ТМЦ: Проводка', 14142, 14142001, 1, 'Общие данные', 1, 1, 'b_TranP', 1, 'tab_Comm', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14201001, 'Основные средства: Приход: Заголовок', 14201, 14201001, 1, 'Заголовок', 0, 1, 'b_SRec', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14201002, 'Основные средства: Приход: ОС', 14201, 14201002, 2, 'ОС', 1, 1, 'b_SRecD', 1, 'tab_Comm', 'ChID;SrcPosID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14202001, 'Основные средства: Ввод в эксплуатацию: Заголовок', 14202, 14202001, 1, 'Заголовок', 0, 1, 'b_SPut', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14202002, 'Основные средства: Ввод в эксплуатацию: ОС', 14202, 14202002, 2, 'ОС', 1, 1, 'b_SPutD', 1, 'tab_Comm', 'ChID;SrcPosID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14203001, 'Основные средства: Амортизация: Заголовок', 14203, 14203001, 1, 'Заголовок', 0, 1, 'b_SDep', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14203002, 'Основные средства: Амортизация: ОС', 14203, 14203002, 2, 'ОС', 1, 1, 'b_SDepD', 1, 'tab_Comm', 'ChID;SrcPosID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14204001, 'Основные средства: Износ: Заголовок', 14204, 14204001, 1, 'Заголовок', 0, 1, 'b_SWer', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14204002, 'Основные средства: Износ: ОС', 14204, 14204002, 2, 'ОС', 1, 1, 'b_SWerD', 1, 'tab_Comm', 'ChID;SrcPosID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14205001, 'Основные средства: Ремонт: Заголовок', 14205, 14205001, 1, 'Заголовок', 0, 1, 'b_SRep', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14205002, 'Основные средства: Ремонт: Общие затраты', 14205, 14205002, 2, 'Общие затраты', 1, 1, 'b_SRepDV', 1, 'tab_V', 'ChID;VSrcPosID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14205003, 'Основные средства: Ремонт: ТМЦ', 14205, 14205003, 3, 'ТМЦ', 1, 1, 'b_SRepDP', 1, 'tab_P', 'ChID;SrcPosID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14206001, 'Основные средства: Продажа: Заголовок', 14206, 14206001, 1, 'Заголовок', 0, 1, 'b_SInv', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14206002, 'Основные средства: Продажа: ОС', 14206, 14206002, 2, 'ОС', 1, 1, 'b_SInvD', 1, 'tab_Comm', 'ChID;SrcPosID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14207001, 'Основные средства: Списание: Заголовок', 14207, 14207001, 1, 'Заголовок', 0, 1, 'b_SExp', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14207002, 'Основные средства: Списание: ОС', 14207, 14207002, 2, 'ОС', 1, 1, 'b_SExpD', 1, 'tab_Comm', 'ChID;SrcPosID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14208001, 'Основные средства: Перемещение: Заголовок', 14208, 14208001, 1, 'Заголовок', 0, 1, 'b_SExc', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14208002, 'Основные средства: Перемещение: ОС', 14208, 14208002, 2, 'ОС', 1, 1, 'b_SExcD', 1, 'tab_Comm', 'ChID;SrcPosID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14209001, 'Основные средства: Инвентаризация: Заголовок', 14209, 14209001, 1, 'Заголовок', 0, 1, 'b_SVen', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14209002, 'Основные средства: Инвентаризация: ОС', 14209, 14209002, 2, 'ОС', 1, 1, 'b_SVenD', 1, 'tab_Comm', 'ChID;SrcPosID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14210001, 'Основные средства: Проводка', 14210, 14210001, 1, 'Общие данные', 1, 1, 'b_TranS', 1, 'tab_Comm', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14301001, 'Акт приемки услуг: Заголовок', 14301, 14301001, 1, 'Заголовок', 0, 1, 'b_ARec', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14302001, 'Акт сдачи услуг: Заголовок', 14302, 14302001, 1, 'Заголовок', 0, 1, 'b_AExp', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14310001, 'Авансовый отчет: Заголовок', 14310, 14310001, 1, 'Заголовок', 0, 1, 'b_RepA', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14310002, 'Авансовый отчет: Общие', 14310, 14310002, 2, 'Общие', 1, 1, 'b_RepADV', 1, 'tab_V', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14310003, 'Авансовый отчет: ТМЦ', 14310, 14310003, 3, 'ТМЦ', 1, 1, 'b_RepADP', 1, 'tab_P', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14310004, 'Авансовый отчет: Основные средства', 14310, 14310004, 4, 'Основные средства', 1, 1, 'b_RepADS', 1, 'tab_S', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14311001, 'Авансовый отчет с признаками: Заголовок', 14311, 14311001, 1, 'Заголовок', 0, 1, 'b_CRepA', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14311002, 'Авансовый отчет с признаками: Общие', 14311, 14311002, 2, 'Общие', 1, 1, 'b_CRepADV', 1, 'tab_V', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14311003, 'Авансовый отчет с признаками: ТМЦ', 14311, 14311003, 3, 'ТМЦ', 1, 1, 'b_CRepADP', 1, 'tab_P', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14311004, 'Авансовый отчет с признаками: Основные средства', 14311, 14311004, 4, 'Основные средства', 1, 1, 'b_CRepADS', 1, 'tab_S', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14325001, 'Зарплата: Начисление: Заголовок', 14325, 14325001, 1, 'Заголовок', 0, 1, 'b_LRec', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14325002, 'Зарплата: Начисление: Список', 14325, 14325002, 2, 'Список', 1, 1, 'b_LRecD', 1, 'TabSheet1', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14326001, 'Зарплата: Выплата: Заголовок', 14326, 14326001, 1, 'Заголовок', 0, 1, 'b_LExp', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14326002, 'Зарплата: Выплата: Список', 14326, 14326002, 2, 'Список', 1, 1, 'b_LExpD', 1, 'TabSheet1', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14330001, 'Путевой лист: Заголовок', 14330, 14330001, 1, 'Заголовок', 0, 1, 'b_WBill', 1, '', 'OurID;DocDate;DocID;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14330002, 'Путевой лист: Общие', 14330, 14330001, 2, 'Общие', 0, 1, '< Главный Источник Документа >', 5, 'tab_Main', 'OurID;DocDate;DocID;', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14330003, 'Путевой лист: Задания водителю', 14330, 14330003, 3, 'Задания водителю', 1, 1, 'b_WBillD', 1, 'tab_Tasks', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14330004, 'Путевой лист: Результаты работы', 14330, 14330002, 4, 'Результаты работы', 1, 1, 'b_WBillA', 1, 'tab_RWork', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14331001, 'Проводка общая', 14331, 14331001, 1, 'Общие данные', 1, 1, 'b_TranV', 1, 'tab_Comm', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14332001, 'Проводка по предприятию', 14332, 14332001, 1, 'Общие данные', 1, 1, 'b_TranC', 1, 'tab_Comm', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14333001, 'Проводка по служащему', 14333, 14333001, 1, 'Общие данные', 1, 1, 'b_TranE', 1, 'tab_Comm', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14335001, 'Ручные проводки: Список', 14335, 14335001, 1, 'Список', 1, 1, 'b_TranH', 1, 'tab_List', 'OurID;ChID;', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14335002, 'Ручные проводки: Аналитика дебета', 14335, 14335001, 2, 'Аналитика дебета', 0, 1, 'Ручные проводки: Список', 5, 'tab_DAnal', 'OurID;PosNo;', '', '', 0, 0, '', '', 0, 0, 0, 3, 0, 0, 0, 40, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14335003, 'Ручные проводки: Аналитика кредита', 14335, 14335001, 3, 'Аналитика кредита', 0, 1, 'Ручные проводки: Список', 5, 'tab_CAnal', 'OurID;PosNo;', '', '', 0, 0, '', '', 0, 0, 0, 3, 0, 0, 0, 40, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14341001, 'Налоговые накладные: Входящие: Список', 14341, 14341001, 1, 'Список', 1, 1, 'b_TRec', 1, 'TabSheet1', 'OurID;DocID;', '', '', 0, 0, '', NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14342001, 'Налоговые накладные: Исходящие: Список', 14342, 14342001, 1, 'Список', 1, 1, 'b_TExp', 1, 'TabSheet1', 'OurID;DocID;', '', '', 0, 0, '', NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14501001, 'Реестр: Счет на оплату', 14501, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.CompID,
 c.CompName,
  Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_nt/KursMC) AS TSumMC_nt,
 m.DocID,
 m.IntDocID
FROM (r_Comps AS c INNER JOIN b_Acc AS m ON c.CompID = m.CompID) LEFT JOIN b_AccD AS d ON m.ChID = d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.CompID,
 c.CompName,
  m.DocID,
 m.IntDocID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14510001, 'Реестр: Платежное поручение', 14510, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT b_BankPayCC.ChID,
b_BankPayCC.OurID,
b_BankPayCC.DocDate,
b_BankPayCC.CodeID1,
b_BankPayCC.CodeID2,
b_BankPayCC.CodeID3,
b_BankPayCC.CodeID4,
b_BankPayCC.CodeID5,
b_BankPayCC.SumCC_wt AS TSumCC,
b_BankPayCC.SumCC_nt AS TSumCC_nt,
SumCC_wt/KursMC AS TSumMC,
SumCC_nt/KursMC AS TSumMC_nt,
b_BankPayCC.DocID,
IntDocID,
b_BankPayCC.CompID,
CompAccountCC,
r_Comps.CompName,
r_Comps.City,
b_BankPayCC.Subject
FROM r_Comps INNER JOIN b_BankPayCC ON r_Comps.CompID = b_BankPayCC.CompID
WHERE @WorkAge@(DocDate) 
) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14511001, 'Реестр: Расчетный счет: Приход', 14511, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.DocID, m.StockID, StockName, m.CompID, CompName,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5,
  m.SumCC_nt, m.SumCC_wt SumCC, m.SumCC_wt / m.KursMC SumMC, Subject, 
  m.EmpID, e.EmpName, 
  m.AccountCC 
FROM 
  b_BankRecCC m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Comps,
  r_Emps e
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND r_Comps.CompID = m.CompID
  AND e.EmpID = m.EmpID
  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocDate, DocID, CompID', 3, 'tab_Comm', '', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14512001, 'Реестр: Расчетный счет: Расход', 14512, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID,
  m.OurID, m.DocDate, m.DocID, m.StockID, StockName, m.CompID, CompName,
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4, m.CodeID5, CodeName5,
  m.SumCC_nt, m.SumCC_wt SumCC, m.SumCC_wt / m.KursMC SumMC, Subject, 
  m.EmpID, e.EmpName, 
  m.AccountCC 
FROM 
  b_BankExpCC m,
  r_Ours, r_Stocks,
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5,
  r_Comps,
  r_Emps e
WHERE
  r_Ours.OurID = m.OurID
  AND r_Stocks.StockID = m.StockID
  AND r_Codes1.CodeID1 = m.CodeID1
  AND r_Codes2.CodeID2 = m.CodeID2
  AND r_Codes3.CodeID3 = m.CodeID3
  AND r_Codes4.CodeID4 = m.CodeID4
  AND r_Codes5.CodeID5 = m.CodeID5
  AND r_Comps.CompID = m.CompID
  AND e.EmpID = m.EmpID
  AND @WorkAge@(m.DocDate) 
) GMSView
ORDER BY OurID, DocDate, DocID, CompID', 3, 'tab_Comm', '', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14520001, 'Реестр: Валютное платежное поручение', 14520, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT b_BankPayAC.ChID,
b_BankPayAC.OurID,
b_BankPayAC.DocDate,
b_BankPayAC.CodeID1,
b_BankPayAC.CodeID2,
b_BankPayAC.CodeID3,
b_BankPayAC.CodeID4,
b_BankPayAC.CodeID5,
Sum(SumAC) AS TSumAC,
Sum(SumAC*KursCC) AS TSumCC,
Sum(SumAC/KursMC) AS TSumMC,
b_BankPayAC.DocID,
IntDocID,
b_BankPayAC.CompID,
CompAccountAC,
r_Comps.CompName,
r_Comps.City,
b_BankPayAC.Subject,
b_BankPayAC.CurrID
FROM b_BankPayAC INNER JOIN r_Comps ON b_BankPayAC.CompID = r_Comps.CompID
WHERE @WorkAge@(DocDate) 
GROUP BY b_BankPayAC.ChID,
b_BankPayAC.OurID,
b_BankPayAC.DocDate,
b_BankPayAC.CodeID1,
b_BankPayAC.CodeID2,
b_BankPayAC.CodeID3,
b_BankPayAC.CodeID4,
b_BankPayAC.CodeID5,
b_BankPayAC.DocID,
IntDocID,
b_BankPayAC.CompID,
CompAccountAC,
r_Comps.CompName,
r_Comps.City,
b_BankPayAC.Subject,
b_BankPayAC.CurrID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14521001, 'Реестр: Валютный счет: Приход', 14521, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT 
  m.ChID, 
  m.OurID, m.CurrID, m.DocDate, m.DocID, m.StockID, StockName, m.CompID, CompName,   
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4,  m.CodeID5, CodeName5, 
  m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, Subject, 
  m.EmpID, e.EmpName, 
  m.AccountAC 
FROM 
  b_BankRecAC m, 
  r_Ours, r_Stocks, 
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5, 
  r_Comps, 
  r_Emps e 
WHERE 
  r_Ours.OurID = m.OurID 
  AND r_Stocks.StockID = m.StockID 
  AND r_Codes1.CodeID1 = m.CodeID1 
  AND r_Codes2.CodeID2 = m.CodeID2 
  AND r_Codes3.CodeID3 = m.CodeID3 
  AND r_Codes4.CodeID4 = m.CodeID4 
  AND r_Codes5.CodeID5 = m.CodeID5 
  AND r_Comps.CompID = m.CompID 
  AND e.EmpID = m.EmpID 
  AND @WorkAge@(m.DocDate)  
) GMSView
ORDER BY OurID, DocDate, DocID, CompID', 3, 'tab_Comm', '', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14522001, 'Реестр: Валютный счет: Расход', 14522, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT 
  m.ChID, 
  m.OurID, m.CurrID, m.DocDate, m.DocID, m.StockID, StockName, m.CompID, CompName,   
  m.CodeID1, CodeName1, m.CodeID2, CodeName2, m.CodeID3, CodeName3, m.CodeID4, CodeName4,  m.CodeID5, CodeName5, 
  m.SumAC, m.KursMC, m.SumAC / m.KursMC SumMC, m.KursCC, m.SumAC * m.KursCC SumCC, Subject, 
  m.EmpID, e.EmpName, 
  m.AccountAC 
FROM 
  b_BankExpAC m, 
  r_Ours, r_Stocks, 
  r_Codes1, r_Codes2, r_Codes3, r_Codes4, r_Codes5, 
  r_Comps, 
  r_Emps e 
WHERE 
  r_Ours.OurID = m.OurID 
  AND r_Stocks.StockID = m.StockID 
  AND r_Codes1.CodeID1 = m.CodeID1 
  AND r_Codes2.CodeID2 = m.CodeID2 
  AND r_Codes3.CodeID3 = m.CodeID3 
  AND r_Codes4.CodeID4 = m.CodeID4 
  AND r_Codes5.CodeID5 = m.CodeID5 
  AND r_Comps.CompID = m.CompID 
  AND e.EmpID = m.EmpID 
  AND @WorkAge@(m.DocDate)  
) GMSView
ORDER BY OurID, DocDate, DocID, CompID', 3, 'tab_Comm', '', '', '', 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14531001, 'Реестр: Кассовый ордер: Приход', 14531, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT b_CRec.ChID,
 b_CRec.OurID,
 b_CRec.DocDate,
 b_CRec.CodeID1,
 b_CRec.CodeID2,
 b_CRec.CodeID3,
 b_CRec.CodeID4,
 b_CRec.CodeID5,
 SumCC_nt,
 TaxSum,
 SumCC_wt,
 SumAC AS TSumAC,
 SumCC_wt AS TSumCC,
 SumCC_nt AS TSumCC_nt,
 SumAC/KursMC AS TSumMC,
 b_CRec.DocID,
 IntDocID,
 b_CRec.CompID,
  r_Comps.CompName,
 r_Comps.City,
 b_CRec.Subject,
 b_CRec.EmpID,
 CashEmpID,
 r_Emps.EmpName,
 b_CRec.CurrID,
 b_CRec.GOperID,
 b_CRec.GTranID
FROM r_Emps INNER JOIN (b_CRec INNER JOIN r_Comps ON b_CRec.CompID = r_Comps.CompID) ON r_Emps.EmpID = b_CRec.EmpID
WHERE @WorkAge@(DocDate) 
) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14532001, 'Реестр: Кассовый ордер: Расход', 14532, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT b_CExp.ChID,
 b_CExp.OurID,
 b_CExp.DocDate,
 b_CExp.CodeID1,
 b_CExp.CodeID2,
 b_CExp.CodeID3,
 b_CExp.CodeID4,
 b_CExp.CodeID5,
 SumCC_nt,
 TaxSum,
 SumCC_wt,
 SumAC AS TSumAC,
 SumCC_wt AS TSumCC,
 SumCC_nt AS TSumCC_nt,
 SumAC/KursMC AS TSumMC,
 b_CExp.DocID,
 IntDocID,
 b_CExp.CompID,
 r_Comps.CompName,
  r_Comps.City,
 b_CExp.Subject,
 b_CExp.EmpID,
 CashEmpID,
 r_Emps.EmpName,
 b_CExp.CurrID,
 b_CExp.GOperID,
 b_CExp.GTranID
FROM r_Emps INNER JOIN (b_CExp INNER JOIN r_Comps ON b_CExp.CompID = r_Comps.CompID) ON r_Emps.EmpID = b_CExp.EmpID
WHERE @WorkAge@(DocDate) 
) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14601001, 'Реестр: ТМЦ: Счет на оплату', 14601, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.StockID,
 m.CompID,
 c.CompName,
  m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.EmpID,
 m.DocID,
 IntDocID,
 m.PayDelay,
 Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_wt/KursMC) AS TSumMC_nt,
 Sum(d.Qty) AS TQty
FROM (r_Comps AS c INNER JOIN b_PAcc AS m ON c.CompID = m.CompID) LEFT JOIN b_PAccD AS d ON m.ChID = d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.StockID,
 m.CompID,
 c.CompName,
  m.DocID,
 IntDocID,
 m.PayDelay,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.EmpID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14602001, 'Реестр: ТМЦ: Приход по накладной', 14602, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.DocID,
 IntDocID,
 m.CompID,
 c.CompName,
  c.City,
 m.StockID,
 m.SrcDocID,
 m.SrcDocDate,
 m.PayDelay,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_nt/KursMC) AS TSumMC_nt,
 Sum(d.Qty) AS TQty
FROM (r_Comps AS c INNER JOIN b_Rec AS m ON c.CompID = m.CompID) LEFT JOIN b_RecD AS d ON m.ChID = d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.DocID,
 IntDocID,
 m.CompID,
 c.CompName,
  c.City,
 m.StockID,
 m.SrcDocID,
 m.SrcDocDate,
 m.PayDelay) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14603001, 'Реестр: ТМЦ: Возврат от получателя', 14603, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.DocID,
 IntDocID,
 m.CompID,
 c.CompName,
 c.City,
 m.StockID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.SrcDocID,
 m.SrcDocDate,
 Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_nt/KursMC) AS TSumMC_nt,
 m.TRealSum,
 m.TLevySum,
 Sum(d.Qty) AS TQty
FROM (r_Comps AS c INNER JOIN b_Ret AS m ON c.CompID = m.CompID) LEFT JOIN b_RetD AS d ON m.ChID = d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.DocID,
 IntDocID,
 m.CompID,
 c.CompName,
 c.City,
 m.StockID,
 m.TRealSum, 
 m.TLevySum,
 m.SrcDocID,
 m.SrcDocDate) GMSView
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14611001, 'Реестр: ТМЦ: Расходная накладная', 14611, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.PayDelay,
 m.DocID,
 m.IntDocID,
 m.CompID,
 c.CompName,
 c.City,
 m.StockID,
 Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_nt/KursMC) AS TSumMC_nt,
 Sum(d.Qty) AS TQty, 
 m.TRealSum, 
 m.TLevySum
FROM (r_Comps AS c INNER JOIN b_Inv AS m ON c.CompID = m.CompID) LEFT JOIN b_InvD AS d ON m.ChID = d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.PayDelay,
 m.DocID,
 m.IntDocID,
 m.CompID,
 c.CompName,
 c.City,
 m.StockID,
 m.TRealSum, 
 m.TLevySum) GMSView
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14612001, 'Реестр: ТМЦ: Внутренний расход', 14612, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.DocID,
 m.IntDocID,
 m.CompID,
 c.CompName,
 c.City,
 m.StockID,   
 Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_nt/KursMC) AS TSumMC_nt,
 Sum(d.Qty) AS TQty,     
 m.TRealSum, 
 m.TLevySum
FROM (r_Comps AS c INNER JOIN b_Exp AS m ON c.CompID = m.CompID) LEFT JOIN b_ExpD AS d ON m.ChID = d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.DocID,
 m.IntDocID,
 m.CompID,
 c.CompName,
 c.City,
 m.StockID,
 m.TRealSum, 
 m.TLevySum) GMSView
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14613001, 'Реестр: ТМЦ: Возврат поставщику', 14613, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.DocID,
 IntDocID,
 m.CompID,
 c.CompName,
  c.City,
 m.StockID,
 Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_nt/KursMC) AS TSumMC_nt,
 Sum(d.Qty) AS TQty
FROM (r_Comps AS c INNER JOIN b_CRet AS m ON c.CompID = m.CompID) LEFT JOIN b_CRetD AS d ON m.ChID = d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.DocID,
 IntDocID,
 m.CompID,
 c.CompName,
  c.City,
 m.StockID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14621001, 'Реестр: ТМЦ: Перемещение', 14621, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.DocID,
 IntDocID,
 m.CompID,
 c.CompName,
  c.City,
 m.StockID,
 m.NewStockID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_nt/KursMC) AS TSumMC_nt,
 Sum(d.Qty) AS TQty,
 Sum(SumCC_In) AS TSumCC_In
FROM (r_Comps AS c INNER JOIN b_PExc AS m ON c.CompID = m.CompID) LEFT JOIN b_PExcD AS d ON m.ChID = d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.DocID,
 IntDocID,
 m.CompID,
 c.CompName,
  c.City,
 m.StockID,
 m.NewStockID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14622001, 'Реестр: ТМЦ: Инвентаризация', 14622, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.DocID,
 IntDocID,
 m.CompID,
 c.CompName,
  c.City,
 m.StockID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_nt/KursMC) AS TSumMC_nt,
 Sum(d.Qty) AS TQty
FROM r_Comps AS c INNER JOIN ((b_PVen AS m LEFT JOIN b_PVenA AS a ON m.ChID=a.ChID) LEFT JOIN b_PVenD AS d ON (a.ChID=d.ChID) AND (a.ProdID=d.DetProdID)) ON c.CompID = m.CompID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.DocID,
 IntDocID,
 m.CompID,
 c.CompName,
  c.City,
 m.StockID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14623001, 'Реестр: ТМЦ: Переоценка партий', 14623, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
 SELECT m.ChID,
 m.DocID,
 m.OurID,
 m.DocDate,
 m.StockID,
 IntDocID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_nt/KursMC) AS TSumMC_nt,
 Sum(d.Qty) AS TQty,
 Sum(d.NewSumCC_wt) AS TNewSumCC,
 Sum(d.NewSumCC_nt) AS TNewSumCC_nt,
 Sum(NewSumCC_wt/KursMC) AS TNewSumMC,
 Sum(NewSumCC_nt/KursMC) AS TNewSumMC_nt
 FROM b_PEst AS m LEFT JOIN b_PEstD AS d ON m.ChID = d.ChID
 GROUP BY m.ChID,
 m.DocID,
 m.OurID,
 m.DocDate,
 m.StockID,
 IntDocID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5) GMSView
', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14625001, 'Реестр: ТМЦ: Формирование себестоимости', 14625, 14625001, 1, 'Список', 1, 1, 'SELECT * FROM (
SELECT ChID, OurID, DocDate, DocID, IntDocID,  CodeID1, TNewSumCC_nt, TExpCostCC , TExpPosProdCostCC, TExpPosCostCC, CodeID2, CodeID3, CodeID4, CodeID5, Notes, StateCode FROM b_PCost m) GMSView', 3, 'tab_Comm', 'OurID;DocDate;DocID', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14631001, 'Реестр: ТМЦ: Приход по ГТД', 14631, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.StockID,
 m.CompID,
 c.CompName,
  m.CurrID,
 c.City,
 Sum(SumAC_In) AS TSumAC,
 Sum(d.SumCC_In) AS TSumCC,
 Sum(SumCC_In/KursMC/KursCC) AS TSumMC,
 Sum(d.Qty) AS TQty,
 m.DocID,
 IntDocID,
 m.PayDelay,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.KursCC,
 m.TSumAC_In
FROM (r_Comps AS c INNER JOIN b_Cst AS m ON c.CompID = m.CompID) LEFT JOIN b_CstD AS d ON m.ChID = d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.StockID,
 m.CompID,
 c.CompName,
  c.City,
 m.DocID,
 IntDocID,
 m.PayDelay,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.CurrID,
 m.KursCC,
 m.TSumAC_In) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14632001, 'Реестр: ТМЦ: Расход по ГТД', 14632, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.StockID,
 m.CompID,
 c.CompName,
  m.CurrID,
 m.KursMC,
 m.KursAC,
 m.KursCC,
 c.City,
 m.DocID,
 IntDocID,
 m.PayDelay,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.DtyCC,
 m.PrcCC,
 m.TaxPercent,
 m.TranCC,
 m.MoreCC,
 Sum(SumAC) AS TSumAC,
 Sum(SumCC_nt) AS TSumCC_nt,
 Sum(TaxSum) AS TTaxSum,
 Sum(SumCC_wt) AS TSumCC_wt,
 Sum(SumCC_In) AS TSumCC_In,
 Sum(d.Qty) AS TQty,
 Sum(SumCC_wt) AS TSumCC,
 Sum(d.SumCC_wt / KursMC) AS TSumMC
FROM (r_Comps AS c INNER JOIN b_CInv AS m ON c.CompID = m.CompID) LEFT JOIN b_CInvD AS d ON m.ChID = d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.StockID,
 m.CompID,
 c.CompName,
  c.City,
 m.DocID,
 IntDocID,
 m.PayDelay,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.CurrID,
 m.KursCC,
 m.KursMC,
 m.KursAC,
 m.DtyCC,
 m.PrcCC,
 m.TaxPercent,
 m.TranCC,
 m.MoreCC) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14642001, 'Реестр: ТМЦ: Проводка', 14642, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT b_TranP.ChID,
 b_TranP.OurID,
 b_TranP.DocDate,
 b_TranP.CodeID1,
 b_TranP.CodeID2,
 b_TranP.CodeID3,
 b_TranP.CodeID4,
 b_TranP.CodeID5,
 Sum(b_TranP.SumCC_wt) AS TSumCC,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 b_TranP.StockID,
 Sum(b_TranP.Qty) AS TQty
FROM b_TranP INNER JOIN r_Prods ON b_TranP.ProdID = r_Prods.ProdID
WHERE @WorkAge@(DocDate) 
GROUP BY b_TranP.ChID,
 b_TranP.OurID,
 b_TranP.DocDate,
 b_TranP.CodeID1,
 b_TranP.CodeID2,
 b_TranP.CodeID3,
 b_TranP.CodeID4,
 b_TranP.CodeID5,
 b_TranP.StockID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14701001, 'Реестр: Основные средства: Приход', 14701, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.EmpID,
 m.DocID,
 IntDocID,
 m.CompID,
 r_Comps.CompName,
  r_Comps.City,
 m.PayDelay,
 Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_nt/KursMC) AS TSumMC_nt
FROM (b_SRec AS m LEFT JOIN b_SRecD AS d ON m.ChID = d.ChID) INNER JOIN r_Comps ON m.CompID = r_Comps.CompID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.EmpID,
 m.DocID,
 IntDocID,
 m.CompID,
 r_Comps.CompName,
  r_Comps.City,
 m.PayDelay) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14702001, 'Реестр: Основные средства: Ввод в эксплуатацию', 14702, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.DocID,
 IntDocID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.EmpID,
 m.CompID,
 r.CompName,
  Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_nt/KursMC) AS TSumMC_nt
FROM (b_SPut AS m LEFT JOIN b_SPutD AS d ON m.ChID = d.ChID) INNER JOIN r_Comps AS r ON r.CompID=m.CompID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.CompID,
 r.CompName,
  m.EmpID,
 m.DocID,
 IntDocID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14703001, 'Реестр: Основные средства: Амортизация', 14703, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.DocID,
 m.IntDocID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.EmpID,
 Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_nt/KursMC) AS TSumMC_nt
FROM b_SDep AS m LEFT JOIN b_SDepD AS d ON m.ChID = d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.DocID,
 m.IntDocID,
 m.EmpID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14704001, 'Реестр: Основные средства: Износ', 14704, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.DocID,
 IntDocID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.EmpID,
 Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_nt/KursMC) AS TSumMC_nt
FROM b_SWer AS m LEFT JOIN b_SWerD AS d ON m.ChID = d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.EmpID,
 m.DocID,
 IntDocID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14705001, 'Реестр: Основные средства: Ремонт', 14705, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT ChID,
 OurID,
 CompID,
  DocDate,
 RepType,
 AssID,
 DocID,
 IntDocID,
 EmpID,
 EmpName,
 CompName,
 SUM(FSumCC_wt) AS TSumCC,
 SUM(FSumMC_wt) AS TSumMC,
 SUM(FSumCC_nt) AS TSumCC_nt,
 SUM(FSumMC_nt) AS TSumMC_nt,
 SUM(FTaxSumCC) AS TTaxSumCC,
 SUM(FTaxSumMC) AS TTaxSumMC
FROM b_SRepAa
WHERE @WorkAge@(DocDate) 
GROUP BY ChID,
 OurID,
 CompID,
  DocDate,
 RepType,
 AssID,
 DocID,
 IntDocID,
 EmpID,
 EmpName,
 CompName) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14706001, 'Реестр: Основные средства: Продажа', 14706, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.EmpID,
 m.DocID,
 IntDocID,
 m.CompID,
 r_Comps.CompName,
  r_Comps.City,
 m.PayDelay,
 Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_nt/KursMC) AS TSumMC_nt
FROM (b_SInv AS m LEFT JOIN b_SInvD AS d ON m.ChID = d.ChID) INNER JOIN r_Comps ON m.CompID = r_Comps.CompID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.EmpID,
 m.DocID,
 IntDocID,
 m.CompID,
 r_Comps.CompName,
  r_Comps.City,
 m.PayDelay) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14707001, 'Реестр: Основные средства: Списание', 14707, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.EmpID,
 m.DocID,
 IntDocID,
 m.CompID,
 r.CompName,
  r.City,
 Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_nt/KursMC) AS TSumMC_nt
FROM (b_SExp AS m LEFT JOIN b_SExpD AS d ON m.ChID = d.ChID) INNER JOIN r_Comps AS r ON r.CompID=m.CompID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.EmpID,
 m.DocID,
 IntDocID,
 m.CompID,
 r.CompName,
  r.City) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14708001, 'Реестр: Основные средства: Перемещение', 14708, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 DocID,
 IntDocID,
 DocDate,
 KursMC,
 OurID,
 CodeID1,
 CodeID2,
 CodeID3,
 CodeID4,
 CodeID5,
 EmpID,
 NewEmpID,
 Notes,
 Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_nt/KursMC) AS TSumMC_nt
FROM b_SExc AS m INNER JOIN b_SExcD AS d ON m.ChID=d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 DocID,
 IntDocID,
 DocDate,
 KursMC,
 OurID,
 CodeID1,
 CodeID2,
 CodeID3,
 CodeID4,
 CodeID5,
 EmpID,
 NewEmpID,
 Notes) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14709001, 'Реестр: Основные средства: Инвентаризация', 14709, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.DocID,
 IntDocID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.EmpID,
 Sum(d.SumCC_wt) AS TSumCC,
 Sum(d.SumCC_nt) AS TSumCC_nt,
 Sum(SumCC_wt/KursMC) AS TSumMC,
 Sum(SumCC_nt/KursMC) AS TSumMC_nt
FROM b_SVen AS m LEFT JOIN b_SVenD AS d ON m.ChID = d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.DocID,
 IntDocID,
 m.EmpID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14710001, 'Реестр: Основные средства: Проводка', 14710, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT b_TranS.ChID,
 b_TranS.OurID,
 b_TranS.DocDate,
 b_TranS.CodeID1,
 b_TranS.CodeID2,
 b_TranS.CodeID3,
 b_TranS.CodeID4,
 b_TranS.CodeID5,
 Sum(b_TranS.SumCC_nt) AS TSumCC,
 Sum(SumCC_nt/KursMC) AS TSumMC
FROM r_Assets INNER JOIN b_TranS ON r_Assets.AssID = b_TranS.AssID
WHERE @WorkAge@(DocDate) 
GROUP BY b_TranS.ChID,
 b_TranS.OurID,
 b_TranS.DocDate,
 b_TranS.CodeID1,
 b_TranS.CodeID2,
 b_TranS.CodeID3,
 b_TranS.CodeID4,
 b_TranS.CodeID5) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14801001, 'Реестр: Акт приемки услуг', 14801, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.DocID,
 m.IntDocID,
 m.CompID,
 r.CompName,
  r.City,
 m.Subject,
 m.SumCC_wt AS TSumCC,
 m.SumCC_nt AS TSumCC_nt,
 SumCC_wt/KursMC AS TSumMC,
 SumCC_nt/KursMC AS TSumMC_nt
FROM b_ARec AS m INNER JOIN r_Comps AS r ON m.CompID = r.CompID
WHERE @WorkAge@(m.DocDate) 
) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14802001, 'Реестр: Акт сдачи услуг', 14802, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.DocID,
 m.IntDocID,
 m.CompID,
 r.CompName,
  r.City,
 m.Subject,
 m.SumCC_wt AS TSumCC,
 m.SumCC_nt AS TSumCC_nt,
 SumCC_wt/KursMC AS TSumMC,
 SumCC_nt/KursMC AS TSumMC_nt
FROM b_AExp AS m INNER JOIN r_Comps AS r ON m.CompID = r.CompID
WHERE @WorkAge@(m.DocDate) 
) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14810001, 'Реестр: Авансовый отчет', 14810, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT b_RepAa.ChID,
 b_RepAa.OurID,
 b_RepAa.DocDate,
 b_RepAa.CodeID1,
 b_RepAa.CodeID2,
 b_RepAa.CodeID3,
 b_RepAa.CodeID4,
 b_RepAa.CodeID5,
 Sum(b_RepAa.SumCC) AS TSumCC,
 Sum(b_RepAa.SumMC) AS TSumMC,
 b_RepAa.DocID,
 IntDocID,
 b_RepAa.EmpID,
 b_RepAa.CompID
FROM (SELECT
 1 AS SelType,
 m.ChID,
 m.OurID,
 DocDate,
 CodeID1,
 CodeID2,
 CodeID3,
 CodeID4,
 CodeID5,
 SUM(SumCC_wt) AS SumCC,
 SUM(SumCC_wt/KursMC) AS SumMC,
 DocID,
 IntDocID,
 m.EmpID,
 EmpName,
 m.CompID

FROM b_RepA m,
 b_RepADV d,
 r_Emps e
WHERE e.EmpID=m.EmpID AND d.ChID=m.ChID
  AND @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 DocID,
 IntDocID,
 DocDate,
 m.EmpID,
 EmpName,
 m.CompID,
  KursMC,
 CodeID1,
 CodeID2,
 CodeID3,
 CodeID4,
 CodeID5

UNION 

SELECT
 2 AS SelType,
 m.ChID,
 m.OurID,
 DocDate,
 CodeID1,
 CodeID2,
 CodeID3,
 CodeID4,
 CodeID5,
 SUM(SumCC_wt) AS SumCC,
 SUM(SumCC_wt/KursMC) AS SumMC,
 DocID,
 IntDocID,
 m.EmpID,
 EmpName,
 m.CompID
FROM b_RepA m,
 b_RepADP d,
 r_Emps e
WHERE e.EmpID=m.EmpID AND d.ChID=m.ChID
GROUP BY m.ChID,
 m.OurID,
 DocID,
 IntDocID,
 DocDate,
 m.EmpID,
 EmpName,
 m.CompID,
  KursMC,
 CodeID1,
 CodeID2,
 CodeID3,
 CodeID4,
 CodeID5

UNION SELECT
 3 AS SelType,
 m.ChID,
 m.OurID,
 DocDate,
 CodeID1,
 CodeID2,
 CodeID3,
 CodeID4,
 CodeID5,
 SUM(SumCC_wt) AS SumCC,
 SUM(SumCC_wt/KursMC) AS SumMC,
 DocID,
 IntDocID,
 m.EmpID,
 EmpName,
 m.CompID
FROM b_RepA m,
 b_RepADS d,
 r_Emps e
WHERE e.EmpID=m.EmpID AND d.ChID=m.ChID
GROUP BY m.ChID,
 m.OurID,
 DocID,
 IntDocID,
 DocDate,
 m.EmpID,
 EmpName,
 m.CompID,
  KursMC,
 CodeID1,
 CodeID2,
 CodeID3,
 CodeID4,
 CodeID5) b_RepAa
GROUP BY b_RepAa.ChID,
 b_RepAa.OurID,
 b_RepAa.DocDate,
 b_RepAa.CodeID1,
 b_RepAa.CodeID2,
 b_RepAa.CodeID3,
 b_RepAa.CodeID4,
 b_RepAa.CodeID5,
 b_RepAa.DocID,
 IntDocID,
 b_RepAa.EmpID,
 b_RepAa.CompID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14811001, 'Реестр: Авансовый отчет с признаками', 14811, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT b_CRepAa.ChID,
 b_CRepAa.OurID,
 b_CRepAa.DocDate,
 Sum(b_CRepAa.SumCC) AS TSumCC,
 Sum(b_CRepAa.SumMC) AS TSumMC,
 b_CRepAa.DocID,
 IntDocID,
 b_CRepAa.EmpID,
 b_CRepAa.EmpName,
 b_CRepAa.CompID
FROM (SELECT
 m.ChID,
 m.OurID,
 DocDate,
 VCodeID1 As CodeID1,
 VCodeID2 As CodeID2,
 VCodeID3 As CodeID3,
 VCodeID4 As CodeID4,
 VCodeID5 As CodeID5,
 SUM(SumCC_wt) AS SumCC,
 SUM(SumCC_wt/KursMC) AS SumMC,
 DocID,
 IntDocID,
 m.EmpID,
 EmpName,
 m.CompID
FROM b_CRepA m,
 b_CRepADV d,
 r_Emps e
WHERE e.EmpID=m.EmpID AND d.ChID=m.ChID
  AND @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 DocID,
 IntDocID,
 DocDate,
 m.EmpID,
 EmpName,
 m.CompID,
  KursMC,
 VCodeID1,
 VCodeID2,
 VCodeID3,
 VCodeID4,
 VCodeID5

UNION ALL

SELECT
 m.ChID,
 m.OurID,
 DocDate,
 PCodeID1 As CodeID1,
 PCodeID2 As CodeID2,
 PCodeID3 As CodeID3,
 PCodeID4 As CodeID4,
 PCodeID5 As CodeID5,
 SUM(SumCC_wt) AS SumCC,
 SUM(SumCC_wt/KursMC) AS SumMC,
 DocID,
 IntDocID,
 m.EmpID,
 EmpName,
 m.CompID
FROM b_CRepA m,
 b_CRepADP d,
 r_Emps e
WHERE e.EmpID=m.EmpID AND d.ChID=m.ChID
GROUP BY m.ChID,
 m.OurID,
 DocID,
 IntDocID,
 DocDate,
 m.EmpID,
 EmpName,
 m.CompID,
  KursMC,
 PCodeID1,
 PCodeID2,
 PCodeID3,
 PCodeID4,
 PCodeID5

UNION ALL
SELECT
 m.ChID,
 m.OurID,
 DocDate,
 ACodeID1 As CodeID1,
 ACodeID2 As CodeID2,
 ACodeID3 As CodeID3,
 ACodeID4 As CodeID4,
 ACodeID5 As CodeID5,
 SUM(SumCC_wt) AS SumCC,
 SUM(SumCC_wt/KursMC) AS SumMC,
 DocID,
 IntDocID,
 m.EmpID,
 EmpName,
 m.CompID
FROM b_CRepA m,
 b_CRepADS d,
 r_Emps e
WHERE e.EmpID=m.EmpID AND d.ChID=m.ChID
GROUP BY m.ChID,
 m.OurID,
 DocID,
 IntDocID,
 DocDate,
 m.EmpID,
 EmpName,
 m.CompID,
  KursMC,
 ACodeID1,
 ACodeID2,
 ACodeID3,
 ACodeID4,
 ACodeID5) b_CRepAa
GROUP BY b_CRepAa.ChID,
 b_CRepAa.OurID,
 b_CRepAa.DocDate,
 b_CRepAa.DocID,
 IntDocID,
 b_CRepAa.EmpID,
 b_CRepAa.EmpName,
 b_CRepAa.CompID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14812001, 'Реестр: Авансовый отчет валютный', 14812, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT b_ARepAa.ChID,
 b_ARepAa.OurID,
 b_ARepAa.DocDate,
 Sum(b_ARepAa.SumAC) AS TSumAC,
 Sum(b_ARepAa.SumCC) AS TSumCC,
 Sum(b_ARepAa.SumMC) AS TSumMC,
 b_ARepAa.DocID,
 IntDocID,
 b_ARepAa.EmpID,
 b_ARepAa.EmpName,
 b_ARepAa.CompID
FROM (SELECT m.ChID,
 m.OurID,
 DocDate,
 VCodeID1 As CodeID1,
 VCodeID2 As CodeID2,
 VCodeID3 As CodeID3,
 VCodeID4 As CodeID4,
 VCodeID5 As CodeID5,
 SUM(SumCC_wt) AS SumCC,
 SUM(VSumAC/VKursMC) AS SumMC,
 SUM(VSumAC) AS SumAC,
 DocID,
 IntDocID,
 m.EmpID,
 EmpName,
 m.CompID
FROM b_ARepA m,
 b_ARepADV d,
 r_Emps e WHERE e.EmpID=m.EmpID AND d.ChID=m.ChID 
  AND @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 DocID,
 IntDocID,
 DocDate,
 m.EmpID,
 EmpName,
 m.CompID,
  VKursMC,
 VCodeID1,
 VCodeID2,
 VCodeID3,
 VCodeID4,
 VCodeID5 
UNION ALL 
SELECT m.ChID,
 m.OurID,
 DocDate,
 PCodeID1 As CodeID1,
 PCodeID2 As CodeID2,
 PCodeID3 As CodeID3,
 PCodeID4 As CodeID4,
 PCodeID5 As CodeID5,
 SUM(SumCC_wt) AS SumCC,
 SUM(SumAC_In/PKursMC) AS SumMC,
 SUM(SumAC_In) AS SumAC,
 DocID,
 IntDocID,
 m.EmpID,
 EmpName,
 m.CompID
 
FROM b_ARepA m,
 b_ARepADP d,
 r_Emps e WHERE e.EmpID=m.EmpID AND d.ChID=m.ChID 
GROUP BY m.ChID,
 m.OurID,
 DocID,
 IntDocID,
 DocDate,
 m.EmpID,
 EmpName,
 m.CompID,
  PKursMC,
 PCodeID1,
 PCodeID2,
 PCodeID3,
 PCodeID4,
 PCodeID5 
UNION ALL
SELECT m.ChID,
 m.OurID,
 DocDate,
 ACodeID1 As CodeID1,
 ACodeID2 As CodeID2,
 ACodeID3 As CodeID3,
 ACodeID4 As CodeID4,
 ACodeID5 As CodeID5,
 SUM(SumCC_wt) AS SumCC,
 SUM(ASumAC/AKursMC) AS SumMC,
 SUM(ASumAC) AS SumAC,
 DocID,
 IntDocID,
 m.EmpID,
 EmpName,
 m.CompID
 
FROM b_ARepA m,
 b_ARepADS d,
 r_Emps e WHERE e.EmpID=m.EmpID AND d.ChID=m.ChID 
GROUP BY m.ChID,
 m.OurID,
 DocID,
 IntDocID,
 DocDate,
 m.EmpID,
 EmpName,
 m.CompID,
  AKursMC,
 ACodeID1,
 ACodeID2,
 ACodeID3,
 ACodeID4,
 ACodeID5) b_ARepAa
GROUP BY b_ARepAa.ChID,
 b_ARepAa.OurID,
 b_ARepAa.DocDate,
 b_ARepAa.DocID,
 IntDocID,
 b_ARepAa.EmpID,
 b_ARepAa.EmpName,
 b_ARepAa.CompID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14825001, 'Реестр: Зарплата: Начисление', 14825, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT b_LRec.ChID,
 b_LRec.OurID,
 b_LRec.DocID,
 IntDocID,
 b_LRec.DocDate,
 b_LRec.CodeID1,
 b_LRec.CodeID2,
 b_LRec.CodeID3,
 b_LRec.CodeID4,
 b_LRec.CodeID5,
 b_LRecD.EmpID,
 r_Emps.EmpName,
 Sum(ChargeCC+SickCC+InsureCC+LeaveCC+NLeaveCC+MHelpCC+PregCC+MChargeCC+MChargeCC1+MChargeCC2) AS TCharge,
 Sum(AdvanceCC+AlimonyCC+PensionTaxCC+IncomeTaxCC+InsureTaxCC+UnionCC+LoanCC+EmpTaxCC+MoreCC+MoreCC2+MoreCC1) AS TUnCharge,
 Sum((ChargeCC+SickCC+InsureCC+LeaveCC+NLeaveCC+MHelpCC+PregCC+MChargeCC+MChargeCC1+MChargeCC2)-(AdvanceCC+AlimonyCC+PensionTaxCC+IncomeTaxCC+InsureTaxCC+UnionCC+CRateCC+LoanCC+EmpTaxCC+MoreCC+MoreCC2+MoreCC1)) AS TSumCC,
 Sum(((ChargeCC+SickCC+InsureCC+LeaveCC+NLeaveCC+MHelpCC+PregCC+MChargeCC+MChargeCC1+MChargeCC2)-(AdvanceCC+AlimonyCC+PensionTaxCC+IncomeTaxCC+InsureTaxCC+UnionCC+CRateCC+LoanCC+EmpTaxCC+MoreCC+MoreCC2+MoreCC1))/KursMC) AS TSumMC
FROM b_LRec INNER JOIN (r_Emps INNER JOIN b_LRecD ON r_Emps.EmpID = b_LRecD.EmpID) ON b_LRec.ChID = b_LRecD.ChID
WHERE @WorkAge@(DocDate) 
GROUP BY b_LRec.ChID,
 b_LRec.OurID,
 b_LRec.DocID,
 IntDocID,
 b_LRec.DocDate,
 b_LRec.CodeID1,
 b_LRec.CodeID2,
 b_LRec.CodeID3,
 b_LRec.CodeID4,
 b_LRec.CodeID5,
 b_LRecD.EmpID,
 r_Emps.EmpName) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14826001, 'Реестр: Зарплата: Выплата', 14826, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocID,
 m.IntDocID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 Sum(SumCC) AS TSumCC,
 Sum(SumCC/KursMC) AS TSumMC,
 d.EmpID,
 EmpName,
 m.AccDate,
 m.LExpPrc
FROM r_Emps AS r INNER JOIN (b_LExp AS m INNER JOIN b_LExpD AS d ON m.ChID = d.ChID) ON r.EmpID = d.EmpID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocID,
 m.IntDocID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 d.EmpID,
 r.EmpName,
 m.AccDate,
 m.LExpPrc) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14830001, 'Реестр: Путевой лист', 14830, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocID,
 IntDocID,
 m.DocDate,
 m.KursMC,
 m.EmpID,
 re.EmpName,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.CarrID,
 r.CarrName,
 m.TrailerID1,
 m.TrailerID2,
 m.RaceLength,
 m.RaceTime,
 Count(d.SrcPosID) AS JobCount,
 Sum(a.Qty) AS TQty,
 Sum(a.SumCC_wt) AS TSumCC,
 Sum(a.SumCC_wt/m.KursMC) AS TSumMC,
 Sum(a.SumCC_nt) AS TSumCC_nt,
 Sum(a.TaxSum) AS TTaxSum
FROM (((b_WBill AS m INNER JOIN r_Emps AS re ON m.EmpID = re.EmpID) INNER JOIN r_Carrs AS r ON m.CarrID = r.CarrID) LEFT JOIN b_WBillA AS a ON m.ChID = a.ChID) LEFT JOIN b_WBillD AS d ON m.ChID = d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 m.DocID,
 IntDocID,
 m.DocDate,
 m.KursMC,
 m.EmpID,
 re.EmpName,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.CarrID,
 r.CarrName,
 m.TrailerID1,
 m.TrailerID2,
 m.RaceLength,
 m.RaceTime) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14831001, 'Реестр: Проводка общая', 14831, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT b_TranV.ChID,
 b_TranV.OurID,
 b_TranV.DocDate,
 b_TranV.CodeID1,
 b_TranV.CodeID2,
 b_TranV.CodeID3,
 b_TranV.CodeID4,
 b_TranV.CodeID5,
 SumAC*KursCC AS TSumCC,
 SumAC/KursMC AS TSumMC,
 SumAC1*KursCC AS TSumCC1,
 SumAC1/KursMC AS TSumMC1
FROM b_TranV
WHERE @WorkAge@(DocDate) 
) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14832001, 'Реестр: Проводка по предприятию', 14832, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT b_TranC.ChID,
 b_TranC.OurID,
 b_TranC.DocDate,
 b_TranC.CodeID1,
 b_TranC.CodeID2,
 b_TranC.CodeID3,
 b_TranC.CodeID4,
 b_TranC.CodeID5,
 SumAC*KursCC AS TSumCC,
 SumAC/KursMC AS TSumMC,
 SumAC1*KursCC AS TSumCC1,
 SumAC1/KursMC AS TSumMC1,
 b_TranC.CompID,
 r_Comps.CompName,
  r_Comps.City
FROM b_TranC INNER JOIN r_Comps ON b_TranC.CompID = r_Comps.CompID
WHERE @WorkAge@(DocDate) 
) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14833001, 'Реестр: Проводка по служащему', 14833, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT b_TranE.ChID,
 b_TranE.OurID,
 b_TranE.DocDate,
 b_TranE.CodeID1,
 b_TranE.CodeID2,
 b_TranE.CodeID3,
 b_TranE.CodeID4,
 b_TranE.CodeID5,
 SumAC*KursCC AS TSumCC,
 SumAC/KursMC AS TSumMC,
 b_TranE.EmpID,
 r_Emps.EmpName,
 SumAC1*KursCC AS TSumCC1,
 SumAC1/KursMC AS TSumMC1
FROM r_Emps INNER JOIN b_TranE ON r_Emps.EmpID = b_TranE.EmpID
WHERE @WorkAge@(DocDate) 
) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14841001, 'Реестр: Входящие налоговые накладные', 14841, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT ChID,
 DocID,
 IntDocID,
 DocDate,
 KursMC,
 OurID,
 CompID,
 SumCC_nt,
 TaxSum,
 SumCC_wt,
 Notes,
 CodeID1,
 CodeID2,
 CodeID3,
 CodeID4,
 CodeID5,
 SumCC_wt AS TSumCC,
 SumCC_wt/KursMC AS TSumMC,
 SumCC_nt AS TSumCC_nt,
 SumCC_nt/KursMC AS TSumMC_nt,
 SrcDocID,
 SrcDocDate,
 TakeTotalCosts
FROM b_TRec
WHERE @WorkAge@(DocDate) 
) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14842001, 'Реестр: Исходящие налоговые накладные', 14842, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT ChID,
 DocID,
 IntDocID,
 DocDate,
 KursMC,
 OurID,
 CompID,
 SumCC_nt,
 TaxSum,
 SumCC_wt,
 Notes,
 CodeID1,
 CodeID2,
 CodeID3,
 CodeID4,
 CodeID5,
 SumCC_wt AS TSumCC,
 SumCC_wt/KursMC AS TSumMC,
 SumCC_nt AS TSumCC_nt,
 SumCC_nt/KursMC AS TSumMC_nt
FROM b_TExp
WHERE @WorkAge@(DocDate) 
) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14901001, 'Входящий баланс: Расчетный счет', 14901, 14901001, 1, 'Общие данные', 1, 1, 'b_zInBC', 1, 'tab_Comm', 'ChID;OurID;DocID', NULL, NULL, 0, 1, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14902001, 'Входящий баланс: Валютный счет', 14902, 14902001, 1, 'Общие данные', 1, 1, 'b_zInBA', 1, 'tab_Comm', 'ChID;OurID;AccountAC', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14903001, 'Входящий баланс: Касса', 14903, 14903001, 1, 'Общие данные', 1, 1, 'b_zInCA', 1, 'tab_Comm', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14904001, 'Входящий баланс: ТМЦ', 14904, 14904001, 1, 'Общие данные', 1, 1, 'b_zInP', 1, 'tab_Comm', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14905001, 'Входящий баланс: Основные средства', 14905, 14905001, 1, 'Общие данные', 1, 1, 'b_zInS', 1, 'tab_Comm', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14906001, 'Входящий баланс: Предприятия', 14906, 14906001, 1, 'Общие данные', 1, 1, 'b_zInC', 1, 'tab_Comm', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14907001, 'Входящий баланс: Служащие', 14907, 14907001, 1, 'Общие данные', 1, 1, 'b_zInE', 1, 'tab_Comm', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14908001, 'Входящий баланс: Общие данные', 14908, 14908001, 1, 'Общие данные', 1, 1, 'b_zInV', 1, 'tab_Comm', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14909001, 'Ручные входящие: Список', 14909, 14909001, 1, 'Список', 1, 1, 'b_zInH', 1, 'tab_List', 'OurID;ChID;', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14909002, 'Ручные входящие: Аналитика дебета', 14909, 14909001, 2, 'Аналитика дебета', 0, 1, 'Ручные входящие: Список', 5, 'tab_DAnal', 'OurID;PosNo;', '', '', 0, 0, '', '', 0, 0, 0, 3, 0, 0, 0, 40, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14909003, 'Ручные входящие: Аналитика кредита', 14909, 14909001, 3, 'Аналитика кредита', 0, 1, 'Ручные входящие: Список', 5, 'tab_CAnal', 'OurID;PosNo;', '', '', 0, 0, '', '', 0, 0, 0, 3, 0, 0, 0, 40, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14910001, 'ТМЦ: Текущие остатки', 14910, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT b_Rem.OurID,
 b_Rem.StockID,
 b_Rem.ProdID,
 r_Prods.ProdName,
 r_Prods.UM,
 r_Prods.PCatID,
 r_Prods.PGrID,
 Sum(b_Rem.Qty) AS TQty,
 r_Prods.PGrID1,
 r_Prods.PGrID2,
 r_Prods.PGrID3,
 r_Prods.PGrAID,
 r_Prods.PBGrID
FROM b_Rem INNER JOIN r_Prods ON b_Rem.ProdID = r_Prods.ProdID
GROUP BY b_Rem.OurID,
 b_Rem.StockID,
 b_Rem.ProdID,
 r_Prods.ProdName,
 r_Prods.UM,
 r_Prods.PCatID,
 r_Prods.PGrID,
 r_Prods.PGrID1,
 r_Prods.PGrID2,
 r_Prods.PGrID3,
 r_Prods.PGrAID,
 r_Prods.PBGrID
) GMSView
ORDER BY OurID, StockID, ProdID', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14911001, 'ТМЦ: Текущие остатки в ценах прихода', 14911, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT b_Rem.OurID,
 b_Rem.StockID,
 b_Rem.ProdID,
 r_Prods.ProdName,
 r_Prods.UM,
 r_Prods.PCatID,
 r_Prods.PGrID,
 b_PInP.PriceCC_In,
 Sum(b_Rem.Qty) AS TQty,
 Sum(Qty*PriceCC_In) AS SumCC,
 b_Rem.PPID,
 r_Prods.PGrID1,
 r_Prods.PGrID2,
 r_Prods.PGrID3,
 r_Prods.PGrAID,
 r_Prods.PBGrID,
 b_PInP.CompID
FROM (b_Rem INNER JOIN b_PInP ON (b_Rem.ProdID = b_PInP.ProdID) AND (b_Rem.PPID = b_PInP.PPID)) INNER JOIN r_Prods ON b_PInP.ProdID = r_Prods.ProdID
GROUP BY b_Rem.OurID,
 b_Rem.StockID,
 b_Rem.ProdID,
 r_Prods.ProdName,
 r_Prods.UM,
 r_Prods.PCatID,
 r_Prods.PGrID,
 b_PInP.PriceCC_In,
 b_Rem.PPID,
 r_Prods.PGrID1,
 r_Prods.PGrID2,
 r_Prods.PGrID3,
 r_Prods.PGrAID,
 r_Prods.PBGrID,
 b_PInP.CompID
) GMSView
ORDER BY OurID, StockID, ProdID', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14912001, 'ТМЦ: Текущие остатки в ценах продажи', 14912, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT b_Rem.OurID,
 b_Rem.StockID,
 b_Rem.ProdID,
 r_Prods.ProdName,
 r_Prods.UM,
 r_Prods.PCatID,
 r_Prods.PGrID,
 r_ProdMPs.PriceMC,
 r_ProdMPs.PriceCC,
 Sum(b_Rem.Qty) AS TRem,
 Sum(Qty*PriceMC) AS TRemSumMC,
 Sum(Qty*PriceCC) AS TRemSumCC,
 Sum(b_Rem.Qty) AS TAcc,
 Sum(b_Rem.Qty) AS TQty,
 Sum((Qty)*PriceMC) AS SumMC,
 Sum((Qty)*PriceCC) AS SumCC,
 r_ProdMPs.PLID,
 r_Prods.PGrID1,
 r_Prods.PGrID2,
 r_Prods.PGrID3,
 r_Prods.PGrAID,
 r_Prods.PBGrID
FROM (b_Rem INNER JOIN r_Prods ON b_Rem.ProdID = r_Prods.ProdID) INNER JOIN r_ProdMPs ON r_Prods.ProdID = r_ProdMPs.ProdID
GROUP BY b_Rem.OurID,
 b_Rem.StockID,
 b_Rem.ProdID,
 r_Prods.ProdName,
 r_Prods.UM,
 r_Prods.PCatID,
 r_Prods.PGrID,
 r_ProdMPs.PriceMC,
 r_ProdMPs.PriceCC,
 r_ProdMPs.PLID,
 r_Prods.PGrID1,
 r_Prods.PGrID2,
 r_Prods.PGrID3,
 r_Prods.PGrAID,
 r_Prods.PBGrID
) GMSView
ORDER BY OurID, StockID, ProdID', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14915001, 'ТМЦ: Остатки на дату', 14915, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT b_RemD.OurID,
 b_RemD.StockID,
 b_RemD.ProdID,
 r_Prods.ProdName,
 r_Prods.UM,
 r_Prods.PCatID,
 r_Prods.PGrID,
 Sum(b_RemD.Qty) AS TQty,
 r_Prods.PGrID1,
 r_Prods.PGrID2,
 r_Prods.PGrID3,
 r_Prods.PGrAID,
 r_Prods.PBGrID
FROM b_RemD INNER JOIN r_Prods ON b_RemD.ProdID = r_Prods.ProdID
GROUP BY b_RemD.OurID,
 b_RemD.StockID,
 b_RemD.ProdID,
 r_Prods.ProdName,
 r_Prods.UM,
 r_Prods.PCatID,
 r_Prods.PGrID,
 r_Prods.PGrID1,
 r_Prods.PGrID2,
 r_Prods.PGrID3,
 r_Prods.PGrAID,
 r_Prods.PBGrID
) GMSView
ORDER BY OurID, StockID, ProdID', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14915002, 'ТМЦ: Остатки на дату: Информация', 14915, 0, 2, 'Информация', 2, 1, 'SELECT * FROM (
SELECT TOP 1 EDate RemDate, DocDate CalcDate 
FROM z_LogAU 
WHERE AUGroupCode = 3 AND UserCode = dbo.zf_GetUserCode() 
) GMSView
ORDER BY CalcDate DESC
', 3, '', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14916001, 'ТМЦ: Остатки на дату в ценах прихода', 14916, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT b_RemD.OurID,
 b_RemD.StockID,
 b_RemD.ProdID,
 r_Prods.ProdName,
 r_Prods.UM,
 r_Prods.PCatID,
 r_Prods.PGrID,
 b_PInP.PriceCC_In,
 Sum(b_RemD.Qty) AS TQty,
 Sum(Qty*PriceCC_In) AS SumCC,
 b_RemD.PPID,
 r_Prods.PGrID1,
 r_Prods.PGrID2,
 r_Prods.PGrID3,
 r_Prods.PGrAID,
 r_Prods.PBGrID,
 b_PInP.CompID
FROM (b_RemD INNER JOIN b_PInP ON (b_RemD.PPID = b_PInP.PPID) AND (b_RemD.ProdID = b_PInP.ProdID)) INNER JOIN r_Prods ON b_PInP.ProdID = r_Prods.ProdID
GROUP BY b_RemD.OurID,
 b_RemD.StockID,
 b_RemD.ProdID,
 r_Prods.ProdName,
 r_Prods.UM,
 r_Prods.PCatID,
 r_Prods.PGrID,
 b_PInP.PriceCC_In,
 b_RemD.PPID,
 r_Prods.PGrID1,
 r_Prods.PGrID2,
 r_Prods.PGrID3,
 r_Prods.PGrAID,
 r_Prods.PBGrID,
 b_PInP.CompID
) GMSView
ORDER BY OurID, StockID, ProdID', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14916002, 'ТМЦ: Остатки на дату в ценах прихода: Информация', 14916, 0, 2, 'Информация', 2, 1, 'SELECT * FROM (
SELECT TOP 1 EDate RemDate, DocDate CalcDate 
FROM z_LogAU 
WHERE AUGroupCode = 3 AND UserCode = dbo.zf_GetUserCode() 
) GMSView
ORDER BY CalcDate DESC
', 3, '', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14917001, 'ТМЦ: Остатки на дату в ценах продажи', 14917, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT b_RemD.OurID,
 b_RemD.StockID,
 b_RemD.ProdID,
 r_Prods.ProdName,
 r_Prods.UM,
 r_Prods.PCatID,
 r_Prods.PGrID,
 r_ProdMPs.PriceMC,
 r_ProdMPs.PriceCC,
 Sum(b_RemD.Qty) AS TRem,
 Sum(Qty*PriceMC) AS TRemSumMC,
 Sum(Qty*PriceCC) AS TRemSumCC,
 Sum(b_RemD.Qty) AS TAcc,
 Sum(b_RemD.Qty) AS TQty,
 Sum((Qty)*PriceMC) AS SumMC,
 Sum((Qty)*PriceCC) AS SumCC,
 r_ProdMPs.PLID,
 r_Prods.PGrID1,
 r_Prods.PGrID2,
 r_Prods.PGrID3,
 r_Prods.PGrAID,
 r_Prods.PBGrID
FROM (b_RemD INNER JOIN r_Prods ON b_RemD.ProdID = r_Prods.ProdID) INNER JOIN r_ProdMPs ON r_Prods.ProdID = r_ProdMPs.ProdID
GROUP BY b_RemD.OurID,
 b_RemD.StockID,
 b_RemD.ProdID,
 r_Prods.ProdName,
 r_Prods.UM,
 r_Prods.PCatID,
 r_Prods.PGrID,
 r_ProdMPs.PriceMC,
 r_ProdMPs.PriceCC,
 r_ProdMPs.PLID,
 r_Prods.PGrID1,
 r_Prods.PGrID2,
 r_Prods.PGrID3,
 r_Prods.PGrAID,
 r_Prods.PBGrID
) GMSView
ORDER BY OurID, StockID, ProdID', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14917002, 'ТМЦ: Остатки на дату в ценах продажи: Информация', 14917, 0, 2, 'Информация', 2, 1, 'SELECT * FROM (
SELECT TOP 1 EDate RemDate, DocDate CalcDate 
FROM z_LogAU 
WHERE AUGroupCode = 3 AND UserCode = dbo.zf_GetUserCode() 
) GMSView
ORDER BY CalcDate DESC
', 3, '', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (14920001, 'Проводки для документов', 14920, 14920001, 1, 'Заголовок', 0, 1, 'b_GOperDocs', 1, '', 'DSCode;Priority;', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15011001, 'Штатное расписание: Заголовок', 15011, 15011001, 1, 'Заголовок', 0, 1, 'p_LMem', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15011002, 'Штатное расписание: Список', 15011, 15011002, 2, 'Список', 1, 1, 'p_LMemD', 1, 'tab_List', 'ChID;SubID;PostID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15012001, 'Штатная численность сотрудников: Заголовок', 15012, 15012001, 1, 'Заголовок', 0, 1, 'p_LStr', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15012002, 'Штатная численность сотрудников: Список', 15012, 15012002, 2, 'Список', 1, 1, 'p_LStrD', 1, 'tab_List', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15021001, 'Приказ: Прием на работу: Заголовок', 15021, 15021001, 1, 'Заголовок', 0, 1, 'p_EGiv', 1, '', 'OurID;DocID;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15021002, 'Приказ: Прием на работу: Основное', 15021, 15021001, 2, 'Основное', 0, 1, 'Приказ: Прием на работу: Заголовок', 5, 'tab_Main', 'OurID;DocID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15021003, 'Приказ: Прием на работу: Зарплата', 15021, 15021001, 3, 'Зарплата', 0, 1, 'Приказ: Прием на работу: Заголовок', 5, 'tab_Salary', 'OurID;DocID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15022001, 'Приказ: Кадровое перемещение: Заголовок', 15022, 15022001, 1, 'Заголовок', 0, 1, 'p_EExc', 1, '', 'OurID;DocID;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15022002, 'Приказ: Кадровое перемещение: Основное', 15022, 15022001, 2, 'Основное', 0, 1, 'Приказ: Кадровое перемещение: Заголовок', 5, 'tab_Main', 'OurID;DocID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15022003, 'Приказ: Кадровое перемещение: Зарплата', 15022, 15022001, 3, 'Зарплата', 0, 1, 'Приказ: Кадровое перемещение: Заголовок', 5, 'tab_Salary', 'OurID;DocID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15023001, 'Приказ: Кадровое перемещение списком: Заголовок', 15023, 15023001, 1, 'Заголовок', 0, 1, 'p_LExc', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15023002, 'Приказ: Кадровое перемещение списком: Список', 15023, 15023002, 2, 'Список', 1, 1, 'p_LExcD', 1, 'tab_List', 'ChID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15024001, 'Приказ: Командировка: Заголовок', 15024, 15024001, 1, 'Заголовок', 0, 1, 'p_ETrp', 1, '', 'OurID;DocID;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15024002, 'Приказ: Командировка: Основное', 15024, 15024001, 2, 'Основное', 0, 1, 'Приказ: Командировка: Заголовок', 5, 'tab_Comm', 'OurID;DocID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15025001, 'Приказ: Отпуск: Заголовок', 15025, 15025001, 1, 'Заголовок', 0, 1, 'p_ELeav', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15025002, 'Приказ: Отпуск: Список', 15025, 15025002, 2, 'Список', 1, 1, 'p_ELeavD', 1, 'tab_List', 'ChID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15025003, 'Приказ: Отпуск: Подробно', 15025, 15025003, 3, 'Подробно', 0, 1, 'p_ELeavDD', 1, '', 'AChID;SrcDate;', '', '', 0, 0, 'Приказ: Отпуск: Список', 'AChID;', 0, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15025004, 'Приказ: Отпуск: Помесячно', 15025, 15025005, 4, 'Помесячно', 0, 1, 'p_ELeavDP', 1, '', 'AChID;SrcDate', '', '', 0, 0, '< Главный Источник Документа >', 'AChID', 0, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15026001, 'Приказ: Увольнение: Заголовок', 15026, 15026001, 1, 'Заголовок', 0, 1, 'p_EDis', 1, '', 'OurID;DocID;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15026002, 'Приказ: Увольнение: Основное', 15026, 15026001, 2, 'Основное', 0, 1, 'Приказ: Увольнение: Заголовок', 5, 'tab_Main', 'OurID;DocID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15026003, 'Приказ: Увольнение: Расчетные', 15026, 15026001, 3, 'Расчетные', 0, 1, 'Приказ: Увольнение: Заголовок', 5, 'tab_Salary', 'OurID;DocID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15027001, 'Приказ: Производственный: Заголовок', 15027, 15027001, 1, 'Заголовок', 0, 1, 'p_OPWrk', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15027002, 'Приказ: Производственный: Список', 15027, 15027002, 2, 'Список', 1, 1, 'p_OPWrkD', 1, 'tab_List', 'ChID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15028001, 'Приказ: Отпуск: Корректировка: Заголовок', 15028, 15028001, 1, 'Заголовок', 1, 0, 'p_ELeavCor', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15028002, 'Приказ: Отпуск: Корректировка: Список', 15028, 15028002, 2, 'Список', 1, 1, 'p_ELeavCorD', 1, 'tab_List', 'ChID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15029001, 'Отпуск: Лимиты по видам: Заголовок', 15029, 15029001, 1, 'Заголовок', 0, 0, 'p_LeaveSched', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15029002, 'Отпуск: Лимиты по видам: Список', 15029, 15029002, 2, 'Список', 1, 1, 'p_LeaveSchedD', 1, 'tab_List', 'ChID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15031001, 'Приказ: Дополнительный график работы: Заголовок', 15031, 15031001, 1, 'Заголовок', 1, 1, 'p_EmpSchedExt', 1, '', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15031002, 'Приказ: Дополнительный график работы: Список', 15031, 15031002, 2, 'Список', 1, 1, 'p_EmpSchedExtD', 1, 'tab_List', 'ChID;SrcPosID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15041001, 'Больничный лист: Заголовок', 15041, 15041001, 1, 'Заголовок', 0, 1, 'p_ESic', 1, '', 'OurID;DocID;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15041002, 'Больничный лист: Основное', 15041, 15041001, 2, 'Основное', 0, 1, 'Больничный лист: Заголовок', 5, 'tab_Main', 'OurID;DocID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15041003, 'Больничный лист: Данные о заработке', 15041, 15041002, 3, 'Данные о заработке', 1, 1, 'p_ESicD', 1, 'tab_Dates', 'ChID;SrcDate;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15041004, 'Больничный лист: Пособие (по месяцам)', 15041, 15041003, 4, 'Пособие (по месяцам)', 1, 1, 'p_ESicA', 1, 'tab_SumE', 'ChID;DetSrcDate;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15042001, 'Исполнительный лист: Заголовок', 15042, 15042001, 1, 'Заголовок', 0, 1, 'p_EWri', 1, '', 'OurID;DocID;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15042002, 'Исполнительный лист: Основное', 15042, 15042001, 2, 'Основное', 0, 1, 'Исполнительный лист: Заголовок', 5, 'tab_Main', 'OurID;DocID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15042003, 'Исполнительный лист: Получатель', 15042, 15042001, 3, 'Получатель', 0, 1, 'Исполнительный лист: Заголовок', 5, 'tab_Addr', 'OurID;DocID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15042004, 'Исполнительный лист: Удержания', 15042, 15042002, 4, 'Удержания', 1, 1, 'p_EWriP', 1, 'tab_Pays', 'ChID;SrcPosID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15043001, 'Командировочное удостоверение: Заголовок', 15043, 15043001, 1, 'Заголовок', 0, 1, 'p_TSer', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15043002, 'Командировочное удостоверение: Список', 15043, 15043002, 2, 'Список', 1, 1, 'p_TSerD', 1, 'tab_List', 'ChID;SrcPosID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15043003, 'Командировочное удостоверение: Авансовый отчет', 15043, 15043001, 3, 'Авансовый отчет', 0, 1, '< Главный Источник Документа >', 5, 'tab_AdvRep', '', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15050001, 'Табель учета рабочего времени: Корректировка', 15050, 15050001, 1, 'Список', 1, 1, 'p_CWTimeCor', 1, 'tab_Comm', 'OurID;EmpID;AppDate', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15051001, 'Табель учета рабочего времени: Заголовок', 15051, 15051001, 1, 'Заголовок', 0, 1, 'p_CWTime', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15051002, 'Табель учета рабочего времени: Список', 15051, 15051002, 2, 'Список', 1, 1, 'p_CWTimeD', 1, 'tab_List', 'ChID;EmpID;SubID;DepID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15051003, 'Табель учета рабочего времени: Подробно', 15051, 15051003, 3, 'Подробно', 0, 1, 'p_CWTimeDD', 1, '', 'AChID;DayPosID;', '', '', 0, 0, 'Табель учета рабочего времени: Список', 'AChID;', 0, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15051004, 'Табель учета рабочего времени: Подробно: Графики', 15051, 15051005, 4, 'Дополнительные графики', 0, 1, 'p_CWTimeDDExt', 1, 'tab_ExtSched', 'AChID;ShedID;DayPosID', '', '', 0, 0, '< Главный Источник Документа >', 'AChID', 0, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15052001, 'Привлечение на другую работу: Заголовок', 15052, 15052001, 1, 'Заголовок', 0, 1, 'p_WExc', 1, '', 'OurID;DocID;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15052002, 'Привлечение на другую работу: Основное', 15052, 15052001, 2, 'Основное', 0, 1, 'Привлечение на другую работу: Заголовок', 5, 'tab_Info', 'OurID;DocID;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15053001, 'Выполнение работ: Заголовок', 15053, 15053001, 1, 'Заголовок', 0, 1, 'p_EWrk', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15053002, 'Выполнение работ: Список', 15053, 15053002, 2, 'Список', 1, 1, 'p_EWrkD', 1, 'tab_List', 'ChID;EmpID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15061001, 'Заработная плата: Начисление: Заголовок', 15061, 15061001, 1, 'Заголовок', 0, 1, 'p_LRec', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15061002, 'Заработная плата: Начисление: Список', 15061, 15061002, 2, 'Список', 1, 1, 'p_LRecD', 1, 'tab_List', 'ChID;SrcPosID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15061003, 'Заработная плата: Начисление: Подробно', 15061, 15061003, 3, 'Подробно', 0, 1, 'p_LRecDD', 1, '', 'AChID;DetSrcPosID;', '', '', 0, 0, 'Заработная плата: Начисление: Список', 'AChID;', 0, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15061004, 'Заработная плата: Начисление: Корректировка выплат', 15061, 15061006, 4, 'Корректировка выплат', 0, 1, 'p_LRecDCor', 1, 'tab_Cor', 'AChID;YearID;MonthID;PayTypeID', '', '', 0, 0, '< Главный Источник Документа >', 'AChID', 0, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15061005, 'Заработная плата: Начисление: Корректировка начислений и удержаний', 15061, 15061007, 5, 'Корректировка начислений и удержаний', 0, 1, 'p_LRecDCorCR', 1, 'tab_CorCR', 'AChID;YearID;MonthID', '', '', 0, 0, '< Главный Источник Документа >', 'AChID', 0, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15062001, 'Заработная плата: Выплата: Заголовок', 15062, 15062001, 1, 'Заголовок', 0, 1, 'p_LExp', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15062002, 'Заработная плата: Выплата: Список', 15062, 15062002, 2, 'Список', 1, 1, 'p_LExpD', 1, 'tab_List', 'ChID;EmpID;', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15070001, 'Коммунальный налог: Заголовок', 15070, 15070001, 1, 'Заголовок', 1, 1, 'p_CommunalTax', 1, '', 'ChID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15070002, 'Коммунальный налог: Список', 15070, 15070002, 2, 'Список', 1, 1, 'p_CommunalTaxD', 1, 'tab_List', 'ChID;TaxRegionID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15070003, 'Коммунальный налог: Подробно', 15070, 15070003, 3, 'Подробно', 1, 1, 'p_CommunalTaxDD', 1, 'tab_DetPages', 'AChID;CostGAccID', '', '', 0, 0, 'Коммунальный налог: Список', 'AChID', 0, 0, 0, 2, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15090001, 'Перенос рабочих дней: Список', 15090, 15090001, 1, 'Список', 1, 1, 'p_DTran', 1, 'tab_List', 'OurID;TranDate;', '', '', 0, 0, '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15091001, 'Структура предприятия: Заголовок', 15091, 15091001, 1, 'Заголовок', 1, 0, 'p_SubStruc', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15091002, 'Структура предприятия: Список', 15091, 15091002, 2, 'Список', 1, 1, 'p_SubStrucD', 1, 'tab_List', 'ChID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15092001, 'Структура должностей: Заголовок', 15092, 15092001, 1, 'Заголовок', 1, 0, 'p_PostStruc', 1, '', 'OurID;DocID;DocDate;', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15092002, 'Структура должностей: Список', 15092, 15092002, 2, 'Список', 1, 1, 'p_PostStrucD', 1, 'tab_List', 'ChID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15511001, 'Реестр: Штатное расписание', 15511, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.OurID,
 m.DocID,
 IntDocID,
 SubID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 Sum(d.VacTotal) AS TVacTotal,
 Sum(d.VacOcc) AS TVacOcc,
 Sum(d.VacTotal-d.VacOcc) AS TVacFree
FROM p_LMem AS m,
 p_LMemD AS d
WHERE m.ChID=d.ChID
  AND @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.OurID,
 SubID,
 m.DocID,
 IntDocID,
 m.DocDate,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15512001, 'Реестр: Штатная численность сотрудников', 15512, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.DocID,
 IntDocID,
 m.DocDate,
 m.OurID,
 DepID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.SubID,
 m.Notes,
 Sum(d.EmpCount) AS TEmpCount
FROM p_LStr AS m,
 p_LStrD AS d
WHERE m.ChID=d.ChID
  AND @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.DocID,
 IntDocID,
 m.DocDate,
 m.OurID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.SubID,
 DepID,
 m.Notes) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15521001, 'Реестр: Приказ: Прием на работу', 15521, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT m.ChID, m.DocID, e.EmpName, m.IntDocID, m.WOrderID, m.DocDate, m.WorkAppDate, m.KursMC, m.OurID, m.CodeID1, m.CodeID2, m.CodeID3, 
       m.CodeID4, m.CodeID5, m.EmpID, m.SubID, m.DepID, m.PostID, m.EmpClass, m.ShedID, m.WorkCond, m.GEmpType, m.ContractType, 
       m.ContrEDate, m.SubJob, m.TrialMonths, m.SalaryQty, m.SalaryType, m.SalaryForm, m.SalaryMethod, m.BSalary, m.BSalaryPrc, 
       m.AdvSum, m.Joint, m.TimeNormType, m.PensMethod, m.InsurSenYears, m.InsurSenMonths, m.InsurSenDays, m.BankID, m.CardAcc 
FROM p_EGiv m, r_Emps e
WHERE @WorkAge@(m.DocDate) AND m.EmpID = e.EmpID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15522001, 'Реестр: Приказ: Кадровое перемещение', 15522, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT m.ChID, m.DocID, e.EmpName, m.IntDocID, m.WOrderID, m.DocDate, m.ExcDate, m.KursMC, m.OurID, m.CodeID1, m.CodeID2, m.CodeID3, 
       m.CodeID4, m.CodeID5, m.EmpID, m.SubID, m.DepID, m.PostID, m.EmpClass, m.ShedID, m.WorkCond, m.SubJob, m.SalaryQty, 
       m.SalaryType, m.SalaryForm, m.SalaryMethod, m.BSalary, m.BSalaryPrc, m.TimeNormType, m.PensMethod 
FROM p_EExc m, r_Emps e
WHERE @WorkAge@(m.DocDate) AND m.EmpID = e.EmpID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15523001, 'Реестр: Приказ: Кадровое перемещение списком', 15523, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.DocID,
 IntDocID,
 m.WOrderID,
 m.DocDate,
 m.ExcDate,
 m.KursMC,
 m.OurID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 Count(d.EmpID) AS TEmpCount
FROM p_LExc AS m LEFT JOIN p_LExcD AS d ON m.ChID=d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.DocID,
 IntDocID,
 m.WOrderID,
 m.DocDate,
 m.ExcDate,
 m.KursMC,
 m.OurID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15524001, 'Реестр: Приказ: Командировка', 15524, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT m.ChID, m.DocID, e.EmpName, m.IntDocID, m.WOrderID, m.DocDate, m.OurID, m.SubID, m.DepID, m.CodeID1, m.CodeID2, m.CodeID3, 
       m.CodeID4, m.CodeID5, m.CompID, m.EmpID, m.Notes, m.TripBDate, m.TripEDate, m.TripDays, m.TripPurpose, m.TripAdv
FROM p_ETrp m, r_Emps e
WHERE @WorkAge@(m.DocDate) AND m.EmpID = e.EmpID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15525001, 'Реестр: Приказ: Отпуск', 15525, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.DocID,
 IntDocID,
 m.WOrderID,
 m.DocDate,
 m.KursMC,
 m.OurID,
 SubID,
 DepID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 Sum(LeavSumCC) AS TLeavSumCC,
 Count(d.ChID) AS TEmpCount
FROM p_ELeav AS m,
 p_ELeavD AS d
WHERE m.ChID=d.ChID
  AND @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.DocID,
 IntDocID,
 m.WOrderID,
 m.DocDate,
 m.KursMC,
 m.OurID,
 SubID,
 DepID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15526001, 'Реестр: Приказ: Увольнение', 15526, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT m.ChID, m.DocID, e.EmpName, m.IntDocID, m.WOrderID, m.DocDate, m.DisDate, m.OurID, m.SubID, m.DepID, m.KursMC, m.CodeID1, m.CodeID2,
       m.CodeID3, m.CodeID4, m.CodeID5, m.EmpID, m.Notes, m.DisReason, m.DisBasis, m.DisPayCC, m.AvrSalPres, m.SaveAvrSal, 
       m.AvrSalDate, m.AvrNLeaCC, m.NLeaDays, m.NLeaBDate, m.NLeaEDate 
FROM p_EDis m, r_Emps e  
WHERE m.EmpID = e.EmpID AND @WorkAge@(m.DocDate)) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15527001, 'Реестр: Приказ: Производственный', 15527, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.DocID,
 IntDocID,
 m.WOrderID,
 m.DocDate,
 m.KursMC,
 m.OurID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.OrderNotes,
 m.Notes,
 Count(*) AS TRewCount
FROM p_OPWrk AS m,
 p_OPWrkD AS d
WHERE m.ChID=d.ChID
  AND @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.DocID,
 IntDocID,
 m.WOrderID,
 m.DocDate,
 m.KursMC,
 m.OurID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.OrderNotes,
 m.Notes) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15528001, 'Реестр: Приказ: Отпуск: Корректировка', 15528, 0, 1, 'Общие данные', 1, 1, 'SELECT
  m.ChID, m.DocID, m.IntDocID, m.WOrderID, m.DocDate, m.KursMC, m.OurID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes, m.StateCode, COUNT(d.ChID) AS TEmpCount
FROM p_ELeavCor AS m INNER JOIN
     p_ELeavCorD AS d ON m.ChID = d.ChID
 WHERE m.DocDate BETWEEN dbo.zf_GetUserWorkAgeBegin(''t'') AND dbo.zf_GetUserWorkAgeEnd(''t'')
GROUP BY m.ChID, m.DocID, m.IntDocID, m.WOrderID, m.DocDate, m.KursMC, m.OurID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes, m.StateCode
ORDER BY m.OurID, m.ChID', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15529001, 'Реестр: Отпуск: Лимиты по видам', 15529, 0, 1, 'Общие данные', 1, 1, 'SELECT
  m.ChID, m.DocID, m.IntDocID, m.DocDate, m.KursMC, m.OurID, o.OurName, m.EmpID, e.EmpName, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes
FROM
  p_LeaveSched m,
  r_Emps e,
  r_Ours o
WHERE m.EmpID = e.EmpID AND m.OurID = o.OurID AND m.DocDate BETWEEN dbo.zf_GetUserWorkAgeBegin(''t'') AND dbo.zf_GetUserWorkAgeEnd(''t'')
GROUP BY m.ChID, m.DocID, m.IntDocID, m.DocDate, m.KursMC, m.OurID, o.OurName, m.EmpID, e.EmpName, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes
ORDER BY m.OurID, m.ChID', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15531001, 'Реестр: Приказ: Дополнительный график работы', 15531, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT
  m.ChID, m.OurID, m.DocDate, m.AppDate, m.DocID, m.OrderType,  m.Notes, 
  m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.StateCode, m.IntDocID
FROM p_EmpSchedExt m  WHERE m.DocDate BETWEEN dbo.zf_GetUserWorkAgeBegin(''t'') AND dbo.zf_GetUserWorkAgeEnd(''t'') ) GMSView
ORDER BY OurID, ChID', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15541001, 'Реестр: Больничный лист', 15541, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT m.ChID, m.DocID, e.EmpName, IntDocID, m.DocDate, m.OurID, SubID, DepID, m.CodeID1, m.CodeID2, m.CodeID3, 
       m.CodeID4, m.CodeID5, m.EmpID, m.SickType, m.SickDocID, m.SickDept, m.Diagnosis, m.SickBDate, 
       m.SickEDate, m.SickWDays, m.TillFiveSickWDays, m.TillFiveSickWHours, m.SickWHours, m.PrimSickDocID, 
       m.AvrSalary, m.AvrGrantCC, m.GrantSumCC, Sum(d.DaysNorm) AS TDaysNorm, Sum(d.DaysFact) AS TDaysFact, 
       Sum(d.FactSalary) AS TFactSalary 
FROM p_ESic AS m LEFT JOIN p_ESicD AS d ON m.ChID=d.ChID, r_Emps e 
WHERE @WorkAge@(m.DocDate) AND m.EmpID = e.EmpID   
GROUP BY m.ChID, m.DocID, e.EmpName, IntDocID, m.DocDate, m.OurID, SubID, DepID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, 
	 m.CodeID5, m.EmpID, m.SickType, m.SickDocID, m.SickDept, m.Diagnosis, m.SickBDate, m.SickEDate, m.SickWDays, 
	 m.TillFiveSickWDays, m.TillFiveSickWHours, m.SickWHours, m.PrimSickDocID, m.AvrSalary, m.AvrGrantCC, 
	 m.GrantSumCC) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15542001, 'Реестр: Исполнительный лист', 15542, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT m.ChID, m.DocID, e.EmpName, m.IntDocID, m.DocDate, m.KursMC, m.OurID, m.SubID, m.DepID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, 
       m.CodeID5, m.EmpID, m.WritDocID, m.WritDate, m.WritDept, m.WritType, m.WritBDate, m.WritEDate, m.WritSumCC, m.WritPrc, 
       m.AddrCompID, m.AddrEmpID, m.TransType, m.BankID, m.AccountCC, m.Notes 
FROM p_EWri m, r_Emps e 
WHERE @WorkAge@(m.DocDate) AND m.EmpID = e.EmpID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15543001, 'Реестр: Командировочное удостоверение', 15543, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT m1.ChID, m1.DocID, m1.IntDocID, m1.DocDate, m1.KursMC, m1.OurID, t.SubID, t.DepID,
       m1.CodeID1, m1.CodeID2, m1.CodeID3, m1.CodeID4, m1.CodeID5, m1.Notes,
       t.EmpID, t.EmpName, m1.PlaceCount, t.CompID, t.TripPurpose, t.TripBDate, t.TripEDate, t.TripDays
FROM
  (SELECT m.ChID, m.DocID, m.IntDocID, m.DocDate, m.KursMC, m.OurID,
          m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes, COUNT(d.ChID) AS PlaceCount
  FROM p_TSer m
  LEFT JOIN p_TSerD AS d ON m.ChID = d.ChID
  GROUP BY m.ChID, m.DocID, m.IntDocID, m.DocDate, m.KursMC, m.OurID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes )m1
LEFT JOIN (SELECT t1.DocID, t1.OurID, t1.EmpID, e.EmpName, t1.CompID, t1.TripPurpose, t1.TripBDate, t1.TripEDate, t1.TripDays, t1.SubID, t1.DepID
          FROM p_ETrp t1, r_Emps e
          WHERE t1.EmpID = e.EmpID) t ON (ISNULL((SELECT TOP 1 ParentDocID FROM z_DocLinks WHERE ChildDocCode = 15043 AND ChildDocID = m1.DocID),0)) = t.DocID AND m1.OurID = t.OurID AND @WorkAge@(m1.DocDate)) GMSView
ORDER BY OurID, DocID', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15550001, 'Реестр: Табель учета рабочего времени: Корректировка', 15550, 15550001, 1, 'Список', 1, 1, 'SELECT * FROM (
SELECT ChID, OurID, DocDate, DocID, AppDate, EmpID, WTSignID, WorkHours, EveningHours, NightHours, DayShiftCount, DayPayFactor, OverTime, OverPayFactor, Notes, StateCode
FROM p_CWTimeCor
WHERE @WorkAge@(DocDate)) GMSView', 3, 'tab_Comm', 'OurID;EmpID;BDate', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15551001, 'Реестр: Табель учета рабочего времени', 15551, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.DocID,
 IntDocID,
 m.DocDate,
 m.KursMC,
 m.OurID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 Sum(d.ChargeCC) AS TChargeCC,
 Sum(d.TWorkHours) AS TTWorkHours,
 Sum(d.TruanDaysCount) AS TTruanDaysCount,
 Sum(d.TWorkDays) AS TTWorkDays,
 Sum(d.HolDaysCount) AS THolDaysCount,
 Sum(d.SickDaysCount) AS TSickDaysCount,
 Sum(d.BLeaveDaysCount) AS TBLeaveDaysCount,
 Sum(d.PLeaveDaysCount) AS TPLeaveDaysCount,
 Sum(d.NonAppDaysCount) AS TNonAppDaysCount
FROM p_CWTime AS m,
 p_CWTimeD AS d
WHERE m.ChID=d.ChID
  AND @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.DocID,
 IntDocID,
 m.DocDate,
 m.KursMC,
 m.OurID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15552001, 'Реестр: Привлечение на другую работу', 15552, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT m.ChID, m.DocID, e.EmpName, m.IntDocID, m.WOrderID, m.DocDate, m.KursMC, m.OurID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, 
       m.CodeID5, m.ExcBDate, m.ExcEDate, m.EmpID, m.SubID, m.DepID, m.PostID, m.EmpClass 
FROM p_WExc m, r_Emps e 
WHERE @WorkAge@(m.DocDate) AND m.EmpID = e.EmpID) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15553001, 'Реестр: Выполнение работ', 15553, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.DocID,
 IntDocID,
 m.DocDate,
 m.KursMC,
 m.OurID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 SUM(Qty) AS TQty,
 SUM(SumCC) AS TSumCC
FROM p_EWrk AS m INNER JOIN p_EWrkD AS d ON m.ChID=d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.DocID,
 IntDocID,
 m.DocDate,
 m.KursMC,
 m.OurID,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15561001, 'Реестр: Заработная плата: Начисление', 15561, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (
SELECT m.ChID, m.DocID, IntDocID, m.OurID, m.DocDate, m.KursMC, m.CodeID1, m.CodeID2, m.CodeID3,  m.CodeID4, m.CodeID5,
       SUM(MainSumCC + ExtraSumCC + MoreSumCC + NeglibleSumCC) AS TFondSumCC,
       SUM(TotPensCC) AS TTotPensCC,
       SUM(TotUnEmployCC) AS TTotUnEmployCC,
       SUM(TotSocInsureCC) AS TTotSocInsureCC,
       SUM(TotAccidentCC) AS TTotAccidentCC,
       SUM(BUniSocDedСС) AS TBUniSocDedСС,
       SUM(IncomeTaxCC) AS TIncomeTaxCC,
       SUM(MilitaryTaxCC) AS TMilitaryTaxCC,
       SUM(PensCC) AS TPensCC,
       SUM(UnEmployCC) AS TUnEmployCC,
       SUM(SocInsureCC) AS TSocInsureCC,
       SUM(ChargeSumCC) AS TChargeSumCC
FROM   p_LRec AS m
INNER JOIN p_LRecD AS d ON d.ChID = m.ChID
WHERE  @WorkAge@(m.DocDate)
GROUP BY m.ChID, m.DocID, IntDocID, m.OurID, m.DocDate, m.KursMC, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15562001, 'Реестр: Заработная плата: Выплата', 15562, 0, 1, 'Общие данные', 1, 1, 'SELECT * FROM (

SELECT m.ChID,
 m.DocID,
 IntDocID,
 m.OurID,
 m.DocDate,
 m.KursMC,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.AccDate,
 m.LExpType,
 m.LExpForm,
 m.LExpPrc,
 Sum(LArrSumCC) AS TLArrSumCC,
 Sum(LRecSumCC) AS TLRecSumCC,
 Sum(LExpSumCC) AS TLExpSumCC,
 Sum(LDepSumCC) AS TLDepSumCC
FROM p_LExp AS m INNER JOIN p_LExpD AS d ON m.ChID=d.ChID
WHERE @WorkAge@(m.DocDate) 
GROUP BY m.ChID,
 m.DocID,
 IntDocID,
 m.OurID,
 m.DocDate,
 m.KursMC,
 m.CodeID1,
 m.CodeID2,
 m.CodeID3,
 m.CodeID4,
 m.CodeID5,
 m.AccDate,
 m.LExpType,
 m.LExpForm,
 m.LExpPrc) GMSView', 3, 'tab_Comm', '', NULL, NULL, 0, 1, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15570001, 'Реестр: Коммунальный налог', 15570, 15570001, 1, 'Список', 1, 1, 'SELECT * FROM (
SELECT ChID, OurID, DocDate, SrcDate, DocID, IntDocID, ISNULL((SELECT SUM(CommunalSumCC) FROM p_CommunalTaxD WHERE ChID = m. ChID), 0) AS TCommunalSumCC, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Notes, StateCode FROM p_CommunalTax m) GMSView', 3, 'tab_Comm', 'OurID;DocDate;DocID', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15591001, 'Реестр: Структура предприятия', 15591, 0, 1, 'Общие данные', 1, 1, 'SELECT
  m.ChID, m.DocID, m.IntDocID, m.DocDate, m.OrderDocID, m.AppDate, m.OurID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes, m.StateCode, COUNT(d.ChID) AS TSubCount
FROM p_SubStruc AS m INNER JOIN
     p_SubStrucD AS d ON m.ChID = d.ChID
WHERE m.DocDate BETWEEN dbo.zf_GetUserWorkAgeBegin(''t'') AND dbo.zf_GetUserWorkAgeEnd(''t'')
GROUP BY m.ChID, m.DocID, m.IntDocID, m.DocDate, m.OrderDocID, m.AppDate, m.OurID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes, m.StateCode
ORDER BY m.OurID, m.ChID', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15592001, 'Реестр: Структура должностей', 15592, 0, 1, 'Общие данные', 1, 1, 'SELECT
  m.ChID, m.DocID, m.IntDocID, m.DocDate, m.OrderDocID, m.AppDate, m.OurID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes, m.StateCode, COUNT(d.ChID) AS TPostCount
FROM p_PostStruc AS m INNER JOIN
     p_PostStrucD AS d ON m.ChID = d.ChID
WHERE m.DocDate BETWEEN dbo.zf_GetUserWorkAgeBegin(''t'') AND dbo.zf_GetUserWorkAgeEnd(''t'')
GROUP BY m.ChID, m.DocID, m.IntDocID, m.DocDate, m.OrderDocID, m.AppDate, m.OurID, m.CodeID1, m.CodeID2, m.CodeID3, m.CodeID4, m.CodeID5, m.Notes, m.StateCode
ORDER BY m.OurID, m.ChID', 3, 'tab_Comm', '', '', '', 0, 0, '< Нет Master-Источника >', '', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15901001, 'Входящие данные по служащим: Список', 15901, 15901001, 1, 'Список', 1, 1, 'p_EmpIn', 1, '', 'OurID;EmpID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15901002, 'Входящие данные по служащим: Начисления', 15901, 15901002, 2, 'Начисления', 1, 1, 'p_EmpInLRec', 1, 'tab_LRec', 'ChID;AccDate;PayTypeID', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15901003, 'Входящие данные по служащим: Выплаты', 15901, 15901003, 3, 'Выплаты', 1, 1, 'p_EmpInLExp', 1, 'tab_LExp', 'ChID;AccDate', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15901004, 'Входящие данные по служащим: Отработанное время', 15901, 15901004, 4, 'Отработанное время', 1, 1, 'p_EmpInWTime', 1, 'tab_WTime', 'ChID;SrcDate', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15901005, 'Входящие данные по служащим: Отпуска', 15901, 15901005, 5, 'Отпуска', 1, 1, 'p_EmpInLeavs', 1, 'tab_Leavs', 'ChID;BDate', '', '', 0, 0, '< Главный Источник Документа >', 'ChID', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
INSERT dbo.z_DataSets(DSCode, DSName, DocCode, TableCode, PageIndex, PageName, PageStyle, PageVisible, SQLStr, SQLType, IntName, SortFields, IntFilter, OpenFilter, FilterBeforeOpen, IsDefault, MasterSource, MasterFields, ReadOnly, UserCode, AFColCount, DSLevel, ColWidth, DescWidth, PageHeight, AFCodeWidth, OptimizeData, LockMode) VALUES (15902001, 'Индексы потребительских цен', 15902, 15902001, 1, 'Индексы потребительских цен', 1, 1, 'p_CPIs', 1, 'tab_Comm', 'YearID;MonthID', '', '', 0, 0, '< Нет Master-Источника >', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
