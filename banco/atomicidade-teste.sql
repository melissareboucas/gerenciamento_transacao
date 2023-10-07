DECLARE @NumeroQuarto int;
DECLARE @DataCheckin DATE;
DECLARE @DataCheckout DATE;
DECLARE @UltimaReserva int;
DECLARE @ClienteID int;
DECLARE @ValorQuarto decimal(10,2);

SET @NumeroQuarto = 3;
SET @DataCheckin = '2023-10-15';
SET @DataCheckout = '2023-10-25';
SET @ClienteID = 2;

BEGIN TRANSACTION;

BEGIN TRY

	INSERT INTO Reservas (ClienteID, QuartoID, DataCheckin, DataCheckout, PagamentoConfirmado)
	VALUES (@ClienteID, @NumeroQuarto, @DataCheckin, @DataCheckout, 0);
		
	-- Agora deveriamos realizar o pagamento, mas vamos simular um erro no pagamento com valor 'abc'
	SET @UltimaReserva = SCOPE_IDENTITY();
	SET @ValorQuarto = (select Preco from Quartos where QuartoID = @NumeroQuarto);

	INSERT INTO TransacoesDePagamento (ReservaID, Valor, DataTransacao)
	VALUES (@UltimaReserva, 'abc', GETDATE());

	UPDATE Reservas SET PagamentoConfirmado = 1
	WHERE ReservaID = @UltimaReserva;
	
	COMMIT;
	
END TRY
	
BEGIN CATCH

	PRINT ERROR_MESSAGE();
	PRINT 'Reserva cancelada por falta de pagamento';
	ROLLBACK;

END CATCH;