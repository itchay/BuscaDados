unit UnFrmBuscaCEP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ACBrBase, ACBrSocket,
  ACBrCEP, UnClasseEndereco, Vcl.ComCtrls, UnClasseVersao, System.Actions,
  Vcl.ActnList, Vcl.ExtCtrls;

type
  TFrmBuscaCEP = class(TForm)
    ACBrCEP1: TACBrCEP;
    EdtConsulta: TEdit;
    BtnPesquisar: TButton;
    LblConsulta: TLabel;
    ProgressBar1: TProgressBar;
    GroupBox1: TGroupBox;
    EdtLogradouro: TEdit;
    EdtBairro: TEdit;
    EdtCEP: TEdit;
    EdtCidade: TEdit;
    EdtUF: TEdit;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    ActionList1: TActionList;
    ActFechar: TAction;
    CmbWebService: TComboBox;
    LblServidor: TLabel;
    TimerDesliga: TTimer;
    procedure BtnPesquisarClick(Sender: TObject);
    procedure ACBrCEP1BuscaEfetuada(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EdtConsultaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ActFecharExecute(Sender: TObject);
    procedure CmbWebServiceChange(Sender: TObject);
    procedure TimerDesligaTimer(Sender: TObject);
  private
    { Private declarations }
    procedure RetornaEndereco;
    procedure iniciaTela(bHabilita: boolean);
  public
    { Public declarations }
    sCEP: string;
    oEndereco: TEndereco;
    bTimerDesliga: boolean;
  end;

const
  _ALTURA_CHEIA = 200;
  _ALTURA_REDUZIDA = 26;
  _CORREIOS = 0;
  _REP_VIRTUAL = 1;

var
  FrmBuscaCEP: TFrmBuscaCEP;

implementation

{$R *.dfm}

procedure TFrmBuscaCEP.ACBrCEP1BuscaEfetuada(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ACBrCEP1.Enderecos.Count - 1 do
  begin
    EdtCEP.Text := ACBrCEP1.Enderecos[i].CEP;
    EdtLogradouro.Text := ACBrCEP1.Enderecos[i].Logradouro;
    EdtCidade.Text := ACBrCEP1.Enderecos[i].Municipio;
    EdtUF.Text := ACBrCEP1.Enderecos[i].UF;
    EdtBairro.Text := ACBrCEP1.Enderecos[i].Bairro;
  end;
end;

procedure TFrmBuscaCEP.ActFecharExecute(Sender: TObject);
begin
  Close();
end;

procedure TFrmBuscaCEP.BtnPesquisarClick(Sender: TObject);
begin
  try
    if CmbWebService.ItemIndex = _CORREIOS then
      ACBrCEP1.WebService := wsCorreios
    else if CmbWebService.ItemIndex = _REP_VIRTUAL then
      ACBrCEP1.WebService := wsRepublicaVirtual;

    ACBrCEP1.BuscarPorCEP(edtConsulta.Text);
    retornaEndereco();
    EdtConsulta.SetFocus();
  except
    EdtCEP.Text := '';
    EdtLogradouro.Text := '';
    EdtCidade.Text := '';
    EdtUF.Text := '';
    EdtBairro.Text := '';
  end;
end;

procedure TFrmBuscaCEP.CmbWebServiceChange(Sender: TObject);
begin
  EdtConsulta.SetFocus();
end;

procedure TFrmBuscaCEP.EdtConsultaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_RETURN:
      BtnPesquisar.SetFocus();
  end;
end;

procedure TFrmBuscaCEP.iniciaTela(bHabilita: boolean);
begin
  if bHabilita then
  begin
    LblConsulta.Top := ProgressBar1.Top + 15;
    EdtConsulta.Top := ProgressBar1.Top + 15;
    BtnPesquisar.Top := ProgressBar1.Top + 15;
    ProgressBar1.Visible := false;
    ClientHeight := _ALTURA_CHEIA;
  end
  else
  begin
    ProgressBar1.Visible := true;
    ClientHeight := _ALTURA_REDUZIDA;
  end;

  LblServidor.Top := LblConsulta.Top;
  CmbWebService.Top := EdtConsulta.Top;
end;

procedure TFrmBuscaCEP.FormShow(Sender: TObject);
var
  auxVersao: TVersao;
begin
  auxVersao:= TVersao.Create(Application.ExeName);
  self.caption := self.Caption + ' v.' + auxVersao.toString();
  oEndereco:= TEndereco.Create();

  //modo de consulta manual
  if sCEP = '' then
  begin
    bTimerDesliga := false;
    self.Height := 400;
    iniciaTela(true);
    retornaEndereco();
    exit
  end;

  //modo de consulta por chamada
  try
    try
      //caso seja executado por iniciativa de outro software
      bTimerDesliga := true;
      iniciaTela(false);
      ACBrCEP1.BuscarPorCEP(sCEP);
      retornaEndereco();
    Except
      retornaEndereco();
      Application.Terminate;
    end;
  finally
    Application.Terminate;
  end;
end;

procedure TFrmBuscaCEP.RetornaEndereco;
var
  txt: textfile;
  nomeArquivo, CaminhoSistema: string;
begin
  //salva informacoes no objeto Endereco
  oEndereco.Logradouro := EdtLogradouro.Text;
  oEndereco.Bairro := EdtBairro.Text;
  oEndereco.Cidade.Nome := EdtCidade.Text;
  oEndereco.Cidade.UF := EdtUF.Text;
  oEndereco.CEP.Numero := EdtCEP.Text;

  //grava informacoes em .txt
  try
    CaminhoSistema := ExtractFilePath(ParamStr(0));
    nomeArquivo := CaminhoSistema + 'BuscaCEP.txt';

    AssignFile(txt, nomeArquivo);
    Rewrite(txt);

    WriteLn(txt, 'LOGRADOURO|' + oEndereco.Logradouro);
    WriteLn(txt, 'BAIRRO|' + oEndereco.Bairro);
    WriteLn(txt, 'UF|' + oEndereco.Cidade.UF);
    WriteLn(txt, 'CIDADE|' + oEndereco.Cidade.Nome);
    WriteLn(txt, 'CEP|' + oEndereco.CEP.Numero);
  finally
    CloseFile(txt);
  end;
end;

procedure TFrmBuscaCEP.TimerDesligaTimer(Sender: TObject);
begin
  if bTimerDesliga then
    Application.Terminate;
end;

end.
