SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_ProdMarkDoCancelChequee]( 
	  @DocCode          INT 
   ,@ChID             BIGINT 
   ,@Result           INT OUTPUT 
)  
/* Выполняет отмену чека с маркируемым товаром и изменяет InUse в r_ProdMarks*/ 
AS 
BEGIN 
	DECLARE @MarkCode INT 
	 
	IF @DocCode=1011 /*чек продажи  */
  BEGIN 
  	 
  	DECLARE saleDCurs CURSOR LOCAL FAST_FORWARD FOR 
  	SELECT MarkCode FROM t_SaleTempD AS tstd WHERE tstd.CHID=@ChID AND (MarkCode IS NOT NULL) AND (MarkCode>0) 
 
  	OPEN saleDCurs 
    IF @@ERROR <> 0 GOTO Error 
  	 
  	FETCH NEXT FROM saleDCurs 
    INTO @MarkCode 
     
    WHILE @@FETCH_STATUS = 0 
    BEGIN 
      IF NOT EXISTS(SELECT * FROM t_SaleTempD AS tstd WHERE tstd.MarkCode=@MarkCode AND tstd.ChID<>@ChID)    
    	  UPDATE r_ProdMarks SET InUse = 1, DateChange=GETDATE() WHERE MarkCode=@MarkCode 
  	 
      FETCH NEXT FROM saleDCurs 
      INTO @MarkCode 
  	  IF @@ERROR <> 0 GOTO Error 
    END	 
  END 
	ELSE IF @DocCode=11004 /*чек возврата   */
  BEGIN 
  	 
  	DECLARE CRRetDCurs CURSOR LOCAL FAST_FORWARD FOR 
    SELECT MarkCode FROM t_CRRetD AS tstd WHERE tstd.CHID=@ChID AND (MarkCode IS NOT NULL) AND (MarkCode>0) 
 
    OPEN CRRetDCurs 
    IF @@ERROR <> 0 GOTO Error 
 
    FETCH NEXT FROM CRRetDCurs 
    INTO @MarkCode 
 
    WHILE @@FETCH_STATUS = 0 
    BEGIN	 
      IF NOT EXISTS( SELECT tcd.CHID, tcd.ProdID, tc.StateCode, tsd.MarkCode 
                      FROM t_CRRetD AS tcd INNER JOIN t_CRRet AS tc ON tc.ChID = tcd.ChID  
	                        INNER JOIN t_Sale AS ts ON ts.DocID = tc.SrcDocID  
	                        INNER JOIN t_SaleD AS tsd ON tsd.ChID = ts.ChID 
                      WHERE tc.StateCode<22 AND tsd.MarkCode=@MarkCode AND tcd.MarkCode=tsd.MarkCode AND tcd.ChID<>@ChID ) 
      UPDATE r_ProdMarks SET InUse = 0, DateChange=GETDATE() WHERE MarkCode=@MarkCode 
   
      FETCH NEXT FROM CRRetDCurs 
      INTO @MarkCode 
      IF @@ERROR <> 0 GOTO Error 
    END                
  END 
    
  Error:  
    Set @Result = 0 
END
GO
