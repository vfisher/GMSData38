INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_AssetC', 'Справочник основных средств: категории', 'SELECT  ACatName, ACatIDFROM  r_AssetC WITH (NOLOCK) 
ORDER BY ACatName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_AssetG', 'Справочник основных средств: группы', 'SELECT  AGrName, AGrIDFROM  r_AssetG WITH (NOLOCK)ORDER BY AGrID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Assets', 'Справочник основных средств', 'SELECT  AssName, AssIDFROM  r_Assets WITH (NOLOCK) 
ORDER BY AssName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_BankCompAC', 'Банк предприятия валютный', 'SELECT
  BankName CompBankName, CompID, CompAccountAC 
FROM
  r_Banks b WITH(NOLOCK), r_CompsAC c WITH(NOLOCK)
WHERE
  b.BankID = c.BankID
ORDER BY CompBankName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_BankCompCC', 'Банк предприятия расчетный', 'SELECT
  BankName CompBankName, CompID, CompAccountCC 
FROM
  r_Banks b WITH(NOLOCK), r_CompsCC c WITH(NOLOCK)
WHERE
  b.BankID = c.BankID
ORDER BY CompBankName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_BankGrs', 'Справочник банков: группы', 'SELECT
  BankGrName, BankGrID
FROM
  r_BankGrs WITH(NOLOCK)
ORDER BY
  BankGrID
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_BankOurAC', 'Банк фирмы валютный', 'SELECT
  BankName, OurID, AccountAC
FROM
  r_Banks b WITH(NOLOCK), r_OursAC c WITH(NOLOCK)
WHERE
  b.BankID = c.BankID
ORDER BY BankName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_BankOurCC', 'Банк фирмы расчетный', 'SELECT
  BankName, OurID, AccountCC 
FROM
  r_Banks b WITH(NOLOCK), r_OursCC c WITH(NOLOCK)
WHERE
  b.BankID = c.BankID
ORDER BY BankName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Banks', 'Справочник банков', 'SELECT   BankName, BankIDFROM   r_Banks WITH (NOLOCK) 
ORDER BY BankName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_BServs', 'Справочник банковских услуг', 'SELECT
  BServName, BServID
FROM
  r_BServs WITH(NOLOCK)
ORDER BY
  BServID
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Candidates', 'Справочник кандидатов', 'SELECT
  CandidateName, CandidateID
FROM
  r_Candidates WITH(NOLOCK)
ORDER BY
  CandidateID
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Carrs', 'Справочник транспорта', 'SELECT  CarrName, CarrIDFROM  r_Carrs WITH (NOLOCK) 
ORDER BY CarrName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_CarrsC', 'Справочник транспорта: категории', 'SELECT  CarrCName, CarrCIDFROM  r_CarrsC WITH (NOLOCK) 
ORDER BY CarrCName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Codes1', 'Справочник признаков 1', 'SELECT   CodeName1, CodeID1FROM   r_Codes1 WITH (NOLOCK) 
ORDER BY CodeName1');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Codes2', 'Справочник признаков 2', 'SELECT   CodeName2, CodeID2FROM   r_Codes2 WITH (NOLOCK) 
ORDER BY CodeName2');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Codes3', 'Справочник признаков 3', 'SELECT   CodeName3, CodeID3FROM   r_Codes3 WITH (NOLOCK) 
ORDER BY CodeName3');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Codes4', 'Справочник признаков 4', 'SELECT   CodeName4, CodeID4FROM   r_Codes4 WITH (NOLOCK) 
ORDER BY CodeName4');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Codes5', 'Справочник признаков 5', 'SELECT   CodeName5, CodeID5FROM   r_Codes5 WITH (NOLOCK) 
ORDER BY CodeName5');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_CompContacts', 'Справочник Предприятий - Контакты', 'SELECT  CompName, CompIDFROM  r_CompContacts WITH (NOLOCK) 
ORDER BY CompName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_CompG', 'Справочник предприятий: группы', 'SELECT  CGrName, CGrIDFROM  r_CompG WITH (NOLOCK) 
ORDER BY CGrName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_CompGrs1', 'Справочник предприятий: 1 группа', 'SELECT  CompGrName1, CompGrID1FROM  r_CompGrs1 WITH (NOLOCK) 
ORDER BY CompGrName1');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_CompGrs2', 'Справочник предприятий: 2 группа', 'SELECT  CompGrName2, CompGrID2FROM  r_CompGrs2 WITH (NOLOCK) 
ORDER BY CompGrName2');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_CompGrs3', 'Справочник предприятий: 3 группа', 'SELECT  CompGrName3, CompGrID3FROM  r_CompGrs3 WITH (NOLOCK) 
ORDER BY CompGrName3');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_CompGrs4', 'Справочник предприятий: 4 группа', 'SELECT  CompGrName4, CompGrID4FROM  r_CompGrs4 WITH (NOLOCK) 
ORDER BY CompGrName4');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_CompGrs5', 'Справочник предприятий: 5 группа', 'SELECT  CompGrName5, CompGrID5FROM  r_CompGrs5 WITH (NOLOCK) 
ORDER BY CompGrName5');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Comps', 'Справочник предприятий', 'SELECT   CompName, City, CompIDFROM   r_Comps WITH (NOLOCK) 
ORDER BY CompName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_CompsTax', 'Справочник предприятий (налоговые)', 'SELECT  CompName, City, CompID, TaxCode, TaxRegNoFROM  r_Comps WITH (NOLOCK)ORDER BY CompName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_CompValues', 'Справочник предприятий - Значения', 'SELECT  CompName, CompIDFROM  r_CompValues WITH (NOLOCK) 
ORDER BY CompName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Countries', 'Справочник стран', 'SELECT
  Country, CounID
FROM
  r_Countries WITH(NOLOCK)
ORDER BY
  CounID
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_CRs', 'Справочник ЭККА', 'SELECT   CRName, CRIDFROM   r_CRs WITH (NOLOCK) 
ORDER BY CRName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_CRSrvs', 'Справочник торговых серверов', 'SELECT  SrvName, SrvIDFROM  r_CRSrvs WITH (NOLOCK) 
ORDER BY SrvName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_CRTaxs', 'Справочник ЭККА: налоги', 'SELECT  TaxName, TaxIDFROM  r_CRTaxs WITH (NOLOCK) 
ORDER BY TaxName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Currs', 'Справочник валют', 'SELECT   CurrName, CurrIDFROM   r_Currs WITH (NOLOCK) 
ORDER BY CurrName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_DCards', 'Справочник дисконтных карт', 'SELECT
  ChID, DCardID
FROM
  r_DCards WITH (NOLOCK) 
ORDER BY DCardID
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_DCTypeG', 'Справочник дисконтных карт: группы типов', 'SELECT
  DCTypeGName, DCTypeGCode
FROM
  r_DCTypeG WITH(NOLOCK)
ORDER BY
  DCTypeGName
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_DCTypes', 'Справочник типов дисконтных карт', 'SELECT  DCTypeName, DCTypeCodeFROM  r_DCTypes WITH (NOLOCK) 
ORDER BY DCTypeName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Deps', 'Справочник отделов', 'SELECT  DepName, DepIDFROM  r_Deps WITH (NOLOCK) 
ORDER BY DepName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_DeskG', 'Справочник столиков: Группы', 'SELECT  DeskGName, DeskGCodeFROM  r_DeskG WITH (NOLOCK) 
ORDER BY DeskGName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Desks', 'Справочник столиков', 'SELECT  DeskName, DeskCodeFROM  r_Desks WITH (NOLOCK) 
ORDER BY DeskName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_DeviceTypes', 'Тип устройства', 'SELECT
  DeviceTypeName, DeviceType
FROM
  r_DeviceTypes WITH(NOLOCK)
ORDER BY
  SrcPosID
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Dis', 'Справочник ЭККА: скидки - Скидки', 'SELECT  DisName, DisIDFROM  r_Dis WITH (NOLOCK) 
ORDER BY DisName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Emps', 'Справочник служащих', 'SELECT   EmpName, EmpIDFROM   r_Emps WITH (NOLOCK) 
ORDER BY EmpName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Executors', 'Исполнитель', 'SELECT
  ExecutorName, ExecutorID
FROM
  r_Executors WITH(NOLOCK)
ORDER BY
  ExecutorID
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_ExtFiles', 'Справочник расширений файлов', 'SELECT
  ExtFileName, ExtFileID
FROM
  r_ExtFiles WITH(NOLOCK)
ORDER BY
  ExtFileID
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_GAccs', 'Справочник счетов', 'SELECT   GAccID,   GAccName FROM r_GAccs WITH (NOLOCK) 
ORDER BY GAccName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_GAccs1', 'Справочник счетов - Классы', 'SELECT  GAccName1, GAccID1FROM  r_GAccs1 WITH (NOLOCK) 
ORDER BY GAccName1');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_GOperC', 'Справочник проводок: категории', 'SELECT  GOperCName, GOperCIDFROM  r_GOperC WITH (NOLOCK) 
ORDER BY GOperCName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_GOpers', 'Справочник проводок', 'SELECT  GOperName, GOperIDFROM  r_GOpers WITH (NOLOCK) 
ORDER BY GOperName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_GVols', 'Справочник проводок: виды аналитики', 'SELECT  GVolName, GVolIDFROM  r_GVols WITH (NOLOCK) 
ORDER BY GVolName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Holidays', 'Справочник праздничных и нерабочих дней', 'SELECT  HolidayName, HolidayDateFROM  r_Holidays WITH (NOLOCK) 
ORDER BY HolidayName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Levies', 'Сбор', 'SELECT
  LevyName, LevyID
FROM
  r_Levies WITH(NOLOCK)
ORDER BY
  LevyName
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Menu', 'Справочник меню', 'SELECT
  MenuName, MenuID
FROM
  r_Menu WITH(NOLOCK)
ORDER BY
  MenuID
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Mods', 'Справочник модификаторов', 'SELECT  ModName, ModCodeFROM  r_Mods WITH (NOLOCK) 
ORDER BY ModName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Norms', 'Справочник работ: нормы времени', 'SELECT  YearName, YearIDFROM  r_Norms WITH (NOLOCK) 
ORDER BY YearName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Opers', 'Справочник ЭККА: операторы', 'SELECT   OperName, OperIDFROM   r_Opers WITH (NOLOCK) 
ORDER BY OperName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_OrderMonitors', 'Монитор заказов', 'SELECT
  OrderMonitorName, OrderMonitorID
FROM
  r_OrderMonitors WITH(NOLOCK)
ORDER BY
  OrderMonitorName
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Ours', 'Справочник внутренних фирм', 'SELECT   OurName, OurIDFROM   r_Ours WITH (NOLOCK) 
ORDER BY OurName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_OurValues', 'Справочник внутренних фирм - Значения', 'SELECT  OurName, OurIDFROM  r_OurValues WITH (NOLOCK) 
ORDER BY OurName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_PayForms', 'Справочник форм оплаты', 'SELECT 
  PayFormName, PayFormCode
FROM 
  r_PayForms WITH (NOLOCK) 
ORDER BY PayFormName
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_PayTypeCats', 'Справочник выплат/удержаний: категории', 'SELECT  PayTypeCatName, PayTypeCatIDFROM  r_PayTypeCats WITH (NOLOCK) 
ORDER BY PayTypeCatName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_PayTypes', 'Справочник выплат/удержаний', 'SELECT  PayTypeName, PayTypeIDFROM  r_PayTypes WITH (NOLOCK) 
ORDER BY PayTypeName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Persons', 'Персона', 'SELECT
  PersonName, PersonID
FROM
  r_Persons WITH(NOLOCK)
ORDER BY
  PersonID
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_PLs', 'Справочник прайс-листов', 'SELECT   PLName, PLIDFROM   r_PLs WITH (NOLOCK) 
ORDER BY PLName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_POSPays', 'Справочник платежных терминалов', 'SELECT
  POSPayName, POSPayID
FROM
  r_POSPays WITH(NOLOCK)
ORDER BY
  POSPayName
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_PostC', 'Справочник должностей: категории', 'SELECT  PostCName, PostCIDFROM  r_PostC WITH (NOLOCK) 
ORDER BY PostCName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Posts', 'Справочник должностей', 'SELECT  PostName, PostIDFROM  r_Posts WITH (NOLOCK) 
ORDER BY PostName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Prevs', 'Справочник льгот', 'SELECT  PrevName, PrevIDFROM  r_Prevs WITH (NOLOCK) 
ORDER BY PrevName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Processings', 'Процессинговые центры', 'SELECT
  ProcessingName, ProcessingID
FROM
  r_Processings WITH(NOLOCK)
ORDER BY
  ProcessingName
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_ProdA', 'Справочник товаров: группа альтернатив', 'SELECT  PGrAName, PGrAIDFROM  r_ProdA WITH (NOLOCK) 
ORDER BY PGrAName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_ProdBG', 'Справочник товаров: группа бухгалтерии', 'SELECT  PBGrName, PBGrIDFROM  r_ProdBG WITH (NOLOCK) 
ORDER BY PBGrName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_ProdC', 'Справочник товаров: 1 группа', 'SELECT  PCatName, PCatIDFROM  r_ProdC WITH (NOLOCK) 
ORDER BY PCatName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_ProdG', 'Справочник товаров: 2 группа', 'SELECT  PGrName, PGrIDFROM  r_ProdG WITH (NOLOCK) 
ORDER BY PGrName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_ProdG1', 'Справочник товаров: 3 группа', 'SELECT  PGrName1, PGrID1FROM  r_ProdG1 WITH (NOLOCK) 
ORDER BY PGrName1');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_ProdG2', 'Справочник товаров: 4 группа', 'SELECT  PGrName2, PGrID2FROM  r_ProdG2 WITH (NOLOCK) 
ORDER BY PGrName2');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_ProdG3', 'Справочник товаров: 5 группа', 'SELECT  PGrName3, PGrID3FROM  r_ProdG3 WITH (NOLOCK) 
ORDER BY PGrName3');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_ProdMarks', 'Справочник товаров: маркировки', 'SELECT
  DataMatrix, MarkCode
FROM
  r_ProdMarks WITH(NOLOCK)
ORDER BY
  MarkCode
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Prods', 'Справочник товаров', 'SELECT   ProdName, UM, ProdIDFROM   r_Prods WITH (NOLOCK) 
ORDER BY ProdName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_ProdValues', 'Справочник товаров - Значения', 'SELECT  ProdName, ProdIDFROM  r_ProdValues WITH (NOLOCK) 
ORDER BY ProdName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Resources', 'Ресурс', 'SELECT
  ResourceName, ResourceID
FROM
  r_Resources WITH(NOLOCK)
ORDER BY
  ResourceID
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_ResourceTypes', 'Тип ресурса', 'SELECT
  ResourceTypeName, ResourceTypeID
FROM
  r_ResourceTypes WITH(NOLOCK)
ORDER BY
  ResourceTypeID
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_ScaleDefs', 'Весы: конфигурации', 'SELECT
  ScaleDefName, ScaleDefID
FROM
  r_ScaleDefs WITH(NOLOCK)
ORDER BY
  ScaleDefName
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_ScaleGrs', 'Справочник весов: группы', 'SELECT
  ScaleGrName, ScaleGrID
FROM
  r_ScaleGrs WITH(NOLOCK)
ORDER BY
  ScaleGrName
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Scales', 'Справочник весов', 'SELECT
  ScaleName, ScaleID
FROM
  r_Scales WITH(NOLOCK)
ORDER BY
  ScaleName
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Secs', 'Справочник секций', 'SELECT   SecName, SecIDFROM   r_Secs WITH (NOLOCK) 
ORDER BY SecName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Services', 'Услуга', 'SELECT
  ProdName AS SrvcName, SrvcID
FROM
  r_Services s WITH(NOLOCK), r_Prods p WITH(NOLOCK)
WHERE
  s.ProdID = p.ProdID
ORDER BY
  p.ProdName
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Sheds', 'Справочник работ: графики', 'SELECT  ShedName, ShedIDFROM  r_Sheds WITH (NOLOCK) 
ORDER BY ShedName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Spends', 'Справочник затрат', 'SELECT   SpendName, SpendCodeFROM   r_Spends WITH (NOLOCK) 
ORDER BY SpendName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_StateRuleDocs', 'Справочник статусов: документы', 'SELECT  StateName, StateCodeFROM  r_StateRuleDocs WITH (NOLOCK) 
ORDER BY StateName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_StateRuleFrom', 'Справочник статусов: статусы источники', 'SELECT  StateName, StateCodeFROM  r_StateRuleFrom WITH (NOLOCK) 
ORDER BY StateName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_StateRuleTo', 'Справочник статусов: статусы назначения', 'SELECT  StateName, StateCodeFROM  r_StateRuleTo WITH (NOLOCK) 
ORDER BY StateName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_StateRuleUsers', 'Справочник статусов: пользователи', 'SELECT  StateName, StateCodeFROM  r_StateRuleUsers WITH (NOLOCK) 
ORDER BY StateName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_States', 'Справочник статусов', 'SELECT   StateName, StateCodeFROM   r_States WITH (NOLOCK) 
ORDER BY StateName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_StockGs', 'Справочник складов: группы', 'SELECT  StockGName, StockGIDFROM  r_StockGs WITH (NOLOCK) 
ORDER BY StockGName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Stocks', 'Справочник складов', 'SELECT   StockName, StockIDFROM   r_Stocks WITH (NOLOCK) 
ORDER BY StockName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Subs', 'Справочник работ: подразделения', 'SELECT  SubName, SubIDFROM  r_Subs WITH (NOLOCK) 
ORDER BY SubName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_TagC', 'Справочник специализаций: категории', 'SELECT
  TagCName, TagCID
FROM
  r_TagC WITH(NOLOCK)
ORDER BY
  TagCID
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Tags', 'Справочник специализаций', 'SELECT
  TagName, TagID
FROM
  r_Tags WITH(NOLOCK)
ORDER BY
  TagID
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Taxes', 'Справочник НДС', 'SELECT
  TaxName, TaxTypeID
FROM
  r_Taxes WITH(NOLOCK)
ORDER BY
  TaxTypeID
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_TaxRegions', 'Справочник местных налогов', 'SELECT TaxRegionID, TaxRegionName FROM r_TaxRegions');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10011', 'Справочник полов', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10011
ORDER BY
  RefName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10020', 'Справочник типов гражданско-правовых договоров', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10020
ORDER BY
  RefName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10041', 'Справочник видов налоговых накладных', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10041
ORDER BY
  RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10042', 'Справочник причин корректировки налоговых накладных', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10042
ORDER BY
  RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10050', 'Справочник типов должностей', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10050
ORDER BY
  RefName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10051', 'Справочник типов отпусков', '
SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10051
ORDER BY
  RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10055', 'Справочник причин увольнения', 'SELECT
  RefName, Notes, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10055
ORDER BY
  RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10056', 'Справочник причин нетрудоспособности', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10056
ORDER BY
  RefName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10057', 'Справочник типов ставок страхового сбора', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10057
ORDER BY
  RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10058', 'Справочник категорий застрахованных лиц', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10058
ORDER BY
  RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10059', 'Справочник типов корректировки отпуска', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10059
ORDER BY
  RefName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10060', 'Справочник причин корректировки отпуска', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10060
ORDER BY
  RefName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10061', 'Справочник видов образования', 'SELECT RefName, RefID FROM r_Uni WITH(NOLOCK) WHERE RefTypeID = 10061 ORDER BY RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10062', 'Справочник видов семейного положения', 'SELECT RefName, RefID FROM r_Uni WITH(NOLOCK) WHERE RefTypeID = 10062 ORDER BY RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10063', 'Справочник категорий воинской обязанности', 'SELECT RefName, RefID FROM r_Uni WITH(NOLOCK) WHERE RefTypeID = 10063 ORDER BY RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10064', 'Справочник видов годности к военной службе', 'SELECT RefName, RefID FROM r_Uni WITH(NOLOCK) WHERE RefTypeID = 10064 ORDER BY RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10455', 'Справочник ЭККА: Единый ввод: Действия', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10455
ORDER BY
  RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10606', 'Справочник должностей в смене ресторана', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10606
ORDER BY
  RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10607', 'Справочник причин отмены', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10607
ORDER BY
  RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10608', 'Справочник товаров: изображения', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10608
ORDER BY
  RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10609', 'Справочник видов документов', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10609
ORDER BY
  RefName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10610', 'Справочник кандидатов: навыки/ресурсы', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10610
ORDER BY
  RefName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10611', 'Справочник кандидатов: статусы', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10611
ORDER BY
  RefName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10612', 'Справочник кандидатов: результат проверки АО', 'SELECT RefName, RefID FROM r_Uni WITH(NOLOCK) WHERE RefTypeID = 10612 ORDER BY RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10701', 'Справочник персон: Cтатусы', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10701
ORDER BY
  RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10702', 'Справочник причин возврата', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10702
ORDER BY
  RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Uni_10800', 'Справочник способов ввода данных', 'SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 10800
ORDER BY
  RefID');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_Users', 'Справочник пользователей', 'SELECT  UserName, UserIDFROM  r_Users WITH (NOLOCK) 
ORDER BY UserName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_WPrefs', 'Справочник товаров: весовые префиксы', 'SELECT  WPref, Notes WPrefNameFROM  r_WPrefs WITH (NOLOCK)ORDER BY WPref');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_WPRoles', 'Роль рабочего места', 'SELECT
  WPRoleName, WPRoleID
FROM
  r_WPRoles WITH(NOLOCK)
ORDER BY
  WPRoleID
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_WPs', 'Рабочее место', 'SELECT
  WPName, WPID
FROM
  r_WPs WITH(NOLOCK)
ORDER BY
  WPID
');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_WrkTypes', 'Справочник работ: виды', 'SELECT  WrkName, WrkIDFROM  r_WrkTypes WITH (NOLOCK) 
ORDER BY WrkName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_WTSigns', 'Справочник работ: обозначения времени', 'SELECT  WTSignName, WTSignIDFROM  r_WTSigns WITH (NOLOCK) 
ORDER BY WTSignName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('r_WWeeks', 'Справочник работ: типы недели', 'SELECT  WWeekName, WWeekTypeIDFROM  r_WWeeks WITH (NOLOCK) 
ORDER BY WWeekName');
INSERT dbo.z_Lookups(LSName, LSDesc, SQLStr) VALUES ('z_Docs', 'Документы', 'SELECT
  DocName, DocCode
FROM
  z_Docs WITH (NOLOCK) 
ORDER BY DocName');
