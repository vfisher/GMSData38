SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[t_SaleOnCustomBonusFrameChange](@DocCode int, @ChID bigint, @SumMax numeric(21,9), @Sum numeric(21,9), @Value numeric(21,9) Output)
as
/* Возвращает сумму для кастомной ФО бонусами */
begin
  select @Value = @Sum 
end
GO