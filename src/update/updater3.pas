unit updater3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ComCtrls, process, ExtCtrls, inifiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Process1: TProcess;
    Process2: TProcess;
    ProgressBar1: TProgressBar;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);



  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 
  theupdater: TInifile;
  zclver: Tinifile;
implementation

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);

begin
theupdater := Tinifile.Create('update.ini'); //ZOMG WTF?
zclver := Tinifile.Create('zcl.ini'); //This will be used also
//theupdater.Create('update.ini'); <-- EPIC FAIL!
label3.caption:= 'Downloading updates. (Screen May Freeze while Downloading)';
progressbar1.Position:= 1;
update;

if fileexists('update.ini') then begin
{$ifdef win32}
process1.CommandLine := 'wget ' + theupdater.ReadString('UPDATE', 'WINDOWSLINK', '');
{$endif}
{$ifdef linux}
process1.CommandLine := 'wget ' + theupdater.ReadString('UPDATE', 'LINUXLINK', '');
{$endif}
process1.execute;
progressbar1.Position:= 2;
label3.Caption:= 'Applying Updates';
update;
{$ifdef win32}
process1.CommandLine := theupdater.readstring('UPDATE', 'WUZIP', '');
{$endif}
{$ifdef linux}
process1.CommandLine := theupdater.ReadString('UPDATE', 'LUTAR', '');
process1.execute;
process1.CommandLine := 'chmod 777 zlaunch-l';
process1.execute;
process1.CommandLine := 'chmod 777 zelda-l';
process1.execute;
process1.CommandLine := 'chmod 777 zquest-l';
{$endif linux}

process1.Execute;
label3.Caption:= 'Cleaning Up';
progressbar1.position:= 3;
update;
//Cleanup Time
{$ifdef win32}
deletefile(theupdater.ReadString('UPDATE', 'CLEANW', ''));
deletefile('unzip.exe');
{$endif}

{$ifdef linux}
deletefile(theupdater.ReadString('UPDATE', 'CLEANL', ''));
{$endif}



//This will set the new file version Shh it's a secret to everyone :o
zclver.WriteString('VERSIONS', 'ZELDAWIN', theupdater.readstring('UPDATE', 'WINDOWS', ''));
zclver.WriteString('VERSIONS', 'ZELDALIN', theupdater.readstring('UPDATE', 'LINUX', ''));

label3.Caption:= 'Press Launch to Start';
button2.Enabled:= true;
button1.Enabled:= false;
progressbar1.Position:= 4;
end else begin
Label3.Caption:= 'Uh where is update.ini?';
end;


end;

procedure TForm1.Button2Click(Sender: TObject);
begin

{$ifdef win32}
process2.CommandLine := './zlaunch-w.exe';
{$endif}
{$ifdef linux}
process2.CommandLine := './zlaunch-l';
{$endif}
process2.Execute;
application.terminate;
end;

procedure TForm1.FormShow(Sender: TObject);
begin

end;

initialization
  {$I updater3.lrs}

end.

