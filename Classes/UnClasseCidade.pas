unit UnClasseCidade;

interface

uses
  SysUtils;

type

  TCidade = class(TObject)
  private
    iCodigo: Integer;
    sUF: string;
    sNome: String;

  public
    property Codigo: Integer
      read iCodigo
      write iCodigo;
    property Nome: String
      read sNome
      write sNome;
    property UF: string
      read sUF
      write sUF;

    constructor Create;
    destructor Destroy; Reintroduce;

  protected

  end;

implementation

uses SqlExpr, DB;

{ TCidade }

constructor TCidade.Create;
begin
  inherited;
  Self.iCodigo:= 0;
  Self.sNome:= '';
  Self.sUF:= '';
end;

destructor TCidade.Destroy;
begin
  inherited;
end;

end.

