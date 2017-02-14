unit uFinMovto;

(* classe modelagem *)

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TFin_Movto = class;
  TFin_MovtoClass = class of TFin_Movto;

  TFin_MovtoList = class;
  TFin_MovtoListClass = class of TFin_MovtoList;

  TFin_Movto = class(TmCollectionItem)
  private
    fCd_Conta: String;
    fCd_Mes: String;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fDs_Conteudo: String;
    fVl_Total: Real;
    fTp_Total: String;
  public
    constructor Create(ACollection: TCollection); overload; override;
    constructor Create(ACd_Conta: String; ACd_Mes: String); overload;
    destructor Destroy; override;
    function GetHashCode: String;
  published
    property Cd_Conta: String read fCd_Conta write fCd_Conta;
    property Cd_Mes: String read fCd_Mes write fCd_Mes;
    property U_Version: String read fU_Version write fU_Version;
    property Cd_Operador: Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro: TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Conteudo: String read fDs_Conteudo write fDs_Conteudo;
    property Vl_Total: Real read fVl_Total write fVl_Total;
    property Tp_Total: String read fTp_Total write fTp_Total;
  end;

  TFin_MovtoList = class(TmCollection)
  private
    function GetItem(Index: Integer): TFin_Movto;
    procedure SetItem(Index: Integer; Value: TFin_Movto);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TFin_Movto;
    function IndexOf(AObj_Movto: TFin_Movto) : TFin_Movto;
    property Items[Index: Integer]: TFin_Movto read GetItem write SetItem; default;
  end;

implementation

{ TFin_Movto }

constructor TFin_Movto.Create(ACollection: TCollection);
begin
  inherited;

end;

constructor TFin_Movto.Create(ACd_Conta, ACd_Mes: String);
begin
  fCd_Conta := ACd_Conta;
  fCd_Mes := ACd_Mes;
end;

destructor TFin_Movto.Destroy;
begin

  inherited;
end;

function TFin_Movto.GetHashCode: String;
begin
  Result := Cd_Conta + '#' + Cd_Mes;
end;

{ TFin_MovtoList }

constructor TFin_MovtoList.Create(AOwner: TPersistent);
begin
  inherited Create(TFin_Movto);
end;

function TFin_MovtoList.Add: TFin_Movto;
begin
  Result := TFin_Movto(inherited Add);
  Result.create(Self);
end;

function TFin_MovtoList.GetItem(Index: Integer): TFin_Movto;
begin
  Result := TFin_Movto(inherited GetItem(Index));
end;

procedure TFin_MovtoList.SetItem(Index: Integer; Value: TFin_Movto);
begin
  inherited SetItem(Index, Value);
end;

function TFin_MovtoList.IndexOf(AObj_Movto: TFin_Movto): TFin_Movto;
var
  I : Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    if Items[I].GetHashCode() = AObj_Movto.GetHashCode() then begin
      Result := Items[I];
      Exit;
    end;
end;

end.
