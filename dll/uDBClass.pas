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
// Database routines
// -----------------------------------------------------------------------------------

unit uDBClass;

interface

uses
  ADODB, DB, classes, SysUtils, GrFinger, Dialogs,ZConnection,
  ZAbstractRODataset, ZAbstractDataset, ZAbstractTable, ZDataset;


type
  // Class TTemplate
  // Define a type to temporary storage of template
  TTemplate = class
    public
      // Template data.
      tpt:        Pchar;
      // Template size
      size:       Integer;
      // Template ID (if retrieved from DB)
      id:         Integer;

      // Allocates space to template
      constructor Create;
      // clean-up
      destructor Destroy; override;
  end;

  TDBClass = class
  private
    // a data set to mantain all templates of database
    //dsTemplates: TADODataSet;
    dsTemplates: TZQuery;
    qCommon: TZQuery;
    // the connection object
//    connection: TADOConnection;
    connection: TZConnection;

    // Template object used to get a template from database.
    tptBlob: TTemplate;
    procedure ExeSql(sql: string);
  public
    function getAppRoot(): string;
    function getFileName(id: Integer): string;
    function openDB(): boolean;
    procedure closeDB();
    procedure clearDB();
    function addTemplate(photo_id: Integer; template: TTemplate): Integer;
    procedure getTemplates();
    function getTemplate(id: Integer) : TTemplate;
    function getNextTemplate(): TTemplate;

  end;

implementation

// Default constructor
constructor TTemplate.Create();
begin
  // Allocate memory for template and initialize its size to 0
  tpt := AllocMem(GR_MAX_SIZE_TEMPLATE);
  size := 0;
end;

// Default destructor
destructor TTemplate.Destroy();
begin
  // free resources
  FreeMemory(tpt);
end;

// Open connection
function TDBClass.openDB(): boolean;
begin
  try
        tptBlob := TTemplate.Create();
        connection := TZConnection.Create(nil);
        connection.User:= 'root';
        connection.Password:= '';
        connection.HostName:= 'localhost';
        connection.Database:= 'zhiwenku';
        connection.Protocol:= 'mysql';

        //connection.ConnectionString := ConnectionString;
  //      connection.Database:='FingDB.db';
        dsTemplates := TZQuery.Create(nil);

        dsTemplates.Connection:=connection;


        dsTemplates.SQL.Text:= 'select id, data from fingers';
        dsTemplates.Open();
        qCommon:= TZQuery.Create(nil);
 //       dsTemplates.ExecSQL;
        openDB := true;
  except
        openDB := false;
  end;
end;

// Close conection
procedure TDBClass.closeDB();
begin
  dsTemplates.Close();
  dsTemplates.Free();
  qCommon.Close();
  qCommon.Free();
  tptBlob.Free();
  connection.Free();
  connection := nil;
end;

procedure TDBClass.ExeSql(sql: string);
begin
//  dsTemplates.SQL.Text:=sql;
//  dsTemplates.ExecSQL;

end;

// Clear database
procedure TDBClass.clearDB();
begin
  // run "clear" query
  ExeSql('DELETE FROM enroll');
end;

{// Add template to database. Returns added template ID.
function TDBClass.addTemplate(template: TTemplate): Integer;
var
  rs: TZTable;
  tptStream: TMemoryStream;
  id: Integer;
begin
  // get DB data and append one row
  rs := TZTable.Create(nil);
  rs.Connection := connection;
//  rs.CursorType := ctStatic;
//  rs.LockType := ltOptimistic;
  rs.TableName := 'fingers';
  rs.Open();
  rs.Append();
  tptStream := TMemoryStream.Create();
  // write template data to memory stream.
  tptStream.write(template.tpt^, template.size);
  // save template data from memory stream to database.
  (rs.FieldByName('data') as  TBlobField).LoadFromStream(tptStream);
  rs.FieldByName('status').AsInteger:= 1;
  // update database with added template.
  rs.post();
  // get the ID of enrolled template.
  id := rs.FieldByName('ID').AsInteger;
  // close connection
  tptStream.Free();
  rs.Close();
  rs.Free();
  addTemplate := id;
end;
}

function TDBClass.addTemplate(photo_id: Integer; template: TTemplate): Integer;
var
  rs: TZQuery;
  tptStream: TMemoryStream;
  id: Integer;
  s: string;
begin
  // get DB data and append one row
  rs := TZQuery.Create(nil);
  rs.Connection := connection;
//  rs.CursorType := ctStatic;
//  rs.LockType := ltOptimistic;
//  rs.TableName := 'fingers';


  tptStream := TMemoryStream.Create();
  // write template data to memory stream.
  tptStream.write(template.tpt^, template.size);
//  s:= PChar2Str(template.tpt^);//TStringStream(tptStream).DataString;


  rs.SQL.Text := format ('update fingers set data = :DATA,status=1 where id= %d ',[photo_id]);


  rs.ParamByName('DATA').SetBlobData(tptStream.Memory,tptStream.Size);


  rs.ExecSQL;
  {
  // save template data from memory stream to database.
  (rs.FieldByName('data') as  TBlobField).LoadFromStream(tptStream);
  rs.FieldByName('status').AsInteger:= 1;
  // update database with added template.
  rs.post();
  // get the ID of enrolled template.
  id := rs.FieldByName('ID').AsInteger;  }
  // close connection
  tptStream.Free();
  rs.Close();
  rs.Free();
  addTemplate := photo_id;
end;


// Start fetching all enrolled templates from database.
procedure TDBClass.getTemplates();
begin
  dsTemplates.Close();
//  dsTemplates.CacheSize := 15000;
//  dsTemplates.CursorLocation := clUseClient;
//  dsTemplates.CursorType := ctOpenForwardOnly;
//  dsTemplates.LockType := ltReadOnly;
  dsTemplates.Connection := connection;
  dsTemplates.SQL.Text := 'select id, data from fingers where status >= 1';
 // dsTemplates.TableName:= 'fingers';
  dsTemplates.Open();
  dsTemplates.First;
//  dsTemplates.BlockReadSize := 15000;
end;

// Returns template with supplied ID.
function TDBClass.getTemplate(id: Integer): TTemplate;
Var
  template: TTemplate;
begin
{  dsTemplates.Close();
  dsTemplates.Connection := connection;
//  dsTemplates.CursorType := ctDynamic;
//  dsTemplates.LockType := ltReadOnly;
  dsTemplates.SQL.Text := 'SELECT * FROM enroll WHERE ID = ' + IntToStr(id);
  // Get query response
  dsTemplates.Open();
  // Deserialize template and return it
  template := getNextTemplate();
  dsTemplates.Close();
  getTemplate := template;  }
end;
function TDBClass.getAppRoot(): string;
begin
  qCommon.Close();
  qCommon.Connection := connection;
//  dsTemplates.CursorType := ctDynamic;
//  dsTemplates.LockType := ltReadOnly;
  qCommon.SQL.Text := 'SELECT value FROM configs WHERE name = "app_root"';
  // Get query response
  qCommon.Open();
  Result:= qCommon.FieldByName('value').AsString;
  // Deserialize template and return it
  qCommon.Close();
end;

function TDBClass.getFileName(id: Integer): string;


begin
  qCommon.Close();
  qCommon.Connection := connection;
//  dsTemplates.CursorType := ctDynamic;
//  dsTemplates.LockType := ltReadOnly;
  qCommon.SQL.Text := 'SELECT fingerdata_file_name FROM fingers WHERE ID = ' + IntToStr(id);
  // Get query response
  qCommon.Open();
  Result:= qCommon.FieldByName('fingerdata_file_name').AsString;
  // Deserialize template and return it
  qCommon.Close();

end;


// Return next template from dataset
function TDBClass.getNextTemplate(): TTemplate;
Var
  tmp: String;
begin
  // No results?
  if dsTemplates.Eof then
  begin
    tptBlob.size := -1;
    getNextTemplate := tptBlob;
  end else
  begin
    // Get template ID from database

    tptBlob.id := dsTemplates.FieldByName('id').AsInteger;
    // Get template data from database as string.
    tmp := dsTemplates.FieldByName('data').AsString;
    // Get template size from database.
    tptBlob.size := length(tmp);
    // Move template data from temporary string
    // to template object.
    Move(PChar(tmp)^, tptBlob.tpt^, tptBlob.size);
    // move foward in the list of templates
    dsTemplates.Next();
    getNextTemplate := tptBlob;
  end;
end;

end.
