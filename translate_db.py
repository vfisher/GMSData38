# Create a dictionary from db objects
# python 3.12+

import pyodbc
import regex
import translators as trs
import time
import json
import itertools
from funcy import print_durations
from datetime import datetime
import os.path

# Если не компилится, доустановите модули:
# python -m pip install pyodbc
# python -m pip install regex
# python -m pip install ...

__author__ = "Oleksii Veseliev"
__copyright__ = "Copyright (C) 2024 Oleksii Veseliev, GMS Service LLC"
__license__ = "Public Domain"
__version__ = "1.3"


# # ---=== Настройки ===---
dict_filename = 'dict.json'
server = r'gmsveseljev\sql2016'
user = r'sa'
password = r''
db = r'Etalon'
# Начальный id для добавляемых в словарь строк (если там пусто, то 1)
msg_id_base = 1
# Пропустить слова на українскій мові (возможно, часть БД уже переведена и нам надо сделать "по быстрому" на единственный укр. язык)
avoid_ua = 0
# Добавить в начало скрипта создание таблицы с переводами
include_create_table = 1
# Перевести найденные в ХП строки автоматом
translate = True
# Движок для перевода 'google', 'bing' ... Гугл любит банить за большой rps
translation_engine = 'bing'
# Задержка перед переводом каждой строки в сек (антибан). Гугл банит и на 4 сек, бинг работает нормально на 1 сек
translation_delay = 0.01
# Регексп для игнорируемых объектов БД
ignore_obects_regexp = [r'(?i)t_GetValid\w*Discs_\d+'
    , r'(?i)t_SaleOnEvent'
    , r'(?i)t_DiscChargePos_\d+'
    , r'(?i)p_GetXMLJ3001001'
    , r'(?i)t_DiscSave_\d+'
    , r'(?i)p_GetIndexUnifiedSocialTax'
    , r'(?i)tf_Get\w*DocBonuses\w*_\d'
    , r'(?i)t_Booking\w+'
    , r'(?i)t_ProdMarkDoValidate'
    , r'(?i)t_UpdateClosedBookingPos'
    , r'(?i)t_CanCloseRestShift'
    , r'(?i)t_RestBill2Res'
    , r'(?i)t_SaleGetFreeDCTypes'
    , r'(?i)t_RestRes2Bill'
    , r'(?i)t_DiscOnPrint\w+'
    , r'(?i)tf_GetBooking\w+'
    , r'(?i)t_ShowCRBalance'
    , r'(?i)pf_GetTaxSocialPrivilege'
    , r'(?i)pf_LeavCalcAvgSalary'
                        ]
# Регексп для игнорируемых найденных в текстах ХП строк
ignore_strings_regexp = r'(?i)БУ_\w+|КЗ_\w|НЗ_\w+|ЗК_\w+|НУ_\w+'

# ---=== Конец настроек ===---

dictionary = dict()  # set()
base_script = """
drop table z_Translations
go 

if OBJECT_ID (N'z_Translations', N'U') IS NULL 
    create table z_Translations(
        MsgID int not null
        , TypeID tinyint not null
        , RU varchar(max) 
        , UK varchar(max)
    )
go

IF object_id('zf_Translate', 'FN') IS NOT NULL
    DROP FUNCTION dbo.zf_Translate
go

create function dbo.zf_Translate(@RUText varchar(max))
returns varchar(max)
as
begin
  declare @lng varchar(20), @s varchar(max)
  set @lng = Cast(SESSION_CONTEXT(N'language') as varchar(20))

  if @lng = 'Russian' 
    select @s = COALESCE(RU, cast(MsgID as varchar(10))) from z_Translations where TypeID = 0 And RU = @RUText
  else if @lng = 'Ukrainian' or @lng = '' or @lng is null
    select @s = COALESCE(UK, RU, cast(MsgID as varchar(10))) from z_Translations where TypeID = 0 And RU = @RUText

  If @s is NULL
    set @s = @RUText

  return @s
end
go

IF object_id('zf_TranslateMetadata', 'FN') IS NOT NULL
    DROP FUNCTION dbo.zf_TranslateMetadata
go

create function dbo.zf_TranslateMetadata(@MsgID int, @TypeID tinyint)
returns varchar(max)
as
begin
  /* TypeID: 0:Text 1:FieldDesc 2:DocName 3:DsName 4:PageName */
  declare @lng varchar(20), @s varchar(max)
  set @lng = Cast(SESSION_CONTEXT(N'language') as varchar(20))

  if @lng = 'Russian' 
    select @s = COALESCE(RU, cast(MsgID as varchar(10))) from z_Translations where MsgID = @MsgID and TypeID = @TypeID
  else if @lng = 'Ukrainian' or @lng = '' or @lng is null
    select @s = COALESCE(UK, RU, cast(MsgID as varchar(10))) from z_Translations where MsgID = @MsgID and TypeID = @TypeID

  If @s is NULL
    set @s = 'Null: ' + cast(@MsgID as varchar(10))

  return @s
end
go

if not exists (select * from z_Tables where TableName = 'z_Translations')
INSERT INTO z_Tables ([DocCode], [TableCode], [TableName], [TableDesc], [TableInfo], [DateField], [PKFields], [SortFields], [IntFilter], [OpenFilter], [IsView], [IsDefault], [HaveOur], [ForSync], [UpdateLog], [SyncAUFields])
VALUES
( 1001, 1001182, 'z_Translations', 'Перевод', 'Перевод сообщений в БД', '', 'MsgID', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0 )

if not exists (select * from z_Tables where TableName = 'z_TranslationsMetadata')
INSERT INTO z_Tables ([DocCode], [TableCode], [TableName], [TableDesc], [TableInfo], [DateField], [PKFields], [SortFields], [IntFilter], [OpenFilter], [IsView], [IsDefault], [HaveOur], [ForSync], [UpdateLog], [SyncAUFields])
VALUES
( 1001, 1001183, 'z_TranslationsMetadata', 'Перевод метаданных', 'Перевод метаданных', '', 'MetaID,TypeID', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0 )

/*
if not exists (select * from z_Fields where FieldName = 'MsgID')
INSERT INTO z_Fields ([TableCode], [FieldPosID], [FieldName], [FieldInfo], [Required], [DataSize], [DBDefault])
VALUES
( 1001182, 1, 'MsgID', NULL, 1, 4, NULL ),
( 1001182, 2, 'RU', NULL, 0, -1, NULL ),
( 1001182, 3, 'UK', NULL, 0, -1, NULL )
*/
if not exists (select * from z_objects where ObjName = 'zf_Translate')
INSERT INTO z_objects ([ObjCode], [ObjName], [ObjDesc], [ObjInfo], [ObjType], [RevID])
VALUES
( (select max([ObjCode])+1 from z_objects), 'zf_Translate', 'Возвращает перевод для фразы', NULL, 'FN', 1 )

if not exists (select * from z_objects where ObjName = 'zf_TranslateMetadata')
INSERT INTO z_objects ([ObjCode], [ObjName], [ObjDesc], [ObjInfo], [ObjType], [RevID])
VALUES
( (select max([ObjCode])+1 from z_objects), 'zf_TranslateMetadata', 'Возвращает перевод для метаданных', NULL, 'FN', 1 )
go

update z_datasets set intname = 'tab_Comm' where intname = 'Общие данные' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_DCards')
update z_datasets set intname = 'tab_List' where intname = 'Список' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_Comm' where intname = 'Общие данные' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_PClass' where intname = 'Классификация' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_MQ' where intname = 'Виды упаковок' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_M_PP' where intname = 'Партии' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_M_PL' where intname = 'Цены продажи' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_AutoCh' where intname = 'Автоизменение цен' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_Prices' where intname = 'Цены' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_Norms' where intname = 'Нормы' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_More1' where intname = 'Дополнительно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_Alts' where intname = 'Альтернативы' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_ProdEC' where intname = 'Внешние коды' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_Values' where intname = 'Значения периодов' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_Crts' where intname = 'Сертификаты' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'TabSheet3' where intname = 'Сертификаты партий ' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_Sets' where intname = 'Комплекты' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_SetD' where intname = 'Комплектация' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_SExp' where intname = 'Разукомплектация' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_SetC' where intname = 'Затраты на 1 комплект' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_ProdValues' where intname = 'Значения' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_Images' where intname = 'Изображения' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'TabSheet1' where intname = 'Товар' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_PCstRec')
update z_datasets set intname = 'ctl_Main' where intname = 'Свойства' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_PCstRec')
update z_datasets set intname = 'ctl_More' where intname = 'Дополнительно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_PCstRec')
update z_datasets set intname = 'ctl_Tax' where intname = 'Налоговая' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_PCstRec')
update z_datasets set intname = 'tab_Comm' where intname = 'Товар' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_PCustom')
update z_datasets set intname = 'ctl_Main' where intname = 'Свойства' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_PCustom')
update z_datasets set intname = 'ctl_More' where intname = 'Дополнительно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_PCustom')
update z_datasets set intname = 'tab_Tax' where intname = 'Налоговая' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_PCustom')
update z_datasets set intname = 'TabSheet2' where intname = 'Первичные данные' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_EVen')
update z_datasets set intname = 'ctl_Params' where intname = 'Настройки' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_PDoc')
update z_datasets set intname = 'TabSheet1' where intname = 'Товар' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_SEst')
update z_datasets set intname = 'TabSheet2' where intname = 'Свойства' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_SEst')
update z_datasets set intname = 'tab_Props' where intname = 'Настройки' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_SEst')
update z_datasets set intname = 'tab_Main2' where intname = 'Подробно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_OrderDistrib')
update z_datasets set intname = 'ctl_Params' where intname = 'Настройки' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_OrderExtNew')
update z_datasets set intname = 'tab_Sets' where intname = 'Комплекты' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_SetDoc')
update z_datasets set intname = 'tab_SubSets' where intname = 'Составляющие комплекта' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_SetDoc')
update z_datasets set intname = 'tab_SubSet1Costs' where intname = 'Затраты на 1 комплект' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_SetDoc')
update z_datasets set intname = 'tab_CreateSets' where intname = 'Работа с комплектами' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_SetDoc')
update z_datasets set intname = 'tab_Cost' where intname = 'Общие затраты' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_SetDoc')
update z_datasets set intname = 'TabSheet2' where intname = 'Итоги' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_SetDoc')
update z_datasets set intname = 'TabSheet3' where intname = 'Дополнительно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tft_SetDoc')
update z_datasets set intname = 'tab_List' where intname = 'Список' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_Comm' where intname = 'Общие данные' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_PClass' where intname = 'Классификация' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_M_PP' where intname = 'Партии' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_M_PL' where intname = 'Цены продажи' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_Prices' where intname = 'Цены' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_Norms' where intname = 'Нормы' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_More1' where intname = 'Дополнительно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_Crts' where intname = 'Сертификаты' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'TabSheet3' where intname = 'Сертификаты партий ' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_Sets' where intname = 'Комплекты' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_SetD' where intname = 'Комплектация' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_SExp' where intname = 'Разукомплектация' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_SetC' where intname = 'Затраты на 1 комплект' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Prods')
update z_datasets set intname = 'tab_V' where intname = 'Общие' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_AssRepair')
update z_datasets set intname = 'tab_P' where intname = 'ТМЦ' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_AssRepair')
update z_datasets set intname = 'ctl_Main' where intname = 'Свойства' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_AssRepair')
update z_datasets set intname = 'ctl_More' where intname = 'Дополнительно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_AssRepair')
update z_datasets set intname = 'TabSheet1' where intname = 'Список' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Assets')
update z_datasets set intname = 'tab_Main' where intname = 'Общие данные' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Assets')
update z_datasets set intname = 'tab_More' where intname = 'Дополнительно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Assets')
update z_datasets set intname = 'tab_Comm' where intname = 'ТМЦ' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_Acc')
update z_datasets set intname = 'ctl_Main' where intname = 'Свойства' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_Acc')
update z_datasets set intname = 'ctl_More' where intname = 'Дополнительно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_Acc')
update z_datasets set intname = 'tab_List' where intname = 'Список' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_HandTran')
update z_datasets set intname = 'tab_DAnal' where intname = 'Аналитика дебета' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_HandTran')
update z_datasets set intname = 'tab_CAnal' where intname = 'Аналитика кредита' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_HandTran')
update z_datasets set intname = 'tab_Filter' where intname = 'Фильтр' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_HandTran')
update z_datasets set intname = 'TabSheet1' where intname = 'Список' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_TaxInvOut')
update z_datasets set intname = 'ctl_Main' where intname = 'Свойства' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_TaxInvOut')
update z_datasets set intname = 'ctl_Params' where intname = 'Настройки' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_TaxInvOut')
update z_datasets set intname = 'tab_Main' where intname = 'Общие' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_WayBill')
update z_datasets set intname = 'tab_Tasks' where intname = 'Задания водителю' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_WayBill')
update z_datasets set intname = 'tab_RWork' where intname = 'Результаты работы' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_WayBill')
update z_datasets set intname = 'ctl_Main' where intname = 'Свойства' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_WayBill')
update z_datasets set intname = 'ctl_More' where intname = 'Дополнительно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_WayBill')
update z_datasets set intname = 'TabSheet1' where intname = 'Список' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Cars')
update z_datasets set intname = 'tab_Carrs' where intname = 'Общие данные' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Cars')
update z_datasets set intname = 'tab_More' where intname = 'Дополнительно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Cars')
update z_datasets set intname = 'tab_V' where intname = 'Общие' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_CashRep')
update z_datasets set intname = 'tab_P' where intname = 'ТМЦ' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_CashRep')
update z_datasets set intname = 'tab_S' where intname = 'Основные средства' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_CashRep')
update z_datasets set intname = 'ctl_Main' where intname = 'Свойства' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_CashRep')
update z_datasets set intname = 'ctl_More' where intname = 'Дополнительно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_CashRep')
update z_datasets set intname = 'ctl_Tax' where intname = 'Налоговая' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_CashRep')
update z_datasets set intname = 'tab_V' where intname = 'Общие' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_CashRepCodes')
update z_datasets set intname = 'tab_P' where intname = 'ТМЦ' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_CashRepCodes')
update z_datasets set intname = 'tab_S' where intname = 'Основные средства' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_CashRepCodes')
update z_datasets set intname = 'ctl_Main' where intname = 'Свойства' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_CashRepCodes')
update z_datasets set intname = 'ctl_More' where intname = 'Дополнительно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_CashRepCodes')
update z_datasets set intname = 'ctl_Tax' where intname = 'Налоговая' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_CashRepCodes')
update z_datasets set intname = 'tab_Comm' where intname = 'ТМЦ' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_PAcc')
update z_datasets set intname = 'tab_MoreComm' where intname = 'Свойства' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_PAcc')
update z_datasets set intname = 'ctl_More' where intname = 'Дополнительно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_PAcc')
update z_datasets set intname = 'ctl_Tax' where intname = 'Налоговая' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_PAcc')
update z_datasets set intname = 'TabSheet4' where intname = 'Списание ТМЦ' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_PCost')
update z_datasets set intname = 'TabSheet5' where intname = 'Прочие расходы' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_PCost')
update z_datasets set intname = 'tab_DocD_Exp' where intname = 'Прочие расходы' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_PCost')
update z_datasets set intname = 'pan_RunCalc' where intname = 'Расчет себестоимости' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_PCost')
update z_datasets set intname = 'TabSheet1' where intname = 'ТМЦ' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_PCstRec')
update z_datasets set intname = 'ctl_Main' where intname = 'Свойства' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_PCstRec')
update z_datasets set intname = 'ctl_More' where intname = 'Дополнительно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_PCstRec')
update z_datasets set intname = 'ctl_Tax' where intname = 'Налоговая' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_PCstRec')
update z_datasets set intname = 'ctl_Params' where intname = 'Настройки' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_ProdIn')
update z_datasets set intname = 'TabSheet1' where intname = 'Список' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_SalaryIn')
update z_datasets set intname = 'ctl_Main' where intname = 'Свойства' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_SalaryIn')
update z_datasets set intname = 'ctl_FundsInfo' where intname = 'По фондам' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_SalaryIn')
update z_datasets set intname = 'TabSheet1' where intname = 'Список' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_SalaryOut')
update z_datasets set intname = 'ctl_Main' where intname = 'Свойства' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfb_SalaryOut')
update z_datasets set intname = 'TabSheet1' where intname = 'Данные' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfc_Salary')
update z_datasets set intname = 'tab_Comm' where intname = 'Общие данные' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_StdRef')
update z_datasets set intname = 'tab_Comm' where intname = 'Список' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfz_StdDoc')
update z_datasets set intname = 'tab_List' where intname = 'Список' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Comps')
update z_datasets set intname = 'tab_Comm' where intname = 'Общие данные' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Comps')
update z_datasets set intname = 'tab_Contacts' where intname = 'Контакты' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Comps')
update z_datasets set intname = 'tab_BankCC' where intname = 'Расчетные счета' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Comps')
update z_datasets set intname = 'tab_BankMC' where intname = 'Валютные счета' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Comps')
update z_datasets set intname = 'tab_Templates' where intname = 'Дополнительно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Comps')
update z_datasets set intname = 'tab_Docs' where intname = 'Документы' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Comps')
update z_datasets set intname = 'tab_Addresses' where intname = 'Адреса доставки' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Comps')
update z_datasets set intname = 'tab_Discount' where intname = 'Дисконтные карты' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Comps')
update z_datasets set intname = 'tab_CompValues' where intname = 'Значения' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Comps')
update z_datasets set intname = 'tab_List' where intname = 'Список' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Emps')
update z_datasets set intname = 'tab_Comm' where intname = 'Общие данные' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Emps')
update z_datasets set intname = 'tab_More' where intname = 'Дополнительно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Emps')
update z_datasets set intname = 'tab_Contact' where intname = 'Контакты' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Emps')
update z_datasets set intname = 'tab_Kin' where intname = 'Семейное положение' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Emps')
update z_datasets set intname = 'tab_Act' where intname = 'Трудовая деятельность' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Emps')
update z_datasets set intname = 'tab_Ours' where intname = 'Фирмы' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Emps')
update z_datasets set intname = 'tab_Priv' where intname = 'Льготы' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Emps')
update z_datasets set intname = 'tab_Mil' where intname = 'Воинский учет' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Emps')
update z_datasets set intname = 'tab_EmpNames' where intname = 'Изменение ФИО' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Emps')
update z_datasets set intname = 'tab_EmpMPst' where intname = 'Кадровое состояние' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Emps')
update z_datasets set intname = 'tab_EmpFiles' where intname = 'Документы' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Emps')
update z_datasets set intname = 'tab_DetPages' where intname = 'Подробно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_CommunalTax')
update z_datasets set intname = 'tab_Main' where intname = 'Основное' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_DocSick')
update z_datasets set intname = 'tab_Dates' where intname = 'Данные о заработке' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_DocSick')
update z_datasets set intname = 'tab_SumE' where intname = 'Пособие (по месяцам)' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_DocSick')
update z_datasets set intname = 'tab_AdvRep' where intname = 'Авансовый отчет' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_DocTrip')
update z_datasets set intname = 'tab_Main' where intname = 'Основное' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_DocWrit')
update z_datasets set intname = 'tab_Addr' where intname = 'Получатель' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_DocWrit')
update z_datasets set intname = 'tab_Pays' where intname = 'Удержания' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_DocWrit')
update z_datasets set intname = 'tab_LRec' where intname = 'Начисления' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_EmpIn')
update z_datasets set intname = 'tab_LExp' where intname = 'Выплаты' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_EmpIn')
update z_datasets set intname = 'tab_WTime' where intname = 'Отработанное время' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_EmpIn')
update z_datasets set intname = 'tab_Leavs' where intname = 'Отпуска' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_EmpIn')
update z_datasets set intname = 'tab_List' where intname = 'Список' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_LeaveSched')
update z_datasets set intname = 'tab_List' where intname = 'Список' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_MoveDays')
update z_datasets set intname = 'tab_List' where intname = 'Список' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_PostStruc')
update z_datasets set intname = 'tab_VacOcc' where intname = 'Занятых должностей' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_PostStruc')
update z_datasets set intname = 'tab_VacFree' where intname = 'Свободных должностей' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_PostStruc')
update z_datasets set intname = 'ctl_Main' where intname = 'Свойства' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_PostStruc')
update z_datasets set intname = 'tab_MainSched' where intname = 'Основной график' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_WorkTime')
update z_datasets set intname = 'tab_ExtSched' where intname = 'Дополнительные графики' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_WorkTime')
update z_datasets set intname = 'tab_Info' where intname = 'Основное' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_CallToWork')
update z_datasets set intname = 'tab_Main' where intname = 'Основное' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_OrderDismiss')
update z_datasets set intname = 'tab_Salary' where intname = 'Расчетные' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_OrderDismiss')
update z_datasets set intname = 'tab_DocDP' where intname = 'Данные помесячно' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_OrderLeave')
update z_datasets set intname = 'tab_DocDD' where intname = 'Данные о выплатах' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_OrderLeave')
update z_datasets set intname = 'tab_Main' where intname = 'Основное' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_OrderMove')
update z_datasets set intname = 'tab_Salary' where intname = 'Зарплата' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_OrderMove')
update z_datasets set intname = 'tab_Comm' where intname = 'Основное' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_OrderTrip')
update z_datasets set intname = 'tab_List' where intname = 'Список' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Candidates')
update z_datasets set intname = 'tab_Comm' where intname = 'Общие данные' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Candidates')
update z_datasets set intname = 'tab_CandidateFiles' where intname = 'Документы' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfr_Candidates')
update z_datasets set intname = 'tab_PayTypes' where intname = 'Типы выплат' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_SalaryIn')
update z_datasets set intname = 'tab_Cor' where intname = 'Корректировка выплат' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_SalaryIn')
update z_datasets set intname = 'tab_CorCR' where intname = 'Корректировка начислений и удержаний' and dscode in (select dscode from z_Datasets s join z_Docs d on s.DocCode = d.DocCode and formclass = 'Tfp_SalaryIn')

"""


class MetaInfo:
    def __init__(self, ru, code, typeid, ua):
        self.ru = ru
        self.code = code
        self.typeid = typeid
        self.ua = ua


def connect():
    return pyodbc.connect(
        f"DRIVER={{ODBC Driver 18 for SQL Server}};SERVER={server};DATABASE={db};UID={user};PWD={password};Encrypt=no")


def is_ukrainian(text):
    rg = regex.compile(r"(?m)(?i)[іІїЇЄє][^ЁёЪъЭэЫы]", cache_pattern=True)
    return rg.search(text) is not None


def repl(m):
    if m.group() is None:
        return ''
    if m.group() == '':
        return ''
    # пропустим строки без кириллицы
    if regex.search(r"(?m)(?i)[\p{IsCyrillic}]", m.group()) is None:
        # print('Пропущено (IsCyrillic): ' + m.group())
        return m.group()
    # Пропустим украинский
    if avoid_ua and is_ukrainian:
        print('Пропущено (Ї): ' + m.group())
        return m.group()
    # пропустим слишком короткие
    if len(m.group().strip('\'')) < 3:
        # print('Пропущено (IsCyrillic): ' + m.group())
        return m.group()
    # пропустим по фильтру игнора
    if regex.search(ignore_strings_regexp, m.group()) is not None:
        return m.group()
    #print('В словарь: ' + m.group())
    #dictionary.add(m.group().strip('\''))
    dictionary[m.group().strip('\'')] = ''
    return r'dbo.zf_Translate(%s)' % m.group()


def add_text_to_dict(conn, sql, dct):
    cursor = conn.cursor()
    cursor.execute(sql)
    for row in cursor:
        if row.text == '':
            continue
        if avoid_ua and is_ukrainian(row.text):
            continue
        if regex.search(r"(?m)(?i)[\p{IsCyrillic}]", row.text) is None:
            continue
        dct[row.text.replace('\'', '\'\'')] = ''

def add_metadata_to_list(conn, sql, dct):
    cursor = conn.cursor()
    cursor.execute(sql)
    for row in cursor:
        if row.text == '':
            continue
#        if avoid_ua and is_ukrainian(row.text):
#            continue
        if regex.search(r"(?m)(?i)[\p{IsCyrillic}]", row.text) is None:
            continue
        c = MetaInfo(row.text.replace('\'', '\'\''), row.code, row.typeid, '')
        dct.append(c)

def repl_raiserror(m):
    global counter
    if m.group() is None:
        return ''
    if m.group() == '':
        return ''
    var_name = '@Error_msg%d' % counter
    counter += 1
    return "%sBEGIN\n%sDECLARE %s varchar(2000) = %s\n" % (m.group(2), m.group(2), var_name, m.group(4)) + m.group(2) + m.group(
        3) + var_name + m.group(5) + m.group(2) + "END\n"

@print_durations()
def parse_procedures(conn):
    cursor = conn.cursor()
    cursor.execute(
        """select name, object_definition(object_id) as text
       from sys.procedures
       """)
    return parse_sql(cursor)

@print_durations()
def parse_functions(conn):
    cursor = conn.cursor()
    cursor.execute(
        """SELECT name, 
                  object_definition(id) as text
           FROM dbo.sysobjects
           WHERE ((type = 'FN') or (type = 'TF'))
        """)
    return parse_sql(cursor)


def parse_sql(cursor):
    global counter
    parsed_script = ''
    # r = regex.compile(r"(?m)(?i)\'([А-Я]|\s|\.|\,|\;|\:|\!|\?)+\'", regex.VERBOSE)
    # r = regex.compile(r"(?m)(?i)\'([\p{IsCyrillic}]|\s|\.|\,|\;|\:|\!|\?|\'\')+\'", regex.VERBOSE)
    # https://stackoverflow.com/questions/171480/regex-grabbing-values-between-quotation-marks
    r = regex.compile(r"(?m)(?i)'([^']*(?:\'\')*[^']*(?:\'\')*[^']*)'", regex.VERBOSE)
    # r = regex.compile(r"(?m)(?i)\'([\p{IsCyrillic}]|\s|\.|\,|\;|\:|\!|\?|\'\'|\-|\d|\)|\()+\'", regex.VERBOSE)
    replacer_sp = regex.compile(r"(?i)^\s*create\s+procedure")
    replacer_fn = regex.compile(r"(?i)^\s*create\s+function")
    for row in cursor:
        if r.search(row.text) is None:
            continue
        for reg in ignore_obects_regexp:
            if regex.search(reg, row.name):
                break
        else:
            s1 = r.sub(repl, row.text)
            if s1 == row.text:
                # print('ХП пропущена: ' + row.name)
                continue
            raisefixer = regex.compile(r"(?i)(?m)((\s*)(RAISERROR\s*\(\s*)(dbo.zf_Translate\('[^']*(?:\'\')*[^']*'\))(.*))", cache_pattern=True)
            counter = 1
            s1 = raisefixer.sub(repl_raiserror, s1)
            s1 = replacer_sp.sub('ALTER PROCEDURE', s1)
            parsed_script += f"print 'Altering {row.name}'\ngo\n"
            parsed_script += replacer_fn.sub('ALTER FUNCTION', s1)
            parsed_script += '\ngo\n\n'


            # print(s1)
            # print('row = %r' % (row,))
            # print(row.text)
            print('Добавлена: ' + row.name)

    return parsed_script


def finish(conn):
    conn.close()

@print_durations()
def fill_table_with_phrases(phrases):
    script = f"print 'Adding data to z_Translations'\ngo\n"
    script += f'\ndelete from z_Translations\n'
    # script += f'\ndelete from z_Translations where MsgID >= {msg_id_base}\n'
    insert = '\ninsert into z_Translations(MsgID, TypeID, ru, uk) values \n   '
    #script += insert
    # for list
    # numerate = lambda x: [f'({t}, \'{x[t]}\')' for t in range(len(x))]
    # script += '\n  ,'.join(numerate(list(phrases_ru)))
    #script += '\n  ,'.join((lambda x: [f'({t + msg_id_base}, \'{x[t]}\')' for t in range(len(x))])(list(phrases_ru)))
    i = msg_id_base
    l = set()
    for key in phrases:
        l.add(f'({i}, 0, \'{key}\', {'\'' + phrases[key] + '\'' if phrases[key] != '' else 'null'})')
        i += 1
    # разбиваем по 900 строк в инстерте (ограничение mssql 1000)
    for b in itertools.batched(l, 900):
        script += insert
        script += '\n  ,'.join(b)
    return script


@print_durations()
def fill_table_with_metadata(lst):
    script = f"print 'Adding data to z_Translations'\ngo\n"
    #script += f'\ndelete from z_Translations\n'
    insert = '\ninsert into z_Translations(MsgID, TypeID, ru, uk) values \n   '
    #script += insert
    # for list
    # numerate = lambda x: [f'({t}, \'{x[t]}\')' for t in range(len(x))]
    # script += '\n  ,'.join(numerate(list(phrases_ru)))
    #script += '\n  ,'.join((lambda x: [f'({t + msg_id_base}, \'{x[t]}\')' for t in range(len(x))])(list(phrases_ru)))
    #i = msg_id_base
    l = set()
    for c in lst:
        l.add(f'({c.code}, {c.typeid}, \'{c.ru}\', {'\'' + c.ua + '\'' if c.ua != '' else 'null'})')
        #i += 1
    # разбиваем по 900 строк в инстерте (ограничение mssql 1000)
    for b in itertools.batched(l, 900):
        script += insert
        script += '\n  ,'.join(b)
    return script


@print_durations()
def translate_dict(dictn):
    dct = dict()
    if os.path.exists(dict_filename) and os.path.isfile(dict_filename):
        with open(dict_filename, 'r', newline='\n', encoding="utf-8") as json_file:
            dct = json.load(json_file)

    for key in dictn:
        if is_ukrainian(key):
            dictn[key] = key
        else:
            i = 0
            while True:
                try:
                    if key in dct: # есть перевод вычитанный, возьмем его
                        dictn[key] = dct[key].replace(r"'", r"''")
                    else:
                      dictn[key] = trs.translate_text(key, translation_engine, 'ru', to_language='uk').replace('\'', '\'\'')
                      time.sleep(translation_delay)
                    break
                except Exception as E:
                    print(f'Ошибка какая-то неведомая при переводе {key}' + str(E))
                    i += 1
                    time.sleep(5)
                    if i > 3:
                        inp = ''
                        while inp not in ['y', 'Y', 'N', 'n']:
                            print('Попробовать еще раз? (Y, N)')
                            inp = input()
                        if inp in ['N', 'n']:
                            break
        print(f'{key} -> {dictn[key]}')


@print_durations()
def translate_metadata(lst):
    dct = dict()
    if os.path.exists(dict_filename) and os.path.isfile(dict_filename):
        with open(dict_filename, 'r', newline='\n', encoding="utf-8") as json_file:
            dct = json.load(json_file)

    for c in lst:
        if is_ukrainian(c.ru):
            c.ua = c.ru
        else:
            i = 0
            while True:
                try:
                    if c.ru in dct: # есть перевод вычитанный, возьмем его
                        c.ua = dct[c.ru].replace(r"'", r"''")
                    else:
                        c.ua = trs.translate_text(c.ru, translation_engine, 'ru', to_language='uk').replace('\'', '\'\'')
                        time.sleep(translation_delay)
                    break
                except Exception as E:
                    print(f'Ошибка какая-то неведомая при переводе {c.ru}' + str(E))
                    i += 1
                    time.sleep(5)
                    if i > 3:
                        inp = ''
                        while inp not in ['y', 'Y', 'N', 'n']:
                            print('Попробовать еще раз? (Y, N)')
                            inp = input()
                        if inp in ['N', 'n']:
                            break
        print(f'{c.ru} -> {c.ua}')


@print_durations()
def translate_dict2(dbdict):
    tempdict = dict()
    #tempdict_i = dict()
    #tempdictua = dict()
    i = 0
    for key in dbdict:
        if is_ukrainian(key):
            dbdict[key] = key
        else:
            tempdict[str(i)] = key
            i += 1

    d = tempdict.copy()
    d2 = dict()
    i = 0
    for key in tempdict:
        d2[key] = tempdict[key].replace('\'', '$$').replace(')', ') ')
        i+= 1
        if i >= 10:
            s = str(d2)
            print(s)
            #s = str(json.dumps(d2))
            t = trs.translate_text(s, translation_engine, 'ru', to_language='uk')
            print(t)
            translated = json.loads(t.replace("'", "\""))

            for key2 in translated:
                dbdict[tempdict[key2]] = translated[key2].replace('$$', '\'').replace('\'', '\'\'')
            i = 0
            d2.clear()
            time.sleep(translation_delay)
#        print(f'{key} -> {dbdict[key]}')


if __name__ == '__main__':
    print(f'Started')
    connection_to_db = connect()
    sps = parse_procedures(connection_to_db)
    fn = parse_functions(connection_to_db)
    metadata_dictionary = list()
    add_metadata_to_list(connection_to_db, 'select FieldDesc as text, FieldID as code, 1 as typeid from z_fieldsrep where FieldDesc is not null', metadata_dictionary)
    add_metadata_to_list(connection_to_db, 'select DocName as text, DocCode as code, 2 as typeid from z_docs where DocName is not null', metadata_dictionary)
    add_metadata_to_list(connection_to_db, 'select DsName as text, DSCode as code, 3 as typeid from z_datasets where DsName is not null', metadata_dictionary)
    add_metadata_to_list(connection_to_db, 'select Distinct PageName as text, DSCode as code, 4 as typeid from z_datasets where PageName is not null', metadata_dictionary)
    add_metadata_to_list(connection_to_db,
                         'select Distinct PageName as text, (ToolCode*100+PageIndex) as code, 4 as typeid from z_ToolPages where PageName is not null',
                         metadata_dictionary)

    finish(connection_to_db)
    if translate:
        print(f'Автоперевод...')
        #translate_dict(dictionary)
        translate_dict(dictionary)
        translate_metadata(metadata_dictionary)
        print(f'Автоперевод завершен')
    tm = datetime.now().strftime("%Y%d%m%H%M%S")
    with open(f"translation_for_{db}_{tm}.sql", "w+", newline='\n', encoding="utf-8") as file1:  # w+ Очищает файл
        if include_create_table:
            file1.write(base_script)
            file1.write('\n\n')
        file1.write(sps)
        file1.write('\n\n')
        file1.write(fn)
        file1.write('\n\n')
        file1.write(fill_table_with_phrases(dictionary))
        file1.write(fill_table_with_metadata(metadata_dictionary))

    print(f'Completed')
