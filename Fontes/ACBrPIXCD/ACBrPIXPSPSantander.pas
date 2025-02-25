{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

(*

  Documenta��o
  https://developer.santander.com.br/

*)

{$I ACBr.inc}

unit ACBrPIXPSPSantander;

interface

uses
  Classes, SysUtils,
  ACBrPIXCD, ACBrBase;

const
  cSantanderPathApiPIX = '/api/v1';
  cSantanderURLSandbox = 'https://pix.santander.com.br'+cSantanderPathApiPIX+'/sandbox';
  cSantanderURLPreProducao = 'https://trust-pix-h.santander.com.br'+cSantanderPathApiPIX;
  cSantanderURLProducao = 'https://trust-pix.santander.com.br'+cSantanderPathApiPIX;

  cSantanderURLAuthTeste = 'https://pix.santander.com.br/sandbox/oauth/token';
  cSantanderURLAuthPreProducao = 'https://trust-pix-h.santander.com.br/oauth/token';
  cSantanderURLAuthProducao = 'https://trust-pix.santander.com.br/oauth/token';

resourcestring
  sErroClienteIdDiferente = 'Cliente_Id diferente do Informado';

type

  { TACBrPSPSantander }
  
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrPSPSantander = class(TACBrPSP)
  private
    fK: String;
    fRefreshURL: String;
    fArquivoPFX: String;
    fSenhaPFX: String;
    function GetConsumerKey: String;
    function GetConsumerSecret: String;
    function GetSenhaPFX: String;
    procedure SetConsumerKey(AValue: String);
    procedure SetConsumerSecret(AValue: String);
    procedure SetArquivoPFX(const AValue: String);
    procedure SetSenhaPFX(const AValue: String);
  protected
    function ObterURLAmbiente(const aAmbiente: TACBrPixCDAmbiente): String; override;
    procedure ConfigurarHeaders(const Method, AURL: String); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Autenticar; override;
    procedure RenovarToken; override;
  published
    property APIVersion;
    property ConsumerKey: String read GetConsumerKey write SetConsumerKey;
    property ConsumerSecret: String read GetConsumerSecret write SetConsumerSecret;
    property ArquivoPFX: String read fArquivoPFX write SetArquivoPFX;
    property SenhaPFX: String read GetSenhaPFX write SetSenhaPFX;
  end;

implementation

uses
  synautil, DateUtils,
  ACBrJSON,
  ACBrUtil.FilesIO,
  ACBrUtil.Strings;

{ TACBrPSPSantander }

procedure TACBrPSPSantander.ConfigurarHeaders(const Method, AURL: String);
begin
 inherited ConfigurarHeaders(Method, AURL);

 if (ACBrPixCD.Ambiente = ambProducao) then
 begin
   http.Sock.SSL.PFXfile     := ArquivoPFX;
   http.Sock.SSL.KeyPassword := SenhaPFX;
 end;
end;

constructor TACBrPSPSantander.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fRefreshURL := EmptyStr;
  fK := EmptyStr;
end;

procedure TACBrPSPSantander.Autenticar;
var
  AURL, Body, client_id: String;
  RespostaHttp: AnsiString;
  ResultCode, sec: Integer;
  js: TACBrJSONObject;
  qp: TACBrQueryParams;
begin
  LimparHTTP;

  case ACBrPixCD.Ambiente of
    ambProducao: AURL := cSantanderURLAuthProducao;
    ambPreProducao: AURL := cSantanderURLAuthPreProducao;
  else
    AURL := cSantanderURLAuthTeste;
  end;

  AURL := AURL + '?grant_type=client_credentials';

  qp := TACBrQueryParams.Create;
  try
    qp.Values['client_id'] := ClientID;
    qp.Values['client_secret'] := ClientSecret;
    Body := qp.AsURL;
    WriteStrToStream(Http.Document, Body);
    Http.MimeType := CContentTypeApplicationWwwFormUrlEncoded;
  finally
    qp.Free;
  end;

  TransmitirHttp(ChttpMethodPOST, AURL, ResultCode, RespostaHttp);

  if (ResultCode = HTTP_OK) then
  begin
    js := TACBrJSONObject.Parse(RespostaHttp);
    try
      client_id := Trim(js.AsString['client_id']);
      if (client_id <> ClientID) then
        raise EACBrPixHttpException.Create(ACBrStr(sErroClienteIdDiferente));
      fpToken := js.AsString['access_token'];
      sec := js.AsInteger['expires_in'];
      fRefreshURL := js.AsString['refresh_token'];
    finally
      js.Free;
    end;

    if (Trim(fpToken) = '') then
      DispararExcecao(EACBrPixHttpException.Create(ACBrStr(sErroAutenticacao)));

    fpValidadeToken := IncSecond(Now, sec);
    fpAutenticado := True;
  end
  else
    DispararExcecao(EACBrPixHttpException.CreateFmt( sErroHttp,
       [Http.ResultCode, ChttpMethodPOST, AURL]));
end;

procedure TACBrPSPSantander.RenovarToken;
begin
  // TODO: ??
  inherited RenovarToken;
end;

function TACBrPSPSantander.GetConsumerKey: String;
begin
  Result := ClientID;
end;

function TACBrPSPSantander.GetConsumerSecret: String;
begin
  Result := ClientSecret;
end;

function TACBrPSPSantander.GetSenhaPFX: String;
begin
  Result := StrCrypt(fSenhaPFX, fK)  // Descritografa a Senha
end;

procedure TACBrPSPSantander.SetArquivoPFX(const AValue: String);
begin
  if (fArquivoPFX = AValue) then
    Exit;

  fArquivoPFX := Trim(AValue);
end;

procedure TACBrPSPSantander.SetConsumerKey(AValue: String);
begin
  ClientID := AValue;
end;

procedure TACBrPSPSantander.SetConsumerSecret(AValue: String);
begin
  ClientSecret := AValue;
end;

procedure TACBrPSPSantander.SetSenhaPFX(const AValue: String);
begin
  if (fK <> '') and (fSenhaPFX = StrCrypt(AValue, fK)) then
    Exit;

  fK := FormatDateTime('hhnnsszzz', Now);
  fSenhaPFX := StrCrypt(AValue, fK);  // Salva Senha de forma Criptografada, para evitar "Inspect"
end;

function TACBrPSPSantander.ObterURLAmbiente(const aAmbiente: TACBrPixCDAmbiente): String;
begin
  case aAmbiente of
    ambProducao: Result := cSantanderURLProducao;
    ambPreProducao: Result := cSantanderURLPreProducao;
  else
    Result := cSantanderURLSandbox;
  end;
end;

end.


