unit ufrmFinan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids, DBGrids, DB, DBClient, StrUtils, Clipbrd,
  uFinConta, uFinFluxo, uFinMovto;

type
  TF_Finan = class(TForm)
    _PanelFiltro: TPanel;
    LabelReferencia: TLabel;
    EditReferencia: TEdit;
    tFluxo: TClientDataSet;
    dFluxo: TDataSource;
    gFluxo: TDBGrid;
    ButtonLimpar: TButton;
    ButtonConsultar: TButton;
    ButtonSalvar: TButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure gFluxoDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure gFluxoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tFluxoNewRecord(DataSet: TDataSet);
    procedure tFluxoBeforePost(ADataset : TDataSet);
    procedure tFluxoAfterPost(ADataset: TDataSet);
    procedure gFluxoDblClick(Sender: TObject);
    procedure ButtonLimparClick(Sender: TObject);
    procedure ButtonConsultarClick(Sender: TObject);
    procedure ButtonSalvarClick(Sender: TObject);
  private
    fList_Conta : TFin_ContaList;
    fObj_Conta : TFin_Conta;
    fList_Fluxo : TFin_FluxoList;
    fObj_Fluxo : TFin_Fluxo;
    fList_Movto : TFin_MovtoList;
    fObj_Movto : TFin_Movto;
    procedure Carregar();
    procedure DesCarregar();
    procedure Limpar();
    procedure Consultar();
    procedure Salvar();
  protected
    function GetObj_Fluxo() : TFin_Fluxo;
    procedure SetObj_Fluxo(AObj_Fluxo : TFin_Fluxo);
  public
    constructor Create(AOwner : TComponent); override;
  published
    property Obj_Fluxo : TFin_Fluxo read GetObj_Fluxo write SetObj_Fluxo;
  end;

var
  F_Finan: TF_Finan;

implementation

{$R *.dfm}

uses
  mClientDataSet, mDataSet, mProperty, mObjeto, mClasse,
  mArquivo, mPath, mJson, mString, mMeses, ufrmMovto;

  function PegarContaPai(AConta : String) : String;
  var
    I : Integer;
  begin
    Result := '';

    I := Length(AConta);
    while (I > 0) and (AConta[I] <> '.') do
      Dec(I);

    if I > 0 then
      Result := Copy(AConta, 1, I - 1);
  end;

  function GetInCampo(pCdCampo, pInPago : String) : Boolean;
  var
    vDsMes : String;
    vNrMes : Integer;
  begin
    pInPago := IfThen(pInPago <> '', pInPago, TmString.Replicate('N', 12));
    vDsMes := TmString.LeftStr(pCdCampo, 'Vl_');
    vNrMes := TmMeses.Codigo(vDsMes);
    Result := Copy(pInPago, vNrMes, 1) = 'S';
  end;

  function SetInCampo(pCdCampo, pInPago, pInValue : String) : String;
  var
    vDsMes, vInPago : String;
    vNrMes : Integer;
  begin
    pInPago := IfThen(pInPago <> '', pInPago, TmString.Replicate('N', 12));
    vDsMes := TmString.LeftStr(pCdCampo, 'Vl_');
    vNrMes := TmMeses.Codigo(vDsMes);
    vInPago := Copy(pInPago, vNrMes, 1);
    vInPago := IfThen(vInPago = 'S', 'N', 'S');
    pInPago[vNrMes] := vInPago[1];
    Result := pInPago;
  end;

  procedure TF_Finan.Carregar();
  var
    vArquivo, vConteudo : String;
    I : Integer;
  begin
    vArquivo := TmPath.Dados() + 'conta.json';
    vConteudo := TmArquivo.Ler(vArquivo);
    fList_Conta.SetJson(vConteudo);
    if fList_Conta.Count = 0 then begin
      with fList_Conta do begin
        AddConta('1', 'D E S P E S A S', 'D');
        AddConta('1.101', '.COPEL', 'D');
        AddConta('1.102', '.SANEPAR', 'D');
        AddConta('1.103', '.NET', 'D');
        AddConta('1.104', '.ITAUCARD', 'D');
        AddConta('1.105', '.IPVA / DPVAT / LICENCIAMENTO', 'D');
        AddConta('1.105.01', '..PRISMA IPVA', 'D');
        AddConta('1.105.02', '..CB300 IPVA', 'D');
        AddConta('1.105.03', '..PRISMA DPVAT', 'D');
        AddConta('1.105.04', '..CB300 DPVAT', 'D');
        AddConta('1.106', '.IPTU', 'D');
        AddConta('1.107', '.SEGURO CONTRA TERCEIROS', 'D');
        AddConta('1.108', '.FABIANA', 'D');
        AddConta('1.108.01', '..ALUGUEL', 'D');
        AddConta('1.108.02', '..COOPER', 'D');
        AddConta('1.109', '.RECARGA', 'D');
        AddConta('1.109.01', '..FABIANA TIM', 'D');
        AddConta('1.109.02', '..FABIANA VIVO', 'D');
        AddConta('1.109.03', '..MIGUEL TIM', 'D');
        AddConta('1.109.04', '..MIGUEL VIVO', 'D');
        AddConta('1.109.05', '..TALIANE TIM', 'D');
        AddConta('1.109.06', '..TALIANE VIVO', 'D');
        AddConta('1.999', '.OUTRAS DESPESAS', 'D');

        AddConta('2', 'R E C E I T A S', 'C');
        AddConta('2.501', '.SALARIO', 'C');
        AddConta('2.502', '.FERIAS', 'C');
        AddConta('2.503', '.13 SALARIO', 'C');
        AddConta('2.504', '.BENEFICIO', 'C');
        AddConta('2.504.01', '..COOPER', 'C');
        AddConta('2.504.02', '..UNIMED', 'C');
        AddConta('2.506', '.PLR', 'C');
        AddConta('2.507', '.ALUGUEL', 'C');
        AddConta('2.999', '.OUTRAS RECEITAS', 'C');

        AddConta('3', 'S A L D O    (RECEITA - DESPESA)', 'S', '{2}-{1}');
        AddConta('4', 'S A L D O    (BANCO)', 'S');
        AddConta('5', 'S A L D O    (RECEITA - DESPESA + BANCO)', 'S', '{2}-{1}+{4}');
      end;

      DesCarregar();
    end;

    vArquivo := TmPath.Dados() + 'fluxo.' + EditReferencia.Text + '.json';
    vConteudo := TmArquivo.Ler(vArquivo);
    fList_Fluxo.SetJson(vConteudo);
    if fList_Fluxo.Count = 0 then begin
      for I := 0 to fList_Conta.Count - 1 do begin
        with fList_Fluxo.Add do begin
          Obj_Conta := fList_Conta.Items[I];
          Cd_Conta := Obj_Conta.Cd_Conta;
          Ds_Conta := Obj_Conta.Ds_Conta;
          Tp_Conta := Obj_Conta.Tp_Conta;
          Ds_Formula := Obj_Conta.Ds_Formula;
        end;
      end;
      
      DesCarregar();
    end;

    vArquivo := TmPath.Dados() + 'movto.' + EditReferencia.Text + '.json';
    vConteudo := TmArquivo.Ler(vArquivo);
    fList_Movto.SetJson(vConteudo);
  end;

  procedure TF_Finan.DesCarregar();
  var
    vArquivo, vConteudo : String;
  begin
    vArquivo := TmPath.Dados() + 'conta.json';
    vConteudo := fList_Conta.GetJson();
    TmArquivo.Gravar(vArquivo, vConteudo);

    vArquivo := TmPath.Dados() + 'fluxo.' + EditReferencia.Text + '.json';
    vConteudo := fList_Fluxo.GetJson();
    TmArquivo.Gravar(vArquivo, vConteudo);

    vArquivo := TmPath.Dados() + 'movto.' + EditReferencia.Text + '.json';
    vConteudo := fList_Movto.GetJson();
    TmArquivo.Gravar(vArquivo, vConteudo);
  end;

  //--

  procedure TF_Finan.Limpar();
  begin
    tFluxo.EmptyDataSet;
  end;

  procedure TF_Finan.Consultar();
  begin
    TmDataSet.SetCollection(tFluxo, fList_Fluxo);
  end;

  procedure TF_Finan.Salvar();
  var
    vCollection : TCollection;
    vJson : String;
  begin
    vCollection := TmDataSet.GetCollection(tFluxo, TFin_Fluxo);
    vJson := TmJson.CollectionToJson(vCollection);
    fList_Fluxo.SetJson(vJson);
    DesCarregar();
  end;

  //--

  function TF_Finan.GetObj_Fluxo() : TFin_Fluxo;
  begin
    TmObjeto.SetValues(fObj_Fluxo, TmDataSet.GetValues(tFluxo));
    Result := fObj_Fluxo;
  end;

  procedure TF_Finan.SetObj_Fluxo(AObj_Fluxo : TFin_Fluxo);
  begin
    TmDataSet.SetValues(tFluxo, TmObjeto.GetValues(fObj_Fluxo));
  end;

{ TF_Finan }

constructor TF_Finan.Create(AOwner: TComponent);
begin
  inherited;

  fList_Conta := TFin_ContaList.Create(Self);
  fObj_Conta := TFin_Conta.Create(nil);
  fList_Fluxo := TFin_FluxoList.Create(Self);
  fObj_Fluxo := TFin_Fluxo.Create(nil);
  fList_Movto := TFin_MovtoList.Create(Self);
  fObj_Movto := TFin_Movto.Create(nil);

  EditReferencia.Text := FormatDateTime('yyyy', Date);

  TmClientDataSet.SetFields(tFluxo, TmClasse.GetProperties(TFin_Fluxo));
  TmClientDataSet.SetInVisible(tFluxo, ['u_version', 'cd_operador', 'dt_cadastro', 'in_pago']);
  TmClientDataSet.SetFieldList(tFluxo, [
    TmClientDataSet_Field.Create('cd_conta', 'Conta', 8),
    TmClientDataSet_Field.Create('ds_conta', 'Descricao', 20),
    TmClientDataSet_Field.Create('tp_conta', 'T', 1),
    TmClientDataSet_Field.Create('ds_formula', 'Formula', 5),
    TmClientDataSet_Field.Create('vl_total', 'Total', 10),
    TmClientDataSet_Field.Create('vl_media', 'Media', 10),
    TmClientDataSet_Field.Create('vl_janeiro', 'Jan', 8),
    TmClientDataSet_Field.Create('vl_fevereiro', 'Fev', 8),
    TmClientDataSet_Field.Create('vl_marco', 'Mar', 8),
    TmClientDataSet_Field.Create('vl_abril', 'Abr', 8),
    TmClientDataSet_Field.Create('vl_maio', 'Mai', 8),
    TmClientDataSet_Field.Create('vl_junho', 'Jun', 8),
    TmClientDataSet_Field.Create('vl_julho', 'Jul', 8),
    TmClientDataSet_Field.Create('vl_agosto', 'Ago', 8),
    TmClientDataSet_Field.Create('vl_setembro', 'Set', 8),
    TmClientDataSet_Field.Create('vl_outubro', 'Out', 8),
    TmClientDataSet_Field.Create('vl_novembro', 'Nov', 8),
    TmClientDataSet_Field.Create('vl_dezembro', 'Dez', 8)]);

  Carregar();

  Consultar();
end;

//--

procedure TF_Finan.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: Close();
    VK_F2: Limpar();
    VK_F3: Salvar();
    VK_F4: Consultar();
  end;
end;

//--

const
  cLst_Campo = 'Cd_Conta,Ds_Conta,Tp_Conta,Ds_Formula,Vl_Total,Vl_Media';

procedure TF_Finan.gFluxoDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  vCdCampo, vCdContaPai : String;
  vInPago : Boolean;
begin
  TmObjeto.SetValues(fObj_Fluxo, TmDataSet.GetValues(tFluxo));

  vCdCampo := Column.FieldName;
  vCdContaPai := PegarContaPai(fObj_Fluxo.Cd_Conta);

  with TDBGrid(Sender) do begin
  
    //-- Saldo
    if fObj_Fluxo.Tp_Conta = 'S' then begin
      Canvas.Font.Color := clBlack;
      Canvas.Brush.Color := clYellow;

    //-- Analitico
    end else if fObj_Fluxo.Tp_Conta = 'A' then begin
      Canvas.Font.Color := clWhite;
      Canvas.Brush.Color := clMedGray;

    //-- Campo descricao
    end else if (Pos(vCdCampo, cLst_Campo) > 0) or (vCdContaPai = '') then begin
      if fObj_Fluxo.Tp_Conta = 'D' then begin
        Canvas.Font.Color := clWhite;
        Canvas.Brush.Color := clRed;
      end else begin
        Canvas.Font.Color := clWhite;
        Canvas.Brush.Color := clGreen;
      end;

    //-- Campo valor  
    end else begin
      vInPago := GetInCampo(vCdCampo, fObj_Fluxo.In_Pago);
      if vInPago then begin
        Canvas.Font.Color := clBlack;
        Canvas.Brush.Color := clWhite;
      end else if fObj_Fluxo.Tp_Conta = 'D' then begin
        Canvas.Font.Color := clRed;
        Canvas.Brush.Color := clWhite;
      end else begin
        Canvas.Font.Color := clGreen;
        Canvas.Brush.Color := clWhite;
      end;
      
    end;

    Canvas.FillRect(Rect);
    DefaultDrawDataCell(Rect, Columns[Datacol].Field, State);
  end;
end;

procedure TF_Finan.gFluxoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  with gFluxo.SelectedField do begin
    if Pos(FieldName, cLst_Campo) > 0 then
      Exit;

    // Ctrl + C
    if ssCtrl in Shift then
      if Chr(Key) in ['C', 'c'] then
        Clipboard.AsText := TmDataSet.PegarS(tFluxo, FieldName);

    // Ctrl + V
    if ssCtrl in Shift then
      if Chr(Key) in ['V', 'v'] then
        TmDataSet.SetarS(tFluxo, FieldName, Clipboard.AsText);
  end;
end;

//--

procedure TF_Finan.tFluxoNewRecord(DataSet: TDataSet);
begin
  TmDataSet.SetarS(tFluxo, 'In_Pago', TmString.Replicate('N', 12));
end;

procedure TF_Finan.tFluxoBeforePost(ADataset: TDataSet);
begin
  Obj_Fluxo := Obj_Fluxo.Totalizar();
end;

procedure TF_Finan.tFluxoAfterPost(ADataset: TDataSet);

  function GetFluxoTotal(AConta : String) : TFin_Fluxo;
  var
    vCdConta, vCdContaPai : String;
    vRecNo : Integer;
  begin
    Result := nil;

    with tFluxo do begin
      vRecNo := RecNo;

      First;
      while not EOF do begin
        vCdConta := TmDataSet.PegarS(tFluxo, 'Cd_Conta');
        vCdContaPai := PegarContaPai(vCdConta);

        if vCdContaPai = AConta then begin
          if not Assigned(Result) then
            Result := TFin_Fluxo.Create(nil);
          Result.Adicionar(Obj_Fluxo);
        end;

        Next;
      end;

      if vRecNo > 0 then
        RecNo := vRecNo;
    end;
  end;

var
  vCdConta : String;
  vNotify : TmDataSet_Notify;
  vObj_Fluxo_Total : TFin_Fluxo;
  vRecNo : Integer;
begin
  with tFluxo do begin
    DisableControls;

    vRecNo := RecNo;

    vNotify := TmDataSet.GetNotify(tFluxo);
    TmDataSet.ClearNotify(ADataSet);

    Last;
    while not BOF do begin
      vCdConta := Obj_Fluxo.Cd_Conta;

      vObj_Fluxo_Total := GetFluxoTotal(vCdConta);
      if Assigned(vObj_Fluxo_Total) then begin
        Obj_Fluxo := Obj_Fluxo.Setar(vObj_Fluxo_Total);
        FreeAndNil(vObj_Fluxo_Total);
      end;

      Prior;
    end;

    TmDataSet.SetNotify(tFluxo, vNotify);

    if vRecNo > 0 then
      RecNo := vRecNo;

    EnableControls;
  end;
end;

procedure TF_Finan.gFluxoDblClick(Sender: TObject);
var
  vObj_Movto, vObj_MovtoAux : TFin_Movto;
  vCdConta, vCdMes : String;
begin
  vCdConta := TmDataSet.PegarS(tFluxo, 'Cd_Conta');
  if vCdConta = '' then
    Exit;

  with gFluxo.SelectedField do
    if Pos(FieldName, cLst_Campo) = 0 then
      vCdMes := FieldName
    else
      Exit;

  // filtro
  vObj_Movto := TFin_Movto.Create(vCdConta, vCdMes);

  // procura
  vObj_MovtoAux := fList_Movto.IndexOf(vObj_Movto);
  if Assigned(vObj_MovtoAux) then
    vObj_Movto := vObj_MovtoAux;

  // formulario
  vObj_Movto := TF_Movto.Execute(vObj_Movto);
  if not Assigned(vObj_Movto) then
    Exit;

  if not Assigned(vObj_MovtoAux) then
    fObj_Movto := fList_Movto.Add;

  with fObj_Movto do begin
    Cd_Conta := vObj_Movto.Cd_Conta;
    Cd_Mes := vObj_Movto.Cd_Mes;
    Ds_Conteudo := vObj_Movto.Ds_Conteudo;
    Vl_Total := vObj_Movto.Vl_Total;
    Tp_Total := vObj_Movto.Tp_Total;
  end;

  TmDataSet.SetarF(tFluxo, vCdMes, vObj_Movto.Vl_Total);
end;

procedure TF_Finan.ButtonLimparClick(Sender: TObject);
begin
  Limpar();
end;

procedure TF_Finan.ButtonConsultarClick(Sender: TObject);
begin
  Consultar();
end;

procedure TF_Finan.ButtonSalvarClick(Sender: TObject);
begin
  Salvar();
  ShowMessage('Gravacao efetuada com sucesso');
end;

end.
