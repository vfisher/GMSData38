SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_Export](@cmd varchar(50), @params varchar(4000)) 
AS 
BEGIN 
  IF (@cmd = '' OR @cmd = 'items' ) 
    BEGIN 
      DECLARE @out1 TABLE (ID int, TDESC varchar(200), DATAPROC varchar(50), TFILENAME varchar(50)) 
      INSERT INTO @out1 (ID, TDESC, DATAPROC, TFILENAME) VALUES (1, 'Таблиця 5. Відомості про трудові відносини осіб', 'p_GetD04T05', 'D04T05D.dbf') 
      INSERT INTO @out1 (ID, TDESC, DATAPROC, TFILENAME) VALUES (2, 'Таблиця 6. Відомості про нар. ЗП застр. особам', 'p_GetD04T06', 'D04T06D.dbf') 
      /*INSERT INTO @out1 (ID, TDESC, DATAPROC, TFILENAME) VALUES (3, 'Ф. №1ДФ Податковий розрахунок сум доходу, нарахованого (сплаченого) на користь платників податку, і сум утриманого з них податку', 'p_Get1DF', 'DA1DF.dbf')*/ 
      SELECT * FROM @out1 
    END 
  ELSE 
  IF (@cmd = 'struc') 
    BEGIN 
      DECLARE @out2 TABLE (ID int, FNAME varchar(50), FTYPE varchar(1), FWIDTH int, FDEC int, FDESC varchar(200)) 
 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'PERIOD_M',  'N', 2,    0, 'Звітний місяць') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'PERIOD_Y',  'N', 4,    0, 'Звітний рік') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'ROWNUM',    'N', 6,    0, '№ з/п') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'UKR_GROMAD','N', 1,    0, 'Громадянин України (1-так, 0-ні)') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'ZO',        'N', 2,    0, 'Категорія особи') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'DOG_CPH',   'N', 1,    0, 'Договір ЦПХ за основним місцем роботи(1 - так, 0 - ні)') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'NUMIDENT',  'С', 10,   0, 'Номер облікової картки ЗО') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'LN',        'С', 100,  0, 'Прізвище ЗО') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'NM',        'С', 100,  0, 'Ім''я ЗО') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'FTN',       'С', 100,  0, 'По батькові ЗО') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'START_DT',  'N', 2,    0, 'День початку') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'END_DT',    'N', 2,    0, 'День припинення') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'NRM_DT',    'C', 8,    0, 'Дата створення нового робочого місця') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'PID_ZV',    'С', 150,  0, 'Підстава припинення трудових відносин') 
       
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'PNR',       'С', 250,  0, 'Професійна назва роботи') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'ZKPP',      'С', 5,    0, 'Код ЗКППТР') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'PROF',      'С', 6,    0, 'Код класифікатора професій') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'POS',       'С', 250,  0, 'Посада') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (1, 'PID',       'С', 250,  0, 'Документ-підстава про початок роботи та відпустку, кінець трудових або цивільно-правових відносин, переведення на іншу посаду') 
 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'PERIOD_M',  'N', 2,    0, 'Звітний місяць') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'PERIOD_Y',  'N', 4,    0, 'Звітний рік') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'ROWNUM',    'N', 6,    0, '№ з/п') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'UKR_GROMAD','N', 1,    0, 'Громадянин України (1 - так, 0 - ні)') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'ST',        'N', 1,    0, 'Стать (0 - Ж, 1 - М)') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'NUMIDENT',  'С', 10,   0, 'Номер облікової картки ЗО') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'LN',        'С', 100,  0, 'Прізвище ЗО') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'NM',        'С', 100,  0, 'Ім''я ЗО') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'FTN',       'С', 100,  0, 'По батькові ЗО') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'ZO',        'N', 2,    0, 'Код категорії ЗО') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'PAY_TP',    'N', 2,    0, 'Тип нарахувань') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'PAY_MNTH',  'N', 2,    0, 'Місяць, за який проведено нарахування') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'PAY_YEAR',  'N', 4,    0, 'Рік, за який проведено нарахування') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'KD_NP',     'N', 2,    0, 'Кількість календарних днів тимчасової непрацездатності') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'KD_NZP',    'N', 2,    0, 'Кількість календарних днів без збереження заробітної плати') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'KD_PTV',    'N', 3,    0, 'Кількість днів перебування у трудових /ЦП відносинах') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'KD_VP',     'N', 3,    0, 'Кількість календарних днів відпустки у звя''зку з вагітністю та пологами') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'SUM_TOTAL', 'N', 16,   2, 'Загальна сума нарахованої заробітної плати / доходу (усього з початку звітного місяця)') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'SUM_MAX',   'N', 16,   2, 'Сума нарахованої заробітної плати / доходу у межах максимальної величини, на яку нараховується єдиний внесок') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'SUM_INS',   'N', 16,   2, 'Сума утриманого єдиного внеску за звітний місяць (із заробітної плати / доходу)') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'OTK',       'N', 1,    0, 'Ознака наявності трудової книжки') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'EXP',       'N', 1,    0, 'Ознака наявності спецстажу') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'NRM',       'N', 1,    0, 'Ознака нового робочого місця') 
 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'SUM_DIFF',  'N', 16,   2, 'Сума різниці між розміром мінімальної заробітної плати та фактично нарахованою заробітною платою за звітний місяць (із заробітної плати / доходу)') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'SUM_NARAH', 'N', 16,   2, 'Сума нарахованого єдиного внеску за звітний місяць (на заробітну плату / доходу)') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (2, 'NRC',       'N', 1,    0, 'Ознака неповного робочого часу') 
 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (3, 'NP',        'N',  5,   0, '№ з/п') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (3, 'PERIOD',    'N',  1,   0, 'Звітний період (квартал)') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (3, 'RIK',       'N',  4,   0, 'Звітний рік') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (3, 'KOD',       'N', 10,   0, 'Код ЄДРПОУ') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (3, 'TYP',       'N',  1,   0, 'Ознака податкового агента, який подає податковий розрахунок (0 - юридична особа, 1 - фізична особа)') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (3, 'TIN',       'N', 10,   0, 'Ідентифікаційний номер фізичної особи') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (3, 'S_NAR',     'N', 12,   2, 'Сума нарахованого доходу') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (3, 'S_DOX',     'N', 12,   2, 'Сума виплаченого доходу') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (3, 'S_TAXN',    'N', 12,   2, 'Сума утриманого податку (нарахованого)') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (3, 'S_TAXP',    'N', 12,   2, 'Сума утриманого податку (перерахованого)') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (3, 'OZN_DOX',   'N',  3,   0, 'Ознака доходу') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (3, 'D_PRIYN',   'C', 10,   0, 'Дата прийняття на роботу') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (3, 'D_ZVILN',   'C', 10,   0, 'Дата звільнення з роботи') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (3, 'OZN_PILG',  'N',  2,   0, 'Ознака податкової соціальної пільги') 
      INSERT INTO @out2 (ID, FNAME, FTYPE, FWIDTH, FDEC, FDESC) VALUES (3, 'OZNAKA',    'N',  1,   0, 'Ознака: 0 - введення запису, 1 - вилучення запису') 
 
   SELECT * FROM @out2 WHERE ID = @params 
   END 
END
GO
