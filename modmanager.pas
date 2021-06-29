unit ModManager;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TModForm }

  TModForm = class(TForm)
    ConfirmDeleteBox: TCheckBox;
    DeleteButton: TButton;
    DeleteBox: TGroupBox;
    SaveButton: TButton;
    RenameEdit: TEdit;
    RenameBox: TGroupBox;
    ModActionGroup: TGroupBox;
    ModGroup: TGroupBox;
    ModList: TListBox;
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

procedure TModForm.ModListSelectionChange(Sender: TObject; User: boolean);
var
  selectedMod: String;
begin
  selectedMod:= TMainForm.GetSelectedItem(ModList);
  RenameEdit.Text:= selectedMod;
  RenameBox.Enabled:= True;
end;

procedure TModForm.SaveButtonClick(Sender: TObject);
var
  oldName: String;
  newName: String;
begin
  oldName:= TMainForm.GetSelectedItem(ModList);
  newName:= Trim(RenameEdit.Text);
end;

end.

