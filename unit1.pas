unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLType,Clipbrd, LCLIntf,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var i,j,k,wrng,rigt,adjustx,adjusty:integer; Pic,template:TPicture; perc:array [1..13] of integer;
  temp:string;
begin
     //if Edit1.text = '' then
     //   Edit1.text:= 'Put link to image here.';
     Pic:= TPicture.Create;
     try
        Pic.LoadFromClipboardFormat(PredefinedClipboardFormat(pcfBitmap));
     except
        ShowMessage('Wrong input file.');
        exit;
     end;
     template:= TPicture.Create;
     wrng:=0;
     rigt:=0;
     adjustx:=605; //605
     adjusty:=55;   //55
     for k:=1 to 13 do
         begin
              perc[k]:=0;
              template.LoadFromFile('maps\world'+inttostr(k)+'.png');
     for i:=1 to template.Width do
         for j:=1 to template.Height do
             begin
                  if (Pic.Bitmap.Canvas.Pixels[i+adjustx,j+adjusty]<>$000000)
                  and (Pic.Bitmap.Canvas.Pixels[i+adjustx,j+adjusty]<>$FFFFFF)
                  and (Pic.Bitmap.Canvas.Pixels[i+adjustx,j+adjusty]<>$7F7F7F) then
                     begin
                          if Pic.Bitmap.Canvas.Pixels[i+adjustx,j+adjusty] =
                          template.Bitmap.Canvas.Pixels[i,j] then
                             rigt +=1
                          else
                             wrng +=1;
                     end;
             end;
             perc[k]:= (rigt*100000) div wrng;
         end;
     for i:=1 to 13 do
         begin
              temp:=inttostr(perc[i]);
              while length(temp)<5 do
                    temp := '0'+temp;
              memo1.Lines.Add('world '+inttostr(i)+' --> ' + temp[1]+temp[2]+'.'+
              temp[3]+temp[4]+temp[5]+' %');
         end;
     j:=perc[1];
     k:=1;
     for i:=2 to 13 do
         if j<perc[i] then
            begin
             j:=perc[i];
             k:=i;
            end;
     template.LoadFromFile('maps\world'+inttostr(k)+'.png');
     for i:=1 to template.Width do
         for j:=1 to template.Height do
             begin
                  image1.Canvas.Pixels[i,j]:= Pic.Bitmap.Canvas.Pixels[i+adjustx,j+adjusty];
                  if not(Pic.Bitmap.Canvas.Pixels[i+adjustx,j+adjusty]=$000000) then
                     if Pic.Bitmap.Canvas.Pixels[i+adjustx,j+adjusty] =
                     template.Bitmap.Canvas.Pixels[i,j] then
                     image2.Canvas.pixels[i,j]:=$0000FF
                     else
                  else
                      image2.canvas.Pixels[i,j]:=template.Bitmap.Canvas.pixels[i,j];
             end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     image1.canvas.FillRect(clientrect);
     image2.canvas.fillrect(clientrect);
end;

end.

