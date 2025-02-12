SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleAfterGetDCardByPhone](
   @Phone VARCHAR(250),
   @DCardID VARCHAR(250)
)       
/* Вызывается после получения информации о ДК от процессинга по номеру телефона */
 AS
GO