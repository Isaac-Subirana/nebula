; SEE THE DOCUMENTATION FOR DETAILS ON CREATING .ISS SCRIPT FILES!

[Setup]
AppName={cm:MyAppName}
AppId=Nebula
AppVerName={cm:MyAppVerName}
WizardStyle=modern
DefaultDirName={code:GetDefaultDirName}
DefaultGroupName={cm:MyAppName}
UninstallDisplayIcon={app}\chrome.exe
VersionInfoDescription=Nebula Installer
VersionInfoProductName=Nebula Installer
OutputDir=userdocs:Inno Setup Examples Output
MissingMessagesWarning=yes
NotRecognizedMessagesWarning=yes
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
DisableDirPage=yes

[Languages]

Name: ca; MessagesFile: "compiler:Languages\Catalan.isl"
Name: es; MessagesFile: "compiler:Languages\Spanish.isl"
Name: en; MessagesFile: "compiler:Default.isl"

[Messages]

ca.BeveledLabel=Catalan
es.BeveledLabel=Español
en.BeveledLabel=English

[CustomMessages]

ca.MyAppName=Nebula
es.MyAppName=Nebula
en.MyAppName=Nebula

ca.MyAppVerName=L'Instal·lador de Nebula. El pot desinstal·lar, no causarà cap problema a la seva instal·lació de Nebula.
es.MyAppVerName=El Instalador de Nebula. Puede desinstalarlo, no va a causar problemas a su instalación de Nebula.
en.MyAppVerName=Nebula Installer. You can uninstall it, it will not cause trouble to your Nebula installation.

ca.Installing=Instal·lant Nebula... 
es.Installing=Instalando Nebula...
en.Installing=Installing Nebula...

ca.Opening=Obrint Nebula...
es.Opening=Abriendo Nebula...
en.Opening=Opening Nebula...

ca.Finished=Instal·lació finalitzada.
es.Finished=Instalación finalizada.
en.Finished=Installation finished.

[Files]

Source: "mini_installer.exe"; DestDir: "{tmp}"; Flags: ignoreversion

[Code]

var
  MiniInstallerArgs: string;
  CMDKillCommand: string;
  OpenCommand: string;
  
  ResultCode: integer;

function GetDefaultDirName(Value: string): string;
begin
  if IsAdminLoggedOn then
    Result := ExpandConstant('{autopf}\Nebula')
  else
    Result := ExpandConstant('{userappdata}\Nebula');
end;

procedure InitializeWizard();
begin
  if IsAdminLoggedOn then
    begin
      MiniInstallerArgs := '--system-level';
      OpenCommand := ExpandConstant('/C "C:\Program Files\Chromium\Application\chrome.exe"')
    end
  else
    begin
      MiniInstallerArgs := '';
      OpenCommand := ExpandConstant('')
    end
end;

procedure CurStepChanged(CurStep: TSetupStep);

begin

  if CurStep = ssPostInstall then
  begin
  
    WizardForm.ProgressGauge.Style := npbstMarquee;
    WizardForm.ProgressGauge.Visible := True;
    
    WizardForm.StatusLabel.Caption := ExpandConstant('{cm:Installing}');
    Exec(ExpandConstant('{tmp}\mini_installer.exe'), MiniInstallerArgs, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    
    //Sleep(2000);
    WizardForm.StatusLabel.Caption := ExpandConstant('{cm:Opening}');
    Exec('cmd.exe', OpenCommand, '', SW_HIDE, ewNoWait, ResultCode);
    
    Sleep(500);

    WizardForm.StatusLabel.Caption := ExpandConstant('{cm:Finished}');
    WizardForm.ProgressGauge.Style := npbstNormal;
    WizardForm.ProgressGauge.Position := WizardForm.ProgressGauge.Max;
    
  end;
end;