SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_UserCostAcc]()
/* Имеет ли текущий пользователь доступ к себестоимости */
RETURNS bit AS
Begin
  RETURN (SELECT s_Cost FROM r_Users WHERE UserName = SUSER_SNAME())
End 
GO
