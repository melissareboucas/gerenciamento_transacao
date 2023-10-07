BEGIN TRANSACTION;

INSERT INTO Reservas
VALUES (2, 2, 2, '2023-10-12', '2023-10-15', 0);

BEGIN TRY

	EXEC simulandoErroPagamento;

END TRY
BEGIN CATCH

	PRINT ERROR_MESSAGE();

	ROLLBACK;
	PRINT 'Reserva cancelada por falta de pagamento';
END CATCH;