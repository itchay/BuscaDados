unit uDMConsultaCNPJ;

interface

uses
  System.SysUtils, System.Classes, REST.Types, REST.Response.Adapter,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.JSon;

type
  TPessoa = Record
    razao: String;
    fantasia: String;
    logradouro: String;
    numero: String;
    bairro: string;
    municipio: string;
    uf: string;
    cep: string;
    email: string;
    complemento: string;
    telefone: string;
    tipo: string;
    porte: string;
    abertura: string;
    situacao: string;
    CNAE1: string;
    CNAE2: Tstringlist;
  public
    procedure Clear;
  End;

type
  TDMConsultaCNPJ = class(TDataModule)
    RESTResponseCNPJ: TRESTResponse;
    RESTRequestCNPJ: TRESTRequest;
    RESTClientCNPJ: TRESTClient;
    RESTResponseDataCNPJ: TRESTResponseDataSetAdapter;
  private
    { Private declarations }
  public
    Pessoa: TPessoa;
    { Public declarations }
    procedure BuscaCNPJ(CNPJ: String);
  end;

var
  DMConsultaCNPJ: TDMConsultaCNPJ;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TDMConsultaCNPJ.BuscaCNPJ(CNPJ: String);
var
  jsonObject, jo: TJsonObject;
  ja: TJSONArray;
  jv: TJSONValue;
  auxstring: string;
  i: integer;
begin
  RESTRequestCNPJ.Resource := CNPJ;
  RESTRequestCNPJ.Execute;
  jsonObject := TJsonObject.ParseJSONValue(RESTResponseCNPJ.Content)
    as TJsonObject;
  auxstring := jsonObject.ToString;
  Pessoa.razao := jsonObject.GetValue('nome').Value;
  Pessoa.fantasia := jsonObject.GetValue('fantasia').Value;
  Pessoa.logradouro := jsonObject.GetValue('logradouro').Value;
  Pessoa.numero := jsonObject.GetValue('numero').Value;
  Pessoa.bairro := jsonObject.GetValue('bairro').Value;
  Pessoa.municipio := jsonObject.GetValue('municipio').Value;
  Pessoa.uf := jsonObject.GetValue('uf').Value;
  Pessoa.cep := jsonObject.GetValue('cep').Value;
  Pessoa.email := jsonObject.GetValue('email').Value;
  Pessoa.complemento := jsonObject.GetValue('complemento').Value;
  Pessoa.telefone := jsonObject.GetValue('telefone').Value;
  Pessoa.tipo := jsonObject.GetValue('telefone').Value;
  Pessoa.porte := jsonObject.GetValue('porte').Value;
  Pessoa.abertura := jsonObject.GetValue('abertura').Value;
  Pessoa.situacao := jsonObject.GetValue('situacao').Value;

  //navega por array json
  jv := jsonObject.Get('atividade_principal').jsonValue;
  ja := jv as TJSONArray;
  for i := 0 to ja.Size - 1 do
  begin
    jo := (ja.Get(i) as TJSONObject);
    jv := jo.Get(0).JsonValue;
    Pessoa.CNAE1 := jv.Value;
  end;

  //navega por array json
  jv := jsonObject.Get('atividades_secundarias').jsonValue;
  Pessoa.CNAE2 := TStringList.Create();
  ja := jv as TJSONArray;
  for i := 0 to ja.Size - 1 do
  begin
    jo := (ja.Get(i) as TJSONObject);
    jv := jo.Get(0).JsonValue;
    Pessoa.CNAE2.Add(jv.Value);
  end;

end;

procedure TPessoa.Clear;
begin
  razao := '';
  fantasia := '';
  logradouro := '';
  numero := '';
  bairro := '';
  municipio := '';
  uf := '';
  cep := '';
  email := '';
  complemento := '';
end;

end.
