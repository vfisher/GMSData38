SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_OrderMonitorGetItems](@OrderMonitorID int)
AS
/* Возвращает набор данных для Информера */
BEGIN
  DECLARE @ShowProdNotes bit 
  DECLARE @OrderMonitorType tinyint
  DECLARE @WPIDFilter varchar(4000), @PProdFilter varchar(4000), @PCatFilter varchar(4000), @PGrFilter varchar(4000)
  DECLARE @PGr1Filter varchar(4000), @PGr2Filter varchar(4000), @PGr3Filter varchar(4000)


  SELECT @OrderMonitorType = OrderMonitorType, @ShowProdNotes = ShowProdNotes, @WPIDFilter = WPIDFilter, @PProdFilter = PProdFilter,
         @PCatFilter = PCatFilter, @PGrFilter = PGrFilter, @PGr1Filter = PGr1Filter, @PGr2Filter = PGr2Filter, @PGr3Filter = PGr3Filter
  FROM r_OrderMonitors
  WHERE OrderMonitorID = @OrderMonitorID

  IF @OrderMonitorType = 0 
    BEGIN
      DECLARE @Delim varchar(10)
      SELECT @Delim = dbo.zf_Var('z_FilterListSeparator')

      SELECT m.LogIDEx, m.DocCode, m.DocChID, m.SaleSrcPosID, m.ProdID, m.UM, m.Qty, m.CreateTime, m.WPID, m.StateCode, NULLIF(m.ServingID, 0) ServingID, m.ServingTime, m.Notes,
        CASE @ShowProdNotes 
          WHEN 1 THEN 
            CASE WHEN ISNULL(d.Notes, '''') = '''' THEN d.ProdName ELSE d.Notes END 
        END ProdName
      FROM t_OrderMonitorsTemp m
        JOIN r_Prods d ON m.ProdID = d.ProdID
      WHERE dbo.zf_MatchFilterInt(m.WPID, @WPIDFilter, @Delim) = 1 AND
        dbo.zf_MatchFilterInt(m.ProdID, @PProdFilter, @Delim) = 1 AND
        dbo.zf_MatchFilterInt(d.PCatID, @PCatFilter, @Delim) = 1 AND
        dbo.zf_MatchFilterInt(d.PGrID, @PGrFilter, @Delim) = 1 AND
        dbo.zf_MatchFilterInt(d.PGrID1, @PGr1Filter, @Delim) = 1 AND
        dbo.zf_MatchFilterInt(d.PGrID2, @PGr2Filter, @Delim) = 1 AND
        dbo.zf_MatchFilterInt(d.PGrID3, @PGr3Filter, @Delim) = 1
      ORDER BY NULLIF(m.ServingID, 0) ASC, m.ServingTime ASC, m.CreateTime ASC
    END
  ELSE IF @OrderMonitorType = 1
    BEGIN
      SELECT DocCode, DocChID, WPID, Suspended, MIN(StateCode) StateCode, MIN(ISNULL(QueueTime, '99991231')) QueueTime FROM t_OrderMonitorsTemp
      GROUP BY DocCode, DocChID, WPID, Suspended
      ORDER BY MIN(ISNULL(QueueTime, '99991231')), DocCode, DocChID
    END
END
GO
