program BuscaDados;

uses
  Vcl.Forms,
  Vcl.Dialogs,
  UnClasseEndereco in 'Classes\UnClasseEndereco.pas',
  UnClasseTipoLogradouro in 'Classes\UnClasseTipoLogradouro.pas',
  UnClasseCEP in 'Classes\UnClasseCEP.pas',
  UnClasseCidade in 'Classes\UnClasseCidade.pas',
  UnClasseVersao in 'Classes\UnClasseVersao.pas',
  UnFrmBuscaCNPJ in 'BuscaCNPJ\UnFrmBuscaCNPJ.pas' {FrmBuscaCNPJ},
  UnFrmConsultaCaptchaCNPJ in 'BuscaCNPJ\UnFrmConsultaCaptchaCNPJ.pas' {FrmConsultaCaptchaCNPJ},
  UnFrmBuscaCEP in 'BuscaCEP\UnFrmBuscaCEP.pas' {FrmBuscaCEP},
  UnClasseUtils in 'Classes\UnClasseUtils.pas',
  uDMConsultaCNPJ in 'JSON\uDMConsultaCNPJ.pas' {DMConsultaCNPJ: TDataModule},
  UnClasseNFEConfig in 'Classes\NFe\UnClasseNFEConfig.pas',
  UnClasseCampoConfig in 'Classes\NFe\UnClasseCampoConfig.pas',
  UnClasseCertificadoDigitalConfig in 'Classes\NFe\UnClasseCertificadoDigitalConfig.pas';

{$R *.res}

var
  i: integer;
  sCEP, sCNPJ: string;
begin
  try
    try
      sCEP := '';
      sCNPJ := '';

      Application.Initialize;
      Application.MainFormOnTaskbar := True;

      if ParamStr(1) = 'CEP' then
      begin
        sCEP := ParamStr(2);
        Application.CreateForm(TFrmBuscaCEP, FrmBuscaCEP);
        FrmBuscaCEP.sCEP := sCEP;
      end
      else
      begin
        sCNPJ := ParamStr(2);
        Application.CreateForm(TFrmBuscaCNPJ, FrmBuscaCNPJ);
        Application.CreateForm(TFrmConsultaCaptchaCNPJ, FrmConsultaCaptchaCNPJ);
        Application.CreateForm(TDMConsultaCNPJ, DMConsultaCNPJ);
        FrmBuscaCNPJ.sCNPJ := sCNPJ;
      end;

      Application.Run;
    except
      Application.Terminate()
    end;
  finally
    Application.Terminate()
  end;
end.
