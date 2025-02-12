SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleFindDCardByPhone](@Phone varchar(100))
/* Возвращает код дисконтной карты по номеру телефона */
AS
BEGIN
  DECLARE @PhoneExpression varchar(500), @part varchar(1)
  DECLARE @i int, @len int
  SELECT @PhoneExpression = ''
  SELECT @i = 1, @len = LEN(@Phone)

  /* в r_Persons.Phone телефон хранится в формате (0XX)XXX-XX-XX */
  IF CHARINDEX('38', @Phone) = 1 
    SELECT @Phone = SUBSTRING(@Phone, 3, @len)

  WHILE @i <= @len
    BEGIN
      SELECT @part = SUBSTRING(@Phone, @i, 1) 
      IF (PATINDEX('[0-9]', @part) = 1)
        BEGIN
          SELECT @PhoneExpression = @PhoneExpression + @part
          IF @i < @len 
            SELECT @PhoneExpression = @PhoneExpression + '%' 
        END         
    SET @i = @i + 1
  END
  IF @PhoneExpression <> ''
    SELECT @PhoneExpression = '%' + @PhoneExpression

  DECLARE @PersonID int
  DECLARE @SQL varchar(1000)
  EXEC sp_executesql N'SELECT TOP 1 @PersonID = PersonID FROM r_Persons WITH (NOLOCK) WHERE Phone LIKE @P2', N'@PersonID int OUTPUT, @P2 varchar(500)', @PersonID OUTPUT, @PhoneExpression 
  IF @PersonID IS NULL 
    BEGIN
      BEGIN

      DECLARE @Error_msg1 varchar(2000) = dbo.zf_Translate('Не найден клиент по заданому номеру телефона')

      RAISERROR(@Error_msg1, 16, 1)
      END

      RETURN
    END

  SELECT d.DCardID FROM r_PersonDC m JOIN r_DCards d ON m.DCardChID = d.ChID
  WHERE PersonID = @PersonID AND d.InUse = 1 AND (d.EDate IS NULL OR d.EDate >= GETDATE())
END
GO