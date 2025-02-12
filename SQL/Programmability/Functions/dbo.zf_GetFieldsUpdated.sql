SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetFieldsUpdated] (@TblName SYSNAME, @BitMask VARBINARY(255))
RETURNS @out TABLE (NAME NVARCHAR(255))
AS
BEGIN
 WITH ColumnsUpdatedBytes(N, B, U, L) AS
      ( SELECT 1, SUBSTRING(@BitMask, 1, 1), @BitMask, DATALENGTH(@BitMask)
        UNION ALL
        SELECT N + 1, SUBSTRING(U, N + 1, 1), U, L
        FROM ColumnsUpdatedBytes
        WHERE N < L),
      BitNumbers(N) AS ( SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 )
 INSERT @out
 SELECT C.name
 FROM ColumnsUpdatedBytes Bytes
   CROSS JOIN BitNumbers Bits JOIN sys.columns C ON  C.column_id = 8*(Bytes.N-1)+Bits.N
 WHERE
   Bytes.B & POWER(2, Bits.N-1)<>0 AND C.object_id = OBJECT_ID(@TblName, 'U')
 OPTION(MAXRECURSION 0)
 RETURN
END
GO