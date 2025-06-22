#define MyAppName "Markdown Editor"
#define MyAppPublisher "Adeeteya"
#define MyAppPublisherURL "https://github.com/adeeteya/"
#define MyAppURL "https://github.com/adeeteya/FlutterMarkdownEditor"
#define MyAppExeName "MarkdownEditor.exe"
#define MyAppContact "adeeteya@gmail.com"
#define MyAppCopyright "Copyright (C) 2025 Adeeteya"

[Setup]
AppId={{B23EEE54-4907-4B4A-9739-A56313D52E7A}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppPublisherURL}
AppSupportURL={#MyAppURL}
AppReadmeFile={#MyAppURL}/README.md
AppUpdatesURL={#MyAppURL}/releases/latest
AppComments={#MyAppName}
AppContact={#MyAppContact}
AppCopyright={#MyAppCopyright}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
OutputDir=C:\a\FlutterMarkdownEditor\FlutterMarkdownEditor\
OutputBaseFilename=MarkdownEditor-Windows
SetupIconFile=C:\a\FlutterMarkdownEditor\FlutterMarkdownEditor\windows\runner\resources\app_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
VersionInfoProductName={#MyAppName}
VersionInfoDescription={#MyAppName} Setup
VersionInfoCompany={#MyAppPublisher}
VersionInfoVersion={#MyAppVersion}.0
VersionInfoProductTextVersion={#MyAppVersion}
VersionInfoCopyright={#MyAppCopyright}
UninstallDisplayIcon={app}\{#MyAppExeName}
UninstallDisplayName={#MyAppName}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\a\FlutterMarkdownEditor\FlutterMarkdownEditor\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{app}\uninstall-{#MyAppName}"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
