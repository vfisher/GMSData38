SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_InitUserVars] (@UserCode int)/* Инициализирует и перепозиционирует переменные пользователя */ AS  INSERT INTO z_UserVars(UserCode, VarName, VarDesc, VarValue, VarInfo, VarType, VarGroup, VarPosID, LabelPos, VarExtInfo, VarVisible, VarSelType)  SELECT @UserCode, VarName, VarDesc, VarValue, VarInfo, VarType, VarGroup, VarPosID, LabelPos, VarExtInfo, 1, VarSelType  FROM z_Vars  WHERE NOT VarName IN (SELECT VarName FROM z_UserVars WHERE UserCode = @UserCode) AND VarPageCode = -10  UPDATE u  SET u.VarPosID = v.VarPosID  FROM z_UserVars u, z_Vars v  WHERE u.VarName = v.VarName AND u.UserCode = @UserCode  
GO
