DECLARE @NumeroQuarto int;
DECLARE @DataCheckin DATE;
DECLARE @DataCheckout DATE;
DECLARE @UltimaReserva int;
DECLARE @ClienteID int;
DECLARE @ValorQuarto decimal(10,2);

SET @NumeroQuarto = 1;
SET @DataCheckin = '2021-10-15';
SET @DataCheckout = '2021-10-25';
SET @ClienteID = 3;

INSERT INTO Reservas (ClienteID, QuartoID, DataCheckin, DataCheckout, PagamentoConfirmado)
VALUES (@ClienteID, @NumeroQuarto, @DataCheckin, @DataCheckout, 0);

SET @UltimaReserva = SCOPE_IDENTITY();
SET @ValorQuarto = (select Preco from Quartos where QuartoID = @NumeroQuarto);
PRINT @ValorQuarto;
INSERT INTO TransacoesDePagamento (ReservaID, Valor, DataTransacao)
VALUES (@UltimaReserva, @ValorQuarto, GETDATE());

UPDATE Reservas SET PagamentoConfirmado = 1
WHERE ReservaID = @UltimaReserva;