SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_DeleteDeadPPs]
AS
SELECT 
	pp.ProdID, pp.PPID
INTO #DeadPPs
FROM t_Pinp pp
LEFT JOIN 
(
	SELECT ProdID, PPID FROM t_AccD
	UNION ALL
	SELECT ProdID, PPID FROM t_RecD 
	UNION ALL
	SELECT ProdID, PPID FROM t_RetD
	UNION ALL
	SELECT ProdID, PPID FROM t_CRRetD
	UNION ALL
	SELECT ProdID, PPID FROM t_CRetD
	UNION ALL
	SELECT ProdID, PPID FROM t_InvD
	UNION ALL
	SELECT ProdID, PPID FROM t_ExpD
	UNION ALL
	SELECT ProdID, PPID FROM t_EppD
	UNION ALL
	SELECT ProdID, PPID FROM t_ExcD
	UNION ALL
	SELECT DetProdID, PPID FROM t_VenD 
	UNION ALL
	SELECT ProdID, PPID FROM t_EstD
	UNION ALL
	SELECT ProdID, NewPPID FROM t_EstD 
	UNION ALL
	SELECT ProdID, PPID FROM t_SaleD
	UNION ALL
	SELECT ProdID, PPID FROM t_CosD
	UNION ALL
	SELECT ProdID, PPID FROM t_CstD
	UNION ALL
	SELECT ProdID, PPID FROM t_IOExpD
	UNION ALL
	SELECT ProdID, PPID FROM t_SPRecA
	UNION ALL
	SELECT SubProdID, SubPPID FROM t_SPRecD
	UNION ALL
	SELECT ProdID, PPID FROM t_SPExpA
	UNION ALL
	SELECT SubProdID, SubPPID FROM t_SPExpD
	UNION ALL
	SELECT ProdID, PPID FROM t_SRecA
	UNION ALL
	SELECT SubProdID, SubPPID FROM t_SRecD
	UNION ALL
	SELECT ProdID, PPID FROM t_SExpA
	UNION ALL
	SELECT SubProdID, SubPPID FROM t_SExpD
	UNION ALL
	SELECT ProdID, PPID FROM t_zInP
) d
ON pp.ProdID = d.ProdID AND pp.PPID = d.PPID
WHERE pp.PPID <> 0 AND d.PPID is null

DELETE r
FROM t_Rem r inner join #DeadPPs d
on r.ProdID = d.ProdID AND r.PPID = d.PPID

DELETE pp
FROM t_Pinp pp inner join #DeadPPs d
on pp.ProdID = d.ProdID AND pp.PPID = d.PPID 

DROP TABLE #DeadPPs

DELETE t_Rem WHERE PPID = 0 AND Qty = 0 AND AccQty = 0
DELETE t_PInPCh
WHERE ProdID NOT IN 
(
  SELECT ProdID FROM t_PInP WHERE PPID <> 0
)
GO