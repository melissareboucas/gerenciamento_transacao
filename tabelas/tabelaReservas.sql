CREATE TABLE Reservas (
    ReservaID INT PRIMARY KEY,
    ClienteID INT,
    QuartoID INT,
    DataInicio DATE,
    DataTermino DATE,
    PagamentoConfirmado BIT,
	FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID),
	FOREIGN KEY (QuartoID) REFERENCES Quartos(QuartoID),
	CONSTRAINT Check_DataTerminoPosteriorDataInicio CHECK (DataTermino > DataInicio)
);
