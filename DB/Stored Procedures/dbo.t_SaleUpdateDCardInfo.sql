SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleUpdateDCardInfo] (@DCardChID bigint, @PersonID int, @DCTypeCode int)
/* Обновляет информацию о клиенте по ДК */
AS
BEGIN
  IF EXISTS(SELECT TOP 1 1 FROM dbo.r_PersonDC WHERE DCardChID = @DCardChID)
    BEGIN
      BEGIN TRAN
        UPDATE r_PersonDC SET PersonID = @PersonID WHERE DCardChID = @DCardChID
        UPDATE r_DCards SET DCTypeCode = @DCTypeCode WHERE ChID = @DCardChID AND DCTypeCode <> @DCTypeCode       
      COMMIT TRAN
    END
  ELSE  
    BEGIN
      BEGIN TRAN
        INSERT INTO r_PersonDC (PersonID, DCardChID) VALUES (@PersonID, @DCardChID) 
        UPDATE r_DCards SET DCTypeCode = @DCTypeCode WHERE ChID = @DCardChID AND DCTypeCode <> @DCTypeCode                                  
      COMMIT TRAN
    END
END
GO
