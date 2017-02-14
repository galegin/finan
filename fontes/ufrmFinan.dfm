object F_Finan: TF_Finan
  Left = 92
  Top = 165
  Width = 873
  Height = 542
  ActiveControl = gFluxo
  Caption = 'F_Finan'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  WindowState = wsMaximized
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object _PanelFiltro: TPanel
    Left = 0
    Top = 0
    Width = 865
    Height = 37
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    object LabelReferencia: TLabel
      Left = 4
      Top = 8
      Width = 73
      Height = 21
      Alignment = taCenter
      AutoSize = False
      Caption = 'Referencia'
      Layout = tlCenter
    end
    object EditReferencia: TEdit
      Left = 84
      Top = 8
      Width = 121
      Height = 21
      BorderStyle = bsNone
      TabOrder = 0
    end
    object ButtonLimpar: TButton
      Left = 212
      Top = 8
      Width = 75
      Height = 21
      Caption = 'Limpar'
      TabOrder = 1
      TabStop = False
      OnClick = ButtonLimparClick
    end
    object ButtonConsultar: TButton
      Left = 292
      Top = 8
      Width = 75
      Height = 21
      Caption = 'Consultar'
      TabOrder = 2
      TabStop = False
      OnClick = ButtonConsultarClick
    end
    object ButtonSalvar: TButton
      Left = 372
      Top = 8
      Width = 75
      Height = 21
      Caption = 'Salvar'
      TabOrder = 3
      TabStop = False
      OnClick = ButtonSalvarClick
    end
  end
  object gFluxo: TDBGrid
    Left = 0
    Top = 37
    Width = 865
    Height = 471
    Align = alClient
    BorderStyle = bsNone
    DataSource = dFluxo
    FixedColor = 12615680
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWhite
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = gFluxoDrawColumnCell
    OnDblClick = gFluxoDblClick
    OnKeyDown = gFluxoKeyDown
  end
  object tFluxo: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforePost = tFluxoBeforePost
    AfterPost = tFluxoAfterPost
    OnNewRecord = tFluxoNewRecord
    Left = 140
    Top = 156
  end
  object dFluxo: TDataSource
    DataSet = tFluxo
    Left = 172
    Top = 156
  end
end
