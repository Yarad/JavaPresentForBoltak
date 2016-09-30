object frmMain: TfrmMain
  Left = 87
  Top = 121
  Width = 1068
  Height = 590
  Caption = #1052#1077#1090#1088#1086#1083#1086#1075#1080#1103
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 18
  object lbFileNameChosen: TLabel
    Left = 8
    Top = 8
    Width = 114
    Height = 18
    Caption = #1060#1072#1081#1083' '#1085#1077' '#1074#1099#1073#1088#1072#1085'!'
    Layout = tlCenter
  end
  object memoCode: TMemo
    Left = 8
    Top = 88
    Width = 457
    Height = 457
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnLoadText: TButton
    Left = 8
    Top = 40
    Width = 457
    Height = 33
    Action = aLoadCode
    TabOrder = 1
  end
  object btnTest: TButton
    Left = 872
    Top = 424
    Width = 75
    Height = 25
    Caption = 'btnTest'
    TabOrder = 2
    OnClick = btnTestClick
  end
  object mmoTest: TMemo
    Left = 832
    Top = 320
    Width = 185
    Height = 89
    Lines.Strings = (
      'mmoTest')
    TabOrder = 3
  end
  object dlgFileOpen: TOpenDialog
    Filter = 'Java Files|*.java'
    Left = 424
    Top = 8
  end
  object alMain: TActionList
    Left = 392
    Top = 8
    object aLoadCode: TAction
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1092#1072#1081#1083' '#1080' '#1087#1086#1089#1095#1080#1090#1072#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1103' '#1084#1077#1090#1088#1080#1082
      OnExecute = aLoadCodeExecute
    end
  end
end
