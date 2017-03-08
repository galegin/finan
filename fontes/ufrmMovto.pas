unit ufrmMovto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils, Math, uFinMovto, mBase64, mString,
  mLogger;

type
  TF_Movto = class(TForm)
    LabelConta: TLabel;
    EditConta: TEdit;
    EditMes: TEdit;
    LabelMes: TLabel;
    LabelConteudo: TLabel;
    LabelTotal: TLabel;
    MemoConteudo: TMemo;
    EditTotal: TEdit;
    ButtonConfirmar: TButton;
    ButtonCorrigir: TButton;
    RadioButtonSaldo: TRadioButton;
    RadioButtonSoma: TRadioButton;
    procedure ButtonCorrigirClick(Sender: TObject);
    procedure ButtonTotalizarClick(Sender: TObject);
  private
    fObj_Movto: TFin_Movto;
    function GetObj_Movto: TFin_Movto;
    procedure SetObj_Movto(const Value: TFin_Movto);
  public
    class function Execute(AObj_Movto: TFin_Movto): TFin_Movto;
  published
    property Obj_Movto: TFin_Movto read GetObj_Movto write SetObj_Movto;
  end;

//var
//  F_Movto: TF_Movto;

implementation

{$R *.dfm}

{ TF_Movto }

class function TF_Movto.Execute;
begin
  Result := nil;
  with TF_Movto.Create(nil) do begin
    Obj_Movto := AObj_Movto;
    if ShowModal = mrOk then
      Result := Obj_Movto;
  end;
end;

function TF_Movto.GetObj_Movto: TFin_Movto;
begin
  Result := fObj_Movto;
  with Result do begin
    Cd_Conta := EditConta.Text;
    Cd_Mes := EditMes.Text;
    Ds_Conteudo := TmBase64.Encode(MemoConteudo.Text);
    Vl_Total := StrToFloatDef(EditTotal.Text, 0);
    Tp_Total := IfThen(RadioButtonSaldo.Checked, 'S', 'T');
  end;
end;

procedure TF_Movto.SetObj_Movto(const Value: TFin_Movto);
begin
  fObj_Movto:= Value;
  with fObj_Movto do begin
    EditConta.Text := Cd_Conta;
    EditMes.Text := Cd_Mes;
    MemoConteudo.Text := TmBase64.Decode(Ds_Conteudo);
    EditTotal.Text := FormatFloat('0.00', Vl_Total);
    RadioButtonSaldo.Checked := (Tp_Total = 'S');
    RadioButtonSoma.Checked := not RadioButtonSaldo.Checked;
  end;
end;

procedure TF_Movto.ButtonCorrigirClick(Sender: TObject);
var
  vString : String;
  I : Integer;
begin
  with MemoConteudo do
    for I := 0 to Lines.Count - 1 do begin
      vString := Lines[I];
      vString := AnsiReplaceStr(vString, #9, ' ');
      vString := AnsiReplaceStr(vString, ' - ', '-');
      vString := TmString.RemoveAcento(vString);
      vString := TmString.AllTrim(vString);
      Lines[I] := vString;
    end;

  ButtonTotalizarClick(Sender);
end;

procedure TF_Movto.ButtonTotalizarClick(Sender: TObject);
var
  vStringList : TmStringList;
  vTotal, vValor, vMult : Real;
  vDsValor : String;
  I : Integer;
begin
  vTotal := 0;

  with MemoConteudo do
    for I := 0 to Lines.Count - 1 do begin
      vStringList := TmString.Split(Lines[I], ' ');

      if vStringList.Count > 0 then
        vDsValor := vStringList.Items[vStringList.Count - 1]
      else
        Continue;

      vMult := IfThen(Pos('-', vDsValor) > 0, -1, 1);
      vDsValor := AnsiReplaceStr(vDsValor, '.', '');
      vDsValor := AnsiReplaceStr(vDsValor, '-', '');
      vValor := StrToFloatDef(vDsValor, 0) * vMult;

      if RadioButtonSoma.Checked then
        vTotal := vTotal + vValor
      else
        vTotal := vValor;
    end;

  EditTotal.Text := FormatFloat('0.00', vTotal);
end;

end.
