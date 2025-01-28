SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[zf_TranslateMetadata](@MsgID int, @TypeID tinyint)
returns varchar(max)
as
begin
  /* TypeID: 0:Text 1:FieldDesc 2:DocName 3:DsName 4:PageName */
  declare @lng varchar(20), @s varchar(max)
  set @lng = Cast(SESSION_CONTEXT(N'language') as varchar(20))

  if @lng = 'Russian' 
    select @s = COALESCE(RU, cast(MsgID as varchar(10))) from z_Translations with (nolock) where MsgID = @MsgID and TypeID = @TypeID
  else if @lng = 'Ukrainian' or @lng = '' or @lng is null
    select @s = COALESCE(UK, RU, cast(MsgID as varchar(10))) from z_Translations with (nolock) where MsgID = @MsgID and TypeID = @TypeID

  If @s is NULL
    set @s = 'Null: ' + cast(@MsgID as varchar(10))

  return @s
end

GO
