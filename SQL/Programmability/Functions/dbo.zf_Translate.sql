SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[zf_Translate](@RUText varchar(max))
returns nvarchar(max)
as
begin
  declare @lng varchar(20), @s nvarchar(max)
  set @lng = Cast(SESSION_CONTEXT(N'language') as varchar(20))

  if @lng = 'Russian' 
    select @s = COALESCE(RU, cast(MsgID as varchar(10))) from z_Translations with (nolock) where TypeID = 0 And RU = @RUText
  else if @lng = 'Ukrainian' or @lng = '' or @lng is null
    select @s = COALESCE(UK, RU, cast(MsgID as varchar(10))) from z_Translations with (nolock) where TypeID = 0 And RU = @RUText

  If @s is NULL
    set @s = @RUText

  return @s
end
GO