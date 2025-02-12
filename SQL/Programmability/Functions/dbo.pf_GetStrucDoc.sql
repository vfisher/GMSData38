SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetStrucDoc] (@DocName VARCHAR(8000), @OurID int, @ChID bigint, @IsEmpName bit, @ActualDate datetime)
/* Возвращает таблицу для формирования структуры документа */
RETURNS @tmpStrucDoc TABLE (ID int, ChID bigint, SrcPosID int, SubID int, FSubID int, SubName VARCHAR(8000), EmpCount int, EmpCountFree int, ParentSubID INT, Height INT, Width INT)
AS
BEGIN
IF @ActualDate = '19000101'
  SET @ActualDate = GETDATE()

IF @DocName = dbo.zf_Translate('Структура предприятия')
BEGIN
  INSERT INTO @tmpStrucDoc(ID, ChID, SrcPosID, SubID, FSubID, SubName, ParentSubID,  EmpCount, EmpCountFree, Height, Width)
  SELECT TOP 1 0 ID, m.ChID, 0 SrcPosID, 0 SubID, 0 FSubID, (SELECT OurName FROM r_Ours WHERE OurID = m.OurID) SubName, 0 ParentSubID, 0, 0,
    LEN((SELECT OurName FROM r_Ours WHERE OurID = m.OurID)) + 40 Height,
    LEN((SELECT OurName FROM r_Ours WHERE OurID = m.OurID)) + 100 Width
  FROM p_SubStruc m
  WHERE m.OurID =  @OurID AND m.ChID = @ChID
  UNION all
  SELECT ROW_NUMBER() OVER(ORDER BY ParentSubID ASC) ID, d.ChID, d.SrcPosID, d.SubID, d.SubID,
    (SELECT TOP 1 SubName FROM r_Subs WHERE SubID = d.SubID) SubName, d.ParentSubID, 0, 0,
    LEN((SELECT TOP 1 SubName FROM r_Subs WHERE SubID = d.SubID)) + 40 Height,
    LEN((SELECT TOP 1 SubName FROM r_Subs WHERE SubID = d.SubID)) + 100 Width
  FROM p_SubStruc m, p_SubStrucD d
  WHERE m.ChID = d.ChID AND m.OurID = @OurID AND d.ChID = @ChID
END
IF @DocName = dbo.zf_Translate('Структура должностей')
BEGIN

/*Создание таблицы для формирования наименований в блоках по коду должности в структуре*/

/*-------- create table @t1 ------------------*/
DECLARE @t1 TABLE (StrucPostID INT, StrucParentPostID INT, SubID INT, PostID INT)
INSERT INTO @t1
SELECT d.StrucPostID, d.StrucParentPostID, d.SubID, d.PostID
FROM dbo.p_PostStrucD d
INNER JOIN dbo.p_PostStruc m ON d.ChID = m.ChID
WHERE m.OurID = @OurID AND d.ChID = @ChID AND  d.VacTotal <> 0          
/*AND (m.AppDate <= d.EDate) */
AND (d.EDate > @ActualDate OR d.EDate IS NULL)
/*SELECT d.StrucPostID, d.StrucParentPostID, d.SubID, d.PostID
FROM dbo.p_PostStrucD d
INNER JOIN dbo.p_PostStruc m ON d.ChID = m.ChID
LEFT JOIN r_EmpMPst r ON m.OurID = r.OurID
WHERE m.OurID = 4 AND d.ChID = 100000033
AND (m.AppDate <= @ActualDate)
AND (d.EDate > @ActualDate OR d.EDate IS NULL)
AND m.AppDate<= r.EDate 
AND r.SalaryQty <> 0
AND r.IsDisDoc = 0 
AND r.StrucPostID = d.StrucPostID 
*/
/*-------- create table @t1 ------------------*/

/*-------- create table @t11 -----------------*/
DECLARE @t11 TABLE (HasChild INT, StrucPostID INT, StrucParentPostID INT, SubID int, PostID int)
INSERT INTO @t11
SELECT
  ISNULL((SELECT TOP 1 1 StrucPostID FROM @t1 d WHERE d.StrucParentPostID = a.StrucPostID),0) HasChild,
  a.StrucPostID,
  a.StrucParentPostID,
  a.SubID,
  a.PostID
FROM @t1 a
ORDER BY
  ISNULL((SELECT TOP 1 1 StrucPostID FROM @t1 d WHERE d.StrucParentPostID = a.StrucPostID),0),
  a.StrucParentPostID,
  a.StrucPostID,
  a.SubID,
  a.PostID
/*-------- create table @t11 ------------------*/

DECLARE @t2 TABLE (StrucParentPostID INT, StrucPostIDList VARCHAR(8000), SubID INT, PostID INT)
DECLARE @HasChild INT, @StrucParentPostID INT, @StrucPostID INT, @HasParent INT, @StrucPostIDList VARCHAR(8000), @SubID INT, @PostID int
DECLARE Struc_Cursor cursor DYNAMIC LOCAL FOR

SELECT * FROM @t11

OPEN Struc_Cursor
fetch FIRST from Struc_Cursor
INTO @HasChild, @StrucPostID, @StrucParentPostID, @SubID, @PostID
WHILE @@FETCH_STATUS = 0
BEGIN
  WHILE EXISTS (SELECT TOP 1 1 FROM @t11)
  BEGIN
    SET @StrucPostIDList = ''
    SELECT
      @StrucPostIDList = @StrucPostIDList + CASE WHEN @StrucPostIDList = '' THEN '' ELSE ',' END +
        CAST(s.StrucPostID AS VARCHAR(8000))
    FROM
      (SELECT * FROM @t11) s

    WHERE s.HasChild = 0 AND s.StrucParentPostID = @StrucParentPostID AND s.SubID = @SubID AND s.PostID = @PostID

  INSERT INTO @t2(StrucParentPostID, StrucPostIDList, SubID, PostID)
  VALUES (@StrucParentPostID, @StrucPostIDList, @SubID, @PostID)

  DELETE m
  FROM  @t1 m
  WHERE m.StrucPostID IN (SELECT * FROM [zf_FilterToTable] (@StrucPostIDList)) AND
    m.StrucParentPostID = @StrucParentPostID AND m.SubID = @SubID AND m.PostID = @PostID

  DELETE FROM @t11

  INSERT INTO @t11(HasChild, StrucPostID, StrucParentPostID, SubID, PostID)
  SELECT
    ISNULL((SELECT TOP 1 1 StrucPostID FROM @t1 d WHERE d.StrucParentPostID = a.StrucPostID),0) HasChild,
    a.StrucPostID,
    a.StrucParentPostID,
    a.SubID,
    a.PostID
  FROM @t1 a
  ORDER BY
    ISNULL((SELECT TOP 1 1 StrucPostID FROM @t1 d WHERE d.StrucParentPostID = a.StrucPostID),0),
    a.StrucParentPostID,
    a.StrucPostID,
    a.SubID,
    a.PostID

fetch FIRST from Struc_Cursor
INTO @HasChild, @StrucPostID, @StrucParentPostID, @SubID, @PostID
END break
END
CLOSE Struc_Cursor
DEALLOCATE Struc_Cursor

/*-----------------------------------------------------------------------------------------------*/

DECLARE @StrucList varchar(8000), @EmpName varchar(8000),/* @PostID int, @SubID INT*/
        @EmpCount INT, @EmpCountFree INT,/* @StrucParentPostID INT,*/
        @Width INT, @ID INT
DECLARE @tmpStruc TABLE (PostID INT, SubID INT, StrucParentPostID INT, StrucPostIDList VARCHAR(8000), EmpName varchar(8000), EmpCount INT, EmpCountFree INT, Width INT)
DECLARE Struc_Cursor_ CURSOR fast_forward for

SELECT ROW_NUMBER() OVER(ORDER BY t.StrucParentPostID ASC) ID,
       t.StrucParentPostID, t.StrucPostIDList, t.SubID, t.PostID
FROM @t2 t

OPEN Struc_Cursor_
FETCH NEXT FROM Struc_Cursor_
INTO @ID, @StrucParentPostID, @StrucPostIDList, @SubID, @PostID
WHILE @@FETCH_STATUS = 0
BEGIN
  SET @EmpName = ''
  SET @EmpCount = 0
  SET @EmpCountFree = 0
  SET @Width = 0        

  SELECT
    /*@EmpCount = @EmpCount + CASE WHEN (ISNULL(d2.EmpName,'') <> '') THEN 1 ELSE 0 END,*/
    @EmpCount = @EmpCount + CASE WHEN (ISNULL(d2.EmpID,'') <> '') THEN CASE WHEN d2.Joint = 1 THEN 0 ELSE 1 END ELSE 0 END,
    /*@EmpName = @EmpName + CASE WHEN (@EmpName = '') OR (@EmpName <> '') AND (ISNULL(d2.EmpName,'') = '') THEN '' ELSE Char(10) END + CAST(ISNULL(d2.EmpName,'') as varchar(8000)),*/
    @EmpName = @EmpName + CASE WHEN (@EmpName = '') OR (@EmpName <> '') AND (ISNULL(d2.EmpName,'') = '') THEN '' ELSE Char(10) END + 
    CASE WHEN (@IsEmpName = 0) THEN  
                                 CASE WHEN (@StrucParentPostID = 0) OR EXISTS(SELECT TOP 1 1 FROM p_PostStrucD WHERE ChID=@ChID AND StrucPostID=@StrucParentPostID AND StrucParentPostID=0) THEN CAST(ISNULL(d2.EmpName,'') as varchar(8000)) ELSE '' END
                               ELSE CAST(ISNULL(d2.EmpName,'') as varchar(8000)) END,
    @EmpCountFree = @EmpCountFree + CASE WHEN (ISNULL(d2.EmpID,'') = '' AND d2.VacTotal <> 0) THEN 1 ELSE 0 END,
    @Width = CASE WHEN LEN(d2.EmpName) > @Width THEN LEN(d2.EmpName) ELSE @Width END
  FROM
    (SELECT
       mm.AppDate,
       dd.PostID, dd.SubID, dd.StrucPostID, dd.StrucParentPostID, dd.VacTotal, ISNULL(r.EmpID, CASE WHEN dd1.OrderType <> 1 THEN dd1.EmpID END) AS EmpID, /*dd1.Joint,*/

ISNULL(r.Joint, dd1.Joint) AS Joint,

       CASE WHEN s.EmpLastName IS NOT NULL THEN s.EmpLastName + ' ' ELSE '' END + ISNULL(s.EmpInitials,'') + 
       CASE WHEN (ISNULL(r.EmpID, CASE WHEN dd1.OrderType <> 1 THEN dd1.EmpID END) IS NOT NULL) AND  
        /* dd1.Joint = 1 */
                ISNULL(r.Joint, dd1.Joint) = 1
       THEN dbo.zf_Translate('(совм)') ELSE '' END  AS EmpName 
     FROM p_PostStrucD dd
     INNER JOIN p_PostStruc mm ON dd.ChID = mm.ChID AND mm.OurID = @OurID  AND mm.ChID = @ChID
     LEFT JOIN r_EmpMPst r ON mm.OurID = r.OurID 
               AND mm.AppDate<= r.EDate AND r.BDate <= @ActualDate AND r.EDate >= @ActualDate AND r.SalaryQty <> 0
               AND r.IsDisDoc = 0 AND r.StrucPostID = dd.StrucPostID
     LEFT JOIN
     /* (SELECT d1.StrucPostID, d1.SalaryQty, d1.EmpID, d1.Joint
       FROM
      (SELECT TOP 1 * FROM p_EmpSchedExt m WHERE OurID = @OurID AND m.OrderType = 0 AND m.AppDate <= @ActualDate ORDER BY m.AppDate DESC) m1
       INNER JOIN p_EmpSchedExtD d1 ON m1.ChID = d1.ChID ) dd1 ON dd.StrucPostID = dd1.StrucPostID */
     (SELECT TOP 1 m.AppDate, d.StrucPostID, d.EmpID, d.Joint, m.OrderType
      FROM p_EmpSchedExt m INNER JOIN p_EmpSchedExtD d ON m.ChID = d.ChID 
      WHERE m.OurID = @OurID AND m.AppDate <= @ActualDate /*AND m.OrderType = 1 */
      ORDER BY m.AppDate DESC) dd1 ON  dd.StrucPostID = dd1.StrucPostID 
     LEFT JOIN r_Emps s ON ISNULL(r.EmpID, CASE WHEN dd1.OrderType <> 1 THEN dd1.EmpID END) = s.EmpID
     ) d2
  WHERE d2.StrucParentPostID = @StrucParentPostID AND d2.StrucPostID IN (SELECT * FROM [zf_FilterToTable] (@StrucPostIDList)) AND d2.SubID = @SubID AND d2.PostID = @PostID

  INSERT INTO @tmpStruc(PostID, SubID, StrucParentPostID, StrucPostIDList, EmpName, EmpCount, EmpCountFree, Width)
  VALUES (@PostID, @SubID, @StrucParentPostID, @StrucPostIDList, @EmpName, @EmpCount, @EmpCountFree, @Width)

FETCH NEXT FROM Struc_Cursor_
INTO @ID, @StrucParentPostID, @StrucPostIDList, @SubID, @PostID
END
CLOSE Struc_Cursor_
DEALLOCATE Struc_Cursor_

INSERT INTO @tmpStrucDoc(ID, ChID, SrcPosID, SubID, FSubID, SubName, ParentSubID, EmpCount, EmpCountFree, Height, Width)
SELECT
  S1.ID,
  S1.ChID,
  S1.SrcPosID,
  S1.StrucPostID AS SubID,
  S1.SubID AS FSubID,

  UPPER(S1.SubName) + Char(10) + replicate('_',20) + Char(10) +
  S1.PostName  + Char(10) + replicate('_',20) + Char(10) +
  CASE WHEN t.EmpName <> '' THEN t.EmpName + CHAR(10) ELSE '' END +
  CASE WHEN t.EmpCount <> 0 THEN ('( ' + CAST(t.EmpCount AS varchar(8000)) + dbo.zf_Translate(' чел. )')) + CHAR(10) ELSE '' END +
  CASE WHEN t.EmpCountFree <> 0 THEN (dbo.zf_Translate('( вакансий: ') + CAST(t.EmpCountFree AS varchar(8000)) + ' )') ELSE '' END AS SubName,
  S1.ParentSubID,

  t.EmpCount AS EmpCount,
  t.EmpCountFree AS EmpCountFree,

  CASE WHEN
    LEN(S1.SubName) = 0 THEN 20 ELSE LEN(S1.SubName) END +
    LEN(Char(10) + '______________________' + Char(10) +  S1.PostName  + Char(10) + '______________________' + Char(10) +
    CASE WHEN t.EmpName <> '' THEN t.EmpName + CHAR(10) ELSE '' END +
    CASE WHEN t.EmpCount <> 0 THEN ('( ' + CAST(t.EmpCount AS varchar(8000)) + dbo.zf_Translate(' чел. )')) + CHAR(10) ELSE '' END +
    CASE WHEN t.EmpCountFree <> 0 THEN (dbo.zf_Translate('( вакансий: ') + CAST(t.EmpCountFree AS varchar(8000)) + ' )') ELSE '' END) + 20 AS Height,
  150 AS Width
FROM
(
  /*SELECT
    ROW_NUMBER() OVER(ORDER BY  d.StrucParentPostID ASC) ID,
    @ChID AS ChID,
    ROW_NUMBER() OVER(ORDER BY  d.StrucParentPostID ASC) SrcPosID,
    d.SubID,
    CAST(
    CASE WHEN CHARINDEX(',',d.StrucPostIDList) = 0  THEN d.StrucPostIDList ELSE
              SUBSTRING(d.StrucPostIDList,0,CHARINDEX(',',d.StrucPostIDList)) end AS INT) AS StrucPostID,
    d.PostID,
    REPLACE(
    (CASE
     WHEN (d.StrucParentPostID = 0) AND (d.SubID = 0) THEN (SELECT TOP 1 o.OurName FROM r_Ours o WHERE o.OurID = @OurID)
     WHEN (d.SubID = 0) THEN '' ELSE s.SubName
     END), ' ', Char(10))  AS SubName,
    REPLACE(p.PostName,' ', Char(10)) AS PostName,
    d.StrucParentPostID AS ParentSubID,
    (Select m.AppDate FROM dbo.p_PostStruc m WHERE m.OurID = @OurID AND m.ChID = @ChID) AS AppDate

  FROM
    @t2 d
  JOIN dbo.r_Posts p ON d.PostID = p.PostID
  JOIN dbo.r_Subs s ON d.SubID = s.SubID */

 SELECT
    ROW_NUMBER() OVER(ORDER BY  d.StrucParentPostID ASC) ID,
    @ChID AS ChID,
    ROW_NUMBER() OVER(ORDER BY  d.StrucParentPostID ASC) SrcPosID,
    d.SubID,
    CAST(
    CASE WHEN CHARINDEX(',',d.StrucPostIDList) = 0  THEN d.StrucPostIDList ELSE
              SUBSTRING(d.StrucPostIDList,0,CHARINDEX(',',d.StrucPostIDList)) end AS INT) AS StrucPostID,
    d.PostID,
    REPLACE(
    (CASE
     WHEN (d.StrucParentPostID = 0) AND (d.SubID = 0) THEN (SELECT TOP 1 o.OurName FROM r_Ours o WHERE o.OurID = @OurID)
     WHEN (d.SubID = 0) THEN '' 
     WHEN d.SubID IN (
                      SELECT
                        d1.SubID
                      FROM @t2 d1
                      WHERE 
                        CAST(
                        CASE WHEN CHARINDEX(',',d1.StrucPostIDList) = 0  THEN d1.StrucPostIDList 
                        ELSE SUBSTRING(d1.StrucPostIDList,0,CHARINDEX(',',d1.StrucPostIDList)) end AS INT) = d.StrucParentPostID)
                        THEN '' ELSE s.SubName  
                      END), ' ', Char(10))  AS SubName,
    REPLACE(p.PostName,' ', Char(10)) AS PostName,
    d.StrucParentPostID AS ParentSubID,
    (Select m.AppDate FROM p_PostStruc m WHERE m.OurID = @OurID AND m.ChID = @ChID) AS AppDate
  FROM
    @t2 d
  JOIN dbo.r_Posts p ON d.PostID = p.PostID
  JOIN dbo.r_Subs s ON d.SubID = s.SubID
) S1
JOIN @tmpStruc t ON S1.PostID = t.PostID AND S1.SubID = t.SubID AND S1.ParentSubID = t.StrucParentPostID AND S1.StrucPostID IN (SELECT * FROM [zf_FilterToTable] (t.StrucPostIDList))
END
RETURN
END
GO