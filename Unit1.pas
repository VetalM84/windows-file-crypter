unit Unit1;

interface

uses
  Windows, SysUtils, Graphics, Forms, Dialogs,  xpman, StdCtrls,
  LbSpeedButton, ExtCtrls, Classes, Controls, ComCtrls, inifiles,
  lbbuttons;

type
  TEncryptStream = function (DataStream: TStream; Count: Int64; Key: string): Boolean; // ����������� ���������� ������
  TDecryptStream = function (DataStream: TStream; Count: Int64; Key: string): Boolean; // ������������ ���������� ������

  TForm1 = class(TForm)
    OpenDialog: TOpenDialog;
    LbSpeedButton1: TLbSpeedButton;
    LbSpeedButton2: TLbSpeedButton;
    LbSpeedButton3: TLbSpeedButton;
    Edit1: TLabeledEdit;
    Edit2: TLabeledEdit;
    CheckBox1: TCheckBox;
    LbSpeedButton4: TLbSpeedButton;
    LbSpeedButton5: TLbSpeedButton;
    CheckBox2: TCheckBox;
    procedure LbSpeedButton2Click(Sender: TObject);
    procedure LbSpeedButton1Click(Sender: TObject);
    procedure LbSpeedButton3Click(Sender: TObject);
    procedure LbSpeedButton4Click(Sender: TObject);
    procedure LbSpeedButton5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  DLL: THandle;
  EncryptStream: TEncryptStream;
  DecryptStream: TDecryptStream;
  SourseStream : TFileStream;
  ini: tinifile;
  ext: string;

implementation


{$R *.dfm}

procedure TForm1.LbSpeedButton2Click(Sender: TObject);
begin
  try
// ���������� �����
    // ��������� dll �����������
    DLL:= loadLibrary('service.dll');
    if DLL <> 0 then
    begin
      // �������� ����� �������
      @EncryptStream:= getProcAddress(DLL, 'EncryptStream');
      // ���� ����� ������� ������
      if addr(EncryptStream) <> nil then
      begin
        if edit2.Text = '' then
        begin
          messagebox(handle, '������� ����', '������', 16);
          edit2.SetFocus;
        end
        else
        begin
          try
            if checkbox1.Checked then copyfile(pchar(edit1.Text), pchar(edit1.Text + '.bak'), false);
            SourseStream:= TFileStream.Create(Edit1.Text, fmOpenReadWrite);
            EncryptStream(SourseStream, SourseStream.Size, Edit2.Text);
            SourseStream.Free;
            if checkbox2.Checked = true then
              renameFile(edit1.Text, edit1.text + '.CRY');
            messagebox(handle, '���� ���������� �������', '���������� �����', 64);
          except
            messagebox(handle, '����������� ��� �����', '������', 16);
          end;
        end;
      end
      else
        // ������� �� ������� ("handleable")
        Messagebox(handle, '������� �� �������...', '������', 16);
    end
    else
      // DLL �� ������� ("handleable")
      Messagebox(handle, 'DLL-���� service.dll �� ������...', '������', 16);

  finally
    // ��������� dll �� ������
    freeLibrary(DLL);
  end;
end;

procedure TForm1.LbSpeedButton1Click(Sender: TObject);
begin
// ����� �����
  opendialog.Execute;
  if opendialog.FileName = '' then
  else edit1.Text:= opendialog.FileName;
end;

procedure TForm1.LbSpeedButton3Click(Sender: TObject);
begin
// ��������������� �����
  try
    DLL:= loadLibrary('service.dll');
    if DLL <> 0 then
    begin
      @DecryptStream:= getProcAddress(DLL, 'DecryptStream');
      if addr(DecryptStream) <> nil then
      begin
        if edit2.Text = '' then
        begin
          messagebox(handle, '������� ����', '������', 16);
          edit2.SetFocus;
        end
        else
        begin
          try
{create .bak}if checkbox1.Checked then copyfile(pchar(edit1.Text), pchar(edit1.Text + '.bak'), false);
            SourseStream := TFileStream.Create(Edit1.Text, fmOpenReadWrite);
            DecryptStream(SourseStream, SourseStream.Size, Edit2.Text);
            SourseStream.Free;
///////////// ����  ���������� �������������� ����� .CRY, ����� ������� ���������� .cry
            if extractfileext(edit1.Text) = '.CRY' then
              renamefile(edit1.Text, (extractfilepath(edit1.Text) + copy(extractfilename(edit1.Text), 1, 
                length(extractfilename(edit1.Text)) - length(extractfileext(edit1.Text)))));
//////////////////////////////////////////
            messagebox(handle, '���� ����������� �������', '��������������� �����', 64);
          except
            messagebox(handle, '����������� ��� �����', '������', 16);
          end;
        end;
      end
      else
        Messagebox(handle, '������� �� �������...', '������', 16);
    end
    else
      Messagebox(handle, 'DLL-���� �� ������...', '������', 16);
  finally
    freeLibrary(DLL);
  end;

end;

procedure TForm1.LbSpeedButton4Click(Sender: TObject);
begin
// ����� �������������� �����
  if clientheight <= 147 then clientheight:= 246
  else clientheight:= 147;
end;

procedure TForm1.LbSpeedButton5Click(Sender: TObject);
begin
// ������� .bak ����
  deletefile(edit1.Text + '.bak');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
// ��������� ����� ������
  ini:= tinifile.Create(extractfilepath(paramstr(0)) + 'Settings.ini');
  form1.ShowHint:= ini.ReadBool('Common', 'Showhint', true);
  if ini.ReadString('Common', 'Style', 'XPNonFlat') = 'XPNonFlat' then
  begin
    with lbspeedbutton1 do
    begin
      colorstyle:= lcsxpnonflat;
      style:= lbspeedbutton.bsXP;
    end;
    with lbspeedbutton2 do
    begin
      colorstyle:= lcsxpnonflat;
      style:= lbspeedbutton.bsXP;
    end;
    with lbspeedbutton3 do
    begin
      colorstyle:= lcsxpnonflat;
      style:= lbspeedbutton.bsXP;
    end;
    with lbspeedbutton4 do
    begin
      colorstyle:= lcsxpnonflat;
      style:= lbspeedbutton.bsXP;
    end;
    with lbspeedbutton5 do
    begin
      colorstyle:= lcsxpnonflat;
      style:= lbspeedbutton.bsXP;
    end;
  end;
  if ini.ReadString('Common', 'Style', 'XPNonFlat') = 'XPNonFlat1' then
  begin
    with lbspeedbutton1 do
    begin
      colorstyle:= lcsXPnonflat1;
      style:= lbspeedbutton.bsXP;
    end;
    with lbspeedbutton2 do
    begin
      colorstyle:= lcsXPnonflat1;
      style:= lbspeedbutton.bsXP;
    end;
    with lbspeedbutton3 do
    begin
      colorstyle:= lcsXPnonflat1;
      style:= lbspeedbutton.bsXP;
    end;
    with lbspeedbutton4 do
    begin
      colorstyle:= lcsXPnonflat1;
      style:= lbspeedbutton.bsXP;
    end;
    with lbspeedbutton5 do
    begin
      colorstyle:= lcsXPnonflat1;
      style:= lbspeedbutton.bsXP;
    end;
  end;
end;

end.
