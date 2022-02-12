unit Saved;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TSavedForm }

  TSavedForm = class(TForm)
    ThanksButton: TButton;
    Label1: TLabel;
    procedure ThanksButtonClick(Sender: TObject);
  private

  public

  end;

var
  SavedForm: TSavedForm;

implementation

{$R *.lfm}

{ TSavedForm }

procedure TSavedForm.ThanksButtonClick(Sender: TObject);
begin
  SavedForm.Close;
end;

end.

