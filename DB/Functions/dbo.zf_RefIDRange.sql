SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_RefIDRange]()/* Возвращает диапазон кодов справочников */RETURNS @out table (RefID_Start int, RefID_End int)BEGIN  INSERT INTO @out(RefID_Start, RefID_End)  SELECT RefID_Start, RefID_End FROM r_DBIs WHERE DBiID = dbo.zf_Var('OT_DBiID')  RETURNEND
GO
