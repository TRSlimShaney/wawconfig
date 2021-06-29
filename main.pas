///////////////////////////////////////////////
//  Call of Duty: World at War Configurator
//  Written by Shane Stacy
///////////////////////////////////////////////
unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, Menus, Dos, FileUtil, strutils, Saved, About, ModManager;

type

  { TMainForm }

  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    FileItem: TMenuItem;
    ExitItem: TMenuItem;
    HelpItem: TMenuItem;
    AboutItem: TMenuItem;
    ModManagerItem: TMenuItem;
    SaveButton: TButton;
    AnimatedCheck: TCheckBox;
    BloodCheck: TCheckBox;
    BrassCheck: TCheckBox;
    StrongCheck: TCheckBox;
    SubtitlesCheck: TCheckBox;
    MicCheck: TCheckBox;
    SkipIntroCheck: TCheckBox;
    ControllerCheck: TCheckBox;
    LockCheck: TCheckBox;
    CorpseLimit: TEdit;
    FOV: TEdit;
    FPSLimit: TEdit;
    ResolutionBox: TGroupBox;
    ThumbBox: TGroupBox;
    AABox: TGroupBox;
    ProfileGroup: TGroupBox;
    ConfigGroup: TGroupBox;
    SettingsGroup: TGroupBox;
    ProfileList: TListBox;
    ConfigList: TListBox;
    ResolutionBar: TTrackBar;
    ThumbBar: TTrackBar;
    AABar: TTrackBar;
    procedure AboutItemClick(Sender: TObject);
    procedure ExitItemClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ModManagerItemClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure ConfigListSelectionChange(Sender: TObject; User: boolean);
    procedure FormActivate(Sender: TObject);
    procedure ProfileListSelectionChange(Sender: TObject; User: boolean);
    function SettingQuoted(Setting: String): String;
    function BoolToIntQuoted(i: Boolean): String;
    function StrIntToBool(i: String): Boolean;
  private
    // has the form been shown yet?
    FormShown: Boolean;
    // the path of where the profiles directory are stored
    ProfilesPath: String;
    // the path of the selected profile directory
    ProfilePath: String;
    // the name of the profile selected
    Profile: String;
    // the path of the selected config file
    ConfigPath: String;
    // the name of the config selected
    Config: String;
    // list of lines read from config file
    CfgContents: TStringList;
  public
    ModsPath: String; static;
    class function GetSelectedItem(list: TListBox): String;
    class procedure GetListOfFiles(list: TListBox; path: String; pattern: String);
    class procedure GetListOfFolders(list: TListBox; path: String);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormActivate(Sender: TObject);
var
  LocalAppDataDir: String;
begin
  // if form not shown yet
  if not FormShown then begin
    // build the path to the profiles directory
    LocalAppDataDir:= GetEnv('APPDATA')+PathDelim+'..'+PathDelim+'Local'+PathDelim+'Activision'+PathDelim+'CoDWaW'+PathDelim;
    ProfilesPath:= LocalAppDataDir+'players'+PathDelim+'profiles'+PathDelim;
    ModsPath:= LocalAppDataDir+'mods'+PathDelim;
    GetListOfFolders(ProfileList, ProfilesPath);
    ProfileGroup.Enabled:= True;
  end;
  // we have shown the form
  FormShown:= True;
end;

procedure TMainForm.ConfigListSelectionChange(Sender: TObject; User: boolean);
var
  // local file attribute to store read-only status
  attr: Word;
  // local counter integer
  i: Integer;
  // local config file pointer
  f: TextFile;
  // local Line is the current config line being interpreted
  // local settingsstr is the str extraction of the setting value
  Line, settingstr: String;
  // local split to process Line
  split: array of AnsiString;
begin
  // if memory CfgContents aren't empty, empty them
  if CfgContents <> nil then begin
     CfgContents.Free;
  end;
  // default value for gui element
  LockCheck.Checked:= False;
  // default value for gui element
  ControllerCheck.Checked:= False;
  // instantiate the CfgContents
  CfgContents:= TStringList.Create;
  // determine the selected config
  Config:= GetSelectedItem(ConfigList);
  // build the config file path
  ConfigPath:= ProfilePath+Config;
  // assign file pointer to the config file
  AssignFile(f, ConfigPath);
  try
    // put the pointer at the beginning of the file
    Reset(f);
    // while more to be read
    while not Eof(f) do begin
      // read the current line
      ReadLn(f, Line);
      // if there is data on this line,
      // add it to be processed
      if Line.Length > 0 then begin
        Line:= TrimRight(Line);
        CfgContents.Add(Line);
      end;
    end;
    // get the file's attributes
    GetFAttr(f, attr);
    // if the file is marked as read only
    if (attr and readonly)<>0 then begin
      // update the gui element
      LockCheck.Checked:= True;
    end;
  finally
    CloseFile(f);
  end;
  // process the CfgContents
  for i:= 0 to CfgContents.Count-1 do begin
    // copy the current line contents into Line
    Line:= Copy(CfgContents[i], 1, CfgContents[i].Length);
    // parse the setting value from the line
    // we get it by splitting the line based on quote delimiter
    split:= SplitString(Line, '"');
    // if we found a value
    if Length(split) >= 2 then begin
      // store the setting value
      settingstr:= split[Length(split)-2];
    end;
    // interpret file data to gui element state data
    if Line.Contains('seta ai_corpseCount') then begin
      CorpseLimit.Text:= settingstr;
    end
    else if Line.Contains('seta animated_trees_enabled') then begin
      AnimatedCheck.Checked:= StrIntToBool(settingstr);
    end
    else if Line.Contains('seta cg_blood ') then begin
      BloodCheck.Checked:= StrIntToBool(settingstr);
    end
    else if Line.Contains('seta cg_bloodLimit') then begin
    end
    else if Line.Contains('seta bloodLimitMsec') then begin
    end
    else if Line.Contains('seta cg_brass') then begin
      BrassCheck.Checked:= StrIntToBool(settingstr);
    end
    else if Line.Contains('seta cg_fov ') then begin
      FOV.Text:= settingstr;
    end
    else if Line.Contains('seta cg_fovMin') then begin
    end
    else if Line.Contains('seta cg_mature') then begin
      StrongCheck.Checked:= StrIntToBool(settingstr);
    end
    else if Line.Contains('seta cg_subtitles') then begin
      SubtitlesCheck.Checked:= StrIntToBool(settingstr);
    end
    else if Line.Contains('seta cl_voice') then begin
      MicCheck.Checked:= StrIntToBool(settingstr);
    end
    else if Line.Contains('seta com_introPlayed') then begin
      SkipIntroCheck.Checked:= StrIntToBool(settingstr);
    end
    else if Line.Contains('seta com_maxfps') then begin
      FPSLimit.Text:= settingstr;
    end
    else if Line.Contains('seta r_aaSamples') then begin
      case (settingstr) of
        '0': begin
            AABar.Position:= 0;
        end;
        '2': begin
            AABar.Position:= 1;
        end;
        '4': begin
            AABar.Position:= 2;
        end;
        '8': begin
            AABar.Position:= 3;
        end;
        else begin
        end;
      end;
    end
    else if Line.Contains('seta r_mode') then begin
      case (settingstr) of
        '1280x720': begin
            ResolutionBar.Position:= 0;
        end;
        '1600x900': begin
            ResolutionBar.Position:= 1;
        end;
        '1920x1080': begin
            ResolutionBar.Position:= 2;
        end;
        '2560x1440': begin
            ResolutionBar.Position:= 3;
        end;
        else begin
        end;
      end;
    end
    else if Line.Contains('exec default_controller.cfg') then begin
      if CompareText(Line, 'exec default_controller.cfg')=0 then begin
         ControllerCheck.Checked:= True;
      end;
    end
    else if Line.Contains('input_viewSensitivity') then begin
      split:= SplitString(Line, ' ');
      settingstr:= split[Length(split)-1];
      case (settingstr) of
        '1': begin
            ThumbBar.Position:= 0;
        end;
        '2': begin
            ThumbBar.Position:= 1;
        end;
        '3': begin
            ThumbBar.Position:= 2;
        end;
        '4': begin
            ThumbBar.Position:= 3;
        end;
        '5': begin
            ThumbBar.Position:= 4;
        end;
        else begin
          ThumbBar.Position:= 0;
        end;
      end;
    end;
  end;
  // make the loaded settings visible
  SettingsGroup.Enabled:= True;
end;

procedure TMainForm.SaveButtonClick(Sender: TObject);
var
  // local file attribute
  attr: Word;
  // local config file pointer
  f: TextFile;
  // local counter integer
  i: Integer;
  // local Line is where we store the current line
  // local settingstr is the parsed setting value
  Line, settingstr: String;
begin
  // assign file pointer to the config file
  AssignFile(f, ConfigPath);
  // get the file's attributes
  GetFAttr(f, attr);
  // if it's marked as read-only
  if (attr and readonly)<>0 then begin
    // we need to temporarily remove this attrib to write to the file
    SetFAttr(f, attr and not readonly);
  end;

  try
    // put the pointer at the start of the file
    Rewrite(f);
    // iterate over the memory CfgContents
    for i:= 0 to CfgContents.Count-1 do begin
      // copy the current line into Line
      Line:= Copy(CfgContents[i], 1, CfgContents[i].Length);
      // convert the gui element statuses into waw config data
      if Line.Contains('seta ai_corpseCount') then begin
        WriteLn(f, 'seta ai_corpseCount '+SettingQuoted(CorpseLimit.Text));
      end
      else if Line.Contains('seta animated_trees_enabled') then begin
        WriteLn(f, 'seta animated_trees_enabled '+BoolToIntQuoted(AnimatedCheck.Checked));
      end
      else if Line.Contains('seta cg_blood') then begin
        WriteLn(f, 'seta cg_blood '+BoolToIntQuoted(BloodCheck.Checked));
      end
      else if Line.Contains('seta cg_bloodLimit') then begin
      end
      else if Line.Contains('seta bloodLimitMsec') then begin
      end
      else if Line.Contains('seta cg_brass') then begin
        WriteLn(f, 'seta cg_brass '+BoolToIntQuoted(BrassCheck.Checked));
      end
      else if Line.Contains('seta cg_fov ') then begin
        settingstr:= Trim(FOV.Text);
        WriteLn(f, 'seta cg_fov '+SettingQuoted(settingstr));
      end
      else if Line.Contains('seta cg_fovMin') then begin
        settingstr:= Trim(FOV.Text);
        WriteLn(f, 'seta cg_fovMin '+SettingQuoted(settingstr));
      end
      else if Line.Contains('seta cg_mature') then begin
        WriteLn(f, 'seta cg_mature '+BoolToIntQuoted(StrongCheck.Checked));
      end
      else if Line.Contains('seta cg_subtitles') then begin
        WriteLn(f, 'seta cg_subtitles '+BoolToIntQuoted(SubtitlesCheck.Checked));
      end
      else if Line.Contains('seta cl_voice') then begin
        WriteLn(f, 'seta cl_voice '+BoolToIntQuoted(MicCheck.Checked));
      end
      else if Line.Contains('seta com_introPlayed') then begin
        WriteLn(f, 'seta com_introPlayed '+BoolToIntQuoted(SkipIntroCheck.Checked));
      end
      else if Line.Contains('seta com_maxfps') then begin
        WriteLn(f, 'seta com_maxfps '+SettingQuoted(FPSLimit.Text));
      end
      else if Line.Contains('seta r_aaSamples') then begin
        case (AABar.Position) of
          0: begin
              settingstr:= '"0"';
          end;
          1: begin
              settingstr:= '"2"';
          end;
          2: begin
              settingstr:= '"4"';
          end;
          3: begin
              settingstr:= '"8"';
          end;
          else begin
          end;
        end;
        WriteLn(f, 'seta r_aaSamples '+settingstr);
      end
      else if Line.Contains('seta r_mode') then begin
        case (ResolutionBar.Position) of
          0: begin
              settingstr:= '"1280x720"';
          end;
          1: begin
              settingstr:= '"1600x900"';
          end;
          2: begin
              settingstr:= '"1920x1080"';
          end;
          3: begin
              settingstr:= '"2560x1440"';
          end;
          else begin
          end;
        end;
        WriteLn(f, 'seta r_mode '+settingstr);
      end
      else if Line.Contains('seta ugx_client_fov ') then begin
        settingstr:= Trim(FOV.Text);
        WriteLn(f, 'seta ugx_client_fov '+SettingQuoted(settingstr));
      end
      else if Line.Contains('seta ugx_client_fovmin') then begin
        settingstr:= Trim(FOV.Text);
        WriteLn(f, 'seta ugx_client_fovmin '+SettingQuoted('Yes'));
      end
      else if Line.Contains('exec default_controller.cfg') then begin
        Continue;
      end
      else if Line.Contains('input_viewSensitivity') then begin
        Continue;
      end
      else begin
        WriteLn(f, Line);
      end;
    end;
  finally
    if ControllerCheck.Checked then begin
      WriteLn(f, 'exec default_controller.cfg');
    end;
    case (ThumbBar.Position) of
      0: begin
          settingstr:= '1';
      end;
      1: begin
          settingstr:= '2';
      end;
      2: begin
          settingstr:= '3';
      end;
      3: begin
          settingstr:= '4';
      end;
      4: begin
          settingstr:= '5';
      end;
      else begin
      end;
    end;
    WriteLn(f, 'input_viewSensitivity '+settingstr);
    if LockCheck.Checked then begin
      SetFAttr(f, attr or readonly);
    end;
    CloseFile(f);
    Saved.SavedForm.Show;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  CfgContents.Free;
end;

procedure TMainForm.ModManagerItemClick(Sender: TObject);
begin
  ModManager.ModForm.Show;
end;

procedure TMainForm.ExitItemClick(Sender: TObject);
begin
  CfgContents.Free;
  Application.Terminate;
end;

procedure TMainForm.AboutItemClick(Sender: TObject);
begin
  About.AboutForm.Show;
end;

procedure TMainForm.ProfileListSelectionChange(Sender: TObject; User: boolean);
begin
  // hide settings since we aren't ready yet
  SettingsGroup.Enabled:= False;
  ConfigGroup.Enabled:= False;
  ModManagerItem.Enabled:= True;
  ModManagerItem.Caption:= 'Mod Manager';
  // determine the selected profile
  Profile:= GetSelectedItem(ProfileList);
  ConfigList.Clear;
  // build the path to the selected profile directory
  ProfilePath:= ProfilesPath+Profile+PathDelim;
  // find all config files in the selected profile directory
  // add their file names to the gui element
  GetListOfFiles(ConfigList, ProfilePath, '*.cfg');
  if ConfigList.Count > 0 then begin
    ConfigGroup.Enabled:= True;
  end;
end;

// some helper converter functions
function TMainForm.SettingQuoted(Setting: String): String;
begin
  SettingQuoted:= '"'+Setting+'"';
end;

function TMainForm.BoolToIntQuoted(i: Boolean): String;
begin
  if i then begin
    BoolToIntQuoted:= '"1"';
  end
  else begin
    BoolToIntQuoted:= '"0"';
  end;
end;

function TMainForm.StrIntToBool(i: String): Boolean;
begin
  if CompareText(i, '1')=0 then begin
    StrIntToBool:= True;
  end
  else if CompareText(i, '0')=0 then begin
    StrIntToBool:= False;
  end
  else begin
    StrIntToBool:= False;
  end;
end;

class function TMainForm.GetSelectedItem(list: TListBox): String;
var
  // for iteration
  i: Integer;
begin
  // determine the selected config
  for i:= 0 to list.Items.Count-1 do begin
    if list.Selected[i] then begin
      GetSelectedItem:= list.Items[i];
      exit;
    end;
  end;
  GetSelectedItem:= ''
end;

class procedure TMainForm.GetListOfFiles(list: TListBox; path: String; pattern: String);
var
  // list of file paths
  filePaths: TStringList;
  // the extracted file name
  extractedName: String;
  // for iteration
  i: Integer;
begin
  try
    filePaths:= FindAllFiles(path, pattern, False);
    for i:=0 to filePaths.Count-1 do begin
      extractedName:= ExtractFileName(filePaths[i]);
      list.Items.Add(extractedName);
    end;
  finally
    filePaths.Free;
  end;
end;

class procedure TMainForm.GetListOfFolders(list: TListBox; path: String);
var
  // list of folder paths
  folderPaths: TStringList;
  // extracted folder name
  split: array of String;
  // for iteration
  i: Integer;
begin
  try
    // get list of directory paths for profile directories
    folderPaths:= FindAllDirectories(path, False);
    // build the gui list of profile names by extracting the profile name
    // and add it to the profilelist
    for i:=0 to folderPaths.Count-1 do begin
      split:= SplitString(folderPaths[i], PathDelim);
      list.Items.Add(split[Length(split)-1]);
    end;
  finally
    folderPaths.Free;
  end;
end;

end.

