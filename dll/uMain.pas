{
 -------------------------------------------------------------------------------
 GrFinger Sample
 (c) 2005 - 2010 Griaule Biometrics Ltda.
 http://www.griaulebiometrics.com
 -------------------------------------------------------------------------------

 This sample is provided with "GrFinger Fingerprint Recognition Library" and
 can't run without it. It's provided just as an example of using GrFinger
 Fingerprint Recognition Library and should not be used as basis for any
 commercial product.

 Griaule Biometrics makes no representations concerning either the merchantability
 of this software or the suitability of this sample for any particular purpose.

 THIS SAMPLE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL GRIAULE BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 You can download the trial version of GrFinger directly from Griaule website.
                                                                   
 These notices must be retained in any copies of any part of this
 documentation and/or sample.

 -------------------------------------------------------------------------------
}

// -----------------------------------------------------------------------------------
// GUI routines: main form
// -----------------------------------------------------------------------------------

unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, uDBClass,
  ExtDlgs, GrFinger, ComCtrls, syncObjs,  ZConnection, DB,
  ZAbstractRODataset, ZAbstractDataset, ZAbstractTable, ZDataset;

function finder(fingerID: integer): PChar; stdcall;
function inlib(fingerID: integer): integer; stdcall;

procedure Init();
procedure btExtract;

implementation

uses  uCallbacks, uUtil;


// Application startup code
procedure Init();
var
  ret: Integer;
begin
  // Initialize GrFinger Library
  ret := InitializeGrFinger();
  // Print result in log
  if ret < 0 then
    WriteError(ret)
  else
    WriteLog('**GrFinger Initialized Successfull**');
  InitializeGrCap();
end;

// Application finalization code
procedure Destroy(Sender: TObject; var Action: TCloseAction);
begin
  // finalize GrFinger
  FinalizeGrFinger();
end;

// Add a fingerprint to database
procedure InFinger(photo_id: Integer);
var
  id: Integer;
  i: Integer;
begin
  // add fingerprint
  id := Enroll(photo_id);
  if id >= 0 then
    WriteLog('Fingerprint enrolled with id = ' + IntToStr(id))
  else
    WriteLog('Error: Fingerprint not enrolled');
end;

// Identify a fingerprint
function Match(photo_id: Integer; var matchId: Integer; var score: Integer): Integer;
var
  ret: Integer;
  sc: Integer;
begin
  score := 0;
  // identify it
  ret := Identify(photo_id,score);
  matchId:= ret;
  Result:= 0;
{  // write result to the log
  if ret > 0 then
  begin
    WriteLog('Fingerprint identified. ID = '+IntToStr(ret)+'. Score = '+
             IntToStr(score)+'.');
    PrintBiometricDisplay(true, GR_DEFAULT_CONTEXT);
  end
  else if ret = 0 then
    WriteLog('Fingerprint not Found.')
  else
    WriteError(ret);     }
end;

// Check a fingerprint
procedure btVerify();
var
  id, score: Integer;
  ret: Integer;
begin
  // ask target fingerprint ID
  score := 0;
  id := StrToIntDef(InputBox('输入指纹库ID号', '认证',''), -1);
  if id >= 0 then
  begin
    // compare fingerprints
    ret := Verify(id, score);
    // write result to the log
    if ret < 0 then
      WriteError(ret);
    if ret = GR_NOT_MATCH then
      WriteLog('Did not match with score = ' + IntToStr(score));
    if ret = GR_MATCH then
    begin
      WriteLog('Matched with score = ' + IntToStr(score));
      // if they match, display matching minutiae/segments/directions
      PrintBiometricDisplay(true, GR_DEFAULT_CONTEXT);
    end;
  end;
end;

// Extract a template from a fingerprint image
procedure btExtract;
var
  ret: Integer;
begin
  // extract template
  ret := ExtractTemplate();
  // write template quality to log
  if (ret = GR_BAD_QUALITY)
    then writeLog('Template extracted successfully. Bad quality.')
  else if (ret = GR_MEDIUM_QUALITY)
    then writeLog('Template extracted successfully. Medium quality.')
  else if (ret = GR_HIGH_QUALITY)
    then writeLog('Template extracted successfully. High quality.');
  if ret >= 0 then
  begin
    // if no error, display minutiae/segments/directions into the image
    PrintBiometricDisplay(true, GR_NO_CONTEXT);
    // enable operations we can do over extracted template
  end
  else
    // write error to log
    WriteError(ret);
end;

// Clear the database


// Clear log


// Load a fingerprint image from a file
procedure ImageLoad(FileName: string);
Var
  resolution: Integer;
  res: String;
begin
 //  fileName:= 'C:\Wroter\IR\rails_apps\GrFinger\GrFinger\image1\Finger2_V300_500dpi.bmp';
  // open "load" dialog

  // load image
  if(FileExists(FileName)) then begin
    // Getting image resolution.
    res := '500';//InputBox('What is the image resolution?', 'Resolution', '');
    if(StrComp(PChar(res),'') <> 0) then
    begin
      resolution := StrToInt(res);
      // Checking if action was canceled, no value or an invalid value was entered.
      if (resolution <> 0) then begin
          if GrCapLoadImageFromFile(FileName, resolution) <> GR_OK then
              WriteLog('Fail to load the file.');
      end;
    end;
  end;
end;


function inlib(fingerID: integer): integer; stdcall;
var
  fileName: string;
begin
  fileName :=  GetFileNameById(fingerID);
//  fileName:= '..\rails_apps\ZhiWenKu\public\system\datas\'+IntToStr(fingerID)+'\original\'+fileName;
  ImageLoad(fileName);//('C:\Wroter\IR\rails_apps\GrFinger\GrFinger\image1\Finger2_V300_500dpi.bmp');
  Enroll(fingerID);
  result:= 1;
end;

function finder(fingerID: integer): PChar; stdcall;
var
  matchId,score :Integer;
  s,fileName: string;
begin
   matchId:=0;
   score:=0;
   fileName :=  GetFileNameById(fingerID);
   ImageLoad(fileName);
   Match(fingerID,matchId,score);
   s := format('%d %d',[matchId,score]);
   s:= UTF8Encode(s);
   Result:=  PChar(s);

end;

// Display GrFinger version

end.
