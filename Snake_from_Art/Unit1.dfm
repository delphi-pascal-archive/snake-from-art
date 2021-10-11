object Form1: TForm1
  Left = 235
  Top = 135
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Snake from Art'
  ClientHeight = 326
  ClientWidth = 308
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 120
  TextHeight = 16
  object Area: TImage
    Left = 0
    Top = 0
    Width = 305
    Height = 305
  end
  object Wall: TImage
    Left = 384
    Top = 20
    Width = 21
    Height = 21
    AutoSize = True
    Visible = False
  end
  object LenPlus: TImage
    Left = 384
    Top = 49
    Width = 18
    Height = 19
    Visible = False
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 307
    Width = 308
    Height = 19
    Panels = <
      item
        Text = #1044#1083#1080#1085#1072':'
        Width = 100
      end
      item
        Text = #1057#1082#1086#1088#1086#1089#1090#1100':'
        Width = 150
      end>
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 152
    Top = 48
  end
  object MainMenu1: TMainMenu
    Left = 120
    Top = 48
    object N1: TMenuItem
      Caption = #1048#1075#1088#1072
      object N3: TMenuItem
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1072#1088#1090#1091
      end
      object N8: TMenuItem
        Caption = #1057#1083#1091#1095#1072#1081#1085#1072#1103' '#1082#1072#1088#1090#1072
        OnClick = N8Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = N4Click
      end
    end
    object N2: TMenuItem
      Caption = #1055#1086#1084#1086#1097#1100
      object N6: TMenuItem
        Caption = #1057#1087#1088#1072#1074#1082#1072
      end
      object N7: TMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077'...'
        OnClick = N7Click
      end
    end
  end
  object XPManifest1: TXPManifest
    Left = 184
    Top = 48
  end
end
