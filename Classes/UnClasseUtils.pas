unit UnClasseUtils;

interface

uses
  SysUtils, xmldoc, XMLIntf, forms, strutils;

  function retiraCaractere(caractaere: String; valor: String): String;
  function retiraFormatacaoCPFCNPJ(lCPF_CNPJ: String): String;
  function lerEntradaDoXMLNFE(localDaChaveNoXML, nomeDaChave: String): String;
  procedure alterarCertificadoDigitalXMLNFE(nomeCertificado, numSerie: String);
  function ExtrairEntreStrings(const Value, A, B: string): string;

implementation

uses SqlExpr, DB, UnClasseNFeConfig;

{  }

function ExtrairEntreStrings(const Value, A, B: string): string;
var
  aPos, bPos: Integer;
begin
  result := '';
  aPos := Pos(A, Value);
  if aPos > 0 then begin
    aPos := aPos + Length(A);
    bPos := PosEx(B, Value, aPos);
    if bPos > 0 then begin
      result := Copy(Value, aPos, bPos - aPos);
    end;
  end;
end;

function retiraCaractere(caractaere: String; valor: String): String;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(valor) do
  begin
    if valor[i] = caractaere then Result := Result
    else Result := Result + valor[i];
  end;
end;

function retiraFormatacaoCPFCNPJ(lCPF_CNPJ: String): String;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(lCPF_CNPJ) do
  begin
    if lCPF_CNPJ[i] in ['0','1','2','3','4','5','6','7','8','9'] then
      Result := Result + lCPF_CNPJ[i]
    else
      Result := Result;
  end;
end;

function lerEntradaDoXMLNFE(localDaChaveNoXML, nomeDaChave: String): String;
var
  oArquivoXML_NFE, oNFEConfig: TXMLDocument;
  oNodeNFE, oNodeChave: IXMLNode;
begin
  Result:= '';
  if FileExists(ExtractFilePath(ParamStr(0)) + 'ConfigBuscaDados.xml') then
  begin
    oArquivoXML_NFE:= TXMLDocument.Create(Application);
    oArquivoXML_NFE.Active:= True;
    oArquivoXML_NFE.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'ConfigBuscaDados.xml');

    oNFEConfig:= TXMLDocument.Create(Application);
    with oNFEConfig do
    begin
      oNodeNFE:= oArquivoXML_NFE.DocumentElement.ChildNodes.FindNode('BuscaDados');
      if oNodeNFE <> Nil then
      begin
        oNodeChave:= oNodeNFE.ChildNodes.FindNode(localDaChaveNoXML);
        if oNodeChave <> Nil then
          Result:= oNodeChave.ChildNodes[nomeDaChave].Text;
      end;
    end;
  end;
end;

procedure alterarCertificadoDigitalXMLNFE(nomeCertificado, numSerie: String);
var
  oNFeConfig: TNFEConfig;
  oArquivoXMLConfig: TXMLDocument;
  oNodeNFE, oNodeCertificadoDigital: IXMLNode;
begin
  oArquivoXMLConfig:= TXMLDocument.Create(Application);
  oArquivoXMLConfig.Active:= True;
  oArquivoXMLConfig.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'ConfigBuscaDados.xml');

  oNFeConfig := TNFEConfig.Create();
  with oNFeConfig do
  begin
    oNodeNFE:= oArquivoXMLConfig.DocumentElement.ChildNodes.FindNode('BuscaDados');
    if oNodeNFE <> Nil then
    begin
      oNodeCertificadoDigital:= oNodeNFE.ChildNodes.FindNode('CertificadoDigital');
      if oNodeCertificadoDigital <> Nil then
      begin
        CertificadoDigital.Nome.Dados := nomeCertificado;
        oNodeCertificadoDigital.ChildNodes[CertificadoDigital.Nome.Nome].Text := CertificadoDigital.Nome.Dados;
        CertificadoDigital.NumeroSerie.Dados := numSerie;
        oNodeCertificadoDigital.ChildNodes[CertificadoDigital.NumeroSerie.Nome].Text := CertificadoDigital.NumeroSerie.Dados;
      end;
    end;
  end;
  oArquivoXMLConfig.SaveToFile(ExtractFilePath(ParamStr(0)) + 'ConfigBuscaDados.xml');
end;

end.

