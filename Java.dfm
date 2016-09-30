object frmMain: TfrmMain
  Left = 349
  Top = 164
  Width = 1068
  Height = 591
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
  object memoSource: TMemo
    Left = 8
    Top = 56
    Width = 457
    Height = 241
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnLoadText: TButton
    Left = 8
    Top = 8
    Width = 457
    Height = 33
    Action = aLoadCode
    TabOrder = 1
  end
  object memoCode: TMemo
    Left = 8
    Top = 304
    Width = 457
    Height = 241
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
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
