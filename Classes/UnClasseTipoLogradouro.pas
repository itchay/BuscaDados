unit UnClasseTipoLogradouro;

interface

type

  TTipoLogradouro = class(TObject)
  private
    iCodigo: Integer;
    sNome: String;
    sAbreviatura: String;

    procedure setCodigo(lCodigo: Integer);
    procedure setNome(lNome: String);
    procedure setAbreviatura(lAbreviatura: String);

  public
    property Codigo: Integer
      read iCodigo
      write setCodigo;
    property Nome: String
      read sNome
      write setNome;
    property Abreviatura: String
      read sAbreviatura
      write setAbreviatura;

    constructor Create;
    destructor Destroy; Reintroduce;

  protected

  end;

implementation

constructor TTipoLogradouro.Create;
begin
  inherited;
  Self.iCodigo:= 0;
  Self.sNome:= '';
end;

destructor TTipoLogradouro.Destroy;
begin
  inherited;
end;

procedure TTipoLogradouro.setCodigo(lCodigo: Integer);
begin
  Self.iCodigo:= lCodigo;
end;

procedure TTipoLogradouro.setNome(lNome: String);
begin
  Self.sNome:= lNome;
end;

procedure TTipoLogradouro.setAbreviatura(lAbreviatura: String);
begin
  Self.sAbreviatura:= lAbreviatura;
end;

end.

