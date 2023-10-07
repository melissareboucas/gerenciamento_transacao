CREATE PROCEDURE simulandoErroPagamento
AS
BEGIN
	THROW 51000, 'Erro na confirmação de pagamento!',1;
END;

-- o 51000 significa que podemos definir um erro personalizado