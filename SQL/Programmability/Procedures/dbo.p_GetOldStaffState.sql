SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[p_GetOldStaffState](@OurID int, @EmpID int, @Date DATETIME, @Salary NUMERIC (21,9) OUTPUT, @IndexBaseMonth DATETIME OUTPUT, @Index NUMERIC (21,9) OUTPUT, @BIndexing NUMERIC(21,9) OUTPUT, @BDateLastMove DATETIME OUTPUT, @SumFixedIndexing NUMERIC(21,9) OUTPUT)
/* Возвращает информацию по предыдущему кадровому состоянию сотрудника: оклад, базовый месяц индексации, индекс потребительских цен относительно базового месяца, сумму фиксированной индексации */
AS
BEGIN
  DECLARE @EmpGivDate DATETIME, @BEmpGivDate DATETIME
  DECLARE @table TABLE (OurID int, EmpiD int, [DATE] DATETIME, Salary NUMERIC (21,9), IndexBaseMonth DATETIME, [INDEX] NUMERIC (21,9), BIndexing NUMERIC(21,9), BDateLastMove DATETIME, SalaryDifference numeric(21,9), MinimumWage numeric(21,9), SumFixedIndexing NUMERIC(21,9))

  SET @EmpGivDate = ISNULL((SELECT dbo.pf_GetEmpGivDate(DATEADD(d,-1,@Date), @EmpID, @OurID)), '20790101')

  INSERT INTO @table(OurID, EmpiD, [DATE], Salary, IndexBaseMonth, [INDEX],
              BIndexing, BDateLastMove, SalaryDifference, MinimumWage, SumFixedIndexing)
  SELECT DISTINCT OurID, EmpiD, IndexBaseMonth, 0, NULL, NULL, NULL, NULL, 0, 0, 0  FROM r_EmpMPst WITH (NOLOCK)
  WHERE OurID= @OurID AND EmpID= @EmpID AND BDate<= @Date AND BDate >= @EmpGivDate AND IsDisDoc = 0
  ORDER BY IndexBaseMonth

  DECLARE @CurrentBSalary NUMERIC(21,9), @BDate DATETIME, @MinimumWage NUMERIC(21,9), @SalaryDifference NUMERIC(21,9)

  DECLARE FixedIndexingCursor CURSOR FAST_FORWARD FOR
  SELECT [DATE] AS BDate FROM @table
  ORDER BY [DATE]

  SET @SumFixedIndexing = 0

  OPEN FixedIndexingCursor
  FETCH NEXT FROM FixedIndexingCursor INTO @BDate
  WHILE @@FETCH_STATUS = 0

  BEGIN
    SET @BEmpGivDate = ISNULL((SELECT dbo.pf_GetEmpGivDate(DATEADD(d,-1,@BDate), @EmpID, @OurID)), '20790101')
  /* Оклад по действующему кадровому состоянию на дату */		
    SET @CurrentBSalary = ISNULL((SELECT TOP 1 BSalary FROM r_EmpMPst WITH (NOLOCK)  
    WHERE OurID=@OurID AND EmpID=@EmpID AND BDate<= @BDate AND BDate >= @BEmpGivDate AND IsDisDoc = 0 
    ORDER BY BDate DESC),0)

  IF (SELECT COUNT(*)  
      FROM r_EmpMPst WITH (NOLOCK) WHERE OurID=@OurID AND EmpID=@EmpID AND BDate<= @BDate AND BDate >= @BEmpGivDate) >= 2
    BEGIN
      DECLARE @tmpDateB DATETIME, @BDateIndexing DATETIME
      /* Предыдущее повышение оклада */   
      SELECT @Salary = ISNULL(BSalary,0), @IndexBaseMonth = ISNULL(IndexBaseMonth,'19000101'), @BDateLastMove = Edate + 1/*BDate */
      FROM (
       SELECT TOP 1 IndexBaseMonth, BSalary, EDate 
        FROM (
          SELECT TOP 1 BSalary, IndexBaseMonth, BDate, EDate FROM r_EmpMPst WITH (NOLOCK) 
          WHERE OurID=@OurID AND EmpID=@EmpID AND BDate<= @BDate AND BDate >= @BEmpGivDate AND BSalary <> @CurrentBSalary 
          ORDER BY BDate DESC) s ORDER BY BDate) s1	

      IF @IndexBaseMonth is NULL 
        SET @tmpDateB = '19000101'
      ELSE             
        SET @tmpDateB = @IndexBaseMonth
      SET @Index = ISNULL((SELECT TOP 1 dbo.pf_GetSalaryIndexation(@tmpDateB, @BDateLastMove)),0)
      SET @BDateIndexing = (SELECT TOP 1 IndexBaseMonth FROM dbo.r_EmpMPst WHERE EmpID = @EmpID AND OurID = @OurID AND BDate <= @BDate ORDER BY BDate DESC)
      IF @BDateIndexing is NULL 
        SET @BDateIndexing = '19000101'
      SET @BIndexing = ISNULL((SELECT SUM(d.BIndexing) FROM p_LRecD d, p_LRec m
      WHERE m.ChID = d.ChID AND d.EmpID = @EmpID AND m.OurID = @OurID AND m.LRecType = 0 AND m.DocDate BETWEEN dbo.zf_GetMonthFirstDay(@BDateIndexing) AND dbo.zf_GetMonthLastDay(@BDateIndexing)),0)
      IF @Salary is NULL
        SET @Salary = 0   
      IF @IndexBaseMonth is NULL
        SET @IndexBaseMonth = '19000101'
      IF @BDateLastMove is NULL
        SET @BDateLastMove = '19000101'
    END
  ELSE
  BEGIN
    SET @Salary = 0
    SET @IndexBaseMonth = '19000101'
    SET @Index = 0
    SET @BIndexing = 0
    SET @BDateLastMove = '19000101'
  END

 SET @SalaryDifference = CASE WHEN @Salary <> 0 THEN @CurrentBSalary - @Salary ELSE 0 END
 SET @MinimumWage = ISNULL((SELECT TOP 1 EExp FROM z_FRUDFR m
     INNER JOIN z_FRUDFRD d ON m.UDFID = d.UDFID AND m.UDFName = 'НЗ_БУ_ПрожиточныйМинимум' AND @BDateLastMove BETWEEN d.BDate AND d.EDate),0)  

 IF @SalaryDifference < (@SumFixedIndexing + (@MinimumWage * @Index / 100))
   SET @SumFixedIndexing = (@SumFixedIndexing + (@MinimumWage * @Index / 100)) - @SalaryDifference
 ELSE
   SET @SumFixedIndexing = 0

 UPDATE @table
 SET 
   Salary = @Salary,
   IndexBaseMonth = @IndexBaseMonth,
   [INDEX] = @Index,
   BIndexing = @BIndexing,
   BDateLastMove = @BDateLastMove,
   SalaryDifference = @SalaryDifference,
   MinimumWage = @MinimumWage,
   SumFixedIndexing = @SumFixedIndexing
 WHERE [DATE] = @BDate

 FETCH NEXT FROM FixedIndexingCursor INTO @BDate
 END

 CLOSE FixedIndexingCursor
 DEALLOCATE FixedIndexingCursor

 SELECT   
   @Salary = Salary, 
   @IndexBaseMonth = IndexBaseMonth, 
   @Index = [Index], 
   @BIndexing = BIndexing,
   @BDateLastMove = BDateLastMove,
   @SumFixedIndexing = SumFixedIndexing
 FROM @table
 WHERE [Date] = @BDate   
END
GO