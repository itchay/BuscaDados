unit UnClasseEndereco;

interface

uses UnClasseTipoLogradouro, UnClasseCidade, UnClasseCEP;

type

  TEndereco = class(TObject)
  private
    oTipoLogradouro: TTipoLogradouro;
    sLogradouro: String;
    sComplemento: String;
    sNumero: String;
    sBairro: String;
    oCEP: TCEP;
    oCidade: TCidade;
    sPontoDeRef: String;

  public

    property TipoLogradouro: TTipoLogradouro
      read oTipoLogradouro
      write oTipoLogradouro;
    property Logradouro: String
      read sLogradouro
      write sLogradouro;
    property Complemento: String
      read sComplemento
      write sComplemento;
    property Numero: String
      read sNumero
      write sNumero;
    property Bairro: String
      read sBairro
      write sBairro;
    property CEP: TCEP
      read oCEP
      write oCEP;
    property Cidade: TCidade
      read oCidade
      write oCidade;
    property PontoDeRef: String
      read sPontoDeRef
      write sPontoDeRef;

    constructor Create;
    destructor Destroy; Reintroduce;

  protected

  end;

implementation

{ TEndereco }

constructor TEndereco.Create;
begin
  inherited;
  Self.oTipoLogradouro:= TTipoLogradouro.Create();
  Self.sLogradouro:= '';
  Self.sComplemento:= '';
  Self.sNumero:= '';
  Self.sBairro:= '';
  Self.oCEP:= TCEP.Create();
  Self.oCidade:= TCidade.Create();
  Self.sPontoDeRef:= '';
end;

destructor TEndereco.Destroy;
begin
  inherited;
end;

end.

