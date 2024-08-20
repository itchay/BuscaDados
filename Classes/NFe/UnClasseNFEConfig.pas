unit UnClasseNFEConfig;

interface

uses
  UnClasseCampoConfig,
  UnClasseCertificadoDigitalConfig;

type
  TNFEConfig = class(TObject)
    private
      oCertificadoDigital: TCertificadoDigitalConfig;

      procedure setCertificadoDigital(lCertificadoDigital: TCertificadoDigitalConfig);
    public

      property CertificadoDigital: TCertificadoDigitalConfig
        read oCertificadoDigital
        write setCertificadoDigital;

      constructor Create();
  end;

implementation

{ TNFEConfig }

constructor TNFEConfig.Create;
begin
  oCertificadoDigital:= TCertificadoDigitalConfig.Create();
end;

procedure TNFEConfig.setCertificadoDigital(lCertificadoDigital: TCertificadoDigitalConfig);
begin
  Self.oCertificadoDigital:= lCertificadoDigital;
end;

end.
