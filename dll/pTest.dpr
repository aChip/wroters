program pTest;

uses
  Forms,
  uTest in 'uTest.pas' {Form1},
  uMain in 'uMain.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.