unit uFinFluxo;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem,
  uFinConta;

type
  TFin_Fluxo = class;
  TFin_FluxoClass = class of TFin_Fluxo;

  TFin_FluxoList = class;
  TFin_FluxoListClass = class of TFin_FluxoList;

  TFin_Fluxo = class(TmCollectionItem)
  private
    fCd_Conta: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDs_Conta: String;
    fTp_Conta: String;
    fDs_Formula: String;
    fVl_Total: Real;
    fVl_Media: Real;
    fVl_Janeiro: Real;
    fVl_Fevereiro: Real;
    fVl_Marco: Real;
    fVl_Abril: Real;
    fVl_Maio: Real;
    fVl_Junho: Real;
    fVl_Julho: Real;
    fVl_Agosto: Real;
    fVl_Setembro: Real;
    fVl_Outubro: Real;
    fVl_Novembro: Real;
    fVl_Dezembro: Real;
    fIn_Pago: String;

    fObj_Conta: TFin_Conta;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    function Limpar() : TFin_Fluxo;
    function Totalizar() : TFin_Fluxo;
    function Setar(AObj_Fluxo : TFin_Fluxo) : TFin_Fluxo;
    function Adicionar(AObj_Fluxo : TFin_Fluxo) : TFin_Fluxo;
  published
    property Cd_Conta: String read fCd_Conta write fCd_Conta;
    property U_Version: String read fU_Version write fU_Version;
    property Cd_Operador: Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro: TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Conta: String read fDs_Conta write fDs_Conta;
    property Ds_Formula: String read fDs_Formula write fDs_Formula;
    property Tp_Conta: String read fTp_Conta write fTp_Conta;
    property Vl_Total: Real read fVl_Total write fVl_Total;
    property Vl_Media: Real read fVl_Media write fVl_Media;
    property Vl_Janeiro: Real read fVl_Janeiro write fVl_Janeiro;
    property Vl_Fevereiro: Real read fVl_Fevereiro write fVl_Fevereiro;
    property Vl_Marco: Real read fVl_Marco write fVl_Marco;
    property Vl_Abril: Real read fVl_Abril write fVl_Abril;
    property Vl_Maio: Real read fVl_Maio write fVl_Maio;
    property Vl_Junho: Real read fVl_Junho write fVl_Junho;
    property Vl_Julho: Real read fVl_Julho write fVl_Julho;
    property Vl_Agosto: Real read fVl_Agosto write fVl_Agosto;
    property Vl_Setembro: Real read fVl_Setembro write fVl_Setembro;
    property Vl_Outubro: Real read fVl_Outubro write fVl_Outubro;
    property Vl_Novembro: Real read fVl_Novembro write fVl_Novembro;
    property Vl_Dezembro: Real read fVl_Dezembro write fVl_Dezembro;
    property In_Pago: String read fIn_Pago write fIn_Pago;

    property Obj_Conta: TFin_Conta read fObj_Conta write fObj_Conta;
  end;

  TFin_FluxoList = class(TmCollection)
  private
    function GetItem(Index: Integer): TFin_Fluxo;
    procedure SetItem(Index: Integer; Value: TFin_Fluxo);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TFin_Fluxo;
    property Items[Index: Integer]: TFin_Fluxo read GetItem write SetItem; default;
  end;

implementation

uses
  mFloat;

{ TFin_Fluxo }

constructor TFin_Fluxo.Create(Collection: TCollection);
begin
  inherited;
  fObj_Conta:= TFin_Conta.Create(nil);
end;

destructor TFin_Fluxo.Destroy;
begin
  inherited;
end;

//--

function TFin_Fluxo.Limpar : TFin_Fluxo;
begin
  Vl_Janeiro := 0;
  Vl_Fevereiro := 0;
  Vl_Marco := 0;
  Vl_Abril := 0;
  Vl_Maio := 0;
  Vl_Junho := 0;
  Vl_Julho := 0;
  Vl_Agosto := 0;
  Vl_Setembro := 0;
  Vl_Outubro := 0;
  Vl_Novembro := 0;
  Vl_Dezembro := 0;

  Vl_Total := 0;
  Vl_Media := 0;

  Result := Self;
end;

function TFin_Fluxo.Totalizar : TFin_Fluxo;
begin
  Vl_Total := Vl_Janeiro + Vl_Fevereiro + Vl_Marco + Vl_Abril + Vl_Maio +
    Vl_Junho + Vl_Julho + Vl_Agosto + Vl_Setembro + Vl_Outubro + Vl_Novembro +
    Vl_Dezembro;

  Vl_Media := TmFloat.Rounded( Vl_Total / 12, 2);

  Result := Self;
end;

function TFin_Fluxo.Setar(AObj_Fluxo : TFin_Fluxo) : TFin_Fluxo;
begin
  Limpar();

  Adicionar(AObj_Fluxo);
end;

function TFin_Fluxo.Adicionar(AObj_Fluxo : TFin_Fluxo) : TFin_Fluxo;
begin
  Vl_Janeiro := Vl_Janeiro + AObj_Fluxo.fVl_Janeiro;
  Vl_Fevereiro := Vl_Fevereiro + AObj_Fluxo.Vl_Fevereiro;
  Vl_Marco := Vl_Marco + AObj_Fluxo.Vl_Marco;
  Vl_Abril := Vl_Abril + AObj_Fluxo.Vl_Abril;
  Vl_Maio := Vl_Maio + AObj_Fluxo.Vl_Maio;
  Vl_Junho := Vl_Junho + AObj_Fluxo.Vl_Junho;
  Vl_Julho := Vl_Julho + AObj_Fluxo.Vl_Julho;
  Vl_Agosto := Vl_Agosto + AObj_Fluxo.Vl_Agosto;
  Vl_Setembro := Vl_Setembro + AObj_Fluxo.Vl_Setembro;
  Vl_Outubro := Vl_Outubro + AObj_Fluxo.Vl_Outubro;
  Vl_Novembro := Vl_Novembro + AObj_Fluxo.Vl_Novembro;
  Vl_Dezembro := Vl_Dezembro + AObj_Fluxo.Vl_Dezembro;

  Totalizar();
end;

{ TFin_FluxoList }

constructor TFin_FluxoList.Create(AOwner: TPersistent);
begin
  inherited Create(TFin_Fluxo);
end;

function TFin_FluxoList.Add: TFin_Fluxo;
begin
  Result := TFin_Fluxo(inherited Add);
  Result.create(Self);
end;

function TFin_FluxoList.GetItem(Index: Integer): TFin_Fluxo;
begin
  Result := TFin_Fluxo(inherited GetItem(Index));
end;

procedure TFin_FluxoList.SetItem(Index: Integer; Value: TFin_Fluxo);
begin
  inherited SetItem(Index, Value);
end;

end.
