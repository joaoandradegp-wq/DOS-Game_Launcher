unit Language;

interface

uses Sysutils,Windows;

//---------------------------------------
function Language_UAC(id:Integer):String;
//---------------------------------------

implementation

uses Unit1;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function Language_UAC(id:Integer):String;
begin

  if Language_WIN = 'por' then
  begin
    case id of
    0: Result:='Uma nova atualização está disponível!'+#13#13+'Atualizar agora?';
    1: Result:='O DOS GAME LAUNCHER já está em execução!';
    end;
  end
  else
  begin
    case id of
    0: Result:='A new update is now available!'+#13#13+'Update now?';
    1: Result:='DOS GAME LAUNCHER is already running!';
    end;
  end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
end.
 