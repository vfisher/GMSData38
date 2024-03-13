SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[t_GetCROperName]( 
  @OperID INT, 
  @EmpName VARCHAR(50), 
  @OperName varchar(50) OUTPUT) 
/* Возвращает имя оператора для РРО */ 
AS 
BEGIN 
	/*SELECT @OperName = 'Служащий №' + LTRIM(STR(o.EmpID)) FROM  r_Opers o WHERE o.OperID = @OperID  */
	 
	/*стандартная выборка  */
	IF @OperName IS NULL 
		SELECT @OperName = UAEmpName FROM r_Emps e, r_Opers o WHERE (e.EmpID = o.EmpID AND o.OperID = @OperID) 
	IF @OperName IS NULL 
		SELECT @OperName = EmpName FROM r_Emps m, r_Users d WHERE m.EmpID=d.EmpID AND UserName=@EmpName	 
END
GO
