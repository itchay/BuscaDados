object FrmBuscaCEP: TFrmBuscaCEP
  Left = 0
  Top = 0
  Caption = 'BuscaCEP'
  ClientHeight = 200
  ClientWidth = 496
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LblConsulta: TLabel
    Left = 237
    Top = 36
    Width = 69
    Height = 13
    Caption = 'Informe o CEP'
  end
  object LblServidor: TLabel
    Left = 54
    Top = 36
    Width = 40
    Height = 13
    Caption = 'Servidor'
  end
  object EdtConsulta: TEdit
    Left = 312
    Top = 33
    Width = 88
    Height = 21
    TabOrder = 0
    OnKeyDown = EdtConsultaKeyDown
  end
  object BtnPesquisar: TButton
    Left = 401
    Top = 31
    Width = 75
    Height = 25
    Caption = 'Pesquisar'
    TabOrder = 1
    OnClick = BtnPesquisarClick
  end
  object ProgressBar1: TProgressBar
    Left = 5
    Top = 3
    Width = 486
    Height = 20
    Position = 98
    Smooth = True
    Style = pbstMarquee
    BarColor = clLime
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 59
    Width = 465
    Height = 118
    Caption = '|  Endere'#231'o  |'
    TabOrder = 3
    object Label10: TLabel
      Left = 47
      Top = 55
      Width = 19
      Height = 13
      Caption = 'CEP'
    end
    object Label12: TLabel
      Left = 33
      Top = 85
      Width = 33
      Height = 13
      Caption = 'Cidade'
    end
    object Label13: TLabel
      Left = 343
      Top = 85
      Width = 13
      Height = 13
      Caption = 'UF'
    end
    object Label3: TLabel
      Left = 187
      Top = 55
      Width = 28
      Height = 13
      Caption = 'Bairro'
    end
    object Label1: TLabel
      Left = 11
      Top = 25
      Width = 55
      Height = 13
      Caption = 'Logradouro'
    end
    object EdtLogradouro: TEdit
      Left = 72
      Top = 22
      Width = 377
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object EdtBairro: TEdit
      Left = 220
      Top = 52
      Width = 229
      Height = 21
      ReadOnly = True
      TabOrder = 1
    end
    object EdtCEP: TEdit
      Left = 72
      Top = 52
      Width = 107
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
    object EdtCidade: TEdit
      Left = 72
      Top = 82
      Width = 262
      Height = 21
      ReadOnly = True
      TabOrder = 3
    end
    object EdtUF: TEdit
      Left = 362
      Top = 82
      Width = 87
      Height = 21
      ReadOnly = True
      TabOrder = 4
    end
  end
  object CmbWebService: TComboBox
    Left = 102
    Top = 33
    Width = 113
    Height = 21
    TabOrder = 4
    Text = 'Supera Solution'
    OnChange = CmbWebServiceChange
    Items.Strings = (
      'correios'
      'repvirtual')
  end
  object ACBrCEP1: TACBrCEP
    ProxyPort = '8080'
    WebService = wsRepublicaVirtual
    PesquisarIBGE = True
    OnBuscaEfetuada = ACBrCEP1BuscaEfetuada
    Left = 264
    Top = 142
  end
  object ActionList1: TActionList
    Left = 320
    Top = 142
    object ActFechar: TAction
      Caption = 'ActFechar'
      ShortCut = 27
      OnExecute = ActFecharExecute
    end
  end
  object TimerDesliga: TTimer
    Interval = 30000
    OnTimer = TimerDesligaTimer
    Left = 184
    Top = 152
  end
end
