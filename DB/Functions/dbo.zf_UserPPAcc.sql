SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[zf_UserPPAcc]()
/* Имеет ли текущий пользователь доступ к ценам прихода */
RETURNS bit AS
Begin
  RETURN (SELECT s_PPAcc FROM r_Users WHERE UserName = SUSER_SNAME())
End 
GO
