BEGIN TRANSACTION;


-- simulando a inconsistencia com checkout antes do checkin
--INSERT INTO Reservas
--VALUES (1, 1, 1, '2023-10-10', '2023-10-07', 0);

-- cenário correto
--INSERT INTO Reservas
--VALUES (1, 1, 1, '2023-10-07', '2023-10-10', 0);

INSERT INTO TransacoesDePagamento
VALUES (1, 1, 100, '2023-10-06');

UPDATE Reservas SET PagamentoConfirmado = 1
WHERE ReservaID = 1;

COMMIT;

PRINT 'Pagamento confirmado, reserva concluída';