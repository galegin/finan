program pFinan;

uses
  Forms,
  ufrmFinan in 'ufrmFinan.pas' {F_Finan},
  uFinFluxo in 'uFinFluxo.pas',
  uFinConta in 'uFinConta.pas',
  uFinMovto in 'uFinMovto.pas',
  ufrmMovto in 'ufrmMovto.pas' {F_Movto};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'pFinan';
  Application.CreateForm(TF_Finan, F_Finan);
  Application.Run;
end.
