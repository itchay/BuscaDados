unit UnClasseCertificadoDigitalConfig;

interface

uses
  UnClasseCampoConfig;

type
  TCertificadoDigitalConfig = class(TObject)
    private
      oNome: TCampoConfig;
      oNumeroSerie: TCampoConfig;
      oCaminho: TCampoConfig;
      oSenha: TCampoConfig;
      oCodigoUF: TCampoConfig;
      oSiglaUF: TCampoConfig;

      procedure setNome(lNome: TCampoConfig);

    public
      property Nome: TCampoConfig
        read oNome
        write setNome;

      property NumeroSerie: TCampoConfig
        read oNumeroSerie
        write oNumeroSerie;

      property Caminho: TCampoConfig
        read oCaminho
        write oCaminho;

      property Senha: TCampoConfig
        read oSenha
        write oSenha;

      Property CodigoUF: TCampoConfig
        read oCodigoUF
        write oCodigoUF;

      Property SiglaUF: TCampoConfig
        read oSiglaUF
        write oSiglaUF;

      constructor Create();
  end;

implementation

{ TCertificadoDigitalConfig }

constructor TCertificadoDigitalConfig.Create;
begin
  oNome := TCampoConfig.Create();
  oNome.Nome:= 'Nome';

  oNumeroSerie := TCampoConfig.Create();
  oNumeroSerie.Nome := 'NumeroSerie';

  oCaminho := TCampoConfig.Create();
  oCaminho.Nome := 'CaminhoPFX';

  oSenha := TCampoConfig.Create();
  oSenha.Nome := 'Senha';

  oSenha := TCampoConfig.Create();
  oSenha.Nome := 'Senha';

  oCodigoUF := TCampoConfig.Create();
  oCodigoUF.Nome := 'CodigoUF';

  oSiglaUF := TCampoConfig.Create();
  oSiglaUF.Nome := 'SiglaUF';
end;

procedure TCertificadoDigitalConfig.setNome(lNome: TCampoConfig);
begin
  Self.oNome:= lNome;
end;

end.
