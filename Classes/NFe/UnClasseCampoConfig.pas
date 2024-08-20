unit UnClasseCampoConfig;

interface

type
  TCampoConfig = class(TObject)
    private
      sNome: String;
      sDados: String;
      sDescricao: String;

      procedure setNome(lNome: String);
      procedure setDados(lDados: String);
      procedure setDescricao(lDescricao: String);

    public
    //function QueryInterface(const IID: TGUID; out Obj): HRESULT; stdcall;
      property Nome: String
        read sNome
        write setNome;

      property Dados: String
        read sDados
        write setDados;

      property Descricao: String
        read sDescricao
        write setDescricao;

      constructor Create();
  end;

implementation

{ TCamposConfig }

procedure TCampoConfig.setDados(lDados: String);
begin
  Self.sDados:= lDados;
end;

procedure TCampoConfig.setDescricao(lDescricao: String);
begin
  Self.sDescricao:= lDescricao;
end;

procedure TCampoConfig.setNome(lNome: String);
begin
  Self.sNome:= lNome;
end;

constructor TCampoConfig.Create;
begin
  sNome:= '';
  sDados:= '';
  sDescricao:= '';
end;

end.
