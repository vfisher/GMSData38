SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_GetEmpNameForDate](@OurID int, @EmpID int, @Date smalldatetime, @Param varchar(100))
GO