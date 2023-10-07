CREATE TABLE Reservas (
    ReservaID INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT,
    QuartoID INT,
    DataCheckin DATE,
    DataCheckout DATE,
    PagamentoConfirmado BIT,
	FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID),
	FOREIGN KEY (QuartoID) REFERENCES Quartos(QuartoID),
);
