SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[pf_GetWTimeCorInfo](@Date datetime, @EmpID int, @OurID int, @WTSignID int, @WorkHours numeric(21,9), @EveningHours numeric(21,9), @NightHours numeric(21,9), @OverTime numeric(21,9),  @PayFactor numeric(21,9), @OverPayFactor numeric(21,9))
GO