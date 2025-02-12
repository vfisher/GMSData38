INSERT dbo.r_Taxes(TaxTypeID, TaxName, TaxDesc, TaxID, Notes) VALUES (0, 'Облагается НДС по указанной ставке', 'Группа А', 0, NULL);
INSERT dbo.r_Taxes(TaxTypeID, TaxName, TaxDesc, TaxID, Notes) VALUES (1, 'Облагается НДС по ставке 0%', 'Группа Б', 1, NULL);
INSERT dbo.r_Taxes(TaxTypeID, TaxName, TaxDesc, TaxID, Notes) VALUES (2, 'Не облагается НДС', 'Группа E', NULL, NULL);
INSERT dbo.r_Taxes(TaxTypeID, TaxName, TaxDesc, TaxID, Notes) VALUES (3, 'Не является объектом НДС', NULL, NULL, NULL);
