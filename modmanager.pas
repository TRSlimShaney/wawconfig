unit ModManager;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, FileUtil;

type

  { TModForm }

  TModForm = class(TForm)
    ConfirmDeleteCheck: TCheckBox;
    DeleteButton: TButton;
    DeleteBox: TGroupBox;
    SaveButton: TButton;
    RenameEdit: TEdit;
    RenameBox: TGroupBox;
    ModActionGroup: TGroupBox;
    ModGroup: TGroupBox;
    ModList: TListBox;
    procedure ConfirmDeleteCheckClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ModListSelectionChange(Sender: TObject; User: boolean);
    procedure SaveButtonClick(Sender: TObject);
  private
    FormShown: Boolean;
  public

  end;

var
  ModForm: TModForm;

implementation

uses
  Main;
{$R *.lfm}

{ TModForm }

procedure TModForm.FormActivate(Sender: TObject);
begin
  if not FormShown then begin
    TMainForm.GetListOfFolders(ModList, TMainForm.ModsPath);
    FormShown:= True;
  end;
end;

procedure TModForm.DeleteButtonClick(Sender: TObject);
var
  deleteSuccess: Boolean;
  selectedMod: String;
  modPath: String;
begin
  if ConfirmDeleteCheck.Checked then begin
    selectedMod:= TMainForm.GetSelectedItem(ModList);
    modPath:= TMainForm.ModsPath+selectedMod;
    deleteSuccess:= DeleteDirectory(modPath, False);
    TMainForm.GetListOfFolders(ModList, TMainForm.ModsPath);
  end;
end;

procedure TModForm.ConfirmDeleteCheckClick(Sender: TObject);
begin
  DeleteButton.Enabled:= ConfirmDeleteCheck.Checked;
end;

procedure TModForm.ModListSelectionChange(Sender: TObject; User: boolean);
var
  selectedMod: String;
begin
  selectedMod:= TMainForm.GetSelectedItem(ModList);
  RenameEdit.Text:= selectedMod;
  RenameBox.Enabled:= True;
  DeleteBox.Enabled:= True;
end;

procedure TModForm.SaveButtonClick(Sender: TObject);
var
  oldName: String;
  newName: String;
  oldPath: String;
  newPath: String;
begin
  oldName:= TMainForm.GetSelectedItem(ModList);
  newName:= Trim(RenameEdit.Text);
  oldPath:= TMainForm.ModsPath+oldName+PathDelim;
  newPath:= TMainForm.ModsPath+newName+PathDelim;
  RenameFile(oldPath, newPath);
  TMainForm.GetListOfFolders(ModList, TMainForm.ModsPath);
end;

end.

