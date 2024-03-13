SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_GetD04T05](@OurID int, @Date smalldatetime) 
/* Возвращает данные таблицы P04T05 (экспорт в "M.E.DOC Додаток 4. Таблиця 5.Відомості про трудові відносини застрахованих осіб") */ 
AS 
BEGIN 
SET NOCOUNT ON 
DECLARE @PeriodBegin smalldatetime, @PeriodEnd smalldatetime, @PeriodM int, @PeriodY int 
 
SET @PeriodBegin = dbo.zf_GetDate(dbo.zf_GetMonthFirstDay(@Date)) 
SET @PeriodEnd = dbo.zf_GetDate(dbo.zf_GetMonthLastDay(@Date)) 
SET @PeriodY = DATEPART(yyyy, @Date) 
SET @PeriodM = DATEPART(mm, @Date) 
 
DECLARE @EmpMPst TABLE (ID int IDENTITY, OurID int, EmpID int, BDate smalldatetime, EDate smalldatetime, PensCatID tinyint, note varchar(255), DocDate smallDatetime, WOrderID VARCHAR(50), PostID int) 
 
/* Таблицу 5 «Відомості про трудові відносини осіб» заполняют те страхователи, у которых в течение отчетного периода: 
   – был заключен или расторгнут трудовой договор (гражданско-правовой договор) с застрахованным лицом; 
   – произошли изменения в Ф.И.О. или номере учетной карточки застрахованного лица; 
   – застрахованному лицу предоставлен отпуск по уходу за ребенком от трехлетнего возраста до достижения им шестилетнего возраста; 
   – застрахованному лицу предоставлен отпуск по беременности и родам. */ 
/* прежняя выборка  
 
/* Выборка принятых и уволенных служащих в отчетном периоде */ 
INSERT INTO @EmpMPst(OurID, EmpID, BDate, EDate, PensCatID, note) 
SELECT OurID, EmpID, MIN(CASE WHEN IsGivDoc = 1 THEN BDate ELSE NULL END), MAX(CASE WHEN IsDisDoc = 1 THEN EDate ELSE NULL END ), CASE WHEN GEmpType = 3 THEN 3 ELSE 1 END, /* PensCatID, */ 'принятые/уволенные' 
FROM   r_EmpMPst s /*JOIN (p_ELeav m JOIN p_ELeavD n ON m.ChID = n.ChID) ON m.OurID = s.OurID AND n.EmpID = s.EmpID  */
WHERE  s.OurID = @OurID AND BDate BETWEEN @PeriodBegin AND @PeriodEnd AND (IsDisDoc = 1 OR IsGivDoc = 1) 
GROUP BY OurID, EmpID, CASE WHEN GEmpType = 3 THEN 3 ELSE 1 END 
 
/* Выборка перемещения служащих в отчетном периоде */ 
INSERT INTO @EmpMPst(OurID, EmpID, BDate, EDate, PensCatID, note) 
SELECT OurID, EmpID, MIN(CASE WHEN (IsDisDoc = 0 OR IsGivDoc = 0) THEN BDate ELSE NULL END), MAX(CASE WHEN (IsDisDoc = 0 OR IsGivDoc = 0) THEN EDate ELSE NULL END ), CASE WHEN GEmpType = 3 THEN 3 ELSE 1 END, /* PensCatID, */ 'перемещение' 
FROM   r_EmpMPst s /*JOIN (p_ELeav m JOIN p_ELeavD n ON m.ChID = n.ChID) ON m.OurID = s.OurID AND n.EmpID = s.EmpID  */
WHERE  s.OurID = @OurID AND BDate BETWEEN @PeriodBegin AND @PeriodEnd AND (IsDisDoc = 0 OR IsGivDoc = 0)  
AND PostID <> (SELECT top 1 PostiD FROM r_EmpMPst WHERE OurID = @OurID AND DATEADD(d,-1,MIN(CASE WHEN (IsDisDoc = 0 OR IsGivDoc = 0) THEN BDate ELSE NULL END)) BETWEEN BDate AND EDate) 
GROUP BY OurID, EmpID, CASE WHEN GEmpType = 3 THEN 3 ELSE 1 END 
/* 
/* Смена фамилии */ 
INSERT INTO @EmpMPst(OurID, EmpID, BDate, EDate, PensCatID, note) 
SELECT  n.OurID, n.EmpID, MIN(CASE WHEN IsGivDoc = 1 THEN r.BDate ELSE NULL END), MAX(CASE WHEN IsDisDoc = 1 THEN r.EDate ELSE NULL END), CASE WHEN GEmpType = 3 THEN 3 ELSE 1 END, 'смена фамилии' 
FROM   r_EmpMPst r JOIN r_EmpNamesDates n ON n.OurID = r.OurID AND n.EmpID = r.EmpID 
WHERE  n.OurID = @OurID AND n.BDate BETWEEN @PeriodBegin AND @PeriodEnd 
GROUP BY n.OurID, n.EmpID, CASE WHEN GEmpType = 3 THEN 3 ELSE 1 END 
*/ 
 
/* Больничный по беременности и родам */ 
INSERT INTO @EmpMPst(OurID, EmpID, BDate, EDate, PensCatID, note) 
SELECT  n.OurID, n.EmpID, MIN(n.SickBDate)/*MIN(CASE WHEN IsGivDoc = 1 THEN r.BDate ELSE NULL END)*/, MIN(n.SickEDate)/*MAX(CASE WHEN IsDisDoc = 1 THEN r.EDate ELSE NULL END)*/, 5 /*PensCatID*/, 'беременность и роды - больничный' 
FROM   r_EmpMPst r JOIN p_ESic n ON n.OurID = r.OurID AND n.EmpID = r.EmpID AND n.SickType IN (8) 
WHERE  n.OurID = @OurID AND n.SickBDate BETWEEN @PeriodBegin AND @PeriodEnd 
GROUP BY n.OurID, n.EmpID, PensCatID 
 
/* Отпуск по уходу за ребенком до 3 лет */ 
INSERT INTO @EmpMPst(OurID, EmpID, BDate, EDate, PensCatID, note) 
SELECT  m.OurID, n.EmpID, MIN(CASE WHEN IsGivDoc = 1 THEN r.BDate ELSE NULL END), MAX(CASE WHEN IsDisDoc = 1 THEN r.EDate ELSE NULL END), 6, 'беременность и роды, отпуск по уходу - отпуски' 
FROM   r_EmpMPst r JOIN (p_ELeav m JOIN p_ELeavD n ON m.ChID = n.ChID) ON m.OurID = r.OurID AND n.EmpID = r.EmpID AND n.LeavType IN (41,1042) 
WHERE  m.OurID = @OurID AND n.BDate BETWEEN @PeriodBegin AND @PeriodEnd 
GROUP BY m.OurID, n.EmpID, PensCatID 
 
/* Отпуск по уходу за ребенком до 6 лет */ 
INSERT INTO @EmpMPst(OurID, EmpID, BDate, EDate, PensCatID, note) 
SELECT  m.OurID, n.EmpID, MIN(CASE WHEN IsGivDoc = 1 THEN r.BDate ELSE NULL END), MAX(CASE WHEN IsDisDoc = 1 THEN r.EDate ELSE NULL END), 4, 'беременность и роды, отпуск по уходу - отпуски' 
FROM   r_EmpMPst r JOIN (p_ELeav m JOIN p_ELeavD n ON m.ChID = n.ChID) ON m.OurID = r.OurID AND n.EmpID = r.EmpID AND n.LeavType IN (42,1043) 
WHERE  m.OurID = @OurID AND n.BDate BETWEEN @PeriodBegin AND @PeriodEnd 
GROUP BY m.OurID, n.EmpID, PensCatID 
*/ 
 
INSERT INTO @EmpMPst(OurID, EmpID, BDate, EDate, PensCatID, note, DocDate, WOrderID, PostID) 
SELECT s.OurID, s.EmpID, MIN(CASE WHEN IsGivDoc = 1 THEN s.BDate ELSE NULL END), null, CASE WHEN s.GEmpType = 3 THEN 3 ELSE 1 END, /* PensCatID, */ 'принятые', 
m.DocDate, m.WOrderID AS BDateWOrderID,  s.PostID 
FROM   r_EmpMPst s  
LEFT JOIN p_EGiv m ON m.OurID = s.OurID AND m.EmpID = s.EmpID 
WHERE  s.OurID = @OurID AND s.BDate BETWEEN @PeriodBegin AND @PeriodEnd AND (IsGivDoc = 1) 
GROUP BY s.OurID, s.EmpID, m.WOrderID, m.DocDate,m.WorkAppDate, s.PostID, CASE WHEN s.GEmpType = 3 THEN 3 ELSE 1 END 
HAVING MIN(CASE WHEN IsGivDoc = 1 THEN s.BDate ELSE NULL END) = m.WorkAppDate  
 
INSERT INTO @EmpMPst(OurID, EmpID, BDate, EDate, PensCatID, note, DocDate, WOrderID, PostID) 
SELECT s.OurID, s.EmpID, null, MAX(CASE WHEN IsDisDoc = 1 THEN s.EDate ELSE NULL END ), CASE WHEN s.GEmpType = 3 THEN 3 ELSE 1 END, /* PensCatID, */ 'уволенные',  
m1.DocDate, m1.WOrderID AS EDateWOrderID,  s.PostID 
FROM   r_EmpMPst s  
LEFT JOIN p_EDis m1 ON m1.OurID = s.OurID AND m1.EmpID = s.EmpID  
WHERE  s.OurID = @OurID AND s.BDate BETWEEN @PeriodBegin AND @PeriodEnd AND (IsDisDoc = 1) 
GROUP BY s.OurID, s.EmpID, m1.WOrderID, m1.DocDate, m1.DisDate, s.PostID, CASE WHEN s.GEmpType = 3 THEN 3 ELSE 1 END 
HAVING  MAX(CASE WHEN IsDisDoc = 1 THEN s.EDate ELSE NULL END ) = m1.DisDate 
 
INSERT INTO @EmpMPst(OurID, EmpID, BDate, EDate, PensCatID, note, DocDate, WOrderID, PostID) 
SELECT s.OurID, s.EmpID, s.BDate, s.EDate, CASE WHEN s.GEmpType = 3 THEN 3 ELSE 1 END, /* PensCatID, */ 'перемещение', 
 m1.DocDate, m1.WOrderID AS EDateWOrderID,s.PostID 
FROM   r_EmpMPst s  
LEFT JOIN p_EExc AS m1 ON m1.OurID = s.OurID AND m1.EmpID = s.EmpID AND m1.ExcDate BETWEEN s.BDate AND s.EDate AND s.IsDisDoc = 0 AND s.IsGivDoc = 0 
WHERE  s.OurID = @OurID AND s.BDate BETWEEN @PeriodBegin AND @PeriodEnd AND (IsDisDoc = 0 AND IsGivDoc = 0) AND s.PostID <> (SELECT top 1 PostiD FROM r_EmpMPst f WHERE f.OurID = @OurID AND f.EmpID = s.EmpID 
AND DATEADD(d,-1,m1.ExcDate) BETWEEN f.BDate AND f.EDate) 
 
INSERT INTO @EmpMPst(OurID, EmpID, BDate, EDate, PensCatID, note, DocDate, WOrderID, PostID) 
SELECT s.OurID, s.EmpID, s.BDate, s.EDate, CASE WHEN s.GEmpType = 3 THEN 3 ELSE 1 END, /* PensCatID, */ 'перемещение-списком', 
m.DocDate, m.WOrderID AS EDateWOrderID, s.PostID 
FROM   r_EmpMPst s  
LEFT JOIN (p_LExc AS m RIGHT JOIN p_LExcD n ON m.ChID=n.ChID) ON m.OurID = s.OurID AND n.EmpID = s.EmpID AND m.ExcDate BETWEEN s.BDate AND s.EDate AND s.IsDisDoc = 0 AND s.IsGivDoc = 0 
WHERE  s.OurID = @OurID AND s.BDate BETWEEN @PeriodBegin AND @PeriodEnd AND (IsDisDoc = 0 AND IsGivDoc = 0) AND s.PostID <> (SELECT top 1 PostiD FROM r_EmpMPst f WHERE f.OurID = @OurID AND f.EmpID = s.EmpID 
AND DATEADD(d,-1,m.ExcDate) BETWEEN f.BDate AND f.EDate) 
 
 
/* Больничный по беременности и родам */ 
INSERT INTO @EmpMPst(OurID, EmpID, BDate, EDate, PensCatID, note, DocDate, WOrderID, PostID) 
SELECT  n.OurID, n.EmpID, MIN(n.SickBDate)/*MIN(CASE WHEN IsGivDoc = 1 THEN r.BDate ELSE NULL END)*/, MIN(n.SickEDate)/*MAX(CASE WHEN IsDisDoc = 1 THEN r.EDate ELSE NULL END)*/, 5 /*PensCatID*/, 'беременность и роды - больничный' 
,n.DocDate,n.SickDocID,  r.PostID 
FROM   r_EmpMPst r JOIN p_ESic n ON n.OurID = r.OurID AND n.EmpID = r.EmpID AND n.SickType IN (8) 
WHERE  n.OurID = @OurID AND n.SickBDate BETWEEN @PeriodBegin AND @PeriodEnd 
GROUP BY n.OurID, n.EmpID, PensCatID,n.SickDocID,n.DocDate, r.PostID 
HAVING MIN(n.SickBDate) IS NOT NULL AND MIN(n.SickEDate) IS NOT NULL 
 
 
/* Отпуск по уходу за ребенком до 3 лет */ 
INSERT INTO @EmpMPst(OurID, EmpID, BDate, EDate, PensCatID, note, DocDate, WOrderID, PostID) 
SELECT  m.OurID, n.EmpID, CASE WHEN n.BDate BETWEEN @PeriodBegin AND @PeriodEnd THEN n.BDate ELSE NULL END, CASE WHEN n.EDate BETWEEN @PeriodBegin AND @PeriodEnd THEN n.EDate ELSE NULL END, 6, 'беременность и роды, отпуск по уходу - отпуски' 
,m.DocDate, m.WOrderID,  r.PostID 
FROM   r_EmpMPst r JOIN (p_ELeav m JOIN p_ELeavD n ON m.ChID = n.ChID) ON m.OurID = r.OurID AND n.EmpID = r.EmpID AND n.LeavType IN (41,1042) 
WHERE  m.OurID = @OurID 
AND ((n.BDate BETWEEN r.Bdate AND r.EDate) OR (n.EDate BETWEEN r.Bdate AND r.EDate)) AND ((r.BDate BETWEEN @PeriodBegin AND @PeriodEnd) OR (r.EDate BETWEEN @PeriodBegin AND @PeriodEnd)) 
AND (CASE WHEN n.BDate BETWEEN @PeriodBegin AND @PeriodEnd THEN n.BDate ELSE NULL END) IS NOT NULL AND (CASE WHEN n.EDate BETWEEN @PeriodBegin AND @PeriodEnd THEN n.EDate ELSE NULL END) IS NOT null  
 
/* Отпуск по уходу за ребенком до 6 лет */ 
INSERT INTO @EmpMPst(OurID, EmpID, BDate, EDate, PensCatID, note, DocDate, WOrderID, PostID) 
SELECT  m.OurID, n.EmpID,  CASE WHEN n.BDate BETWEEN @PeriodBegin AND @PeriodEnd THEN n.BDate ELSE NULL END, CASE WHEN n.EDate BETWEEN @PeriodBegin AND @PeriodEnd THEN n.EDate ELSE NULL END, 4, 'беременность и роды, отпуск по уходу - отпуски' 
,m.DocDate, m.WOrderID,  r.PostID 
FROM   r_EmpMPst r JOIN (p_ELeav m JOIN p_ELeavD n ON m.ChID = n.ChID) ON m.OurID = r.OurID AND n.EmpID = r.EmpID AND n.LeavType IN (42,1043) 
WHERE  m.OurID = @OurID  
AND ((n.BDate BETWEEN r.Bdate AND r.EDate) OR (n.EDate BETWEEN r.Bdate AND r.EDate)) AND ((r.BDate BETWEEN @PeriodBegin AND @PeriodEnd) OR (r.EDate BETWEEN @PeriodBegin AND @PeriodEnd)) 
AND (CASE WHEN n.BDate BETWEEN @PeriodBegin AND @PeriodEnd THEN n.BDate ELSE NULL END) IS NOT NULL AND (CASE WHEN n.EDate BETWEEN @PeriodBegin AND @PeriodEnd THEN n.EDate ELSE NULL END) IS NOT null 
 
DECLARE @ResEmpMPst TABLE (NUMIDENT VARCHAR(250), UKR_GROMAD int, LN varchar(250), NM varchar(250), FTN varchar(250), START_DT int, END_DT int, PERIOD_M INT, PERIOD_Y int, ZO INT, DOG_CPH int, 
PID_ZV VARCHAR(250), PNR varchar(250),/*AS ZKPP,*/ PROF VARCHAR(250), POS varchar(250), PID varchar(550), note varchar(250), empid int) 
/* Результирующий набор */ 
INSERT INTO @ResEmpMPst 
SELECT  CASE WHEN e.TaxCode = '' THEN CASE  
                                    WHEN e.IsCitizen = 1 AND ISNULL(n.PassSer, '')<>'' AND ISNULL(n.PassNo, '')<>'' THEN 'БК' + e.PassSer + e.PassNo   
                                    WHEN e.IsCitizen = 1 AND ISNULL(n.PassSer, '')='' AND ISNULL(n.PassNo, '')<>'' THEN 'П' + n.PassNo  
                                    WHEN e.IsCitizen = 1 THEN  ''                               
                                     END 
             ELSE e.TaxCode 
        END AS NUMIDENT, 
        CAST(e.IsCitizen AS int) AS UKR_GROMAD, 
        ISNULL(n.UAEmpLastName, e.UAEmpLastName) AS LN, 
        ISNULL(n.UAEmpFirstName, e.UAEmpFirstName) AS NM, 
        ISNULL(n.UAEmpParName, e.UAEmpParName) AS FTN, 
        DATEPART(dd, CASE WHEN s.BDate >= @PeriodBegin THEN s.BDate 
                          ELSE NULL 
                     END)	AS START_DT, 
        DATEPART(dd, CASE WHEN s.EDate <= @PeriodEnd THEN s.EDate 
                          ELSE NULL 
                     END)	AS END_DT, 
        @PeriodM AS PERIOD_M, 
        @PeriodY AS PERIOD_Y, 
        s.PensCatID AS ZO, 
        CASE WHEN s.PensCatID = 3 THEN 1 ELSE 0 END AS DOG_CPH, 
        ISNULL(d.DisBasis + ' ' + (SELECT Notes FROM r_Uni u WHERE u.RefTypeID= 10055 AND u.RefID = d.DisReason), '') AS PID_ZV, 
        UPPER(LEFT(p.PostName,1))+LOWER(SUBSTRING(p.PostName,2,LEN(p.PostName))) AS PNR, 
        /* AS ZKPP,  */
        p.PostClassifierCode  AS PROF, 
        UPPER(LEFT(p.PostName,1))+LOWER(SUBSTRING(p.PostName,2,LEN(p.PostName))) AS POS, 
        ISNULL('Наказ від ' + convert(varchar, s.DocDate, 104)  + ' №' +  s.WOrderID, '')     AS PID, 
        note, s.empid 
FROM    (SELECT t1.* FROM @EmpMPst t1 /*JOIN (SELECT MIN(ID) ID, OurID, EmpID FROM @EmpMPst GROUP BY OurID, EmpID) t2 ON t2.ID = t1.ID*/) s 
        INNER JOIN r_Emps e ON e.EmpID = s.EmpID 
        LEFT  JOIN r_EmpNamesDates n ON n.OurID = @OurID 
                                    AND n.EmpID = s.EmpID 
                                    AND @PeriodEnd BETWEEN n.BDate AND n.EDate 
        LEFT JOIN p_EDis d ON s.OurID = d.OurID AND s.EmpID = d.EmpID AND  s.EDate = d.DisDate 
        LEFT JOIN r_Posts p ON s.PostID = p.PostID 
 
 
DECLARE @pid VARCHAR(250) 
DECLARE @pid_zv VARCHAR(250) 
DECLARE @numident VARCHAR(25) 
 
DECLARE CursorEmp CURSOR LOCAL FAST_FORWARD FOR  
 SELECT numident, pid 
 FROM @ResEmpMPst 
 WHERE note='принятые' 
 
  OPEN CursorEmp  
  FETCH NEXT FROM CursorEmp  
  INTO @numident, @pid 
  WHILE @@FETCH_STATUS = 0  
    BEGIN  
    IF EXISTS (SELECT pid FROM @ResEmpMPst WHERE note='уволенные' AND @numident=numident)  
    	BEGIN 
        UPDATE @ResEmpMPst 
        SET	pid = @pid + ',' + (SELECT pid FROM @ResEmpMPst WHERE note='уволенные' AND @numident=numident), 
        END_DT = (SELECT END_DT FROM @ResEmpMPst WHERE note='уволенные' AND @numident=numident), 
        PID_ZV = (SELECT PID_ZV FROM @ResEmpMPst WHERE note='уволенные' AND @numident=numident) 
        WHERE note='принятые' AND @numident=numident 
         
        DELETE FROM @ResEmpMPst WHERE note='уволенные' AND @numident=numident 
       END 
       
    	FETCH NEXT FROM CursorEmp  
      INTO @numident, @pid 
    END  
     
  CLOSE CursorEmp  
  DEALLOCATE CursorEmp  
   
SELECT * FROM @ResEmpMPst 
END
GO
