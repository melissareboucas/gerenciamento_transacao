# Gerenciamento de Transações 

Projeto da discipina de Banco de Dados II - Uni7

## Sumário

- [Introdução](#introdução)
- [Pré-requisitos](#pré-requisitos)
- [Conceitos](#conceitos)
- [Aplicações](#aplicações)
- [Exemplos Práticos](#exemplos-práticos)
- [Contribuição](#contribuição)
- [Referências](#referências)

## Introdução

Neste projeto abordaremos o tema Gerenciamento de Transações em um banco de dados. O objetivo é ter um estudo de caso onde podemos mostrar alguns conceitos fundamentais, aplicações práticas e exemplo de implementações.

## Pré-requisitos

- SQL Server Management Studio;
- Conhecimentos básicos de linguagem SQL.

## Conceitos

Antes de mostrar aplicações de onde o gerenciamento de transações pode ser usado e exemplos de código em sql, é importante abordar os conceitos fundamentais relacionados ao Gerenciamento de Transações.

### Transações

Transações são operações executadas sobre os dados do banco de dados que devem ser vistas pelo usuário do sistema como uma única unidade de processamento. Elas incluem:

- Inserções
- Atualizações
- Exclusões
- Consultas

### Propriedades Fundamentais de uma Transação (ACID)

#### Atomicidade

A propriedade de atomicidade garante que uma transação seja tratada como uma unidade indivisível de trabalho. Isso significa que todas as operações dentro da transação são realizadas com sucesso ou nenhuma delas é realizada. 

Assegurar a Atomicidade de uma transação e responsabilidade do SGBD, mas especificamente dos componentes de Gerenciamento de Transações e de Recuperação de falhas.

#### Consistência

A propriedade de consistência de que uma transação leva o banco de dados de um estado válido para outro. Isso implica que as operações realizadas em uma transação não violam as regras e restrições definidas no esquema do banco de dados.

Assegurar a Consistência de uma transação e responsabilidade do progamador.

#### Isolamento

Uma transação é invisível para outras transação até que a transação seja concluída. Isso evita que transações concorrentes acessem ou modifiquem os mesmos dados simultaneamente.

Assegurar o isolamento é responsabilidade do Controle de Concorrência.

#### Durabilidade

Uma transação persiste no banco de dados, mesmo em caso de falha do sistema. Uma vez que uma transação seja confirmada (commit), suas alterações são armazenadas permanentemente no banco de dados, garantindo que os dados não sejam perdidos, mesmo em cenários de interrupções ou reinicializações.

Assegurar a durabilidade é responsabilidade do componente do SGBD chamado de Recuperador de Falhas.

## Aplicações

Explicar aplicação do banco nos celulares

## Exemplos Práticos

Aqui estão alguns exemplos de código SQL para demonstrar a funcionalidade de gerenciamento de transações:

#### Exemplo 1: Propriedade da atomicidade

```sql
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

```

#### Exemplo 2: Propriedade da consistência

```sql
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

```

#### Exemplo 3: Propriedade do isolamento

```sql
-- Primeira janela
DECLARE @NumeroQuarto int;
DECLARE @DataCheckin DATE;
DECLARE @DataCheckout DATE;
DECLARE @UltimaReserva int;
DECLARE @ClienteID int;
DECLARE @ValorQuarto decimal(10,2);

SET @NumeroQuarto = 2;
SET @DataCheckin = '2021-10-15';
SET @DataCheckout = '2021-10-25';
SET @ClienteID = 1;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

BEGIN TRANSACTION;

IF NOT EXISTS (
	SELECT ReservaID FROM Reservas 
	WHERE QuartoID = @NumeroQuarto
	AND DataCheckin <= @DataCheckout
	AND DataCheckout >= @DataCheckin)

	BEGIN


	INSERT INTO Reservas (ClienteID, QuartoID, DataCheckin, DataCheckout, PagamentoConfirmado)
	VALUES (@ClienteID, @NumeroQuarto, @DataCheckin, @DataCheckout, 0);

	WAITFOR DELAY '00:00:05';
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
	END;
END

ELSE
BEGIN
	PRINT 'Quarto não está disponível para a data selecionada';
	ROLLBACK;

END;

--Segunda Janela
DECLARE @NumeroQuarto int;
DECLARE @DataCheckin DATE;
DECLARE @DataCheckout DATE;
DECLARE @UltimaReserva int;
DECLARE @ClienteID int;
DECLARE @ValorQuarto decimal(10,2);

SET @NumeroQuarto = 2;
SET @DataCheckin = '2021-10-15';
SET @DataCheckout = '2021-10-25';
SET @ClienteID = 2;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

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
	END;
END

ELSE
BEGIN
	PRINT 'Quarto não está disponível para a data selecionada';
	ROLLBACK;

END;


```


## Contribuição

Esse projeto foi realizado por:
- [André Jonas](https://github.com/Andrejmrocha)
- [Andreia Salles](https://github.com/andreiiasalles)
- [Lucas Muniz](https://github.com/lucasMunizt)
- [Melissa Viana](https://github.com/melissareboucas)

## Referências

- [Capítulo1 - Gerenciamento de Transações.md](https://github.com/aasouzaconsult/BDII/blob/main/Apostila/Cap%C3%ADtulo1%20-%20Gerenciamento%20de%20Transa%C3%A7%C3%B5es.md)
- (Pegar com Lucas)
