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
    procedure ModListSelectionChange(Sender: TObject; User: boolean);
  private

  public

  end;

var
  ModForm: TModForm;

implementation

{$R *.lfm}

{ TModForm }

procedure TModForm.ModListSelectionChange(Sender: TObject; User: boolean);
begin

end;

end.

