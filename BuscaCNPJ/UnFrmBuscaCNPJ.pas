unit UnFrmBuscaCNPJ;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ACBrBase, ACBrSocket,
  ACBrCEP, UnClasseEndereco, Vcl.ComCtrls, UnClasseVersao, ACBrConsultaCNPJ, blcksock,
  Vcl.ExtCtrls, System.Actions, Vcl.ActnList, ACBrDFe, ACBrNFe, ACBrDFeSSL, pcnConversao, pcnConversaoNFe, StrUtils;

type
  TFrmBuscaCNPJ = class(TForm)
    EdtConsulta: TEdit;
    BtnPesquisar: TButton;
    LblConsulta: TLabel;
    ProgressBar1: TProgressBar;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    EditTipo: TEdit;
    EditRazaoSocial: TEdit;
    EditAbertura: TEdit;
    EditEndereco: TEdit;
    EditNumero: TEdit;
    EditComplemento: TEdit;
    EditBairro: TEdit;
    EditCidade: TEdit;
    EditUF: TEdit;
    EditCEP: TEdit;
    EditSituacao: TEdit;
    EditFantasia: TEdit;
    ListCNAE2: TListBox;
    EditCNAE1: TEdit;
    EditEmail: TEdit;
    EditTelefone: TEdit;
    EditPorte: TEdit;
    ACBrConsultaCNPJ1: TACBrConsultaCNPJ;
    ActionList1: TActionList;
    ActFechar: TAction;
    TimerDesliga: TTimer;
    Label1: TLabel;
    EditIE: TEdit;
    Label14: TLabel;
    EditRegime: TEdit;
    ACBrNFe: TACBrNFe;
    BtnSelecionaCertificado: TButton;
    procedure BtnPesquisarClick(Sender: TObject);
    procedure ACBrCEP1BuscaEfetuada(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ActFecharExecute(Sender: TObject);
    procedure TimerDesligaTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BtnSelecionaCertificadoClick(Sender: TObject);
  private
    { Private declarations }
    procedure RetornaCNPJ;
    procedure iniciaTela(bHabilita: boolean);
    procedure pesquisaCNPJ(sConsulta: string);
    procedure pesquisaCNPJSemCaptcha(sConsulta: string);
    function ConsultaIE(aDocumento: String; aUF: String): String;

    procedure limpaTela();
    procedure limpaEdits(Owner: TWinControl);
    procedure limpaListBox(Owner: TWinControl);
    procedure configurarACBRNFe(numSerieCert, sUF: String);
  public
    { Public declarations }
    sCNPJ: string;
    oEndereco: TEndereco;
    bTimerDesliga: boolean;
  end;

const
  _ALTURA_CHEIA = 200;
  _ALTURA_REDUZIDA = 26;
  _LARGURA_REDUZIDA = 254;

var
  FrmBuscaCNPJ: TFrmBuscaCNPJ;

implementation

uses
  UnFrmConsultaCaptchaCNPJ, unClasseUtils, uDMConsultaCNPJ;

{$R *.dfm}

procedure TFrmBuscaCNPJ.ACBrCEP1BuscaEfetuada(Sender: TObject);
var
  i: integer;
begin
  {for i := 0 to ACBrCEP1.Enderecos.Count - 1 do
  begin
    EdtCEP.Text := ACBrCEP1.Enderecos[i].CEP;
    EdtLogradouro.Text := ACBrCEP1.Enderecos[i].Logradouro;
    EdtCidade.Text := ACBrCEP1.Enderecos[i].Municipio;
    EdtUF.Text := ACBrCEP1.Enderecos[i].UF;
    EdtBairro.Text := ACBrCEP1.Enderecos[i].Bairro;
  end;}
end;

procedure TFrmBuscaCNPJ.limpaEdits(Owner: TWinControl);
var
  i: integer;
begin
  for i := 0 to Owner.ComponentCount - 1 do
    if (Owner.Components[i] is TEdit) AND (TEdit(Owner.Components[i]) <> EdtConsulta) then
      TEdit(Owner.Components[i]).Clear;
end;

procedure TFrmBuscaCNPJ.limpaListBox(Owner: TWinControl);
var
  i: integer;
begin
  for i := 0 to Owner.ComponentCount - 1 do
    if Owner.Components[i] is TListBox then
      TListBox(Owner.Components[i]).Clear;
end;

procedure TFrmBuscaCNPJ.limpaTela();
begin
  limpaEdits(self);
  limpaListBox(self);
end;

procedure TFrmBuscaCNPJ.ActFecharExecute(Sender: TObject);
begin
  Close();
end;

procedure TFrmBuscaCNPJ.BtnSelecionaCertificadoClick(Sender: TObject);
var
 msgResultado: WideString;
 CertNome, CertRazaoSocial, CertNumeroSerie:string;
begin
  with ACBrNFe.Configuracoes.Geral do
  begin
    //I.T Funciona para A1 e A3
    SSLLib := libWinCrypt;
    SSLCryptLib := cryWinCrypt; //ok
    SSLHttpLib := httpWinHttp;  //ok
    SSLXmlSignLib := xsLibXml2; //ok
  end;

  ACBrNFe.SSL.SSLType := LT_TLSv1_2;
  //ACBrNFe.Configuracoes.Certificados.SelecionarCertificado();
  ACBrNFe.SSL.SelecionarCertificado();
  alterarCertificadoDigitalXMLNFE(ACBrNFe.SSL.CertSubjectName, ACBrNFe.SSL.CertNumeroSerie);
  if (Trim(lerEntradaDoXMLNFE('CertificadoDigital', 'Nome')) = '') or
     (Trim(lerEntradaDoXMLNFE('CertificadoDigital', 'NumeroSerie')) = '') then
  begin
    //MessageDlg('Ocorreu uma falha no acesso ao reposit�rio de certificados digitais...' + #13 + #13 +
    //           msgResultado,mtInformation, [mbOk], 0);
    Application.MessageBox('Ocorreu uma falha no acesso ao reposit�rio de certificados digitai',
                         'Erro', MB_ICONERROR + MB_OK);
  end;
end;

procedure TFrmBuscaCNPJ.BtnPesquisarClick(Sender: TObject);
begin
  //pesquisaCNPJ(EdtConsulta.Text);
  pesquisaCNPJSemCaptcha(EdtConsulta.Text);
end;

//PESQUISA OFICIAL DA RECEITA
procedure TFrmBuscaCNPJ.pesquisaCNPJ(sConsulta: string);
var
  auxFrmConsultaCaptchaCNPJ: TFrmConsultaCaptchaCNPJ;
  MR: TModalResult;
  i, cUF: Integer;
  auxCaptcha, auxString: string;
begin
  try
    try
      auxFrmConsultaCaptchaCNPJ := TFrmConsultaCaptchaCNPJ.Create(Self);
      MR := auxFrmConsultaCaptchaCNPJ.ShowModal;
      auxCaptcha := auxFrmConsultaCaptchaCNPJ.sCaptcha;
    finally
      FreeAndNil(auxFrmConsultaCaptchaCNPJ);
    end;

    if (MR = mrOK) then
    begin
      try
        if ACBrConsultaCNPJ1.Consulta(retiraFormatacaoCPFCNPJ(sConsulta), auxCaptcha) then
        begin
          EdtConsulta.Text     := sConsulta;
          EditTipo.Text        := ACBrConsultaCNPJ1.EmpresaTipo;
          EditRazaoSocial.Text := ACBrConsultaCNPJ1.RazaoSocial;
          EditPorte.Text       := ACBrConsultaCNPJ1.Porte;
          EditAbertura.Text    := DateToStr( ACBrConsultaCNPJ1.Abertura );
          EditFantasia.Text    := ACBrConsultaCNPJ1.Fantasia;
          EditEndereco.Text    := ACBrConsultaCNPJ1.Endereco;
          EditNumero.Text      := ACBrConsultaCNPJ1.Numero;
          EditComplemento.Text := ACBrConsultaCNPJ1.Complemento;
          EditBairro.Text      := ACBrConsultaCNPJ1.Bairro;
          EditComplemento.Text := ACBrConsultaCNPJ1.Complemento;
          EditCidade.Text      := ACBrConsultaCNPJ1.Cidade;
          EditUF.Text          := ACBrConsultaCNPJ1.UF;
          EditCEP.Text         := ACBrConsultaCNPJ1.CEP;
          EditSituacao.Text    := ACBrConsultaCNPJ1.Situacao;
          EditCNAE1.Text       := ACBrConsultaCNPJ1.CNAE1;
          EditEmail.Text       := ACBrConsultaCNPJ1.EndEletronico;
          EditTelefone.Text    := ACBrConsultaCNPJ1.Telefone;

          ListCNAE2.Clear;
          for I := 0 to ACBrConsultaCNPJ1.CNAE2.Count - 1 do
            ListCNAE2.Items.Add(ACBrConsultaCNPJ1.CNAE2[I]);

          RetornaCNPJ();
        end;
      except
        limpaTela();
        if Application.MessageBox(PChar('Erro ao Consultar CNPJ.' + #13 + 'Deseja tentar novamente?'), 'Verifique Captcha e conexao internet', mb_yesno + MB_ICONERROR) = id_yes then
          pesquisaCNPJ(sConsulta);
      end;
    end;
  finally
    //auxFrmConsultaCaptchaCNPJ.Free;
    Application.Terminate;
  end;
end;

procedure TFrmBuscaCNPJ.iniciaTela(bHabilita: boolean);
begin
  if bHabilita then
  begin
    LblConsulta.Top := ProgressBar1.Top + 18;
    EdtConsulta.Top := ProgressBar1.Top + 15;
    BtnPesquisar.Top := ProgressBar1.Top + 13;
    BtnSelecionaCertificado.Top := ProgressBar1.Top + 13;
    ProgressBar1.Visible := false;
    //ClientHeight := _ALTURA_CHEIA;
  end
  else
  begin
    ProgressBar1.Visible := true;
    ClientHeight := _ALTURA_REDUZIDA;
    ClientWidth := _LARGURA_REDUZIDA;
  end;
end;

procedure TFrmBuscaCNPJ.FormShow(Sender: TObject);
begin
  //pesquisaCNPJSemCaptcha('32889329000141'); //consulta pelo site https://receitaws.com.br/api
end;

function TFrmBuscaCNPJ.ConsultaIE(aDocumento: String; aUF: String): String;
var
  auxRegime, AuxIE: string;

  function VerificaCertificado(): boolean;
  var
   msgResultado: WideString;
   CertNome, CertRazaoSocial, CertNumeroSerie:string;
  begin
    result := false;

    with ACBrNFe.Configuracoes.Geral do
    begin
      //I.T Funciona para A1 e A3
      SSLLib := libWinCrypt;
      SSLCryptLib := cryWinCrypt; //ok
      SSLHttpLib := httpWinHttp;  //ok
      SSLXmlSignLib := xsLibXml2; //ok
    end;

    ACBrNFe.SSL.SSLType := LT_TLSv1_2;

    if (Trim(lerEntradaDoXMLNFE('CertificadoDigital', 'Nome')) <> '') or
       (Trim(lerEntradaDoXMLNFE('CertificadoDigital', 'NumeroSerie')) <> '') then
    begin
      //pega informa��es do arquivo XML
      CertNumeroSerie := lerEntradaDoXMLNFE('CertificadoDigital', 'NumeroSerie');
      CertNome := lerEntradaDoXMLNFE('CertificadoDigital', 'Nome');
      CertRazaoSocial := lerEntradaDoXMLNFE('CertificadoDigital', 'Nome');
      CertRazaoSocial := ExtrairEntreStrings(CertRazaoSocial, 'CN=', ':');
      configurarACBRNFe(CertNumeroSerie, aUF);
      result := true;
    end;
  end;
begin
  try
    Result := '';

    if trim(aDocumento) = '' then
      exit;
    if trim(aUF) = '' then
      exit;
    if VerificaCertificado = false then
      exit;

    configurarACBRNFe(ACBrNFe.SSL.CertNumeroSerie, aUF);
    ACBrNFe.WebServices.ConsultaCadastro.Clear;
    ACBrNFe.WebServices.ConsultaCadastro.UF := aUF;
    if length(aDocumento) > 11 then
      ACBrNFe.WebServices.ConsultaCadastro.CNPJ := aDocumento
    else
      ACBrNFe.WebServices.ConsultaCadastro.CPF := aDocumento;

    if ACBrNFe.WebServices.ConsultaCadastro.Executar then
    begin
      if AnsiContainsText(ACBrNFe.WebServices.ConsultaCadastro.RetConsCad.InfCad.Items[0].xRegApur, 'NORMAL') then
        AuxRegime := 'NORMAL'
      else
        AuxRegime := 'SIMPLES';

      AuxIE := retiraFormatacaoCPFCNPJ(ACBrNFe.WebServices.ConsultaCadastro.RetConsCad.InfCad.Items[0].IE);

      EditRegime.Text := AuxRegime;
      EditIE.Text := AuxIE;
    end;
    Result := ACBrNFe.WebServices.ConsultaCadastro.XMotivo;
  except
    // nada
  end;
end;

procedure TFrmBuscaCNPJ.configurarACBRNFe(numSerieCert, sUF: String);
begin
  with ACBRNFe do
  begin
    with Configuracoes.Geral do
    begin
      VersaoDF := ve400;
      ModeloDF := moNFe;
      RetirarAcentos := True;
      FormatoAlerta := 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.';
      ExibirErroSchema := True;
      FormaEmissao := teNormal;
      Salvar := False;
    end;

    with Configuracoes.Arquivos do
    begin
      Salvar := False;
      SalvarEvento := False;
    end;

    //Seta Certificado Digital
    Configuracoes.Certificados.NumeroSerie := numSerieCert;
    SSL.CarregarCertificado();

    with Configuracoes.WebServices do
    begin
      Ambiente := taHomologacao;

      UF := sUF;

      //I.T Atributos para tentar resolver problema de internet inst�vel
      AguardarConsultaRet := 3000; //permite definir um tempo em milisegundos entre o Envio e a primeira Consulta (Consultar Situa��o de Lote)
      AjustaAguardaConsultaRet := True;
      IntervaloTentativas := 2000; //permite definir um tempo em milisegundos entre uma Consulta e outra (Consultar Situa��o de Lote)
      Tentativas := 10; //permite definir a quantidade de consultas que ser�o realizadas (Consultar Situa��o de Lote)
      TimeOut := 10000;

    end;
  end;
end;

procedure TFrmBuscaCNPJ.pesquisaCNPJSemCaptcha(sConsulta: string);
var
  i: integer;
begin
  try
    try
      dmConsultaCNPJ.BuscaCNPJ(retiraFormatacaoCPFCNPJ(sConsulta));
      ConsultaIE(retiraFormatacaoCPFCNPJ(sConsulta), DMConsultaCNPJ.Pessoa.uf);

      EditRazaoSocial.Text := UpperCase(DMConsultaCNPJ.Pessoa.razao);
      EditFantasia.Text := UpperCase(DMConsultaCNPJ.Pessoa.fantasia);
      EditEndereco.Text := UpperCase(DMConsultaCNPJ.Pessoa.logradouro);
      EditCidade.Text := UpperCase(DMConsultaCNPJ.Pessoa.municipio);
      EditUF.Text := UpperCase(DMConsultaCNPJ.Pessoa.uf);
      EditCEP.Text := UpperCase(DMConsultaCNPJ.Pessoa.cep);
      EditBairro.Text := UpperCase(DMConsultaCNPJ.Pessoa.bairro);
      EditNumero.Text := UpperCase(DMConsultaCNPJ.Pessoa.numero);
      EditComplemento.Text := UpperCase(DMConsultaCNPJ.Pessoa.complemento);
      EditEmail.Text := UpperCase(DMConsultaCNPJ.Pessoa.email);
      EditTelefone.Text := UpperCase(DMConsultaCNPJ.Pessoa.telefone);
      EdtConsulta.Text     := sConsulta;
      EditTipo.Text        := UpperCase(DMConsultaCNPJ.Pessoa.tipo);
      EditPorte.Text       := UpperCase(DMConsultaCNPJ.Pessoa.porte);
      EditAbertura.Text    := UpperCase(DMConsultaCNPJ.Pessoa.abertura);
      EditSituacao.Text    := UpperCase(DMConsultaCNPJ.Pessoa.situacao);
      EditCNAE1.Text       := DMConsultaCNPJ.Pessoa.CNAE1;

      ListCNAE2.Clear;
      for I := 0 to DMConsultaCNPJ.Pessoa.CNAE2.Count - 1 do
        ListCNAE2.Items.Add(DMConsultaCNPJ.Pessoa.CNAE2[I]);

      RetornaCNPJ();
    except
      limpaTela();
      if Application.MessageBox(PChar('Erro ao Consultar CNPJ.' + #13 + 'Deseja tentar novamente?'), 'Verifique conexao de internet', mb_yesno + MB_ICONERROR) = id_yes then
        pesquisaCNPJSemCaptcha(sConsulta);
    end;
  finally
    //Application.Terminate;
  end;
end;

procedure TFrmBuscaCNPJ.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 then //Se o comando for igual a enter
  Begin
    Key := #0;
    Perform (wm_nextdlgctl, 0, 0); //Para pular de campo em campo
  End;
end;

procedure TFrmBuscaCNPJ.FormActivate(Sender: TObject);
var
  auxVersao: TVersao;
  Input: TInput;
begin
  ZeroMemory(@Input, SizeOf(Input));
  SendInput(1, Input, SizeOf(Input)); // don't send anyting actually to another app..
  SetForegroundWindow(Handle);

  auxVersao:= TVersao.Create(Application.ExeName);
  self.caption := self.Caption + ' v.' + auxVersao.toString();
  iniciaTela(true);

  //modo de consulta manual
  if sCNPJ = '' then
  begin
    bTimerDesliga := false;
    iniciaTela(true);
    RetornaCNPJ();
    exit;
  end;

  //modo de consulta por chamada
  try
    try
      bTimerDesliga := true;
      //caso seja executado por iniciativa de outro software
      iniciaTela(false);
      pesquisaCNPJSemCaptcha(sCNPJ);
      RetornaCNPJ();
    Except
      RetornaCNPJ();
      //Application.Terminate;
    end;
  finally
    Application.Terminate;
  end;
end;

procedure TFrmBuscaCNPJ.RetornaCNPJ;
var
  txt: textfile;
  nomeArquivo, CaminhoSistema: string;
begin
  //grava informacoes em .txt
  try
    CaminhoSistema := ExtractFilePath(ParamStr(0));
    nomeArquivo := CaminhoSistema + 'BuscaCNPJ.txt';

    AssignFile(txt, nomeArquivo);
    Rewrite(txt);

    WriteLn(txt, 'RAZAO|' + EditRazaoSocial.Text);
    WriteLn(txt, 'FANTASIA|' + EditFantasia.Text);
    WriteLn(txt, 'PORTE|' + EditPorte.Text);
    WriteLn(txt, 'DATAABERTURA|' + EditAbertura.Text);
    WriteLn(txt, 'CNPJ|' + retiraFormatacaoCPFCNPJ(EdtConsulta.Text));
    WriteLn(txt, 'INSCRICAO|' + retiraFormatacaoCPFCNPJ(EditIE.Text));
    WriteLn(txt, 'EMAIL|' + EditEmail.Text);
    WriteLn(txt, 'TELEFONE|' + retiraFormatacaoCPFCNPJ(EditTelefone.Text));
    WriteLn(txt, 'REGIME|' + EditRegime.Text);

    WriteLn(txt, 'LOGRADOURO|' + EditEndereco.Text);
    WriteLn(txt, 'NUMERO|' + EditNumero.Text);
    WriteLn(txt, 'COMPLEMENTO|' + EditComplemento.Text);
    WriteLn(txt, 'BAIRRO|' + EditBairro.Text);
    WriteLn(txt, 'UF|' + EditUF.Text);
    WriteLn(txt, 'CIDADE|' + EditCidade.Text);
    WriteLn(txt, 'CEP|' + EditCEP.Text);
  finally
    CloseFile(txt);
  end;
end;

procedure TFrmBuscaCNPJ.TimerDesligaTimer(Sender: TObject);
begin
  if bTimerDesliga then
    Application.Terminate;
end;

end.
