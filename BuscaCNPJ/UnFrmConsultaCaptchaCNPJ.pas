unit UnFrmConsultaCaptchaCNPJ;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls;

type

  { TFrmConsultaCaptchaCNPJ }

  TFrmConsultaCaptchaCNPJ = class(TForm)
    btNovoCaptcha: TBitBtn;
    btOK: TBitBtn;
    btOK1: TBitBtn;
    imgCaptcha: TImage;
    lInformeCaptcha: TLabel;
    pBotoes: TPanel;
    pCaptcha: TPanel;
    Panel1: TPanel;
    edtCaptcha: TEdit;
    TimerDesliga2: TTimer;
    procedure btNovoCaptchaClick(Sender: TObject);
    procedure edtCaptchaChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
    procedure edtCaptchaExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerDesliga2Timer(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    procedure AtualizarCaptcha;

  public
    sCaptcha: string;
    bTimerDesliga: boolean;
  end;

var
  FrmConsultaCaptchaCNPJ: TFrmConsultaCaptchaCNPJ;

implementation

uses
  UnFrmBuscaCNPJ,
  ACBrUtil,
  pngimage;

{$R *.dfm}

{ TFrmConsultaCaptchaCNPJ }

procedure TFrmConsultaCaptchaCNPJ.FormShow(Sender: TObject);
begin
  bTimerDesliga := true;
  AtualizarCaptcha;
  AtualizarCaptcha;
  edtCaptcha.SetFocus;
end;

procedure TFrmConsultaCaptchaCNPJ.TimerDesliga2Timer(Sender: TObject);
begin
  if bTimerDesliga then
    Application.Terminate();
end;

procedure TFrmConsultaCaptchaCNPJ.btNovoCaptchaClick(Sender: TObject);
begin
  AtualizarCaptcha;
end;

procedure TFrmConsultaCaptchaCNPJ.btOKClick(Sender: TObject);
begin
  bTimerDesliga := false;
end;

procedure TFrmConsultaCaptchaCNPJ.edtCaptchaChange(Sender: TObject);
begin
  lInformeCaptcha.Visible := False;
end;

procedure TFrmConsultaCaptchaCNPJ.edtCaptchaExit(Sender: TObject);
begin
  sCaptcha := edtCaptcha.Text;
end;

procedure TFrmConsultaCaptchaCNPJ.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  bTimerDesliga := false;
  sCaptcha := trim(edtCaptcha.Text);
end;

procedure TFrmConsultaCaptchaCNPJ.FormCloseQuery(Sender: TObject; var CanClose: boolean
  );
begin
  if (ModalResult = mrOK) then
  begin
    if (Trim(edtCaptcha.Text) = '') then
    begin
      lInformeCaptcha.Visible := True;
      CanClose := False;
    end;
  end;
end;

procedure TFrmConsultaCaptchaCNPJ.AtualizarCaptcha;
var
  Stream: TMemoryStream;
  ImgName: String;
begin
  ImgName := ApplicationPath+'captcha.png';
  Stream := TMemoryStream.Create;
  try
    FrmBuscaCNPJ.ACBrConsultaCNPJ1.Captcha(Stream);
    Stream.SaveToFile(ImgName);
    imgCaptcha.Picture.LoadFromFile(ImgName);

    edtCaptcha.Clear;
    edtCaptcha.SetFocus;
  finally
    Stream.Free;
  end;
end;

end.
