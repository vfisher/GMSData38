SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetColorField] (@DocCode INT, @Vals VARCHAR(4000))
/* Возвращает таблицу настройки цвета полей документа */
AS
  BEGIN
  	DECLARE @Out TABLE (FieldName VARCHAR(250), Red TINYINT, Green TINYINT, Blue TINYINT)

    /* Пример переменных для обработки
    * DECLARE @ChID BIGINT 
    * EXEC z_ValsLookup 'ChID', @Vals, @ChID OUTPUT
    */

    /* Пример настройки цвета полей
    * INSERT INTO @Out(FieldName, Red, Green, Blue)
    * VALUES ('DocID', 237, 28, 237)
    */

    SELECT FieldName, Red, Green, Blue  
    FROM @Out t 
  END
GO
