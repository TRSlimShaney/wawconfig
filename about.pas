unit About;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
  private

  public

  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.lfm}

{ TAboutForm }

end.

