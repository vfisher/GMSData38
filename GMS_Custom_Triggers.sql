SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[GMSCheck_IU] 
  ON [dbo].[b_TRec]
  AFTER INSERT, UPDATE
AS
BEGIN
  SET NOCOUNT ON

  DECLARE
    @ChID bigint,
    @CompID int,
    @SrcDocDate smalldatetime,
    @SrcDocID varchar(50),
    @ABegin smalldatetime,
    @AEnd smalldatetime,
    @err varchar(250)

  SELECT @ChID = ChID, @CompID = CompID, @SrcDocDate = SrcDocDate, @SrcDocID = SrcDocID FROM inserted

  /* Проверка на дублирование входящего номера */
  SELECT @ABegin = dbo.zf_GetMonthFirstDay(@SrcDocDate)
  SELECT @AEnd = dbo.zf_GetMonthLastDay(@SrcDocDate)
  IF EXISTS(SELECT TOP 1 1 FROM b_TRec WHERE ChID <> @ChID AND CompID = @CompID AND SrcDocID = @SrcDocID AND (SrcDocDate between @ABegin and @AEnd))
    BEGIN
      SELECT
        @err = 'Налоговая накладная от текущего предприятия с номером ' + @SrcDocID +
        ' в период с ' + dbo.zf_DateToStr(@ABegin) + ' по ' + dbo.zf_DateToStr(@AEnd) + ' уже зарегистрирована.'
      RAISERROR (@err, 18, 1)
      ROLLBACK TRAN
      RETURN
    END
END
GO


CREATE TRIGGER [dbo].[GMSOpenAge_UD] ON [dbo].[z_OpenAge]
FOR DELETE, UPDATE AS
  IF @@ROWCOUNT = 0 RETURN
  DECLARE @ChDate smalldatetime
  SELECT @ChDate = GETDATE()
  SET NOCOUNT ON
  DELETE h FROM z_OpenAgeH h JOIN DELETED d ON h.OurID = d.OurID AND h.ChDate = @ChDate
  INSERT INTO z_OpenAgeH (
    OurID, BDate, EDate, OpenAgeBType, OpenAgeEType, OpenAgeBQty, OpenAgeEQty, ChUserID, ChDate )
  SELECT
    OurID, BDate, EDate, OpenAgeBType, OpenAgeEType, OpenAgeBQty, OpenAgeEQty, ChUserID, @ChDate
  FROM DELETED
GO


CREATE TRIGGER [dbo].[GMSUserOpenAge_UD] ON [dbo].[z_UserOpenAge]
FOR DELETE, UPDATE AS
  IF @@ROWCOUNT = 0 RETURN
  DECLARE
    @ChDate smalldatetime,
    @UserCode int
  SELECT
    @ChDate = GETDATE(),
    @UserCode = dbo.zf_GetUserCode()
  SET NOCOUNT ON
  DELETE h FROM z_UserOpenAgeH h JOIN DELETED d ON h.OurID = d.OurID AND h.UserID = d.UserID AND h.ChDate = @ChDate
  INSERT INTO z_UserOpenAgeH (
    OurID, UserID, UseOpenAge, BDate, EDate, OpenAgeBType, OpenAgeEType, OpenAgeBQty, OpenAgeEQty, ChUserID, ChDate )
  SELECT
    OurID, UserID, UseOpenAge, BDate, EDate, OpenAgeBType, OpenAgeEType, OpenAgeBQty, OpenAgeEQty, ChUserID, @ChDate
  FROM DELETED
GO


CREATE TRIGGER [dbo].[T_Upd_c_CompCurr] 
ON [dbo].[c_CompCurr] 
FOR UPDATE 
AS 
BEGIN 
  DECLARE @RCount int  
  SET @RCount = @@RowCount  
  SET NOCOUNT ON  
  IF @RCount > 1 AND (UPDATE(NewAccountAC) OR UPDATE(NewCompAccountAC)) 
    BEGIN  
      RAISERROR('Пакетное обновление, изменяющее поля ключа невозможно.', 16, 1)  
      ROLLBACK TRANSACTION  
      RETURN  
    END 
       
    IF UPDATE(NewCompAccountAC)    
      UPDATE oc 
      SET    oc.OldNewCompAccountAC = CASE  
                                    WHEN i.NewCompAccountAC LIKE '[a-Z][a-Z]%' AND d.NewCompAccountAC NOT LIKE '[a-Z][a-Z]%' THEN d.NewCompAccountAC 
                                    ELSE i.OldNewCompAccountAC 
                               END 
      FROM   DELETED d 
            ,c_CompCurr oc 
             INNER JOIN INSERTED i 
                  ON  (oc.OurID=i.OurID AND oc.NewCompAccountAC=i.NewCompAccountAC) 
    IF UPDATE(NewAccountAC)    
      UPDATE oc 
      SET    oc.OldNewAccountAC = CASE  
                                    WHEN i.NewAccountAC LIKE '[a-Z][a-Z]%' AND d.NewAccountAC NOT LIKE '[a-Z][a-Z]%' THEN d.NewAccountAC 
                                    ELSE i.OldNewAccountAC 
                               END 
      FROM   DELETED d 
            ,c_CompCurr oc 
             INNER JOIN INSERTED i 
                  ON  (oc.OurID=i.OurID AND oc.NewAccountAC=i.NewAccountAC) 
END
GO


CREATE TRIGGER [dbo].[T_Upd_r_CompsAC] 
ON [dbo].[r_CompsAC] 
FOR UPDATE 
AS 
BEGIN 
  DECLARE @RCount int  
  SET @RCount = @@RowCount  
  SET NOCOUNT ON  
  IF @RCount > 1 AND UPDATE(CompAccountAC) 
    BEGIN  
      RAISERROR('Пакетное обновление, изменяющее поля ключа невозможно.', 16, 1)  
      ROLLBACK TRANSACTION  
      RETURN  
    END 
       
    IF UPDATE(CompAccountAC)    
      UPDATE oc 
      SET    oc.OldCompAccountAC = CASE  
                                    WHEN i.CompAccountAC LIKE '[a-Z][a-Z]%' AND d.CompAccountAC NOT LIKE '[a-Z][a-Z]%' THEN d.CompAccountAC 
                                    ELSE i.OldCompAccountAC 
                               END 
      FROM   DELETED d 
            ,r_CompsAC oc 
             INNER JOIN INSERTED i 
                  ON  (oc.CompID=i.CompID AND oc.CompAccountAC=i.CompAccountAC) 
END
GO


CREATE TRIGGER [dbo].[T_Upd_r_CompsCC] 
ON [dbo].[r_CompsCC] 
FOR UPDATE 
AS 
BEGIN 
  DECLARE @RCount int  
  SET @RCount = @@RowCount  
  SET NOCOUNT ON  
  IF @RCount > 1 AND UPDATE(CompAccountCC) 
    BEGIN  
      RAISERROR('Пакетное обновление, изменяющее поля ключа невозможно.', 16, 1)  
      ROLLBACK TRANSACTION  
      RETURN  
    END 
       
    IF UPDATE(CompAccountCC)    
      UPDATE oc 
      SET    oc.OldCompAccountCC = CASE  
                                    WHEN i.CompAccountCC LIKE '[a-Z][a-Z]%' AND d.CompAccountCC NOT LIKE '[a-Z][a-Z]%' THEN d.CompAccountCC 
                                    ELSE i.OldCompAccountCC 
                               END 
      FROM   DELETED d 
            ,r_CompsCC oc 
             INNER JOIN INSERTED i 
                  ON  (oc.CompID=i.CompID AND oc.CompAccountCC=i.CompAccountCC) 
END
GO



CREATE TRIGGER [dbo].[T_Upd_r_OursAC] 
ON [dbo].[r_OursAC] 
FOR UPDATE 
AS 
BEGIN 
  DECLARE @RCount int  
  SET @RCount = @@RowCount  
  SET NOCOUNT ON  
  IF @RCount > 1 AND UPDATE(AccountAC) 
    BEGIN  
      RAISERROR('Пакетное обновление, изменяющее поля ключа невозможно.', 16, 1)  
      ROLLBACK TRANSACTION  
      RETURN  
    END 
       
    IF UPDATE(AccountAC)    
      UPDATE oc 
      SET    oc.OldAccountAC = CASE  
                                    WHEN i.AccountAC LIKE '[a-Z][a-Z]%' AND d.AccountAC NOT LIKE '[a-Z][a-Z]%' THEN d.AccountAC 
                                    ELSE i.OldAccountAC 
                               END 
      FROM   DELETED d 
            ,r_OursAC oc 
             INNER JOIN INSERTED i 
                  ON  (oc.OurID=i.OurID AND oc.AccountAC=i.AccountAC) 
END
GO


CREATE TRIGGER [dbo].[T_Upd_r_OursCC] 
ON [dbo].[r_OursCC] 
FOR UPDATE 
AS 
BEGIN 
  DECLARE @RCount int  
  SET @RCount = @@RowCount  
  SET NOCOUNT ON  
  IF @RCount > 1 AND UPDATE(AccountCC) 
    BEGIN  
      RAISERROR('Пакетное обновление, изменяющее поля ключа невозможно.', 16, 1)  
      ROLLBACK TRANSACTION  
      RETURN  
    END 
       
    IF UPDATE(AccountCC)    
      UPDATE oc 
      SET    oc.OldAccountCC = CASE  
                                    WHEN i.AccountCC LIKE '[a-Z][a-Z]%' AND d.AccountCC NOT LIKE '[a-Z][a-Z]%' THEN d.AccountCC 
                                    ELSE i.OldAccountCC 
                               END 
      FROM   DELETED d 
            ,r_OursCC oc 
             INNER JOIN INSERTED i 
                  ON  (oc.OurID=i.OurID AND oc.AccountCC=i.AccountCC) 
END
GO


CREATE TRIGGER [dbo].[TGMS_UpdCheck_t_Spec] ON [dbo].[t_Spec]
/* Обеспечивает автоматическое заполнение параметров Калькуляционной карты */
AFTER INSERT, UPDATE
AS
BEGIN  
  IF UPDATE(ProdID)
  BEGIN
    UPDATE m 
    SET m.UM = p.UM 
    FROM t_Spec m WITH (NOLOCK)  
    INNER JOIN inserted i ON m.ChID = i.ChID  
    INNER JOIN r_Prods p WITH (NOLOCK)  
    ON i.ProdID = p.ProdID
  END

  INSERT INTO t_SpecParams (ChID, LayUM, LayQty, ProdDate, StockID)
  SELECT
    i.ChID, p.UM, 1, i.DocDate, dbo.zf_UserVar('t_StockID')  
  FROM inserted i
  INNER JOIN r_Prods p WITH (NOLOCK)
  ON i.ProdID = p.ProdID
  LEFT JOIN t_SpecParams sp WITH (NOLOCK)  
  ON i.ChID = sp.ChID
  WHERE sp.ChID IS NULL

  IF UPDATE(ProdID) AND NOT UPDATE(ChID)
  UPDATE sp
  SET
    sp.LayUM = m.UM  
  FROM t_Spec m WITH (NOLOCK)
  INNER JOIN deleted d ON m.ChID = d.ChID 
  INNER JOIN t_SpecParams sp WITH (NOLOCK) ON m.ChID = sp.ChID AND d.UM = sp.LayUM

  IF UPDATE(OutUM) AND NOT UPDATE(ChID)
  UPDATE sp
  SET
    sp.LayUM = m.OutUM  
  FROM t_Spec m WITH (NOLOCK)
  INNER JOIN deleted d ON m.ChID = d.ChID
  INNER JOIN t_SpecParams sp WITH (NOLOCK) ON m.ChID = sp.ChID AND d.OutUM = sp.LayUM
END
GO


SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGMSRel1_Ins_r_DeviceTypes] ON [dbo].[r_DeviceTypes]
FOR INSERT AS
/* r_DeviceTypes - Справочник типов устройств - INSERT TRIGGER */
BEGIN
  SET NOCOUNT ON

  RAISERROR ('Изменение системного справочника запрещено', 18, 1)
  ROLLBACK TRAN

END
GO


CREATE TRIGGER [dbo].[TGMSRel2_Upd_r_DeviceTypes] ON [dbo].[r_DeviceTypes]
FOR UPDATE AS
/* r_DeviceTypes - Справочник типов устройств - UPDATE TRIGGER */
BEGIN
  SET NOCOUNT ON

  RAISERROR ('Изменение системного справочника запрещено', 18, 1)
  ROLLBACK TRAN

END
GO

CREATE TRIGGER [dbo].[TGMSRel3_Del_r_DeviceTypes] ON [dbo].[r_DeviceTypes]
FOR DELETE AS
/* r_DeviceTypes - Справочник типов устройств - DELETE TRIGGER */
BEGIN
  SET NOCOUNT ON
  ROLLBACK TRAN
  RAISERROR ('Изменение системного справочника запрещено', 18, 1)

END
GO