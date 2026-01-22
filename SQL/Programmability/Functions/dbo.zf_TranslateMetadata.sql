SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[zf_TranslateMetadata](@MsgID int, @TypeID tinyint)
returns nvarchar(max)
as
begin
  /* TypeID: 0:Text 1:FieldDesc 2:DocName 3:DsName 4:PageName 5:ToolName 6:RepToolName 7:AppName 8:VarPageName 9:PageName (ToolCode*100+PageIndex) 10:TableDesc */
  declare @lng varchar(20), @s nvarchar(max)
  set @lng = Cast(SESSION_CONTEXT(N'language') as varchar(20))

  if @lng = 'Russian' 
    select @s = COALESCE(RU, cast(MsgID as varchar(10))) from z_Translations with (nolock) where MsgID = @MsgID and TypeID = @TypeID
  else if @lng = 'Ukrainian' or @lng = '' or @lng is null
    select @s = COALESCE(UK, RU, cast(MsgID as varchar(10))) from z_Translations with (nolock) where MsgID = @MsgID and TypeID = @TypeID

  If @s is NULL
    BEGIN
      IF @TypeID = 1
        SELECT @s = FieldDesc FROM z_fieldsrep with (nolock) WHERE FieldID = @MsgID
      ELSE IF @TypeID = 2
        SELECT @s = DocName FROM z_docs with (nolock) WHERE DocCode = @MsgID
      ELSE IF @TypeID = 3
        SELECT @s = DsName FROM z_datasets with (nolock) WHERE DSCode = @MsgID
      ELSE IF @TypeID = 4
        SELECT @s = PageName FROM z_datasets with (nolock) WHERE DSCode = @MsgID      
      ELSE IF @TypeID = 5
        SELECT @s = ToolName FROM z_Tools with (nolock) WHERE ToolCode = @MsgID      
      ELSE IF @TypeID = 6
        SELECT @s = RepToolName FROM z_toolrep with (nolock) WHERE RepToolCode = @MsgID      
      ELSE IF @TypeID = 7
        SELECT @s = AppName FROM z_apps with (nolock) WHERE AppCode = @MsgID      
      ELSE IF @TypeID = 8
        SELECT @s = VarPageName FROM z_VarPages with (nolock) WHERE VarPageCode = @MsgID      
      ELSE IF @TypeID = 9
        SELECT @s = PageName FROM z_ToolPages with (nolock) WHERE (ToolCode*100+PageIndex) = @MsgID      
      ELSE IF @TypeID = 10
        SELECT @s = TableDesc FROM z_Tables with (nolock) WHERE TableCode = @MsgID
    END

  IF @s is NULL
    SET @s = 'NULL. MsgID:' + cast(@MsgID as varchar(10)) + ' TypeID:' +  cast(@TypeID as varchar(10))
  
  RETURN @s
END
GO