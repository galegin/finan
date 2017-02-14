object F_Movto: TF_Movto
  Left = 192
  Top = 114
  Width = 393
  Height = 442
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'F_Movto'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    385
    408)
  PixelsPerInch = 96
  TextHeight = 13
  object LabelConta: TLabel
    Left = 4
    Top = 4
    Width = 28
    Height = 13
    Caption = 'Conta'
  end
  object LabelMes: TLabel
    Left = 4
    Top = 28
    Width = 20
    Height = 13
    Caption = 'Mes'
  end
  object LabelConteudo: TLabel
    Left = 4
    Top = 52
    Width = 46
    Height = 13
    Caption = 'Conteudo'
  end
  object LabelTotal: TLabel
    Left = 4
    Top = 380
    Width = 24
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Total'
  end
  object EditConta: TEdit
    Left = 60
    Top = 4
    Width = 121
    Height = 21
    TabStop = False
    BorderStyle = bsNone
    Color = clSilver
    ReadOnly = True
    TabOrder = 0
  end
  object EditMes: TEdit
    Left = 60
    Top = 28
    Width = 121
    Height = 21
    TabStop = False
    BorderStyle = bsNone
    Color = clSilver
    ReadOnly = True
    TabOrder = 1
  end
  object MemoConteudo: TMemo
    Left = 60
    Top = 52
    Width = 317
    Height = 325
    Anchors = [akLeft, akTop, akRight, akBottom]
    BorderStyle = bsNone
    TabOrder = 4
  end
  object EditTotal: TEdit
    Left = 60
    Top = 380
    Width = 121
    Height = 21
    TabStop = False
    Anchors = [akLeft, akBottom]
    BorderStyle = bsNone
    Color = 8454143
    ReadOnly = True
    TabOrder = 5
  end
  object ButtonConfirmar: TButton
    Left = 184
    Top = 28
    Width = 75
    Height = 21
    Caption = 'Confirmar'
    Default = True
    ModalResult = 1
    TabOrder = 2
    TabStop = False
  end
  object ButtonCorrigir: TButton
    Left = 264
    Top = 28
    Width = 75
    Height = 21
    Caption = 'Corrigir'
    TabOrder = 3
    TabStop = False
    OnClick = ButtonCorrigirClick
  end
  object RadioButtonSaldo: TRadioButton
    Left = 188
    Top = 384
    Width = 85
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Saldo'
    TabOrder = 6
    OnClick = ButtonTotalizarClick
  end
  object RadioButtonSoma: TRadioButton
    Left = 284
    Top = 384
    Width = 85
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Soma'
    TabOrder = 7
    OnClick = ButtonTotalizarClick
  end
end
