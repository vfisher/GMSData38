SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_ProdMarkDoValidate]( 
	  @DocCode          INT 
   ,@ChID             BIGINT 
   ,@appSale          BIT 
   ,@ProdID           INT 
   ,@DataMatrix       VARCHAR(150) 
   ,@MarkCode         INT OUTPUT 
   ,@ErrorMessage     VARCHAR(250) OUTPUT 
   ,@Result           INT OUTPUT 
)  
/* Выполняет проверку маркируемого товара и изменяет InUse в r_ProdMarks*/ 
AS 
BEGIN 
    DECLARE @OurID INT  
    DECLARE @SrcDocID INT 
    DECLARE @InUse BIT  
     
    SET @Result = 0 
     
    IF @DocCode=1011 
        SELECT @OurID = OurID 
        FROM   t_SaleTemp 
        WHERE  ChID = @ChID 
    ELSE 
        SELECT @SrcDocID=SrcDocID, @OurID = OurID 
        FROM   t_CRRet 
        WHERE  ChID = @ChID  
             
    SELECT @InUse = rpm.InUse, @MarkCode=rpm.MarkCode 
    FROM   r_ProdMarks AS rpm 
    WHERE  rpm.ProdID = @ProdID 
           AND rpm.DataMatrix = @DataMatrix 
             
    IF @DocCode=1011 /*чек продажи  */
    BEGIN 
      IF (NOT @InUse IS NULL) /*запись найдена  */
      BEGIN 
          IF (@InUse=0 AND @appSale=1) 
              SET @ErrorMessage = 'Товар уже продан, повторная продажа невозможна'; 
           
          IF (@InUse=1 AND @appSale=1)  
          BEGIN /*разрешаем продажу  */
   /*     	  UPDATE r_ProdMarks SET InUse = 0 WHERE DataMatrix=@DataMatrix  */
          	 
        	  SET @Result=1; 
          END  
           
          IF (@InUse=0 AND @appSale=0 AND (NOT EXISTS(SELECT * FROM t_SaleTempD AS tstd WHERE tstd.ChID=@ChID AND tstd.ProdID=@ProdID AND tstd.MarkCode=@MarkCode))) 
              SET @ErrorMessage = 'Товар в чеке отсутствует, отмена товара невозможна';       
           
          IF (@InUse=1 AND @appSale=0) 
              SET @ErrorMessage = 'Товар не продан, отмена товара невозможна';   
           
          IF (@InUse=0 AND @appSale=0 AND EXISTS(SELECT * FROM t_SaleTempD AS tstd WHERE tstd.ChID=@ChID AND tstd.ProdID=@ProdID AND tstd.MarkCode=@MarkCode)) 
          BEGIN /*разрешаем отмену продажи  */
        	 /* UPDATE r_ProdMarks SET InUse = 1 WHERE DataMatrix=@DataMatrix  */
          	 
        	  SET @Result=1; 
          END            
           
        END  
      ELSE /*запись не найдена  */
          SET @ErrorMessage = 'Данного товара нет на остатке, продажа невозможна' 
  END   
       
  IF @DocCode=11004 /*чек возврата   */
  BEGIN 
  	/*проверить наличие введенного кода DataMatrix в товарной позиции родительского чека продажи  */
/*SELECT  @SrcDocID,@OurID, @ProdID, @MarkCode	  */
/*SELECT * FROM   t_Sale s   INNER JOIN t_SaleD sd 
                       ON  sd.ChID = s.ChID 
           WHERE  s.DocID = @SrcDocID 
                  AND s.OurID = @OurID 
                  AND sd.ProdID = @ProdID 
                  AND sd.MarkCode = @MarkCode 
           ORDER BY 
                  sd.SrcPosID  	*/ 
  	  IF EXISTS( 
           SELECT TOP 1 1 
           FROM   t_Sale s 
                  INNER JOIN t_SaleD sd 
                       ON  sd.ChID = s.ChID 
           WHERE  s.DocID = @SrcDocID 
                  AND s.OurID = @OurID 
                  AND sd.ProdID = @ProdID 
                  AND sd.MarkCode = @MarkCode 
           ORDER BY 
                  sd.SrcPosID 
       ) 
  	  BEGIN /*найдена запись, то  */
  	      IF @InUse=1 
  	          SET @ErrorMessage = 'Товар уже возвращен, повторный возврат невозможен'; 
  	      IF @InUse=0 
          BEGIN /*разрешаем возврат товара  */
  	       /*- UPDATE r_ProdMarks SET InUse = 1 WHERE DataMatrix=@DataMatrix  */
          	 
  	        SET @Result=1; 
          END  
  	  END 
  	  ELSE /*если не найдена запись, то  */
          SET @ErrorMessage = 'Товар в чеке продажи отсутствует, возврат товара невозможен'       
  END 
END
GO