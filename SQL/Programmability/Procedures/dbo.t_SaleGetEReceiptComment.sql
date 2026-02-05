SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_SaleGetEReceiptComment](@ParamsIn nvarchar(max))
/* Повертає коментар до чека для підтримки програми «єЧек» */
AS
BEGIN
    DECLARE 
        @CRID int,
        @DocCode int,
        @ChID bigint,
        @DocID bigint,
        @OurID int,
        @ChequeComment nvarchar(500),
        @TIN varchar(10),
        @mcr nchar(2) = CHAR(13) + CHAR(10),
        @CRComment nvarchar(1024)

  /* SET @ParamsIn = '{"OurID":7,"ChequeComment":"ЧЕК:100000009 ПРРО GMS ТЕСТ (касса 1)","DocCode":1011,"DocID":100000009,"ChID":100000117,"CRID":25}' */
  /* 
    <COMMENT>ERECEIPT
    BID=123e4567-e89b-12d3-a456-426614174000
    RID=bar:20240101-123456789
    TIN=1234567890
    BNS=acpenfb
    RWR=2312 балів
    BTX=Замовлення №12345, дякуємо за покупку!</COMMENT>
  */

    SELECT
        @CRID          = JSON_VALUE(@ParamsIn, '$.CRID'),
        @DocCode       = JSON_VALUE(@ParamsIn, '$.DocCode'),
        @ChID          = JSON_VALUE(@ParamsIn, '$.ChID'),
        @OurID         = JSON_VALUE(@ParamsIn, '$.OurID'),
        @DocID         = JSON_VALUE(@ParamsIn, '$.DocID'),
        @ChequeComment = JSON_VALUE(@ParamsIn, '$.ChequeComment')

    SELECT @TIN = Code FROM r_Ours WITH (NOLOCK) WHERE OurID = @OurID

    SELECT
        @CRComment = STUFF((
            SELECT @mcr +
                   'ERECEIPT' + @mcr +
                   'BID=' + ISNULL(JSON_VALUE(JSON_VALUE(p.TransactionInfo,'$.POSPayAdv'),'$.natr'),'') + @mcr +
                   'RID=' + ISNULL(JSON_VALUE(JSON_VALUE(p.TransactionInfo,'$.POSPayAdv'),'$.rid'),'')  + @mcr +
                   'TIN=' + @TIN + @mcr +
                   'BTX=Замовлення №' + CAST(@DocID AS varchar(20)) + ', дякуємо за покупку!'
            FROM (
                SELECT TransactionInfo
                FROM t_SaleTempPays
                WHERE @DocCode = 1011 AND ChID = @ChID

                UNION ALL
                SELECT TransactionInfo
                FROM t_SalePays
                WHERE @DocCode = 11035 AND ChID = @ChID

                UNION ALL
                SELECT TransactionInfo
                FROM t_CRRetPays
                WHERE @DocCode = 11004 AND ChID = @ChID
            ) p
            WHERE
                ISJSON(JSON_VALUE(p.TransactionInfo,'$.POSPayAdv')) = 1
            FOR XML PATH(''), TYPE
        ).value('.', 'nvarchar(max)'), 1, LEN(@mcr), '')

    SELECT
        CASE WHEN @ChequeComment <> '' 
          THEN @ChequeComment + @mcr 
        ELSE '' END + ISNULL(@CRComment,'') AS CRComment
END
GO