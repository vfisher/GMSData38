SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaveCashRegInetCheque](@DocCode int, @ChID bigint, @InetChequeNum VARCHAR(250)
                                       , @InetChequeURL VARCHAR(250), @Status int, @IsOffline BIT
                                       , @OfflineSeed VARCHAR(250), @OfflineSessionID VARCHAR(250)
                                       , @XMLTextCheque VARBINARY(MAX), @DocTime datetime, @FinID VARCHAR(250)
                                       , @NextlocalNum int, @OfflineNextLocalNum int, @DocHash VARCHAR(250), @CRID INT, @IsTesting BIT, @ExtraInfo varchar(8000))

AS
BEGIN
IF Len(@XMLTextCheque) = 0
SET @XMLTextCheque= NULL

IF @DocCode <> 3
  BEGIN
    DELETE FROM t_CashRegInetCheques WHERE ChID = @ChID AND DocCode = @DocCode AND CRID = @CRID
    INSERT INTO t_CashRegInetCheques (DocCode, ChID, InetChequeNum, InetChequeURL, Status, IsOffline, OfflineSeed, OfflineSessionID,
                                    XMLTextCheque, DocTime, FinID, NextlocalNum, OfflineNextLocalNum, DocHash, CRID, IsTesting, ExtraInfo)
    VALUES (@DocCode, @ChID, @InetChequeNum
          , @InetChequeURL, @Status, @IsOffline
          , @OfflineSeed, @OfflineSessionID
          , @XMLTextCheque, @DocTime, @FinID
          , @NextlocalNum, @OfflineNextLocalNum, @DocHash, @CRID, @IsTesting, @ExtraInfo)
  END
ELSE
  BEGIN
    IF NOT EXISTS(SELECT TOP 1 1 FROM t_CashRegInetCheques WHERE DocCode = @DocCode AND FinID = @FinID AND InetChequeNum = @InetChequeNum AND CRID = @CRID)
  	  INSERT INTO t_CashRegInetCheques (DocCode, ChID, InetChequeNum, InetChequeURL, Status, IsOffline, OfflineSeed, OfflineSessionID,
                                    XMLTextCheque, DocTime, FinID, NextlocalNum, OfflineNextLocalNum, DocHash, CRID, IsTesting, ExtraInfo)
      VALUES (@DocCode, @ChID, @InetChequeNum
          , @InetChequeURL, @Status, @IsOffline
          , @OfflineSeed, @OfflineSessionID
          , @XMLTextCheque, @DocTime, @FinID
          , @NextlocalNum, @OfflineNextLocalNum, @DocHash, @CRID, @IsTesting, @ExtraInfo)
  END
END
GO