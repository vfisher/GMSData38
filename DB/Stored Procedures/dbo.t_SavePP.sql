SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SavePP](@ANewPP bit, @ADocCode int, @AChID bigint, @AInMC bit,
  @ACurrID int, @ARateMC numeric(21, 9), @APriceMC numeric(21, 9), @APriceCC numeric(21, 9),
  @ACostAC numeric(21, 9), @ACostCC numeric(21, 9), @APPWeight numeric(21, 9), @APPDesc varchar(200), @AProdID int,
  @APPID int, @APriority int, @ACompID int, @AProdDate smalldatetime, @AArticle varchar(200),
  @APPDelay smallint, @AProdPPDate smalldatetime, @AIsCommission bit,
  @ACstProdCode varchar(200), @ACstDocCode varchar(200), @APriceAC numeric(21, 9), @ACostMC numeric(21, 9))
/* Создает новую или изменяет существующую партию (Торговля) */
AS
BEGIN
  DECLARE @APrice numeric(21, 9)
  DECLARE @ACurr int
  DECLARE @NChID bigint
  DECLARE @AOldCurrID smallint
  DECLARE @AOldPrice numeric(21, 9)
  DECLARE @AOldPriceIn numeric(21, 9), @AOldPriceCC_In numeric(21, 9), @AOldPriceAC_In numeric(21, 9)
  DECLARE @ARateCC numeric(21, 9)
  DECLARE @ACurrMC int, @ACurrCC int 
  DECLARE @AUseMultiCurrencies bit

  SET @ACurrMC = dbo.zf_GetCurrMC()
  SET @ACurrCC = dbo.zf_GetCurrCC()
  SET @ARateCC = dbo.zf_GetRateCC(@ACurrID)
  SET @AUseMultiCurrencies = dbo.zf_Var('t_UseMultiCurrencies')

  IF @AInMC = 1
    BEGIN
      SET @APrice = @APriceMC
      SET @ACurr = dbo.zf_GetCurrMC()
    END
  ELSE
    BEGIN
      SET @APrice = @APriceCC
      SET @ACurr = dbo.zf_GetCurrCC()
    END

  BEGIN TRANSACTION
  IF @ANewPP = 1
    BEGIN

    IF @AUseMultiCurrencies = '1'
      INSERT INTO t_PInP (ProdID, PPID, PriceMC_In, CostAC, PriceMC, Priority, CurrID, CompID, ProdDate, Article, PriceCC_In, CostCC, PPWeight, PPDelay, PPDesc, ProdPPDate, IsCommission, CstProdCode, CstDocCode, ParentDocCode, ParentChID, PriceAC_In, CostMC)
      VALUES (@AProdID , @APPID,  @APriceMC, @ACostAC, 0, @APriority, @ACurrID, @ACompID, @AProdDate, @AArticle, @APriceCC, @ACostCC, @APPWeight, @APPDelay, @APPDesc, @AProdPPDate, @AIsCommission, @ACstProdCode, @ACstDocCode, @ADocCode, @AChID, @APriceAC, @ACostMC)
    ELSE
      INSERT INTO t_PInP (ProdID, PPID, PriceMC_In, CostAC, PriceMC, Priority, CurrID, CompID, ProdDate, Article, PriceCC_In, CostCC, PPWeight, PPDelay, PPDesc, ProdPPDate, IsCommission, CstProdCode, CstDocCode, ParentDocCode, ParentChID)
      VALUES (@AProdID , @APPID,  @APrice, @ACostAC, 0, @APriority, @ACurr, @ACompID, @AProdDate, @AArticle, @APriceCC, @ACostCC, @APPWeight, @APPDelay, @APPDesc, @AProdPPDate, @AIsCommission, @ACstProdCode, @ACstDocCode, @ADocCode, @AChID)
    END
  ELSE
    BEGIN
      SELECT
        @AOldCurrID = CurrID,
        @AOldPrice = PriceMC,
        @AOldPriceIn = PriceMC_In,
        @AOldPriceCC_In = PriceCC_In,
        @AOldPriceAC_In = PriceAC_In 
      FROM t_PInP WITH(NOLOCK)
      WHERE ProdID = @AProdID AND PPID = @APPID

      IF @AUseMultiCurrencies = '1'
        BEGIN
          UPDATE t_PInP
          SET
            PriceMC_In = @APriceMC,
            PriceAC_In = @APriceAC,
            PriceCC_In = @APriceCC,
            CostMC = @ACostMC,
            CostAC = @ACostAC,
            CostCC = @ACostCC,
            CurrID = @ACurrID,
            CompID = @ACompID,
            ProdDate = @AProdDate,
            Article = @AArticle,
            PPWeight = @APPWeight,
            PPDelay = @APPDelay,
            PPDesc = @APPDesc,
            Priority = @APriority,
            ProdPPDate = @AProdPPDate,
            IsCommission = @AIsCommission,
            CstProdCode = @ACstProdCode,
            CstDocCode = @ACstDocCode,
            ParentDocCode = @ADocCode,
            ParentChID = @AChID
          WHERE ProdID = @AProdID AND PPID = @APPID

          EXEC z_NewChID 't_PInPCh', @NChID OUTPUT
          IF @@ERROR <> 0
            BEGIN
              ROLLBACK TRANSACTION
              RETURN
            END

          INSERT INTO t_PInPCh (ChID, ChDate, ChTime, ProdID, PPID, OldCurrID, OldPriceMC_In, OldPriceMC, CurrID, PriceMC_In, PriceMC, UserID, OldPriceCC_In, PriceCC_In, OldPriceAC_In, PriceAC_In)
          VALUES (@NChID, GETDATE(), GETDATE(), @AProdID, @APPID, @AOldCurrID, @AOldPriceIn, @AOldPrice, @ACurr, @APriceMC, @AOldPrice, dbo.zf_GetUserCode(), @AOldPriceCC_In, @APriceCC, @AOldPriceAC_In, @APriceAC)         
        END
      ELSE
        BEGIN
          UPDATE t_PInP
          SET
            PriceMC_In = @APrice,
            CostAC = @ACostAC,
            CurrID = @ACurr,
            CompID = @ACompID,
            ProdDate = @AProdDate,
            Article = @AArticle,
            PriceCC_In = @APriceCC,
            CostCC = @ACostCC,
            PPWeight = @APPWeight,
            PPDelay = @APPDelay,
            PPDesc = @APPDesc,
            Priority = @APriority,
            ProdPPDate = @AProdPPDate,
            IsCommission = @AIsCommission,
            CstProdCode = @ACstProdCode,
            CstDocCode = @ACstDocCode,
            ParentDocCode = @ADocCode,
            ParentChID = @AChID
          WHERE ProdID = @AProdID AND PPID = @APPID

          EXEC z_NewChID 't_PInPCh', @NChID OUTPUT
          IF @@ERROR <> 0
            BEGIN
              ROLLBACK TRANSACTION
              RETURN
            END

          INSERT INTO t_PInPCh (ChID, ChDate, ChTime, ProdID, PPID, OldCurrID, OldPriceMC_In, OldPriceMC, CurrID, PriceMC_In, PriceMC, UserID)
          VALUES (@NChID, GETDATE(), GETDATE(), @AProdID, @APPID, @AOldCurrID, @AOldPriceIn, @AOldPrice, @ACurr, @APrice, @AOldPrice, dbo.zf_GetUserCode())
        END
    END
  COMMIT TRANSACTION
END
GO
