INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_AssetC', N'Справочник основных средств: категории', N'SELECT  ACatName, ACatIDFROM  r_AssetC WITH (NOLOCK) 
ORDER BY ACatName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_AssetG', N'Справочник основных средств: группы', N'SELECT  AGrName, AGrIDFROM  r_AssetG WITH (NOLOCK)ORDER BY AGrID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Assets', N'Справочник основных средств', N'SELECT  AssName, AssIDFROM  r_Assets WITH (NOLOCK) 
ORDER BY AssName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_BankCompAC', N'Банк предприятия валютный', N'SELECT
  BankName CompBankName, CompID, CompAccountAC 
FROM
  r_Banks b WITH(NOLOCK), r_CompsAC c WITH(NOLOCK)
WHERE
  b.BankID = c.BankID
ORDER BY CompBankName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_BankCompCC', N'Банк предприятия расчетный', N'SELECT
  BankName CompBankName, CompID, CompAccountCC 
FROM
  r_Banks b WITH(NOLOCK), r_CompsCC c WITH(NOLOCK)
WHERE
  b.BankID = c.BankID
ORDER BY CompBankName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_BankGrs', N'Справочник банков: группы', N'SELECT
  BankGrName, BankGrID
FROM
  r_BankGrs WITH(NOLOCK)
ORDER BY
  BankGrID
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_BankOurAC', N'Банк фирмы валютный', N'SELECT
  BankName, OurID, AccountAC
FROM
  r_Banks b WITH(NOLOCK), r_OursAC c WITH(NOLOCK)
WHERE
  b.BankID = c.BankID
ORDER BY BankName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_BankOurCC', N'Банк фирмы расчетный', N'SELECT
  BankName, OurID, AccountCC 
FROM
  r_Banks b WITH(NOLOCK), r_OursCC c WITH(NOLOCK)
WHERE
  b.BankID = c.BankID
ORDER BY BankName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Banks', N'Справочник банков', N'SELECT   BankName, BankIDFROM   r_Banks WITH (NOLOCK) 
ORDER BY BankName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_BServs', N'Справочник банковских услуг', N'SELECT
  BServName, BServID
FROM
  r_BServs WITH(NOLOCK)
ORDER BY
  BServID
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Candidates', N'Справочник кандидатов', N'SELECT
  CandidateName, CandidateID
FROM
  r_Candidates WITH(NOLOCK)
ORDER BY
  CandidateID
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Carrs', N'Справочник транспорта', N'SELECT  CarrName, CarrIDFROM  r_Carrs WITH (NOLOCK) 
ORDER BY CarrName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_CarrsC', N'Справочник транспорта: категории', N'SELECT  CarrCName, CarrCIDFROM  r_CarrsC WITH (NOLOCK) 
ORDER BY CarrCName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Codes1', N'Справочник признаков 1', N'SELECT   CodeName1, CodeID1FROM   r_Codes1 WITH (NOLOCK) 
ORDER BY CodeName1')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Codes2', N'Справочник признаков 2', N'SELECT   CodeName2, CodeID2FROM   r_Codes2 WITH (NOLOCK) 
ORDER BY CodeName2')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Codes3', N'Справочник признаков 3', N'SELECT   CodeName3, CodeID3FROM   r_Codes3 WITH (NOLOCK) 
ORDER BY CodeName3')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Codes4', N'Справочник признаков 4', N'SELECT   CodeName4, CodeID4FROM   r_Codes4 WITH (NOLOCK) 
ORDER BY CodeName4')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Codes5', N'Справочник признаков 5', N'SELECT   CodeName5, CodeID5FROM   r_Codes5 WITH (NOLOCK) 
ORDER BY CodeName5')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_CompContacts', N'Справочник Предприятий - Контакты', N'SELECT  CompName, CompIDFROM  r_CompContacts WITH (NOLOCK) 
ORDER BY CompName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_CompG', N'Справочник предприятий: группы', N'SELECT  CGrName, CGrIDFROM  r_CompG WITH (NOLOCK) 
ORDER BY CGrName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_CompGrs1', N'Справочник предприятий: 1 группа', N'SELECT  CompGrName1, CompGrID1FROM  r_CompGrs1 WITH (NOLOCK) 
ORDER BY CompGrName1')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_CompGrs2', N'Справочник предприятий: 2 группа', N'SELECT  CompGrName2, CompGrID2FROM  r_CompGrs2 WITH (NOLOCK) 
ORDER BY CompGrName2')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_CompGrs3', N'Справочник предприятий: 3 группа', N'SELECT  CompGrName3, CompGrID3FROM  r_CompGrs3 WITH (NOLOCK) 
ORDER BY CompGrName3')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_CompGrs4', N'Справочник предприятий: 4 группа', N'SELECT  CompGrName4, CompGrID4FROM  r_CompGrs4 WITH (NOLOCK) 
ORDER BY CompGrName4')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_CompGrs5', N'Справочник предприятий: 5 группа', N'SELECT  CompGrName5, CompGrID5FROM  r_CompGrs5 WITH (NOLOCK) 
ORDER BY CompGrName5')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Comps', N'Справочник предприятий', N'SELECT   CompName, City, CompIDFROM   r_Comps WITH (NOLOCK) 
ORDER BY CompName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_CompsTax', N'Справочник предприятий (налоговые)', N'SELECT  CompName, City, CompID, TaxCode, TaxRegNoFROM  r_Comps WITH (NOLOCK)ORDER BY CompName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_CompValues', N'Справочник предприятий - Значения', N'SELECT  CompName, CompIDFROM  r_CompValues WITH (NOLOCK) 
ORDER BY CompName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Countries', N'Справочник стран', N'SELECT
  Country, CounID
FROM
  r_Countries WITH(NOLOCK)
ORDER BY
  CounID
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_CRs', N'Справочник ЭККА', N'SELECT   CRName, CRIDFROM   r_CRs WITH (NOLOCK) 
ORDER BY CRName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_CRSrvs', N'Справочник торговых серверов', N'SELECT  SrvName, SrvIDFROM  r_CRSrvs WITH (NOLOCK) 
ORDER BY SrvName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_CRTaxs', N'Справочник ЭККА: налоги', N'SELECT  TaxName, TaxIDFROM  r_CRTaxs WITH (NOLOCK) 
ORDER BY TaxName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Currs', N'Справочник валют', N'SELECT   CurrName, CurrIDFROM   r_Currs WITH (NOLOCK) 
ORDER BY CurrName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_DCards', N'Справочник дисконтных карт', N'SELECT
  ChID, DCardID
FROM
  r_DCards WITH (NOLOCK) 
ORDER BY DCardID
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_DCTypeG', N'Справочник дисконтных карт: группы типов', N'SELECT
  DCTypeGName, DCTypeGCode
FROM
  r_DCTypeG WITH(NOLOCK)
ORDER BY
  DCTypeGName
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_DCTypes', N'Справочник типов дисконтных карт', N'SELECT  DCTypeName, DCTypeCodeFROM  r_DCTypes WITH (NOLOCK) 
ORDER BY DCTypeName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Deps', N'Справочник отделов', N'SELECT  DepName, DepIDFROM  r_Deps WITH (NOLOCK) 
ORDER BY DepName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_DeskG', N'Справочник столиков: Группы', N'SELECT  DeskGName, DeskGCodeFROM  r_DeskG WITH (NOLOCK) 
ORDER BY DeskGName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Desks', N'Справочник столиков', N'SELECT  DeskName, DeskCodeFROM  r_Desks WITH (NOLOCK) 
ORDER BY DeskName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_DeviceTypes', N'Тип устройства', N'SELECT
  DeviceTypeName, DeviceType
FROM
  r_DeviceTypes WITH(NOLOCK)
ORDER BY
  SrcPosID
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Dis', N'Справочник ЭККА: скидки - Скидки', N'SELECT  DisName, DisIDFROM  r_Dis WITH (NOLOCK) 
ORDER BY DisName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Emps', N'Справочник служащих', N'SELECT   EmpName, EmpIDFROM   r_Emps WITH (NOLOCK) 
ORDER BY EmpName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Executors', N'Исполнитель', N'SELECT
  ExecutorName, ExecutorID
FROM
  r_Executors WITH(NOLOCK)
ORDER BY
  ExecutorID
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_ExtFiles', N'Справочник расширений файлов', N'SELECT
  ExtFileName, ExtFileID
FROM
  r_ExtFiles WITH(NOLOCK)
ORDER BY
  ExtFileID
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_GAccs', N'Справочник счетов', N'SELECT   GAccID,   GAccName FROM r_GAccs WITH (NOLOCK) 
ORDER BY GAccName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_GAccs1', N'Справочник счетов - Классы', N'SELECT  GAccName1, GAccID1FROM  r_GAccs1 WITH (NOLOCK) 
ORDER BY GAccName1')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_GOperC', N'Справочник проводок: категории', N'SELECT  GOperCName, GOperCIDFROM  r_GOperC WITH (NOLOCK) 
ORDER BY GOperCName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_GOpers', N'Справочник проводок', N'SELECT  GOperName, GOperIDFROM  r_GOpers WITH (NOLOCK) 
ORDER BY GOperName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_GVols', N'Справочник проводок: виды аналитики', N'SELECT  GVolName, GVolIDFROM  r_GVols WITH (NOLOCK) 
ORDER BY GVolName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Holidays', N'Справочник праздничных и нерабочих дней', N'SELECT  HolidayName, HolidayDateFROM  r_Holidays WITH (NOLOCK) 
ORDER BY HolidayName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Levies', N'Сбор', N'SELECT
  LevyName, LevyID
FROM
  r_Levies WITH(NOLOCK)
ORDER BY
  LevyName
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Menu', N'Справочник меню', N'SELECT
  MenuName, MenuID
FROM
  r_Menu WITH(NOLOCK)
ORDER BY
  MenuID
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Mods', N'Справочник модификаторов', N'SELECT  ModName, ModCodeFROM  r_Mods WITH (NOLOCK) 
ORDER BY ModName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Norms', N'Справочник работ: нормы времени', N'SELECT  YearName, YearIDFROM  r_Norms WITH (NOLOCK) 
ORDER BY YearName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Opers', N'Справочник ЭККА: операторы', N'SELECT   OperName, OperIDFROM   r_Opers WITH (NOLOCK) 
ORDER BY OperName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_OrderMonitors', N'Монитор заказов', N'SELECT
  OrderMonitorName, OrderMonitorID
FROM
  r_OrderMonitors WITH(NOLOCK)
ORDER BY
  OrderMonitorName
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Ours', N'Справочник внутренних фирм', N'SELECT   OurName, OurIDFROM   r_Ours WITH (NOLOCK) 
ORDER BY OurName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_OurValues', N'Справочник внутренних фирм - Значения', N'SELECT  OurName, OurIDFROM  r_OurValues WITH (NOLOCK) 
ORDER BY OurName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_PayForms', N'Справочник форм оплаты', N'SELECT 
  PayFormName, PayFormCode
FROM 
  r_PayForms WITH (NOLOCK) 
ORDER BY PayFormName
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_PayTypeCats', N'Справочник выплат/удержаний: категории', N'SELECT  PayTypeCatName, PayTypeCatIDFROM  r_PayTypeCats WITH (NOLOCK) 
ORDER BY PayTypeCatName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_PayTypes', N'Справочник выплат/удержаний', N'SELECT  PayTypeName, PayTypeIDFROM  r_PayTypes WITH (NOLOCK) 
ORDER BY PayTypeName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Persons', N'Персона', N'SELECT
  PersonName, PersonID
FROM
  r_Persons WITH(NOLOCK)
ORDER BY
  PersonID
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_PLs', N'Справочник прайс-листов', N'SELECT   PLName, PLIDFROM   r_PLs WITH (NOLOCK) 
ORDER BY PLName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_POSPays', N'Справочник платежных терминалов', N'SELECT
  POSPayName, POSPayID
FROM
  r_POSPays WITH(NOLOCK)
ORDER BY
  POSPayName
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_PostC', N'Справочник должностей: категории', N'SELECT  PostCName, PostCIDFROM  r_PostC WITH (NOLOCK) 
ORDER BY PostCName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Posts', N'Справочник должностей', N'SELECT  PostName, PostIDFROM  r_Posts WITH (NOLOCK) 
ORDER BY PostName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Prevs', N'Справочник льгот', N'SELECT  PrevName, PrevIDFROM  r_Prevs WITH (NOLOCK) 
ORDER BY PrevName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Processings', N'Процессинговые центры', N'SELECT
  ProcessingName, ProcessingID
FROM
  r_Processings WITH(NOLOCK)
ORDER BY
  ProcessingName
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_ProdA', N'Справочник товаров: группа альтернатив', N'SELECT  PGrAName, PGrAIDFROM  r_ProdA WITH (NOLOCK) 
ORDER BY PGrAName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_ProdBG', N'Справочник товаров: группа бухгалтерии', N'SELECT  PBGrName, PBGrIDFROM  r_ProdBG WITH (NOLOCK) 
ORDER BY PBGrName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_ProdC', N'Справочник товаров: 1 группа', N'SELECT  PCatName, PCatIDFROM  r_ProdC WITH (NOLOCK) 
ORDER BY PCatName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_ProdG', N'Справочник товаров: 2 группа', N'SELECT  PGrName, PGrIDFROM  r_ProdG WITH (NOLOCK) 
ORDER BY PGrName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_ProdG1', N'Справочник товаров: 3 группа', N'SELECT  PGrName1, PGrID1FROM  r_ProdG1 WITH (NOLOCK) 
ORDER BY PGrName1')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_ProdG2', N'Справочник товаров: 4 группа', N'SELECT  PGrName2, PGrID2FROM  r_ProdG2 WITH (NOLOCK) 
ORDER BY PGrName2')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_ProdG3', N'Справочник товаров: 5 группа', N'SELECT  PGrName3, PGrID3FROM  r_ProdG3 WITH (NOLOCK) 
ORDER BY PGrName3')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_ProdMarks', N'Справочник товаров: маркировки', N'SELECT
  DataMatrix, MarkCode
FROM
  r_ProdMarks WITH(NOLOCK)
ORDER BY
  MarkCode
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Prods', N'Справочник товаров', N'SELECT   ProdName, UM, ProdIDFROM   r_Prods WITH (NOLOCK) 
ORDER BY ProdName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_ProdValues', N'Справочник товаров - Значения', N'SELECT  ProdName, ProdIDFROM  r_ProdValues WITH (NOLOCK) 
ORDER BY ProdName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Resources', N'Ресурс', N'SELECT
  ResourceName, ResourceID
FROM
  r_Resources WITH(NOLOCK)
ORDER BY
  ResourceID
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_ResourceTypes', N'Тип ресурса', N'SELECT
  ResourceTypeName, ResourceTypeID
FROM
  r_ResourceTypes WITH(NOLOCK)
ORDER BY
  ResourceTypeID
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_ScaleDefs', N'Весы: конфигурации', N'SELECT
  ScaleDefName, ScaleDefID
FROM
  r_ScaleDefs WITH(NOLOCK)
ORDER BY
  ScaleDefName
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_ScaleGrs', N'Справочник весов: группы', N'SELECT
  ScaleGrName, ScaleGrID
FROM
  r_ScaleGrs WITH(NOLOCK)
ORDER BY
  ScaleGrName
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Scales', N'Справочник весов', N'SELECT
  ScaleName, ScaleID
FROM
  r_Scales WITH(NOLOCK)
ORDER BY
  ScaleName
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Secs', N'Справочник секций', N'SELECT   SecName, SecIDFROM   r_Secs WITH (NOLOCK) 
ORDER BY SecName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Services', N'Услуга', N'SELECT
  ProdName AS SrvcName, SrvcID
FROM
  r_Services s WITH(NOLOCK), r_Prods p WITH(NOLOCK)
WHERE
  s.ProdID = p.ProdID
ORDER BY
  p.ProdName
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Sheds', N'Справочник работ: графики', N'SELECT  ShedName, ShedIDFROM  r_Sheds WITH (NOLOCK) 
ORDER BY ShedName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Spends', N'Справочник затрат', N'SELECT   SpendName, SpendCodeFROM   r_Spends WITH (NOLOCK) 
ORDER BY SpendName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_StateRuleDocs', N'Справочник статусов: документы', N'SELECT  StateName, StateCodeFROM  r_StateRuleDocs WITH (NOLOCK) 
ORDER BY StateName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_StateRuleFrom', N'Справочник статусов: статусы источники', N'SELECT  StateName, StateCodeFROM  r_StateRuleFrom WITH (NOLOCK) 
ORDER BY StateName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_StateRuleTo', N'Справочник статусов: статусы назначения', N'SELECT  StateName, StateCodeFROM  r_StateRuleTo WITH (NOLOCK) 
ORDER BY StateName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_StateRuleUsers', N'Справочник статусов: пользователи', N'SELECT  StateName, StateCodeFROM  r_StateRuleUsers WITH (NOLOCK) 
ORDER BY StateName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_States', N'Справочник статусов', N'SELECT   StateName, StateCodeFROM   r_States WITH (NOLOCK) 
ORDER BY StateName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_StockGs', N'Справочник складов: группы', N'SELECT  StockGName, StockGIDFROM  r_StockGs WITH (NOLOCK) 
ORDER BY StockGName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Stocks', N'Справочник складов', N'SELECT   StockName, StockIDFROM   r_Stocks WITH (NOLOCK) 
ORDER BY StockName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Subs', N'Справочник работ: подразделения', N'SELECT  SubName, SubIDFROM  r_Subs WITH (NOLOCK) 
ORDER BY SubName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_TagC', N'Справочник специализаций: категории', N'SELECT
  TagCName, TagCID
FROM
  r_TagC WITH(NOLOCK)
ORDER BY
  TagCID
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Tags', N'Справочник специализаций', N'SELECT
  TagName, TagID
FROM
  r_Tags WITH(NOLOCK)
ORDER BY
  TagID
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Taxes', N'Справочник НДС', N'SELECT
  TaxName, TaxTypeID
FROM
  r_Taxes WITH(NOLOCK)
ORDER BY
  TaxTypeID
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_TaxRegions', N'Справочник местных налогов', N'SELECT TaxRegionID, TaxRegionName FROM r_TaxRegions')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10011', N'Справочник полов', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10011
ORDER BY
  RefName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10020', N'Справочник типов гражданско-правовых договоров', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10020
ORDER BY
  RefName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10041', N'Справочник видов налоговых накладных', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10041
ORDER BY
  RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10042', N'Справочник причин корректировки налоговых накладных', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10042
ORDER BY
  RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10050', N'Справочник типов должностей', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10050
ORDER BY
  RefName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10051', N'Справочник типов отпусков', N'
SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10051
ORDER BY
  RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10055', N'Справочник причин увольнения', N'SELECT
  RefName, Notes, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10055
ORDER BY
  RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10056', N'Справочник причин нетрудоспособности', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10056
ORDER BY
  RefName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10057', N'Справочник типов ставок страхового сбора', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10057
ORDER BY
  RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10058', N'Справочник категорий застрахованных лиц', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10058
ORDER BY
  RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10059', N'Справочник типов корректировки отпуска', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10059
ORDER BY
  RefName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10060', N'Справочник причин корректировки отпуска', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10060
ORDER BY
  RefName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10061', N'Справочник видов образования', N'SELECT RefName, RefID FROM r_Uni WITH(NOLOCK) WHERE RefTypeID = 10061 ORDER BY RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10062', N'Справочник видов семейного положения', N'SELECT RefName, RefID FROM r_Uni WITH(NOLOCK) WHERE RefTypeID = 10062 ORDER BY RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10063', N'Справочник категорий воинской обязанности', N'SELECT RefName, RefID FROM r_Uni WITH(NOLOCK) WHERE RefTypeID = 10063 ORDER BY RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10064', N'Справочник видов годности к военной службе', N'SELECT RefName, RefID FROM r_Uni WITH(NOLOCK) WHERE RefTypeID = 10064 ORDER BY RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10455', N'Справочник ЭККА: Единый ввод: Действия', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10455
ORDER BY
  RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10606', N'Справочник должностей в смене ресторана', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10606
ORDER BY
  RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10607', N'Справочник причин отмены', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10607
ORDER BY
  RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10608', N'Справочник товаров: изображения', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10608
ORDER BY
  RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10609', N'Справочник видов документов', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10609
ORDER BY
  RefName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10610', N'Справочник кандидатов: навыки/ресурсы', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10610
ORDER BY
  RefName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10611', N'Справочник кандидатов: статусы', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10611
ORDER BY
  RefName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10612', N'Справочник кандидатов: результат проверки АО', N'SELECT RefName, RefID FROM r_Uni WITH(NOLOCK) WHERE RefTypeID = 10612 ORDER BY RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10701', N'Справочник персон: Cтатусы', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10701
ORDER BY
  RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10702', N'Справочник причин возврата', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10702
ORDER BY
  RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Uni_10800', N'Справочник способов ввода данных', N'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10800
ORDER BY
  RefID')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_Users', N'Справочник пользователей', N'SELECT  UserName, UserIDFROM  r_Users WITH (NOLOCK) 
ORDER BY UserName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_WPrefs', N'Справочник товаров: весовые префиксы', N'SELECT  WPref, Notes WPrefNameFROM  r_WPrefs WITH (NOLOCK)ORDER BY WPref')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_WPRoles', N'Роль рабочего места', N'SELECT
  WPRoleName, WPRoleID
FROM
  r_WPRoles WITH(NOLOCK)
ORDER BY
  WPRoleID
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_WPs', N'Рабочее место', N'SELECT
  WPName, WPID
FROM
  r_WPs WITH(NOLOCK)
ORDER BY
  WPID
')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_WrkTypes', N'Справочник работ: виды', N'SELECT  WrkName, WrkIDFROM  r_WrkTypes WITH (NOLOCK) 
ORDER BY WrkName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_WTSigns', N'Справочник работ: обозначения времени', N'SELECT  WTSignName, WTSignIDFROM  r_WTSigns WITH (NOLOCK) 
ORDER BY WTSignName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'r_WWeeks', N'Справочник работ: типы недели', N'SELECT  WWeekName, WWeekTypeIDFROM  r_WWeeks WITH (NOLOCK) 
ORDER BY WWeekName')
INSERT INTO [dbo].[z_Lookups] ([LSName], [LSDesc], [SQLStr]) VALUES (N'z_Docs', N'Документы', N'SELECT
  DocName, DocCode
FROM
  z_Docs WITH (NOLOCK) 
ORDER BY DocName')
