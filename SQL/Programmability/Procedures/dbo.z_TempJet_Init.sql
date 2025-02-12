SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_TempJet_Init]
/* TempJet: Инициализация */
AS
BEGIN

/* Связь документов */
SELECT
  'CREATE TABLE #_DocLinks (' + CHAR(13) +
  'LinkID int, ' + CHAR(13) +
  'LinkDocDate smalldatetime, ' + CHAR(13) +
  'DocLinkTypeID int, ' + CHAR(13) +
  'ParentDocCode int, ' + CHAR(13) +
  'ParentDocName varchar(250), ' + CHAR(13) +
  'ParentChID bigint, ' + CHAR(13) +
  'ParentDocID bigint, ' + CHAR(13) +
  'ParentDocDate smalldatetime, ' + CHAR(13) +
  'ChildDocCode int, ' + CHAR(13) +
  'ChildDocName varchar(250), ' + CHAR(13) +
  'ChildChID bigint, ' + CHAR(13) +
  'ChildDocID bigint, ' + CHAR(13) +
  'ChildDocDate smalldatetime, ' + CHAR(13) +
  'ParentSumCC numeric(21,9), ' + CHAR(13) +
  'ParentSumCCClosed numeric(21,9), ' + CHAR(13) +
  'ParentSumCCFree numeric(21,9), ' + CHAR(13) +
  'ChildSumCC numeric(21,9), ' + CHAR(13) +
  'ChildSumCCClosed numeric(21,9),  ' + CHAR(13) +
  'ChildSumCCFree numeric(21,9), ' + CHAR(13) +
  'LinkSumCC  numeric(21,9), ' + CHAR(13) +
  'Notes varchar(250), ' + CHAR(13) +
  'RepToolCode int, ' + CHAR(13) +
  'ToolCode int, ' + CHAR(13) +
  'ShowDialog bit' + CHAR(13) +
  ')' As TableDef

UNION ALL

/* Создание налоговых накладных: */
SELECT
  'CREATE TABLE #_TaxDocs (' + CHAR(13) +
  'TJ_Prompt varchar(250), ' + CHAR(13) +
  'TJ_RepToolCode int, ' + CHAR(13) +
  'TJ_ToolCode int, ' + CHAR(13) +
  'TJ_ShowDialog bit, ' + CHAR(13) +

  'ParentDocCode int, ' + CHAR(13) +
  'ParentChID bigint, ' + CHAR(13) +
  'ParentDocID bigint, ' + CHAR(13) +
  'ParentDocDate smalldatetime, ' + CHAR(13) +

  'TaxDocType int, ' + CHAR(13) +
  'TaxCorrType int, ' + CHAR(13) +
  'ChID bigint, ' + CHAR(13) +
  'DocID bigint, ' + CHAR(13) +
  'DocDate smalldatetime, ' + CHAR(13) +
  'KursMC numeric(21,9), ' + CHAR(13) +
  'OurID int, ' + CHAR(13) +
  'CompID int, ' + CHAR(13) +
  'Notes varchar(200), ' + CHAR(13) +
  'CodeID1 int, ' + CHAR(13) +
  'CodeID2 int, ' + CHAR(13) +
  'CodeID3 int, ' + CHAR(13) +
  'CodeID4 int, ' + CHAR(13) +
  'CodeID5 int, ' + CHAR(13) +
  'IntDocID varchar(50), ' + CHAR(13) +
  'StateCode int, ' + CHAR(13) +

  'SrcDocID varchar(250), ' + CHAR(13) +
  'SrcDocDate smalldatetime, ' + CHAR(13) +

  'SrcTaxDocID varchar(250), ' + CHAR(13) +
  'SrcTaxDocDate smalldatetime, ' + CHAR(13) +

  'GOperID int, ' + CHAR(13) +
  'GTranID int, ' + CHAR(13) +
  'GTSum_wt numeric(21, 9), ' + CHAR(13) +
  'GTTaxSum numeric(21, 9), ' + CHAR(13) +
  'GTAccID int, ' + CHAR(13) +
  'GPosID int, ' + CHAR(13) +
  'GTCorrSum_wt numeric(21, 9), ' + CHAR(13) +
  'GTCorrTaxSum numeric(21, 9), ' + CHAR(13) +

  'PosType int, ' + CHAR(13) +
  'TaxCredit bit, ' + CHAR(13) +

  'PayDate smalldatetime, ' + CHAR(13) +
  'PayForm varchar(200), ' + CHAR(13) +
  'TakeTotalCosts bit, ' + CHAR(13) +

  'IsCorrection bit, ' + CHAR(13) +

  'SumCC_nt numeric(21, 9), ' + CHAR(13) +
  'TaxSum numeric(21, 9), ' + CHAR(13) +
  'SumCC_wt numeric(21, 9), ' + CHAR(13) +

  'SumCC_nt_20 numeric(21, 9), ' + CHAR(13) +
  'TaxSum_20 numeric(21, 9), ' + CHAR(13) +
  'SumCC_nt_7 numeric(21, 9), ' + CHAR(13) +
  'TaxSum_7 numeric(21, 9), ' + CHAR(13) +
  'SumCC_nt_0 numeric(21, 9), ' + CHAR(13) +
  'TaxSum_0 numeric(21, 9), ' + CHAR(13) +
  'SumCC_nt_Free numeric(21, 9), ' + CHAR(13) +
  'TaxSum_Free numeric(21, 9), ' + CHAR(13) +
  'SumCC_nt_No numeric(21, 9), ' + CHAR(13) +
  'TaxSum_No numeric(21, 9), ' + CHAR(13) +

  'DocLinkTypeID int, ' + CHAR(13) +
  'LinkSumCC numeric(21, 9)' + CHAR(13) +
  ')' As TableDef
END
GO