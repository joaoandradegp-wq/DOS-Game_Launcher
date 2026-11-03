unit PastaMonitor;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils;

type
  TPastaMonitor = class
  private
    FPasta: string;
    FAtivo: Boolean;
    FThread: TThread;
    FOnChange: TNotifyEvent;
    procedure Iniciar;
    procedure Parar;
    procedure SetPasta(const Value: string);
    procedure SetAtivo(Value: Boolean);
  public
    destructor Destroy; override;
    property Pasta: string read FPasta write SetPasta;
    property Ativo: Boolean read FAtivo write SetAtivo;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

type
  TMonitorThread = class(TThread)
  private
    FOwner: TPastaMonitor;
    FPasta: string;
    FStop: THandle;
    procedure DispararChange;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TPastaMonitor; const APasta: string);
    procedure Parar;
  end;

constructor TMonitorThread.Create(AOwner: TPastaMonitor; const APasta: string);
begin
  FOwner := AOwner;
  FPasta := APasta;
  FStop  := CreateEvent(nil, True, False, nil);
  inherited Create(False);
end;

procedure TMonitorThread.DispararChange;
begin
  if Assigned(FOwner.FOnChange) then
    FOwner.FOnChange(FOwner);
end;

procedure TMonitorThread.Execute;
var
  Handles: array[0..1] of THandle;
begin
  Handles[0] := FindFirstChangeNotification(PChar(FPasta), False,
    FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_SIZE or FILE_NOTIFY_CHANGE_LAST_WRITE);
  if Handles[0] = INVALID_HANDLE_VALUE then Exit;
  Handles[1] := FStop;
  try
    while not Terminated do
    begin
      if WaitForMultipleObjects(2, @Handles, False, INFINITE) <> WAIT_OBJECT_0 then
      Break;
      if WaitForSingleObject(FStop, 300) = WAIT_OBJECT_0 then
      Break;
      FindNextChangeNotification(Handles[0]);
      Queue(DispararChange);
    end;
  finally
    FindCloseChangeNotification(Handles[0]);
  end;
end;

procedure TMonitorThread.Parar;
begin
  Terminate;
  SetEvent(FStop);
  WaitFor;
  RemoveQueuedEvents(Self);
  CloseHandle(FStop);
end;

destructor TPastaMonitor.Destroy;
begin
  Parar;
  inherited;
end;

procedure TPastaMonitor.Iniciar;
begin
  Parar;
  if FAtivo and (FPasta <> '') and DirectoryExists(FPasta) then
    FThread := TMonitorThread.Create(Self, FPasta);
end;

procedure TPastaMonitor.Parar;
begin
  if FThread <> nil then
  begin
    TMonitorThread(FThread).Parar;
    FreeAndNil(FThread);
  end;
end;

procedure TPastaMonitor.SetPasta(const Value: string);
begin
  if FPasta = Value then
  Exit;
  FPasta := Value;
  if FAtivo then
  Iniciar;
end;

procedure TPastaMonitor.SetAtivo(Value: Boolean);
begin
  if FAtivo = Value then
  Exit;
  FAtivo := Value;
  Iniciar;
end;

end.
