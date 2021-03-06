unit LedShape;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TLedShape }

  TLedShape = class(TShape)
  private
    ReadBlue: TColor;
    ReadColor: TColor;
    ReadGreen: TColor;
    ReadRed: TColor;
    ReadColorStep: TColor;

    tmrAnim : TTimer;
    tmrState : Integer;                           // state machine global var.
    ledColorCnt : Tcolor;

    r,g,b,
    t_r,t_g,t_b : byte;

    ReadFromColor: TColor;
    ReadStatus: boolean;
    ReadStep: Integer;
    ReadToColor: TColor;
    procedure OnTmrAnim(Sender: TObject);         // for led animation
    procedure SetBlue(const AValue: TColor);
    procedure SetColor(const AValue: TColor);
    procedure SetColorStep(const AValue: TColor);
    procedure SetFromColor(const AValue: TColor);
    procedure SetGreen(const AValue: TColor);
    procedure SetRed(const AValue: TColor);
    procedure SetStatus(const AValue: boolean);
    procedure SetStep(const AValue: Integer);
    procedure SetToColor(const AValue: TColor);
    { Private declarations }
  protected
    procedure Paint;      Override;            //mu added
    constructor Create(AOwner : TComponent); Override;
    destructor Destroy; Override;
  public
    { Public declarations }
  published
    { Published declarations }
    property StartAnimation: boolean read ReadStatus write SetStatus;             // some functions aren't neccessary
    property LedFromColor : TColor read ReadFromColor write SetFromColor;
    property LedToColor : TColor read ReadToColor write SetToColor;
    property LedColorStep : TColor read ReadColorStep write SetColorStep;
    property LedRed : TColor read ReadRed write SetRed;
    property LedGreen : TColor read ReadGreen write SetGreen;
    property LedBlue : TColor read ReadBlue write SetBlue;
    property AnimationStep : Integer read ReadStep write SetStep default 100;
    property LedColor : TColor read ReadColor write SetColor;

    property Align;
    property Brush;
    property Name;
    property Pen;
    property Shape;
    property Visible;
    property Height;
    property Width;


  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Sample',[TLedShape]);
end;


{ TLedShape }

procedure TLedShape.SetStatus(const AValue: boolean);           //it is added automaticly  CTRL + SHIFT + C
begin
  //if ReadStatus=AValue then exit;
  ReadStatus:=AValue;
  tmrAnim.Enabled := ReadStatus;
  if ReadStatus then
    begin
      ledColorCnt := LedFromColor;
      tmrState := 1;
    end;
end;

procedure TLedShape.SetStep(const AValue: Integer);
begin
  if ReadStep=AValue then exit;
  ReadStep:=AValue;
  tmrAnim.Interval:= ReadStep;
end;

procedure TLedShape.SetFromColor(const AValue: TColor);     //it is added automaticly
begin
  if ReadFromColor=AValue then exit;
  ReadFromColor:=AValue;
  Self.Brush.Color:= ReadFromColor;
end;

procedure TLedShape.SetBlue(const AValue: TColor);
begin
  if ReadBlue=AValue then exit;
  ReadBlue:=AValue;
end;

procedure TLedShape.SetGreen(const AValue: TColor);
begin
  if ReadGreen=AValue then exit;
  ReadGreen:=AValue;
end;

procedure TLedShape.SetRed(const AValue: TColor);
begin
  if ReadRed=AValue then exit;
  ReadRed:=AValue;
end;

procedure TLedShape.SetColor(const AValue: TColor);
begin
  if ReadColor=AValue then exit;
  ReadColor:=AValue;
end;


procedure TLedShape.SetColorStep(const AValue: TColor);
begin
  if ReadColorStep=AValue then exit;
  ReadColorStep:=AValue;
end;

procedure TLedShape.SetToColor(const AValue: TColor);       //it is added automaticly
begin
  if ReadToColor=AValue then exit;
  ReadToColor:=AValue;
end;

procedure TLedShape.Paint;
begin
  inherited Paint;
end;

//tmranim ontmr
procedure TLedShape.OnTmrAnim(Sender: TObject);
begin
  //

  case tmrState of
    0: begin
       end;                 // do nothing...
    1: begin
         ledColorCnt := ReadFromColor;
         Self.Brush.Color := ledColorCnt;
         RedGreenBlue(ReadToColor,t_r,t_g,t_b);
         RedGreenBlue(ledColorCnt,r,g,b);
         tmrState := 2;    // go next state
         SetRed(r);
         SetGreen(g);
         SetBlue(b);

       end;
    2: begin

         if r<t_r then
           inc(r)
           else
             if r>t_r then
               dec(r);

         if g<t_g then
           inc(g)
           else
             if g>t_g then
               dec(g);

         if b<t_b then
           inc(b)
           else
             if b>t_b then
               dec(b);

         SetRed(r);
         SetGreen(g);
         SetBlue(b);

         ledColorCnt:= RGBToColor(r,g,b);

         Self.Brush.Color:= ledColorCnt;   // refresh
         if ledColorCnt=ReadToColor then
           tmrState := 3;    // go next state;

         SetColor(ledColorCnt);
         //Invalidate;
       end;  // 2:

    3: begin
          tmrState:=0;               // do nothing
          StartAnimation := false;
          //Invalidate;
       end;  // 3:
  end;  // case tmrstate


end;


constructor TLedShape.Create(AOwner: TComponent);
begin
  ReadStep := 1;
  // we should create timer object for animation
  tmrAnim := TTimer.Create(self);
  tmrAnim.OnTimer  := @OnTmrAnim;      // animations will in this event by state machine , you must remember @ (address)
  tmrAnim.Enabled  := ReadStatus;
  tmrAnim.Interval := ReadStep;

  inherited Create(AOwner);
end;

destructor TLedShape.Destroy;
begin
  // we should destroy our objects...
  tmrAnim.Free;

  inherited Destroy;
end;

end.
