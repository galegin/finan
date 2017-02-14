unit uFinConta;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TFin_Conta = class;
  TFin_ContaClass = class of TFin_Conta;

  TFin_ContaList = class;
  TFin_ContaListClass = class of TFin_ContaList;

  TFin_Conta = class(TmCollectionItem)
  private
    fCd_Conta: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDs_Conta: String;
    fTp_Conta: String;
    fDs_Formula: String;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  published
    property Cd_Conta: String read fCd_Conta write fCd_Conta;
    property U_Version: String read fU_Version write fU_Version;
    property Cd_Operador: Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro: TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Conta: String read fDs_Conta write fDs_Conta;
    property Tp_Conta: String read fTp_Conta write fTp_Conta;
    property Ds_Formula: String read fDs_Formula write fDs_Formula;
  end;

  TFin_ContaList = class(TmCollection)
  private
    function GetItem(Index: Integer): TFin_Conta;
    procedure SetItem(Index: Integer; Value: TFin_Conta);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TFin_Conta;
    procedure AddConta(
      ACd_Conta: String;
      ADs_Conta: String;
      ATp_Conta: String;
      ADs_Formula: String = '');
    property Items[Index: Integer]: TFin_Conta read GetItem write SetItem; default;
  end;

implementation

{ TFin_Conta }

constructor TFin_Conta.Create(Collection: TCollection);
begin
  inherited;
end;

destructor TFin_Conta.Destroy;
begin
  inherited;
end;

{ TFin_ContaList }

constructor TFin_ContaList.Create(AOwner: TPersistent);
begin
  inherited Create(TFin_Conta);
end;

function TFin_ContaList.Add: TFin_Conta;
begin
  Result := TFin_Conta(inherited Add);
  Result.create(Self);
end;

procedure TFin_ContaList.AddConta;
begin
  with Add do begin
    Cd_Conta := ACd_Conta;
    Ds_Conta := ADs_Conta;
    Tp_Conta := ATp_Conta;
    Ds_Formula := ADs_Formula;
  end;
end;

function TFin_ContaList.GetItem(Index: Integer): TFin_Conta;
begin
  Result := TFin_Conta(inherited GetItem(Index));
end;

procedure TFin_ContaList.SetItem(Index: Integer; Value: TFin_Conta);
begin
  inherited SetItem(Index, Value);
end;

end.
