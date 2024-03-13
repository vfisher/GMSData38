SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[z_DocOpenList](@appCodeStr varchar(200)) AS
/* Возвращает список документов */
BEGIN
  DECLARE @out table (DocCode int, DocName varchar(250), DocCatCode int)
  DECLARE @UserCode int, @UserRoleCode int, @IsAdmin bit

  SELECT @UserCode = dbo.zf_GetUserCode()
  SELECT @IsAdmin = Admin FROM r_Users WHERE UserID = @UserCode 
  SELECT @UserRoleCode = RoleCode FROM z_RoleUsers WHERE UserCode = @UserCode

  IF @IsAdmin = 0 
    BEGIN
      IF @UserRoleCode IS NOT NULL 
     INSERT INTO @out
     SELECT m.DocCode, m.DocName, m.DocCatCode 
     FROM z_Docs m
       JOIN z_RoleDocs d ON m.DocCode = d.DocCode
     WHERE d.RoleCode = @UserRoleCode AND m.FormClass <> '' AND d.DocCode IN (SELECT DocCode FROM z_AppDocs WHERE AppCode IN (100, 101, 102, 103, 104, 105, @appCodeStr))

      INSERT INTO @out
      SELECT m.DocCode, m.DocName, m.DocCatCode 
      FROM z_Docs m
     JOIN z_UserDocs d ON m.DocCode = d.DocCode
      WHERE d.UserCode = @UserCode AND m.FormClass <> '' AND 
        d.DocCode IN (SELECT DocCode FROM z_AppDocs WHERE AppCode IN (100, 101, 102, 103, 104, 105, @appCodeStr)) AND
        d.DocCode NOT IN (SELECT DocCode FROM @out)
    END

  IF NOT EXISTS (SELECT TOP 1 1 FROM @out)
    SELECT DocCode, DocName, DocCatCode FROM z_Docs WHERE FormClass <> ''
    AND DocCode IN (SELECT DocCode FROM z_AppDocs WHERE AppCode IN (100, 101, 102, 103, 104, 105, @appCodeStr))
    ORDER BY DocName
  ELSE 
   SELECT * FROM @out ORDER BY DocName
END
GO
