SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_ShedGetWTSign] (@RefTypeID int, @RefID int)
/* Возвращает код рабочего времени в табеле учета рабочего времени при обработке первичных документов */
RETURNS int AS
BEGIN
RETURN CASE
         WHEN @RefTypeID = 10051 THEN /* Cправочник отпусков */
           CASE @RefID
             WHEN 11 THEN 8
             WHEN 12 THEN 9
             WHEN 13 THEN 9
             WHEN 14 THEN 9
             WHEN 21 THEN 12
             WHEN 31 THEN 11
             WHEN 41 THEN 16
             WHEN 42 THEN 17
             WHEN 43 THEN 15
             WHEN 44 THEN 15
             WHEN 45 THEN 15
             WHEN 46 THEN 15
             WHEN 47 THEN 10
             WHEN 51 THEN 18
             WHEN 52 THEN 14
             WHEN 53 THEN 14
             WHEN 54 THEN 14
             WHEN 55 THEN 14
             WHEN 56 THEN 14
             WHEN 57 THEN 14
             WHEN 58 THEN 14
             WHEN 61 THEN 22
             WHEN 71 THEN 22
             WHEN 100 THEN 9
             WHEN 1041 THEN 16             
             WHEN 1042 THEN 16
             WHEN 1043 THEN 17
             WHEN 1044 THEN 15             
             WHEN 1051 THEN 18             
             WHEN 1011 THEN 8
             WHEN 10000 THEN 9
           END
         WHEN @RefTypeID = 10056 THEN /* Cправочник причин нетрудоспособности */
           CASE @RefID
             WHEN 1 THEN 26
             WHEN 2 THEN 26
             WHEN 3 THEN 26
             WHEN 4 THEN 26
             WHEN 5 THEN 27
             WHEN 6 THEN 26
             WHEN 7 THEN 26
             WHEN 8 THEN 16
             WHEN 9 THEN 26
             WHEN 10 THEN 26
             WHEN 99 THEN 26
           END
       END
END
GO