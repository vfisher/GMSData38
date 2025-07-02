SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_MDIOnEvent](@EventID int, @AppCode INT, @JSON varchar(max))
AS
/* Процедура, вызываемая при различных событиях в MDI модулях */
BEGIN
  /* События */
  DECLARE /* @SALE_EVENT... */ 
    @EVENT_APP_START tinyint = 1               /* Старт приложения */

  /* Действия */
  DECLARE 
    @EVENT_ACTION_SHOWPRINTFORM tinyint = 3            /*  показать печатку, которая лежит по пути ...*/

  /* Пример */
  /*IF @EventID = @EVENT_APP_START AND @Appcode = 11000
    SELECT '{"actions":[{"id":1,"action":'+ cast(@EVENT_ACTION_SHOWPRINTFORM AS Varchar(10))+',"Path":"D:\\GMS\\SrvDirs\\ReportsUni\\1.fr3", "Preview":true, "Export": false}]}' AS Result
  */
END
GO