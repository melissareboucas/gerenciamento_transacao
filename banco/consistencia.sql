DECLARE @NumeroQuarto int;
DECLARE @DataCheckin DATE;
DECLARE @DataCheckout DATE;
DECLARE @UltimaReserva int;
DECLARE @ClienteID int;
DECLARE @ValorQuarto decimal(10,2);

SET @NumeroQuarto = 3;
SET @DataCheckin = '2023-11-18';
SET @DataCheckout = '2023-11-15';
SET @ClienteID = 1;

BEGIN TRANSACTION;

IF NOT EXISTS (
	SELECT ReservaID FROM Reservas 
	WHERE QuartoID = @NumeroQuarto
	AND DataCheckin <= @DataCheckout
	AND DataCheckout >= @DataCheckin)

	BEGIN
	
	INSERT INTO Reservas (ClienteID, QuartoID, DataCheckin, DataCheckout, PagamentoConfirmado)
	VALUES (@ClienteID, @NumeroQuarto, @DataCheckin, @DataCheckout, 0);

	IF (@DataCheckout < @DataCheckin)
	BEGIN
		PRINT 'Seu checkin não pode ser após o checkout';
		ROLLBACK;
	END

	ELSE
	BEGIN
		SET @UltimaReserva = SCOPE_IDENTITY();
		SET @ValorQuarto = (select Preco from Quartos where QuartoID = @NumeroQuarto);

		INSERT INTO TransacoesDePagamento (ReservaID, Valor, DataTransacao)
		VALUES (@UltimaReserva, @ValorQuarto, GETDATE());

		UPDATE Reservas SET PagamentoConfirmado = 1
		WHERE ReservaID = @UltimaReserva;
	
		COMMIT;
	END

	
END

ELSE
BEGIN
	PRINT 'Quarto não está disponível para a data selecionada';
	ROLLBACK;

END;
