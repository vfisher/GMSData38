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

# Если не компилится, доустановите модули:
# python -m pip install pyodbc
# python -m pip install regex
# python -m pip install ...

__author__ = "Oleksii Veseliev"
__copyright__ = "Copyright (C) 2024 Oleksii Veseliev, GMS Service LLC"
__license__ = "Public Domain"
__version__ = "1.0"


# # ---=== Настройки ===---

server = r'gmsveseljev\sql2016'
user = r'username'
password = r'password'
db = r'DatabaseName'
# Начальный id для добавляемых в словарь строк (если там пусто, то 1)
msg_id_base = 1
# Пропустить слова на українскій мові (возможно, часть БД уже переведена и нам надо сделать "по быстрому" на единственный укр. язык)
avoid_ua = 0
# Добавить в начало скрипта создание таблицы с переводами
include_create_table = 1
# Перевести найденные в ХП строки автоматом
translate = False #True
# Движок для перевода 'google', 'bing' ... Гугл любит банить за большой rps
translation_engine = 'bing'
# Задержка перед переводом каждой строки в сек (антибан). Гугл банит и на 4 сек, бинг работает нормально на 1 сек, но для ускорения можно 0.01
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
create table z_Translations(
 MsgID int not null primary key
, RU varchar(max) 
, UA varchar(max)
)
go

create function dbo.zf_Translate(@RUText varchar(max))
returns varchar(max)
as
begin
  declare @lng varchar(20), @s varchar(max)
  set @lng = Cast(SESSION_CONTEXT(N'language') as varchar(20))

  if @lng = 'Russian' 
    select @s = COALESCE(RU, cast(MsgID as varchar(10))) from z_Translations where RU = @RUText
  else if @lng = 'Ukrainian' or @lng = '' or @lng is null
    select @s = COALESCE(UA, RU, cast(MsgID as varchar(10))) from z_Translations where RU = @RUText

  If @s is NULL
    set @s = @RUText

  return @s
end
go

INSERT INTO z_Tables ([DocCode], [TableCode], [TableName], [TableDesc], [TableInfo], [DateField], [PKFields], [SortFields], [IntFilter], [OpenFilter], [IsView], [IsDefault], [HaveOur], [ForSync], [UpdateLog], [SyncAUFields])
VALUES
( 1001, 1001182, 'z_Translations', 'Перевод', 'Перевод сообщений в БД', '', 'MsgID', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0 )

INSERT INTO z_Fields ([TableCode], [FieldPosID], [FieldName], [FieldInfo], [Required], [DataSize], [DBDefault])
VALUES
( 1001182, 1, 'MsgID', NULL, 1, 4, NULL ),
( 1001182, 2, 'RU', NULL, 0, -1, NULL ),
( 1001182, 3, 'UA', NULL, 0, -1, NULL )

INSERT INTO z_objects ([ObjCode], [ObjName], [ObjDesc], [ObjInfo], [ObjType], [RevID])
VALUES
( 3266, 'zf_Translate', 'Возвращает перевод для фразі на русском', NULL, 'FN', 1 )


INSERT INTO z_fields ([TableCode], [FieldPosID], [FieldName], [FieldInfo], [Required], [DataSize], [DBDefault])
VALUES
( 1001182, 1, 'MsgID', NULL, 1, 4, NULL ),
( 1001182, 2, 'RU', NULL, 0, -1, NULL ),
( 1001182, 3, 'UA', NULL, 0, -1, NULL )
go
"""


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


def add_text_to_dict(conn, sql):
    cursor = conn.cursor()
    cursor.execute(sql)
    for row in cursor:
        if row.text == '':
            continue
        if avoid_ua and is_ukrainian(row.text):
            continue
        if regex.search(r"(?m)(?i)[\p{IsCyrillic}]", row.text) is None:
            continue
        dictionary[row.text.replace('\'', '\'\'')] = ''


def repl_raiserror(m):
    global counter
    if m.group() is None:
        return ''
    if m.group() == '':
        return ''
    var_name = '@Error_msg%d' % counter
    counter += 1
    return "%sDECLARE %s varchar(2000) = %s\n" % (m.group(2), var_name, m.group(4)) + m.group(2) + m.group(
        3) + var_name + m.group(5)

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
    insert = '\ninsert into z_Translations(MsgID, ru, ua) values \n   '
    #script += insert
    # for list
    # numerate = lambda x: [f'({t}, \'{x[t]}\')' for t in range(len(x))]
    # script += '\n  ,'.join(numerate(list(phrases_ru)))
    #script += '\n  ,'.join((lambda x: [f'({t + msg_id_base}, \'{x[t]}\')' for t in range(len(x))])(list(phrases_ru)))
    i = msg_id_base
    l = set()
    for key in phrases:
        l.add(f'({i}, \'{key}\', {'\'' + phrases[key] + '\'' if phrases[key] != '' else 'null'})')
        i += 1
    # разбиваем по 900 строк в инстерте (ограничение mssql 1000)
    for b in itertools.batched(l, 900):
        script += insert
        script += '\n  ,'.join(b)
    return script

@print_durations()
def translate_dict(dict):
    for key in dict:
        if is_ukrainian(key):
            dict[key] = key
        else:
            i = 0
            while True:
                try:
                    dict[key] = trs.translate_text(key, translation_engine, 'ru', to_language='uk').replace('\'', '\'\'')
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
        print(f'{key} -> {dict[key]}')


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
    add_text_to_dict(connection_to_db, 'select FieldDesc as text from z_fieldsrep where FieldDesc is not null')
    add_text_to_dict(connection_to_db, 'select DocName as text from z_docs where DocName is not null')
    add_text_to_dict(connection_to_db, 'select DsName as text from z_datasets where DsName is not null')
    add_text_to_dict(connection_to_db, 'select Distinct PageName as text from z_datasets where PageName is not null')
    finish(connection_to_db)
    if translate:
        print(f'Автоперевод...')
        #translate_dict(dictionary)
        translate_dict(dictionary)
        print(f'Автоперевод завершен')
    tm = datetime.now().strftime("%Y%d%m%H%M%S")
    with open(f"translation_for_{db}_{tm}.sql", "w+", newline='\n', encoding="utf-8") as file1:  # w+ Очищает файл
        file1.write(sps)
        file1.write('\n\n')
        file1.write(fn)
        file1.write('\n\n')
        file1.write(fill_table_with_phrases(dictionary))

    print(f'Completed')
