unit UnClasseCEP;

interface

uses UnClasseTipoLogradouro, UnClasseCidade, SysUtils;

type

  TCEP = class(TObject)
  private
    iNumero: String;

  public

    property Numero: String
      read iNumero
      write iNumero;

    function formatar(): String;

    constructor Create;
    destructor Destroy; Reintroduce;

  protected

  end;

implementation

constructor TCEP.Create;
begin
  inherited;
  Self.iNumero:= '';
end;

destructor TCEP.Destroy;
begin
  inherited;
end;

function TCEP.formatar: String;
var
  aux1, aux2: String;
begin
  if Self.Numero <> '' then
  begin
    aux1:= Copy(Self.iNumero, 01, 05);
    aux2:= Copy(Self.iNumero, 06, 03);
    Result:= (aux1 + '-' + aux2);
  end
  else
    Result:= '';
end;

end.

