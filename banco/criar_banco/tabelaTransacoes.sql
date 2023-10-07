CREATE TABLE TransacoesDePagamento (
    TransacaoID INT IDENTITY(1,1) PRIMARY KEY,
    ReservaID INT,
    Valor DECIMAL(10, 2),
    DataTransacao DATETIME,
    FOREIGN KEY (ReservaID) REFERENCES Reservas(ReservaID),
	CONSTRAINT CK_Valor CHECK (ISNUMERIC(Valor) = 1) 
);
