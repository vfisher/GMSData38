SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_PPIDRange]()/* Возвращает диапазон номеров партий */RETURNS @out table (PPIDStart int, PPIDEnd int)BEGIN  INSERT INTO @out(PPIDStart, PPIDEnd)  SELECT PPID_Start, PPID_End FROM r_DBIs WHERE DBiID = dbo.zf_Var('OT_DBiID')  RETURNEND
GO