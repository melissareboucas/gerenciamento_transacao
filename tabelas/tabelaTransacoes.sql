CREATE TABLE TransacoesDePagamento (
    TransacaoID INT PRIMARY KEY,
    ReservaID INT,
    Valor DECIMAL(10, 2),
    DataTransacao DATETIME,
    FOREIGN KEY (ReservaID) REFERENCES Reservas(ReservaID)
);
