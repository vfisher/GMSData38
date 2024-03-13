SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  FUNCTION [dbo].[pf_CheckIntEmpID](@IntEmpID varchar(50), @EmpID INT, @OurID INT) /* Проверяет возможность установки указанного табельного номера сотруднику */RETURNS bitBEGIN  RETURN ISNULL((SELECT TOP 1 0 FROM r_EmpMO WHERE OurID = @OurID AND EmpID <> @EmpID AND IntEmpID <> '' AND IntEmpID = @IntEmpID), 1)END
GO
