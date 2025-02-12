SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[t_SaleSaveMods](@DocCode int, @ChId bigint, @SrcPosID int, @ModCode int, @ModQty int)
as
begin
  If @DocCode <> 1011
    return

  DECLARE @IsProd bit

  SELECT @IsProd = IsProd
  FROM r_Mods m WITH (NOLOCK)
  WHERE ModCode = @ModCode

  if @ModQty <= 0
    delete from t_SaleTempM
	where ChID = @ChId and SrcPosID = @SrcPosID and ModCode = @ModCode
  else
    begin
	  if not exists (select 1 from t_SaleTempM where ChID = @ChId and SrcPosID = @SrcPosID and ModCode = @ModCode)
        insert into t_SaleTempM(ChID, SrcPosID, ModCode, ModQty, IsProd, SaleSrcPosID)
        values(@ChId, @SrcPosID, @ModCode, @ModQty, @IsProd, @SrcPosID)
      else
        update t_SaleTempM
		set ModQty = @ModQty
        where ChID = @ChId and SrcPosID = @SrcPosID and ModCode = @ModCode
    end

/*  If @IsProd = 1 */
/*    не реализовано */

end
GO